pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-2"
        AWS_CREDENTIALS_ID = "aws-jenkins"   // the Jenkins credential ID you created
        TF_WORKING_DIR     = "."           // root of your terraformeks repo
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
                    sh 'terraform fmt -check'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve Terraform Apply?", ok: "Apply"
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Verify EKS Cluster') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh '''
                        aws eks update-kubeconfig --name my-eks-cluster --region ${AWS_DEFAULT_REGION}
                        kubectl get nodes -o wide
                    '''
                }
            }
        }

    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            echo "Terraform applied successfully!"
        }
        failure {
            echo "Pipeline failed! Check logs."
        }
    }
}
