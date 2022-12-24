local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.kubectl + {
      "fileMatch": ["{{arg0}}"],
    },
  ],
}
