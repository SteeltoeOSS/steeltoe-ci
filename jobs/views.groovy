/*
 * Jenkins DSL for Steeltoe views.
 */

nestedView('Steeltoe') {
    views {
        listView('Steeltoe Samples') {
            jobs {
                regex(/^steeltoe-samples-.+/)
            }
            columns defaultColumns()
        }
        listView('Steeltoe Samples: Configuration') {
            jobs {
                regex(/^steeltoe-samples-configuration-.+/)
            }
            columns defaultColumns()
        }
        listView('Steeltoe Samples: Connectors') {
            jobs {
                regex(/^steeltoe-samples-connectors-.+/)
            }
            columns defaultColumns()
        }
        listView('Steeltoe Samples: Management') {
            jobs {
                regex(/^steeltoe-samples-management-.+/)
            }
            columns defaultColumns()
        }
        listView('Steeltoe Samples: Security') {
            jobs {
                regex(/^steeltoe-samples-security-.+/)
            }
            columns defaultColumns()
        }
        listView('Steeltoe Seed') {
            jobs {
                regex(/^steeltoe-seed$/)
            }
            columns defaultColumns()
        }
    }
}

private Closure defaultColumns() {
    return {
        weather()
        status()
        name()
        lastDuration()
        lastSuccess()
        lastFailure()
        buildButton()
    }
}

// vim: et sw=4 sts=4
