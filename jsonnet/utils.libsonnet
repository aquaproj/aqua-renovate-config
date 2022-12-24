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
  versionMatchString(key):: " +['\"]?" + key + "['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)",
  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      $.versionMatchString("version"),
      " +['\"]?name['\"]? *: +['\"]?(?<depName>[^'\" @/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?"
    ],
    datasourceTemplate: "github-releases",
  },
  registryRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      $.versionMatchString("ref"),
    ],
    datasourceTemplate: "github-releases",
  },
  goPkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +['\"]?version['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)",
      " +['\"]?name['\"]? *: +['\"]?(?<depName>[^\\n]+\\.[^\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?"
    ],
    datasourceTemplate: "go",
  },
  golangGo: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +['\"]?version['\"]? *: +['\"]?(go)?(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/go[ \\n]",
      " +['\"]?name['\"]? *: +['\"]?golang/go@(go)?(?<currentValue>[^'\" \\n]+)['\"]?"
    ],
    extractVersionTemplate: "^go(?<version>.*)$",
    datasourceTemplate: "github-tags",
    depNameTemplate: "golang/go",
  },
  kubectl: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +['\"]?version['\"]? *: +['\"]?v(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=kubernetes/kubectl[ \\n]",
      " +['\"]?name['\"]? *: +['\"]?kubernetes/kubectl@v(?<currentValue>[^'\" \\n]+)['\"]?"
    ],
    extractVersionTemplate: "^kubernetes-(?<version>.*)$",
    datasourceTemplate: "github-tags",
    depNameTemplate: "kubernetes/kubectl",
  },
  kustomize: $.prefixRegexManager("kubernetes-sigs/kustomize", "kustomize/"),
  argFileMatch: {
    fileMatch: ["{{arg0}}"],
  },
  protocGenGoGRPC: $.prefixRegexManager("grpc/grpc-go/protoc-gen-go-grpc", "cmd/protoc-gen-go-grpc/") + {
    packageNameTemplate: "grpc/grpc-go",
  },
  gopls: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +['\"]?version['\"]? *: +['\"]?gopls/(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/tools/gopls[ \\n]",
      " +['\"]?name['\"]? *: +['\"]?golang/tools/gopls@gopls/(?<currentValue>[^'\" \\n]+)['\"]?",
    ],
    extractVersionTemplate: "^gopls/(?<version>.*)$",
    datasourceTemplate: "github-releases",
    depNameTemplate: "golang/tools",
  },
  bun: $.prefixRegexManager("oven-sh/bun", "bun-"),
  fileMatches(fileMatch, managers):: [
    manager + {
      fileMatch: fileMatch,
    },
    for manager in managers
  ],
  pkgManagers: [
    $.packageRegexManager,
    $.registryRegexManager,
    $.goPkg,
    $.bun,
    $.golangGo,
    $.gopls,
    $.prefixRegexManager("ipinfo/cli", "ipinfo-"),
    $.ipinfo("cidr2ip"),
    $.ipinfo("cidr2range"),
    $.ipinfo("range2cidr"),
    $.ipinfo("prips"),
    $.ipinfo("splitcidr"),
    $.ipinfo("randip"),
    $.ipinfo("grepip"),
    $.ipinfo("range2ip"),
    $.kubectl,
    $.kustomize,
    $.prefixRegexManager("mongodb/mongodb-atlas-cli/atlascli", "atlascli/") + {
      packageNameTemplate: "mongodb/mongodb-atlas-cli",
    },
    $.prefixRegexManager("orf/gping", "gping-"),
    $.protocGenGoGRPC,
  ]
}
