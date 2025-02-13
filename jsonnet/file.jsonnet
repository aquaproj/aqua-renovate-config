local utils = import 'utils.libsonnet';

{
  packageRules: [
    {
      allowedVersions: '/-esoctl$/',
      matchDepNames: [
        'external-secrets/external-secrets/esoctl',
      ],
    },
  ],
  customManagers: utils.fileMatches(utils.argFileMatch.fileMatch, utils.customManagers),
}
