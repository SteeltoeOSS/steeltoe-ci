/**
 * Jenkins DSL for Steeltoe Samples
 */

recipients = [
    'ccheetham',
]

job('steeltoe-samples-configuration-simple') {
    displayName('Steeltoe Samples : Configuration : Simple')
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
        shell('ci/jenkins.sh Configuration/src/AspDotNetCore/Simple')
    }
    publishers {
        archiveArtifacts('test.log')
        mailer(recipients.collect { "${it}@pivotal.io" }.join(' '), true, false)
    }
    logRotator {
        numToKeep(5)
    }
}

// vim: et sw=4 sts=4
