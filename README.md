# Datadog Continuous Testing for CircleCI

## Overview

[![CircleCI Build Status](https://circleci.com/gh/DataDog/synthetics-test-automation-circleci-orb.svg?style=shield 'CircleCI Build Status')](https://circleci.com/gh/DataDog/synthetics-test-automation-circleci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/datadog/synthetics-ci-orb.svg)](https://circleci.com/orbs/registry/orb/datadog/synthetics-ci-orb) [![Apache 2.0 License](https://shields.io/badge/license-Apache--2.0-lightgray)](https://raw.githubusercontent.com/DataDog/synthetics-ci-orb/main/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

Run Datadog Synthetic tests in your CircleCI pipelines using the Datadog CircleCI orb.

For more information on the available configuration, see the [`datadog-ci synthetics run-tests` documentation][1].

## Setup

To get started:

1. Add your Datadog API and application keys as environment variables to your CircleCI project.
   - For more information, see [API and Application Keys][2].
2. Ensure the image running the orb is a Linux-x64-based image with `curl` installed.
3. Customize your CircleCI workflow by adding a `synthetics-ci/run-tests` step and specifying [inputs](#inputs) as listed below.

Your workflow can be [simple](#simple-usage) or [complex](#complex-usage).

## Simple usage

### Example orb usage using public IDs

```yml
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@4.2.0

jobs:
  e2e-tests:
    docker:
      - image: cimg/base:stable
    steps:
      - synthetics-ci/run-tests:
          public_ids: |
            abc-d3f-ghi
            jkl-mn0-pqr

workflows:
  run-tests:
    jobs:
      - e2e-tests
```

### Example orb usage using a global configuration override

This orb overrides the path to the pattern for [test files][4].

```yml
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@4.2.0

jobs:
  e2e-tests:
    docker:
      - image: cimg/base:stable
    steps:
      - synthetics-ci/run-tests:
          files: e2e-tests/*.synthetics.json

workflows:
  run-tests:
    jobs:
      - e2e-tests
```

For another example pipeline that triggers Synthetic tests, see the [`simple-example.yml` file][5].

## Complex usage

### Example orb usage using the `test_search_query`

```yml
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@4.2.0

jobs:
  e2e-tests:
    docker:
      - image: cimg/base:stable
    steps:
      - synthetics-ci/run-tests:
          test_search_query: 'tag:e2e-tests'

workflows:
  run-tests:
    jobs:
      - e2e-tests
```

### Example orb usage using the [Continuous Testing tunnel][7]

```yml
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@4.2.0

jobs:
  e2e-tests:
    docker:
      - image: your-image
    steps:
      - checkout
      - run:
          name: Running server in background
          command: npm start
          background: true
      - synthetics-ci/run-tests:
          config_path: tests/tunnel-config.json
          files: tests/*.synthetics.json
          test_search_query: 'tag:e2e-tests'
          tunnel: true

workflows:
  test-server:
    jobs:
      - build-image
      - integration-tests:
          requires:
            - build-image
```

For additional options such as customizing the `batchTimeout` for your CircleCI pipelines, see [CI/CD Integrations Configuration][6]. For another example pipeline that starts a local server and triggers Synthetic tests using the Continuous Testing tunnel, see the [`advanced-example.yml` file][8].

## Inputs

For more information on the available configuration, see the [`datadog-ci synthetics run-tests` documentation][1].

| Name                      | Description                                                                                                                                                                                                                                                      |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `api_key`                 | Name of the environment variable containing your Datadog API key. This key is [created in your Datadog organization][2] and should be stored as a secret. <br><sub>**Default:** `DATADOG_API_KEY`</sub>                                                          |
| `app_key`                 | Name of the environment variable containing your Datadog application key. This key is [created in your Datadog organization][2] and should be stored as a secret. <br><sub>**Default:** `DATADOG_APP_KEY`</sub>                                                  |
| `background`              | Whether or not this step should run in the background. [See official CircleCI documentation][18]. <br><sub>**Default:** `false`</sub>                                                                                                                            |
| `batch_timeout`           | The duration in milliseconds after which the CI batch fails as timed out. This does not affect the outcome of a test run that already started. <br><sub>**Default:** `1800000` (30 minutes)</sub>                                                                |
| `config_path`             | The path to the [global configuration file][12] that configures datadog-ci. <br><sub>**Default:** `datadog-ci.json`</sub>                                                                                                                                        |
| `datadog_site`            | Your Datadog site. The possible values are listed [in this table][10]. <br><sub>**Default:** `datadoghq.com`</sub> <!-- partial <br><br>Set it to {{< region-param key="dd_site" code="true" >}} (ensure the correct SITE is selected on the right). partial --> |
| `fail_on_critical_errors` | Fail the CI job if a critical error that is typically transient occurs, such as rate limits, authentication failures, or Datadog infrastructure issues. <br><sub>**Default:** `false`</sub>                                                                      |
| `fail_on_missing_tests`   | Fail the CI job if the list of tests to run is empty or if some explicitly listed tests are missing. <br><sub>**Default:** `false`</sub>                                                                                                                         |
| `fail_on_timeout`         | Fail the CI job if the CI batch fails as timed out. <br><sub>**Default:** `true`</sub>                                                                                                                                                                           |
| `files`                   | Glob patterns to detect Synthetic [test configuration files][4], separated by new lines. <br><sub>Default: `{,!(node_modules)/**/}*.synthetics.json`</sub>                                                                                                       |
| `junit_report`            | The filename for a JUnit report if you want to generate one. <br><sub>Default: none</sub>                                                                                                                                                                        |
| `locations`               | Override the list of locations to run the test from. The possible values are listed [in this API response][3]. <br><sub>**Default:** none</sub>                                                                                                                  |
| `no_output_timeout`       | Elapsed time the command can run without output. The string is a decimal with unit suffix, such as `20m`, `1.25h`, `5s`. [See official CircleCI documentation][13]. <br><sub>**Default:** `35m`</sub>                                                            |
| `public_ids`              | Public IDs of Synthetic tests to run, separated by new lines or commas. If no value is provided, tests are discovered in Synthetic [test configuration files][4]. <br><sub>**Default:** none</sub>                                                               |
| `subdomain`               | The custom subdomain to access your Datadog organization. If your URL is `myorg.datadoghq.com`, the custom subdomain is `myorg`. <br><sub>**Default:** `app`</sub>                                                                                               |
| `test_search_query`       | Use a [search query][14] to select which Synthetic tests to run. Use the [Synthetic Tests list page's search bar][15] to craft your query, then copy and paste it. <br><sub>**Default:** none</sub>                                                              |
| `tunnel`                  | Use the [Continuous Testing tunnel][7] to launch tests against internal environments. <br><sub>**Default:** `false`</sub>                                                                                                                                        |
| `variables`               | Override existing or inject new local and [global variables][16] in Synthetic tests as key-value pairs, separated by new lines or commas. For example: `START_URL=https://example.org,MY_VARIABLE=My title`. <br><sub>**Default:** none</sub>                    |

## Further reading

Additional helpful documentation, links, and articles:

- [Getting Started with Continuous Testing][11]
- [Continuous Testing and CI/CD Configuration][6]
- [Best practices for continuous testing with Datadog][9]

[1]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration/?tab=npm#run-tests-command
[2]: https://docs.datadoghq.com/account_management/api-app-keys/
[3]: https://app.datadoghq.com/api/v1/synthetics/locations?only_public=true
[4]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration/?tab=npm#test-files
[5]: https://github.com/DataDog/synthetics-test-automation-circleci-orb/blob/main/src/examples/simple-example.yml
[6]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration
[7]: https://docs.datadoghq.com/continuous_testing/environments/proxy_firewall_vpn#what-is-the-testing-tunnel
[8]: https://github.com/DataDog/synthetics-test-automation-circleci-orb/blob/main/src/examples/advanced-example.yml
[9]: https://www.datadoghq.com/blog/best-practices-datadog-continuous-testing/
[10]: https://docs.datadoghq.com/getting_started/site/#access-the-datadog-site
[11]: https://docs.datadoghq.com/getting_started/continuous_testing/
[12]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration/?tab=npm#global-configuration-file
[13]: https://circleci.com/docs/configuration-reference/#run
[14]: https://docs.datadoghq.com/synthetics/explore/#search
[15]: https://app.datadoghq.com/synthetics/tests
[16]: https://docs.datadoghq.com/synthetics/platform/settings/?tab=specifyvalue#global-variables
[17]: https://app.datadoghq.com/synthetics/settings/continuous-testing
[18]: https://circleci.com/docs/configuration-reference/#background-commands