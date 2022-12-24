local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.kustomize + {
      fileMatch: ["{{arg0}}"],
    },
  ],
}
