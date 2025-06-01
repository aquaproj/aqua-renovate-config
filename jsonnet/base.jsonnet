local utils = import 'utils.libsonnet';

{
  customManagers: utils.fileMatches(['/\\.?aqua\\.ya?ml/'], utils.customManagers),
}
