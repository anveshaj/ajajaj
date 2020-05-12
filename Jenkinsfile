pipeline {
    agent any
    stages{
        stage('Build'){
            steps {
                bat 'terraform init'
            }
        }
    }
    
    def getTerraformPath(){
          def tfHome = tool name: 'myterraform', type: 'terraform'
          return tfHome
    }    
}

