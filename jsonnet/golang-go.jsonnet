local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.golangGo + utils.argFileMatch,
  ],
  packageRules: [
    {
      matchPackageNames: ["golang/go"],
      matchPaths: [
        "**/.aqua.yaml",
        "**/.aqua.yml",
        "**/aqua.yaml",
        "**/aqua.yml"
      ],
      versioning: "regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.?(?<patch>\\d+)?$"
    }
  ]
}
