local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.golangGo.regexManager + utils.argFileMatch,
  ],
}
