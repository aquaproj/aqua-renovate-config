{
  "regexManagers": [
    {
      "fileMatch": ["\\.?aqua\\.ya?ml"],
      "matchStrings": [
        " +['\"]?(version|ref)['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)",
        " +['\"]?name['\"]? *: +['\"]?(?<depName>[^'\" @/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "datasourceTemplate": "github-releases"
    }
  ]
}
