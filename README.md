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

| Name                      | Description                                                                                                                                                                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `api_key`                 | The name of the environment variable containing the API key. <br><sub>**Default:** `DATADOG_API_KEY`</sub>                                                                                                                                                   |
| `app_key`                 | The name of the environment variable containing the APP key. <br><sub>**Default:** `DATADOG_APP_KEY`</sub>                                                                                                                                                   |
| `background`              | Whether or not this step should run in the background. <br><sub>[See official CircleCI documentation](https://circleci.com/docs/configuration-reference/#run) for the default value.</sub>                                                                   |
| `batch_timeout`           | The duration (in milliseconds) after which the batch fails as timed out. <br><sub>**Default:** `1800000` (30 minutes)</sub>                                                                                                                                  |
| `config_path`             | The global JSON configuration used when launching tests. <br><sub>**Default:** `datadog-ci.json`</sub>                                                                                                                                                       |
| `fail_on_critical_errors` | Fail if tests were not triggered or results could not be fetched. <br><sub>**Default:** `false`</sub>                                                                                                                                                        |
| `fail_on_missing_tests`   | Fail if at least one specified test with a public ID (using `public_ids` or listed in a [test file][18]) is missing in a run (for example, if it has been deleted programmatically or on the Datadog site). <br><sub>**Default:** `false`</sub>              |
| `fail_on_timeout`         | Force the CI to fail (or pass) if one of the results exceeds its test timeout. <br><sub>**Default:** `true`</sub>                                                                                                                                            |
| `files`                   | A list of glob patterns to detect Synthetic tests config files, separated by new lines. <br><sub>Default: `{,!(node_modules)/**/}*.synthetics.json`</sub>                                                                                                    |
| `junit_report`            | The filename for a JUnit report if you want to generate one. <br><sub>Default: none</sub>                                                                                                                                                                    |
| `locations`               | String of locations separated by semicolons to override the locations where your tests run. <br><sub>**Default:** none</sub>                                                                                                                                 |
| `no_output_timeout`       | Elapsed time the command can run without output. The string is a decimal with unit suffix, such as “20m”, “1.25h”, “5s”. <br><sub>[See official CircleCI documentation](https://circleci.com/docs/configuration-reference/#run) for the default value.</sub> |
| `public_ids`              | Public IDs of Synthetic tests to run, separated by new lines or commas. If no value is provided, tests are discovered in `*.synthetics.json` files. <br><sub>**Default:** none</sub>                                                                         |
| `site`                    | The [Datadog site][10] to send data to. If the `DD_SITE` environment variable is set, it takes preference. <br><sub>**Default:** `datadoghq.com`</sub>                                                                                                       |
| `subdomain`               | The name of the custom subdomain set to access your Datadog application. <br><sub>**Default:** `app`</sub>                                                                                                                                                   |
| `test_search_query`       | Trigger tests corresponding to a search query. <br><sub>**Default:** none</sub>                                                                                                                                                                              |
| `tunnel`                  | Use the Continuous Testing tunnel to trigger tests. <br><sub>**Default:** `false`</sub>                                                                                                                                                                      |
| `variables`               | Key-value pairs for injecting variables into tests, separated by newlines or commas. For example: `START_URL=https://example.org,MY_VARIABLE=My title`. <br><sub>**Default:** none</sub>                                                                     |

## Further reading

Additional helpful documentation, links, and articles:

- [Getting Started with Continuous Testing][11]
- [Continuous Testing and CI/CD Configuration][6]
- [Best practices for continuous testing with Datadog][9]

[1]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration/?tab=npm#run-tests-command
[2]: https://docs.datadoghq.com/account_management/api-app-keys/
[4]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration/?tab=npm#test-files
[5]: https://github.com/DataDog/synthetics-test-automation-circleci-orb/blob/main/src/examples/simple-example.yml
[6]: https://docs.datadoghq.com/continuous_testing/cicd_integrations/configuration
[7]: https://docs.datadoghq.com/continuous_testing/environments/proxy_firewall_vpn#what-is-the-testing-tunnel
[8]: https://github.com/DataDog/synthetics-test-automation-circleci-orb/blob/main/src/examples/advanced-example.yml
[9]: https://www.datadoghq.com/blog/best-practices-datadog-continuous-testing/
[10]: https://docs.datadoghq.com/getting_started/site/#access-the-datadog-site
[11]: https://docs.datadoghq.com/getting_started/continuous_testing/
