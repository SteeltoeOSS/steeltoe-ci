/*
 * Jenkins DSL for Steeltoe Samples
 */

// configuration

alertees = [
    'ccheetham',
    'dtillman',
    'jkonicki',
    'hsarella',
    'thess',
]

scmPathTriggers = [
    "behave.ini",
    "ci/.*",
    "config/.*",
    "environment.py",
    "pyenv.pkgs",
    "pylib/.*",
    "steps/.*",
    "test-run.*",
    "test-setup.*",
]

platforms = [
    'ubuntu1604',
    'win2012',
]

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

disabledSamples = [
    ['Configuration/src/AspDotNetCore/Simple', 'win2012']:
        'Disabled due to lack of support for long file names on Windows 2012 slave',
    ['Security/src/AspDotNetCore/CloudFoundrySingleSignon', 'win2012']:
        'Disabled due to lack of support for long file names on Windows 2012 slave',
]

// utils

def jobForSample(def sample, def platform) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}-${platform}"
}

def displayNameForSample(def sample, def platform) {
    nodes = sample.split('/')
    library = nodes[0]
    sample = nodes[-1]
    switch (nodes[-2]) {
        case ~/.*NetCore$/:
            dotnet = 'core'
            break
        case ~/.*Net4/:
            dotnet = 'f4'
            break
        default:
            dotnet = nodes[-2]
            break
    }
    switch (platform) {
        case ~/win.*/:
            os = 'windows'
            break
        case ~/ubuntu.*/:
            os = 'linux'
            break
        default:
            os = platform
            break
    }
    "Steeltoe Sample ${library}/${sample} (${dotnet}/${os})"
}

// jobs

samplePaths.each { samplePath ->
    platforms.each { platform ->
        job(jobForSample(samplePath, platform)) {
            displayName(displayNameForSample(samplePath, platform))
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
                            includedRegions((scmPathTriggers + "${samplePath}/.*").join('\n'))
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
            disabledReason = disabledSamples[[samplePath, platform]]
            if (disabledReason) {
                disabled()
                description(disabledReason)
            } else {
                disabled()
            }
        }
    }
}
