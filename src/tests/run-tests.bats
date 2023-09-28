# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/run-tests.sh
}

DIFF_ARGS="-u --label actual --label expected"

@test 'Use custom parameters' {
    export PARAM_API_KEY="DD_API_KEY"
    export PARAM_APP_KEY="DD_APP_KEY"
    export PARAM_CONFIG_PATH="./some/other/path.json"
    export PARAM_FAIL_ON_CRITICAL_ERRORS="1"
    export PARAM_FAIL_ON_MISSING_TESTS="1"
    export PARAM_FAIL_ON_TIMEOUT="0"
    export PARAM_FILES="test1.json"
    export PARAM_JUNIT_REPORT="reports/TEST-1.xml"
    export PARAM_LOCATIONS="aws:eu-west-1"
    export PARAM_POLLING_TIMEOUT="123"
    export PARAM_PUBLIC_IDS="jak-not-now,jak-one-mor"
    export PARAM_SITE="datadoghq.eu"
    export PARAM_SUBDOMAIN="app1"
    export PARAM_TEST_SEARCH_QUERY="apm"
    export PARAM_TUNNEL="1"
    export PARAM_VARIABLES="KEY=value ANOTHER_KEY=another_value"
    export DATADOG_CI_COMMAND="echo"

    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --failOnCriticalErrors --failOnMissingTests --no-failOnTimeout --tunnel --config ./some/other/path.json --files test1.json --jUnitReport reports/TEST-1.xml --pollingTimeout 123 --public-id jak-not-now --public-id jak-one-mor --search apm --variable KEY=value --variable ANOTHER_KEY=another_value)
}

@test 'Use default parameters' {
    export PARAM_API_KEY="DD_API_KEY"
    export PARAM_APP_KEY="DD_APP_KEY"
    export PARAM_CONFIG_PATH=""
    export PARAM_FAIL_ON_CRITICAL_ERRORS="0"
    export PARAM_FAIL_ON_MISSING_TESTS="0"
    export PARAM_FAIL_ON_TIMEOUT="1"
    export PARAM_FILES=""
    export PARAM_JUNIT_REPORT=""
    export PARAM_LOCATIONS=""
    export PARAM_POLLING_TIMEOUT=""
    export PARAM_PUBLIC_IDS=""
    export PARAM_SITE=""
    export PARAM_SUBDOMAIN=""
    export PARAM_TEST_SEARCH_QUERY=""
    export PARAM_TUNNEL="0"
    export DATADOG_CI_COMMAND="echo"

    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --failOnTimeout)
}

@test 'Support spaces and commas in filenames' {
    export DATADOG_CI_COMMAND="echo"

    export PARAM_FILES="ci/file with space.json"
    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --no-failOnTimeout --files "ci/file with space.json")

    export PARAM_FILES="{,!(node_modules)/**/}*.synthetics.json"
    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --no-failOnTimeout --files "{,!(node_modules)/**/}*.synthetics.json")

    export PARAM_FILES="hello, i'm a file.txt"
    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --no-failOnTimeout --files "hello, i'm a file.txt")

    export PARAM_FILES=$'file 1.json\nfile 2.json'
    diff $DIFF_ARGS <(RunTests) <(echo synthetics run-tests --no-failOnTimeout --files "file 1.json" --files "file 2.json")
}
