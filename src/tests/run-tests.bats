# Runs prior to every test
setup() {
    # Load our script file.
    source ./src/scripts/run-tests.sh
}

@test 'Use custom parameters' {
    # Mock environment variables or functions by exporting them (after the script has been sourced)
    export PARAM_TO="World"
    export PARAM_API_KEY="DD_API_KEY"
    export PARAM_APP_KEY="DD_APP_KEY"
    export PARAM_CONFIG_PATH="./some/other/path.json"
    export PARAM_FAIL_ON_TIMEOUT="1"
    export PARAM_FILES="test1.json,test2.json"
    export PARAM_LOCATIONS="aws:eu-1"
    export PARAM_PUBLIC_IDS="jak-not-now"
    export PARAM_SITE="datadoghq.eu"
    export PARAM_SUBDOMAIN="app1"
    export PARAM_TEST_SEARCH_QUERY="apm"
    export PARAM_TUNNEL="1"
    export PARAM_VERSION="latest"
    export DATADOG_CI_COMMAND="echo"
    # Capture the output of our "Greet" function
    result=$(RunTests)
    
    if ! echo $result | grep -q "synthetics run-tests --config ./some/other/path.json --files test1.json,test2.json --public-id jak-not-now --search apm --failOnTimeout --tunnel"
    then
      echo $result
      exit 1
    fi
}