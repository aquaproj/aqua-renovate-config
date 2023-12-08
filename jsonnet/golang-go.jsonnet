local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.golangGo + utils.argFileMatch,
  ],
}
