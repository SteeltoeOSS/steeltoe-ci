/**
 * Jenkins DSL for Steeltoe view.
 */

listView('Steeltoe') {
    jobs {
        regex(/^steeltoe-.+/)
    }
    columns {
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
