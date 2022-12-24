local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.kubectl + utils.argFileMatch,
  ],
}
