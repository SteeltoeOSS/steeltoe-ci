/**
 * Jenkins DSL for Steeltoe Samples
 */

samplePaths = [
    'Connectors/src/AspDotNetCore/PostgreSql',
    'Connectors/src/AspDotNetCore/PostgreEFCore',
    'Connectors/src/AspDotNetCore/Redis',
    'Connectors/src/AspDotNetCore/MySqlEFCore',
    'Connectors/src/AspDotNetCore/MySqlEF6',
    'Connectors/src/AspDotNetCore/RabbitMQ',
    'Connectors/src/AspDotNetCore/MySql/MySql',
    'Configuration/src/AspDotNetCore/CloudFoundry',
    'Configuration/src/AspDotNetCore/Simple',
    'Configuration/src/AspDotNetCore/SimpleCloudFoundry',
    'Security/src/CloudFoundrySingleSignon',
    'Management/src/AspDotNetCore/CloudFoundry',
]

platforms = [
    'ubuntu1604',
    'win2012',
]

alertees = [
    'ccheetham',
]

def jobForSample(def sample, def platform) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}-${platform}"
}

samplePaths.each { samplePath ->
    platforms.each { platform ->
        job(jobForSample(samplePath, platform)) {
            wrappers {
                credentialsBinding {
                    usernamePassword('STEELTOE_PCF_CREDENTIALS', 'steeltoe-pcf')
                }
                preBuildCleanup()
            }
            label("steeltoe && ${platform}")
                scm {
                    git {
                        remote {
                            github('SteeltoeOSS/Samples', 'https')
                            branch('dev')
                        }
                    }
                }
            triggers {
                scm('H/15 * * * *')
            }
            steps {
                if (platform.startsWith('win')) {
                    batchFile("ci\\jenkins.cmd ${samplePath.replaceAll('/', '\\\\')}")
                } else {
                    shell("ci/jenkins.sh ${samplePath}")
                }
            }
            publishers {
                archiveArtifacts('test.log')
                    mailer(alertees.collect { "${it}@pivotal.io" }.join(' '), true, false)
                    // slackNotifier {
                    //     room('#steeltoe-pipelines')
                    //     notifyAborted(true)
                    //     notifyFailure(true)
                    //     notifyNotBuilt(true)
                    //     notifyUnstable(true)
                    //     notifyBackToNormal(true)
                    //     notifySuccess(false)
                    //     notifyRepeatedFailure(false)
                    //     startNotification(false)
                    //     includeTestSummary(false)
                    //     includeCustomMessage(false)
                    //     customMessage(null)
                    //     sendAs(null)
                    //     commitInfoChoice('AUTHORS_AND_TITLES')
                    //     teamDomain('pivotal')
                    //     authToken('MKRw5ybKEIgspDGHtyaq4TI2')
                    // }
            }
            logRotator {
                numToKeep(5)
            }
        }
    }
}

// vim: et sw=4 sts=4
