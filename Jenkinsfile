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
            // Run terraform fmt, but ignore warnings (non-zero exit due to version notice)
            sh 'terraform fmt -check || true'
            
            // Run terraform validate, fail if actual errors occur
            sh '''
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