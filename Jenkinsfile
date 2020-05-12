pipeline{
    agents any
    environment {
      PATH = "${PATH}:${terrapath()}"
    }

   stages{
      stage('initializing teraform'){
        steps{
           sh"terraform init"
        }
      }

   }
def terrapath(){
  def tfHome = tool name: 'myterraform', type: 'terraform'
  return tfHome
}

}
