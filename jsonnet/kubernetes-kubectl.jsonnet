{
  "regexManagers": [
    {
      "fileMatch": ["{{arg0}}"],
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?v(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=kubernetes/kubectl[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?kubernetes/kubectl@v(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^kubernetes-(?<version>.*)$",
      "datasourceTemplate": "github-tags",
      "depNameTemplate": "kubernetes/kubectl"
    }
  ]
}

