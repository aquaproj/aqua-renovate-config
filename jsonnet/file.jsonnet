local utils = import 'utils.libsonnet';

{
  customManagers: utils.fileMatches(utils.argFileMatch.fileMatch, utils.customManagers),
}
