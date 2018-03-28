/**
 * Jenkins DSL for Steeltoe Samples
 */

recipients = [
    'ccheetham',
]

samplePaths = [
    'Configuration/src/AspDotNetCore/CloudFoundry',
    'Configuration/src/AspDotNetCore/Simple',
    'Configuration/src/AspDotNetCore/SimpleCloudFoundry',
]

def sample2Job(def sample) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}"
}

samplePaths.each { samplePath ->
    job(sample2Job(samplePath)) {
        wrappers {
            credentialsBinding {
                usernamePassword('STEELTOE_PCF_CREDENTIALS', 'steeltoe-pcf')
            }
            preBuildCleanup()
        }
        label('steeltoe')
        scm {
            git {
                remote {
                    github('SteeltoeOSS/Samples', 'https')
                    branch('dev')
                }
            }
        }
        steps {
            shell("ci/jenkins.sh ${samplePath}")
        }
        publishers {
            archiveArtifacts('test.log')
            mailer(recipients.collect { "${it}@pivotal.io" }.join(' '), true, false)
        }
        logRotator {
            numToKeep(5)
        }
    }
}

// vim: et sw=4 sts=4
