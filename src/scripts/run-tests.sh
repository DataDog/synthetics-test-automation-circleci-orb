RunTests() {
    PARAM_API_KEY=$(eval echo "\$$PARAM_API_KEY")
    PARAM_APP_KEY=$(eval echo "\$$PARAM_APP_KEY")

    if [[ -n "${DD_SITE}" ]]; then
        PARAM_SITE=${DD_SITE}
    fi

    DATADOG_CI_VERSION="2.22.1"

    # Not run when running unit tests.
    if [[ -z "${DATADOG_CI_COMMAND}" ]]; then
        curl -L --fail "https://github.com/DataDog/datadog-ci/releases/download/v${DATADOG_CI_VERSION}/datadog-ci_linux-x64" --output "./datadog-ci"
        chmod +x ./datadog-ci

        DATADOG_CI_COMMAND="./datadog-ci"
    fi

    args=()
    if [[ $PARAM_FAIL_ON_CRITICAL_ERRORS == "1" ]]; then
        args+=(--failOnCriticalErrors)
    fi
    if [[ $PARAM_FAIL_ON_MISSING_TESTS == "1" ]]; then
        args+=(--failOnMissingTests)
    fi
    if [[ $PARAM_FAIL_ON_TIMEOUT == "1" ]]; then
        args+=(--failOnTimeout)
    else
        args+=(--no-failOnTimeout)
    fi
    if [[ $PARAM_TUNNEL == "1" ]]; then
        args+=(--tunnel)
    fi
    if [[ -n $PARAM_CONFIG_PATH ]]; then
        args+=(--config "${PARAM_CONFIG_PATH}")
    fi
    if [[ -n $PARAM_FILES ]]; then
        IFS=$'\n'
        for file in ${PARAM_FILES}; do
            args+=(--files "${file}")
        done
        unset IFS
    fi
    if [[ -n $PARAM_JUNIT_REPORT ]]; then
        args+=(--jUnitReport "${PARAM_JUNIT_REPORT}")
    fi
    if [[ -n $PARAM_POLLING_TIMEOUT ]]; then
        args+=(--pollingTimeout "${PARAM_POLLING_TIMEOUT}")
    fi
    if [[ -n $PARAM_PUBLIC_IDS ]]; then
        IFS=$'\n,'
        for public_id in ${PARAM_PUBLIC_IDS}; do
            args+=(--public-id "${public_id}")
        done
        unset IFS
    fi
    if [[ -n $PARAM_TEST_SEARCH_QUERY ]]; then
        args+=(--search "${PARAM_TEST_SEARCH_QUERY}")
    fi
    if [[ -n $PARAM_VARIABLES ]]; then
        IFS=$'\n,'
        for variable in ${PARAM_VARIABLES}; do
            args+=(--variable "${variable}")
        done
        unset IFS
    fi

    if [[ -n $PARAM_LOCATIONS ]]; then
        export DATADOG_SYNTHETICS_LOCATIONS="${PARAM_LOCATIONS}"
    fi

    DATADOG_API_KEY="${PARAM_API_KEY}" \
    DATADOG_APP_KEY="${PARAM_APP_KEY}" \
    DATADOG_SUBDOMAIN="${PARAM_SUBDOMAIN}" \
    DATADOG_SITE="${PARAM_SITE}" \
    DATADOG_SYNTHETICS_CI_TRIGGER_APP="circle_ci_orb" \
        $DATADOG_CI_COMMAND synthetics run-tests \
        "${args[@]}"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    RunTests
fi
