#!/usr/bin/env groovy

def listOfProperties = []
listOfProperties << buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '5'))

// Only master branch will run on a timer basis
if (env.BRANCH_NAME.trim() == 'master') {
    listOfProperties << pipelineTriggers([cron('''H H/6 * * 0-2,4-6
H 6,21 * * 3''')])
}

properties(listOfProperties)

stage('Build') {
    def builds = [:]
    def images = [
        'debian_slim_jdk11_arm32v6',
    ]
    for (i in images) {
        def imageToBuild = i
        builds[imageToBuild] = {
            node('docker') {
                deleteDir()

                stage('Checkout') {
                    checkout scm
                }

                stage('Static analysis') {
                    sh 'make hadolint shellcheck'
                }

                /* Outside of the trusted.ci environment, we're building and testing
                * the Dockerfile in this repository, but not publishing to docker hub
                */
                stage("Build linux-${imageToBuild}") {
                    infra.withDockerCredentials {
                        sh "make build-${imageToBuild}"
                    }
                }

                stage("Test linux-${imageToBuild}") {
                    sh "make prepare-test"
                    try {
                        infra.withDockerCredentials {
                            sh "make test-${imageToBuild}"
                        }
                    } catch (err) {
                        error("${err.toString()}")
                    } finally {
                        junit(allowEmptyResults: true, keepLongStdio: true, testResults: 'target/*.xml')
                    }
                }
            }
        }
        builds['multiarch-build'] = {
            nodeWithTimeout('docker') {
                stage('Checkout') {
                    deleteDir()
                    checkout scm
                }

                // sanity check that proves all images build on declared platforms
                stage('Multi arch build') {
                    infra.withDockerCredentials {
                        sh '''
                            docker buildx create --use
                            docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
                            docker buildx bake --file docker-bake.hcl linux
                        '''
                    }
                }
            }
        }
    } else {
        builds['linux'] = {
            nodeWithTimeout('docker') {
                stage('Checkout') {
                    checkout scm
                }

                stage('Publish') {
                    infra.withDockerCredentials {
                        sh '''
                            docker buildx create --use
                            docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
                            make publish
                            '''
                    }
                }
            }
        }
    }

    parallel builds
}


void nodeWithTimeout(String label, def body) {
    node(label) {
        timeout(time: 60, unit: 'MINUTES') {
            body.call()
        }
    }
}
