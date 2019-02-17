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

scmPathTriggers = [
    "behave.ini",
    "ci/.*",
    "config/.*",
    "environment.py",
    "pyenv.pkgs",
    "pylib/.*",
    "test-run.*",
    "test-setup.*",
]

platforms = [
    'ubuntu1604',
    'win2012',
]

alertees = [
    'ccheetham',
    'dtillman',
    'jkonicki',
    'hsarella',
    'thess',
]

def jobForSample(def sample, def platform) {
    "steeltoe-samples-${sample.split('/').findAll { !(it in ['src']) }.collect { it.toLowerCase() }.join('-')}-${platform}"
}

def displayNameForSample(def sample, def platform) {
    nodes = sample.split('/')
    library = nodes[0]
    sample = nodes[-1]
    switch (nodes[-2]) {
        case ~/.*NetCore$/:
            dotnet = '.NET Core'
            break
        case ~/.*Net4/:
            dotnet = '.NET Framework 4'
            break
        default:
            dotnet = nodes[-2]
            break
    }
    switch (platform) {
        case ~/win.*/:
            os = 'Windows'
            break
        case ~/ubuntu.*/:
            os = 'Linux'
            break
        default:
            os = platform
            break
    }
    "Steeltoe Sample ${library}:${sample} (${dotnet} on ${os})"
}

samplePaths.each { samplePath ->
    platforms.each { platform ->
        job(jobForSample(samplePath, platform)) {
            displayName(displayNameForSample(samplePath, platform))
            if (samplePath == 'Configuration/src/AspDotNetCore/Simple' && platform == 'win2012') {
                disabled()
                description('Disabled due to lack of support for long file names on Windows 2012 slave')
            }
            if (samplePath == 'Security/src/AspDotNetCore/CloudFoundrySingleSignon' && platform == 'win2012') {
                disabled()
                description('Disabled due to inability to run UAA client on Windows 2012 slave')
            }
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
        }
    }
}

// vim: et sw=4 sts=4
