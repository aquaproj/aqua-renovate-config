local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.kustomize + utils.argFileMatch,
  ],
}
