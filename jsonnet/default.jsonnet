local utils = import 'utils.libsonnet';

{
  packageRules: [
    // Some packages are updated by github-tags datasource.
    // So disable github-releases against those packages.
    {
      matchDepNames: utils.githubTagsPackages,
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ['github-releases'],
      enabled: false,
    },
    // By default github-tags is disabled.
    {
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ['github-tags'],
      enabled: false,
    },
    // github-tags is enabled against only those packages.
    {
      matchDepNames: utils.githubTagsPackages,
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ['github-tags'],
      enabled: true,
    },
  ],
  customManagers: [
    {
      // Update aqua-installer action
      customType: 'regex',
      fileMatch: [
        '^action\\.ya?ml$',
        '^\\.github/.*\\.ya?ml$',
        '^\\.circleci/config\\.yml$',
      ],
      matchStrings: [
        ' +%s *: +%s' % [utils.wrapQuote('aqua_version'), utils.currentValue],
        " +%s *: +'%s'" % [utils.wrapQuote('aqua_version'), utils.currentValue],
        ' +%s *: +"%s"' % [utils.wrapQuote('aqua_version'), utils.currentValue],
      ],
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
      depNameTemplate: 'aquaproj/aqua',
      datasourceTemplate: 'github-releases',
    },
    {
      // Update aqua-installer action
      customType: 'regex',
      fileMatch: [
        '^\\.devcontainer\\.json$',
        '^\\.devcontainer/devcontainer\\.json$',
      ],
      matchStrings: [
        // "aqua_version": "v2.27.0"
        ' +"aqua_version" *: +"%s"' % [utils.currentValue],
      ],
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
      depNameTemplate: 'aquaproj/aqua',
      datasourceTemplate: 'github-releases',
    },
    utils.aquaRenovateConfigPreset {
      fileMatch: [
        '^renovate\\.json5?$',
        '^\\.github/renovate\\.json5?$',
        '^\\.gitlab/renovate\\.json5?$',
        '^\\.renovaterc\\.json$',
        '^\\.renovaterc$',
      ],
    },
    utils.packageRegexManager {
      datasourceTemplate: 'github-tags',
    },
  ] + utils.customManagers,
}
