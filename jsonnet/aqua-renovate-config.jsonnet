local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.aquaRenovateConfigPreset + {
      fileMatch: [
        '{{arg0}}',
      ],
    },
  ],
}
