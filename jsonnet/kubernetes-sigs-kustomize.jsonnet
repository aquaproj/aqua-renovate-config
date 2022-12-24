local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.kustomize + utils.argFileMatch,
  ],
}
