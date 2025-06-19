local utils = import 'utils.libsonnet';

{
  customManagers: [
    utils.aquaRenovateConfigPreset {
      managerFilePatterns: [
        '/{{arg0}}/',
      ],
    },
  ],
}
