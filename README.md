# synthetics-ci-orb

[![CircleCI Build Status](https://circleci.com/gh/DataDog/synthetics-ci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/DataDog/synthetics-ci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/datadog/synthetics-ci-orb-private.svg)](https://circleci.com/orbs/registry/orb/datadog/synthetics-ci-orb-private) [![Apache 2.0 License](https://img.shields.io/badge/license-Apache 2.0-lightgrey.svg)](https://raw.githubusercontent.com/DataDog/synthetics-ci-orb/main/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

CircleCI command orb that installs [datadog-ci](https://github.com/DataDog/datadog-ci/) and uses the `datadog-ci synthetics run-tests` [command](https://github.com/DataDog/datadog-ci/tree/master/src/commands/synthetics) to execute [DataDog Synthetics tests](https://docs.datadoghq.com/synthetics/cicd_integrations). For the command to work, the image running it must have `curl` installed.

## Usage

Basic example:

```
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@1.0.0

jobs:
  integration-tests:
    docker: 
      - image: cimg/base:stable
    steps:
      - synthetics-ci/run-tests:
          api_key: DATADOG_API_KEY
          app_key: DATADOG_APP_KEY
          files: integration-tests/*.synthetics.json
```

Advanced example:

```
version: 2.1

orbs:
  synthetics-ci: datadog/synthetics-ci-orb@1.0.0

jobs:
  integration-tests:
    docker: 
      - image: your-image
    steps:
      - checkout
      - your-server-start-command -p 3000
      - synthetics-ci/run-tests:
          api_key: DATADOG_API_KEY
          app_key: DATADOG_APP_KEY
          config_path: integration-tests/tunnel-config.json
          files: integration-tests/*.synthetics.json
          test_search_query: 'tag:e2e-tests'
          tunnel: true
```

## Running unit tests locally

The unit tests defined in the `src/tests` folder can be ran by installing the [bats](https://bats-core.readthedocs.io/en/stable/installation.html) CLI and running:

```
bats src/tests/
```

## Resources

- [CircleCI Orb Registry Page](https://circleci.com/orbs/registry/orb/datadog/synthetics-ci-orb) - The official registry page of this orb for all versions, executors, commands, and jobs described.
- [CircleCI Orb Docs](https://circleci.com/docs/2.0/orb-intro/#section=configuration) - Docs for using and creating CircleCI Orbs.

### How to Contribute

We welcome [issues](https://github.com/DataDog/synthetics-ci-orb/issues) to and [pull requests](https://github.com/DataDog/synthetics-ci-orb/pulls) against this repository!

### How to Publish
* Create and push a branch with your new features.
* When ready to publish a new production version, create a Pull Request from _feature branch_ to `main`.
* The title of the pull request must contain a special semver tag: `[semver:<segment>]` where `<segment>` is replaced by one of the following values.

| Increment | Description|
| ----------| -----------|
| major     | Issue a 1.0.0 incremented release|
| minor     | Issue a x.1.0 incremented release|
| patch     | Issue a x.x.1 incremented release|
| skip      | Do not issue a release|

Example: `[semver:major]`

* Squash and merge. Ensure the semver tag is preserved and entered as a part of the commit message.
* On merge, after manual approval, the orb will automatically be published to the Orb Registry.


For further questions/comments about this or other orbs, visit the Orb Category of [CircleCI Discuss](https://discuss.circleci.com/c/orbs).

