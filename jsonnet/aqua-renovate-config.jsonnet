local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.aquaRenovateConfigPreset {
      fileMatch: [
        '{{arg0}}',
      ],
    },
  ],
}
