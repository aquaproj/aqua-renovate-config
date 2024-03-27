local utils = import 'utils.libsonnet';

{
  customManagers: [
    {
      customType: "regex",
      fileMatch: ['{{arg0}}'],
      matchStrings: [
        'raw\\.githubusercontent\\.com/aquaproj/aqua-installer/%s/aqua-installer' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'aquaproj/aqua-installer',
      versioningTemplate: 'semver', // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
    {
      customType: "regex",
      fileMatch: ['{{arg0}}'],
      matchStrings: [
        'aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +%s\\s' % utils.currentValue,
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +'%s'\\s" % utils.currentValue,
        'aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +"%s"\\s' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'aquaproj/aqua',
      versioningTemplate: 'semver', // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
  ],
}
