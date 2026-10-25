local utils = import 'utils.libsonnet';

{
  customManagers: utils.setCustomTypeRegex([
    {
      // A URL pinned by a commit SHA with the version as a comment:
      // https://raw.githubusercontent.com/aquaproj/aqua-installer/611554c6f0137ba41c8dd15aca8bee82504ea461/aqua-installer # v4.1.1
      // The comment can start with "//" too, e.g. in JavaScript.
      // github-tags is used because github-releases doesn't resolve a tag to a commit SHA.
      managerFilePatterns: ['/{{arg0}}/'],
      matchStrings: [
        'raw\\.githubusercontent\\.com/aquaproj/aqua-installer/(?<currentDigest>[0-9a-f]{40})/aqua-installer[\'"`]?[;,]? +(?:#|//) +%s' % utils.currentValue,
      ],
      datasourceTemplate: 'github-tags',
      depNameTemplate: 'aquaproj/aqua-installer',
      versioningTemplate: 'semver',
    },
    {
      managerFilePatterns: ['/{{arg0}}/'],
      matchStrings: [
        'raw\\.githubusercontent\\.com/aquaproj/aqua-installer/%s/aqua-installer' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'aquaproj/aqua-installer',
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
    {
      managerFilePatterns: ['/{{arg0}}/'],
      matchStrings: [
        'aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +%s\\s' % utils.currentValue,
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +'%s'\\s" % utils.currentValue,
        'aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +"%s"\\s' % utils.currentValue,
      ],
      datasourceTemplate: 'github-releases',
      depNameTemplate: 'aquaproj/aqua',
      versioningTemplate: 'semver',  // https://github.com/renovatebot/renovate/discussions/28150#discussioncomment-8925362
    },
  ]),
}
