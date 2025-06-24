#!groovy

import groovy.json.JsonSlurperClassic

node {

    def SF_CONSUMER_KEY = env.CONNECTED_APP_CONSUMER_KEY_DH
    def SF_USERNAME = env.HUB_ORG_DH
    def SERVER_KEY_CREDENTALS_ID = env.JWT_CRED_ID_DH
    def TEST_LEVEL = 'RunLocalTests'
    def PACKAGE_NAME = '0Ho1U000000CaUzSAK'
    def PACKAGE_VERSION
    def SF_INSTANCE_URL = env.SFDC_HOST_DH ?: "https://login.salesforce.com"

    def toolbelt = tool 'toolbelt'

    stage('checkout source') {
        checkout scm
    }

    withEnv(["HOME=${env.WORKSPACE}"]) {

        withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {

            stage('Authorize DevHub') {
                def rc = command "${toolbelt}/sf org login jwt --instance-url ${SF_INSTANCE_URL} --client-id ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwt-key-file ${server_key_file} --set-default-dev-hub --alias HubOrg"
                if (rc != 0) {
                    error 'Salesforce dev hub org authorization failed.'
                }
            }

            stage('Deploy to DevHub Org') {
                def rc = command "${toolbelt}/sf project deploy start --target-org HubOrg --wait 10"
                if (rc != 0) {
                    error 'Salesforce deploy to Dev Hub org failed.'
                }
            }

            stage('Run Tests in DevHub Org') {
                def rc = command "${toolbelt}/sf apex run test --target-org HubOrg --wait 10 --result-format tap --code-coverage --test-level ${TEST_LEVEL}"
                if (rc != 0) {
                    error 'Salesforce unit tests run in Dev Hub org failed.'
                }
            }

            stage('Create Package Version') {
                def output
                if (isUnix()) {
                    output = sh(returnStdout: true, script: "${toolbelt}/sf package version create --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg")
                } else {
                    output = bat(returnStdout: true, script: "${toolbelt}/sf package version create --package ${PACKAGE_NAME} --installation-key-bypass --wait 10 --json --target-dev-hub HubOrg").trim()
                    output = output.readLines().drop(1).join(" ")
                }

                // Wait 5 minutes for package replication.
                sleep 300

                def jsonSlurper = new JsonSlurperClassic()
                def response = jsonSlurper.parseText(output)

                PACKAGE_VERSION = response.result.SubscriberPackageVersionId
                echo "Package Version Created: ${PACKAGE_VERSION}"
            }

            // Optional: If you want to install and test the package directly on Dev Hub org
            /*
            stage('Install Package in DevHub Org') {
                def rc = command "${toolbelt}/sf package install --package ${PACKAGE_VERSION} --target-org HubOrg --wait 10"
                if (rc != 0) {
                    error 'Salesforce package install failed.'
                }
            }

            stage('Run Tests on Installed Package') {
                def rc = command "${toolbelt}/sf apex run test --target-org HubOrg --result-format tap --code-coverage --test-level ${TEST_LEVEL} --wait 10"
                if (rc != 0) {
                    error 'Salesforce unit test run on installed package failed.'
                }
            }
            */

        }
    }
}

def command(script) {
    if (isUnix()) {
        return sh(returnStatus: true, script: script);
    } else {
        return bat(returnStatus: true, script: script);
    }
}
