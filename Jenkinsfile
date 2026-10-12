pipeline {

    agent any

    stages {

        stage('Deploy') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'netwatch-db-user',
                        usernameVariable: 'MARIADB_USER',
                        passwordVariable: 'MARIADB_PASSWORD'
                    ),
                    string(
                        credentialsId: 'netwatch-db-root-password',
                        variable: 'MARIADB_ROOT_PASSWORD'
                    )
                ]) {
                    sh '''
                        docker compose -p netwatch up -d --build
                    '''
                }
            }
        }
        
        stage('Syntax Check') {
            steps {
                sh 'bash -n netwatch.sh'
            }
        }

        stage('ShellCheck') {
            steps {
                sh 'shellcheck netwatch.sh'
            }
        }

        stage('Function Test') {
            steps {
                sh './test.sh'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t netwatch-bash:${BUILD_NUMBER} .'
            }
        }

        stage('Container Test') {
            steps {
                sh '''
                    OUTPUT=$(docker run --rm netwatch-bash:${BUILD_NUMBER} ./test.sh)
                    LAST_LINE=$(echo "$OUTPUT" | tail -n 1)
                    
                     if [ "$LAST_LINE" = "TEST OK" ]; then
                        echo "Docker-Test erfolgreich!"
                    else
                        echo "Docker-Test fehlgeschlagen!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Create Latest Image') {
            steps {
                sh '''
                    docker tag \
                    netwatch-bash:${BUILD_NUMBER} \
                    netwatch-bash:latest
                '''
            }
        }
    }

    post {

        success {
            echo 'Pipeline erfolgreich!'
            echo 'Docker-Image wurde erstellt.'
        }

        failure {
            echo 'Pipeline fehlgeschlagen!'
        }
    }
}
