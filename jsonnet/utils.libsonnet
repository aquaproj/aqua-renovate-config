{
  aquaYAMLMatchPaths: [
    ".aqua.yaml",
    ".aqua.yml",
    "aqua.yaml",
    "aqua.yml"
  ],
  githubTagsPackages: [
    "golang/go",
    "golang/tools",
    "kubernetes/kubectl",
    "twistedpair/google-cloud-sdk"
  ],
  aquaYAMLFileMatch: ["\\.?aqua\\.ya?ml"],
  aquaPackageMatchStrings(depName, prefix):: [
    " +['\"]?version['\"]? *: +['\"]?" + prefix + "(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=" + depName + "[ \\n]",
    " +['\"]?name['\"]? *: +['\"]?" + depName + "@" + prefix + "(?<currentValue>[^'\" \\n]+)['\"]?"
  ],
  prefixRegexManager(depName, prefix):: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(depName, prefix),
    extractVersionTemplate: "^" + prefix + "(?<version>.*)$",
    datasourceTemplate: "github-releases",
    depNameTemplate: depName,
  },
  ipinfo(name):: $.prefixRegexManager("ipinfo/cli/" + name, name + "-") + {
    "packageNameTemplate": "ipinfo/cli",
  },
  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +['\"]?(version|ref)['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)",
      " +['\"]?name['\"]? *: +['\"]?(?<depName>[^'\" @/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?"
    ],
    datasourceTemplate: "github-releases",
  },
}
