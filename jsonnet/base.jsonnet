local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.packageRegexManager,
    utils.registryRegexManager,
  ],
}
