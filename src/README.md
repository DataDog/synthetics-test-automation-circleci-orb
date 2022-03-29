# Orb Source

Orbs are shipped as individual `orb.yml` files. To make development easier, you can author an orb in _unpacked_ form, which can be _packed_ with the CircleCI CLI and published.

The default `.circleci/config.yml` file contains the configuration code needed to automatically pack, test, and deploy any changes made to the contents of the orb source in this directory.

## @orb.yml

This is the entry point for an orb "tree", which becomes a `orb.yml` file.

Within the `@orb.yml` file, Datadog recommends you specify the following configuration keys.

1. **version**: Specify version 2.1 for orb-compatible configuration `version: 2.1`
2. **description**: Give your orb a description. Shown within the CLI and orb registry
3. **display**: Specify the `home_url` referencing documentation or product URL, and `source_url` linking to the orb's source repository.
4. **orbs (optional)**: Some orbs may depend on other orbs. Import them here.

## Further Reading

Additional helpful documentation, links, and articles:

 - [Orb Author Intro][1]
 - [Reusable Configuration][2]
 
[1]: https://circleci.com/docs/2.0/orb-author-intro/#section=configuration
[2]: https://circleci.com/docs/2.0/reusing-config)
