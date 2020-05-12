pipeline {
    agent any
    tools {
        terraform 'myterraform'
    }
    stages{
        stage('Build'){
            steps {
                bat 'terraform init'
            }
        }
    }   
}

