local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.kubectl + utils.argFileMatch,
  ],
}
