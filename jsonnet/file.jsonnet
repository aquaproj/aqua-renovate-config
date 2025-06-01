local utils = import 'utils.libsonnet';

{
  packageRules: utils.packageRules(utils.argFileMatch.managerFilePatterns),
  customManagers: utils.fileMatches(utils.argFileMatch.managerFilePatterns, utils.customManagers),
}
