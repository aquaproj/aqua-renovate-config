local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.golangGo + utils.argFileMatch,
  ],
  packageRules: [
    {
      matchPackageNames: ["golang/go"],
      versioning: "regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.?(?<patch>\\d+)?$"
    }
  ]
}
