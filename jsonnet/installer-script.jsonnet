local utils = import 'utils.libsonnet';

{
  regexManagers: [
    {
      fileMatch: ["{{arg0}}"],
      matchStrings: [
        "raw\\.githubusercontent\\.com/aquaproj/aqua-installer/%s/aqua-installer" % utils.currentValue,
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "aquaproj/aqua-installer",
    },
    {
      fileMatch: ["{{arg0}}"],
      matchStrings: [
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +%s\\s" % utils.currentValue,
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +'%s'\\s" % utils.currentValue,
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +\"%s\"\\s" % utils.currentValue,
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "aquaproj/aqua",
    },
  ],
}
