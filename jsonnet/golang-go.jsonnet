local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.golangGo + utils.argFileMatch,
  ],
}
