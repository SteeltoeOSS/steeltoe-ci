/**
 * Jenkins DSL for Steeltoe Samples
 */

samplePaths = [
    'Configuration/src/AspDotNetCore/CloudFoundry',
    'Configuration/src/AspDotNetCore/Simple',
    'Configuration/src/AspDotNetCore/SimpleCloudFoundry',
    'Connectors/src/AspDotNetCore/MySql',
    'Connectors/src/AspDotNetCore/MySqlEFCore',
    'Connectors/src/AspDotNetCore/MySqlEF6',
    'Connectors/src/AspDotNetCore/PostgreSql',
    'Connectors/src/AspDotNetCore/PostgreEFCore',
    'Connectors/src/AspDotNetCore/RabbitMQ',
    'Connectors/src/AspDotNetCore/Redis',
    'Security/src/AspDotNetCore/CloudFoundrySingleSignon',
    'Management/src/AspDotNetCore/CloudFoundry',
]

platforms = [
    'ubuntu1604',
    'win2012',
]

alertees = [
    'ccheetham',
    'dtillman',
    'jkonicki',
    'thess',
]

def jobForSample(def sample, def platform) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}-${platform}"
}

samplePaths.each { samplePath ->
    platforms.each { platform ->
        job(jobForSample(samplePath, platform)) {
            // disabled()
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
                    configure { gitScm ->
                        gitScm / 'extensions' << 'hudson.plugins.git.extensions.impl.PathRestriction' {
                            includedRegions("${samplePath}/.*")
                        }
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
                archiveJunit('test.out/reports/*.xml')
                mailer(alertees.collect { "${it}@pivotal.io" }.join(' '), true, false)
            }
            logRotator {
                numToKeep(5)
            }
        }
    }
}

// vim: et sw=4 sts=4
