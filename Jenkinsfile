pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-2"
        AWS_CREDENTIALS_ID = "aws-jenkins"
        TF_WORKING_DIR     = "."
    }

    options {
        ansiColor('xterm')
        timestamps()
        skipStagesAfterUnstable()
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out GitHub repo..."
                checkout scm
            }
        }

        stage('Setup AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate & Format') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh '''
                        echo "Running terraform fmt..."
                        terraform fmt -check || true

                        echo "Running terraform validate..."
                        terraform validate
                        if [ $? -ne 0 ]; then
                            echo "Terraform validation failed!"
                            exit 1
                        fi
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    dir("${TF_WORKING_DIR}") {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

                            echo "Running terraform plan..."
                            terraform plan -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Apply"
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    dir("${TF_WORKING_DIR}") {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

                            echo "Applying terraform changes..."
                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Verify EKS Cluster') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    dir("${TF_WORKING_DIR}") {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                            export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

                            echo "Verifying EKS cluster connectivity..."
                            aws sts get-caller-identity

                            aws eks update-kubeconfig --name my-eks-cluster --region ${AWS_DEFAULT_REGION}
                            kubectl get nodes -o wide
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()

            echo "Destroying Terraform-managed infrastructure..."
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                dir("${TF_WORKING_DIR}") {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}

                        terraform plan -destroy -out=tf-destroy-plan
                        terraform apply -auto-approve tf-destroy-plan
                    '''
                }
            }
        }
        success {
            echo "✅ Terraform applied successfully!"
        }
        failure {
            echo "❌ Pipeline failed! Check logs for details."
        }
    }
}
