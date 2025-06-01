local utils = import 'utils.libsonnet';

{
  packageRules: utils.packageRules(utils.aquaYAMLMatchPaths),
  customManagers: utils.setCustomTypeRegex([
    {
      // Update aqua-installer action
      managerFilePatterns: [
        '/action\\.ya?ml$/',
        '/^\\.github/.*\\.ya?ml$/',
        '/^\\.circleci/config\\.yml$/',
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
      managerFilePatterns: [
        '/^\\.devcontainer\\.json$/',
        '/^\\.devcontainer/devcontainer\\.json$/',
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
      managerFilePatterns: [
        '/^renovate\\.json5?$/',
        '/^\\.github/renovate\\.json5?$/',
        '/^\\.gitlab/renovate\\.json5?$/',
        '/^\\.renovaterc\\.json$/',
        '/^\\.renovaterc$/',
      ],
    },
    utils.packageRegexManager {
      datasourceTemplate: 'github-tags',
      managerFilePatterns: ['/\\.?aqua\\.ya?ml$/'],
    },
  ]) + utils.fileMatches(['/\\.?aqua\\.ya?ml$/'], utils.customManagers),
}
