{
  "regexManagers": [
    {
      "fileMatch": ["{{arg0}}"],
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?(go)?(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/go[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?golang/go@(go)?(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^go(?<version>.*)$",
      "datasourceTemplate": "github-tags",
      "depNameTemplate": "golang/go"
    }
  ]
}
