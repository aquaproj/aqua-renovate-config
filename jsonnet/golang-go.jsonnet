local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.golangGo + {
      fileMatch: ["{{arg0}}"],
    },
  ],
}
