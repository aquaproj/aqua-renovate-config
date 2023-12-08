local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.packageRegexManager,
    utils.registryRegexManager,
  ],
}
