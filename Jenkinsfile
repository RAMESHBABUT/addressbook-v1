pipeline {
    agent none
    tools{
        maven "mymaven"
    }
    
    parameters{
        string(name:'Env',defaultValue:'PRE-PROD',description:'environment to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    }
    environment{
        BUILD_SERVER='ec2-user@172.31.12.185'
    }    
    stages {
        stage('compile') {
            agent any
            steps {
                script{
                  echo 'code compile'
                  echo "compile the code in ${params.Env}"
                  sh "mvn compile"
                }  
            }
        }
        stage('codeReview') {
            agent any
            steps {
                script{
                  echo 'performing code review'
                  echo "perform codeReview in ${params.Env}"
                  sh "mvn pmd:pmd"
                }  
            }
        }
        stage('unitTest') {
            agent any
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
            agent any
             steps {
                script{
                  echo 'performing code coverage'
                  echo "perform code coverage in ${params.Env}"
                  sh "mvn verify"
                }  
            }
        }
        stage('package') {
            steps {
                script{
                    sshagent(['newslave2']) {
                    echo "packaging the code"
                    echo 'platform is ${Platform}'
                    echo "packing the version ${params.APPVERSION}"
                    //sh "mvn package"
                    sh "scp  -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash ~/server-script.sh'"
                    }
                }  
            }
        }
        stage('codeArtifacts') {
            agent {label 'linux_remoteslave'}
            
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
