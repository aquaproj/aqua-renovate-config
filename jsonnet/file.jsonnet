local utils = import 'utils.libsonnet';

{
  regexManagers: utils.fileMatches(utils.argFileMatch.fileMatch, utils.pkgManagers),
}
