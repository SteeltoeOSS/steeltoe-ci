/**
 * Jenkins DSL for Steeltoe Samples
 */

recipients = [
    'ccheetham',
]

samples = [
    'Configuration/src/AspDotNetCore/CloudFoundry',
    'Configuration/src/AspDotNetCore/Simple',
    'Configuration/src/AspDotNetCore/SimpleCloudFoundry',
]

def sample2Job(def sample) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}"
}

samples.each { sample ->
    job(sample2Job(sample)) {
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
            shell("ci/jenkins.sh ${sample}")
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
