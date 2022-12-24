{
  regexManagers: [
    {
      fileMatch: ["{{arg0}}"],
      matchStrings: [
        "raw\\.githubusercontent\\.com/aquaproj/aqua-installer/(?<currentValue>.*?)/aqua-installer",
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "aquaproj/aqua-installer",
    },
    {
      fileMatch: ["{{arg0}}"],
      matchStrings: [
        "aqua-installer +(\\| +(ba|z)?sh +-s +-- +)?(-i +\\S+ +)?-v +['\"]?(?<currentValue>[^'\" \\n]+)['\"]?\\s",
      ],
      datasourceTemplate: "github-releases",
      depNameTemplate: "aquaproj/aqua",
    },
  ],
}
