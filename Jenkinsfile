pipeline {
    agent any
    tools{
        maven "mymaven"
    }
    
    parameters{
        string(name:'Env',defaultValue:'PRE-PROD',description:'environment to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    }
    stages {
        stage('compile') {
            steps {
                script{
                  echo 'code compile'
                  echo "compile the code in ${params.Env}"
                  sh "mvn compile"
                }  
            }
        }
        stage('codeReview') {
            steps {
                script{
                  echo 'performing code review'
                  echo "perform codeReview in ${params.Env}"
                  sh "mvn pmd:pmd"
                }  
            }
        }
        stage('unitTest') {
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                  echo 'performing unit test'
                  echo "perform testing in ${params.Env}"
                  sh "mvn test"
                }  
            }
        }
        stage('codeCoverage') {
            steps {
                script{
                  echo 'performing code coverage'
                  echo "perform code coverage in ${params.Env}"
                  sh "mvn verify"
                }  
            }
        }
        stage('package') {
            input{
                message "Select the platform for deployment"
                ok "Platform Selected"
                parameters{
                    choice(name:'Platform',choices:['EKS','EC2','On-prem'])
                }
            }
            steps {
                script{
                  echo 'package the code'
                  echo "package the code in ${params.Env}"
                  echo "package app version ${params.APPVERSION}"  
                  sh "mvn package"
                }  
            }
        }
        stage('codeArtifacts') {
            steps {
                script{
                  echo 'copy the artifacts repo'
                  echo "copy the artifacts in ${params.Env}"
                  sh "mvn deploy -s settings.xml"
                }  
            }
        }

    }
}
