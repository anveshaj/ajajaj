pipeline {
    agent any
    stages{
        stage('Build'){
            steps {
                bat 'terraform init'
            }
        }
    }
    
    def terrapath(){
          def tfHome = tool name: 'myterraform', type: 'terraform'
          return tfHome
    }    
}

