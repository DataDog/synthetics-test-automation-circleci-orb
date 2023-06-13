module.exports = {
  bumpDatadogCiComment: `This PR was automatically created because a new version of datadog-ci was published.
Once merged, please use [this manual workflow](../actions/workflows/release-version.yml) to release the CI integration.`,
  releaseVersionComment: `Once merged, this PR will automatically create a GitHub release for you.
The description of the release will exactly match this PR's description. Feel free to edit it.

> **Warning**: Publishing the **production** orb with the GitHub App may fail.
> - If so, please **retry the job manually** [here](https://app.circleci.com/pipelines/github/DataDog/synthetics-test-automation-circleci-orb?branch=main&status=failed) on Circle CI. You should look for failing \`test-deploy\` jobs.`,
}
