// pipeline {
//     agent { node("built-in") }

//     stages {
//         stage("hello"){
//             steps{
//                 sh 'echo hello'
//             }
//         }
//         stage("say hi"){
//             steps{
//                 sh 'echo hi'
//             }
//         }
//     }
// }

pipeline{
    agent { node("built-in") }
    stages {
        stage('Checkout from Git'){
            // steps{
            //     git branch: 'main', url: 'git@github.com:shajinrr/ansible-repo.git'
            // }
            steps {
                // Use the 'checkout' step with SSH key credentials
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'git@github.com:shajinrr/ansible-repo.git',
                        credentialsId: 'githubkey'
                    ]],
                    extensions: [[$class: 'DisableRemotePoll']]
                ])
            }
        }
        stage('run ansible'){
            steps{
                sh 'ansible --version'
            }
            
        }
        stage('run ansible pwd'){
            steps{
                sh 'ls -ltahr'
            }
        }
    }
}