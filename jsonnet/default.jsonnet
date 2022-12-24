local utils = import 'utils.libsonnet';

{
  packageRules: [
    // Some packages are updated by github-tags datasource.
    // So disable github-releases against those packages.
    {
      matchPackageNames: utils.githubTagsPackages,
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ["github-releases"],
      enabled: false,
    },
    // By default github-tags is disabled.
    {
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ["github-tags"],
      enabled: false,
    },
    // github-tags is enabled against only those packages.
    {
      matchPackageNames: utils.githubTagsPackages,
      matchPaths: utils.aquaYAMLMatchPaths,
      matchDatasources: ["github-tags"],
      enabled: true,
    }
  ],
  "regexManagers": [
    {
      // Update aqua-installer action
      fileMatch: ["^\\.github/.*\\.ya?ml$"],
      matchStrings: [
        " +['\"]?aqua_version['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      depNameTemplate: "aquaproj/aqua",
      datasourceTemplate: "github-releases",
    },
    {
      // Update aqua-renovate-config
      fileMatch: [
        "^renovate\\.json5?$",
        "^\\.github/renovate\\.json5?$",
        "^\\.gitlab/renovate\\.json5?$",
        "^\\.renovaterc\\.json$",
        "^\\.renovaterc$"
      ],
      matchStrings: [
        "\"github>aquaproj/aqua-renovate-config#(?<currentValue>[^\" \\n\\(]+)",
        "\"github>aquaproj/aqua-renovate-config:.*#(?<currentValue>[^\" \\n\\(]+)",
        "\"github>aquaproj/aqua-renovate-config/.*#(?<currentValue>[^\" \\n\\(]+)"
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "aquaproj/aqua-renovate-config",
    },
    utils.packageRegexManager + {
      datasourceTemplate: "github-tags",
    },
  ] + utils.pkgManagers,
}
