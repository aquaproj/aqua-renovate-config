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
  wrapQuote(s):: "(?:%s|'%s'|\"%s\")" % [s, s, s],
  aquaPackageMatchStrings(depName, prefix):: [
    " +%s *: +['\"]?%s(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=%s[ \\n]" % [$.wrapQuote("version"), prefix, depName],
    " +%s *: +['\"]?%s@%s(?<currentValue>[^'\" \\n]+)['\"]?" % [$.wrapQuote("name"), depName, prefix],
  ],
  prefixRegexManager(depName, prefix):: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(depName, prefix),
    extractVersionTemplate: "^%s(?<version>.*)$" % prefix,
    datasourceTemplate: "github-releases",
    depNameTemplate: depName,
  },
  ipinfo(name):: $.prefixRegexManager("ipinfo/cli/" + name, name + "-") + {
    "packageNameTemplate": "ipinfo/cli",
  },
  versionMatchString(key):: " +%s *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)" % $.wrapQuote(key),
  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      $.versionMatchString("version"),
      " +%s *: +['\"]?(?<depName>[^'\" @/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?" % $.wrapQuote("name"),
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
      " +%s *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)" % $.wrapQuote("version"),
      " +%s *: +['\"]?(?<depName>[^\\n]+\\.[^\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?" % $.wrapQuote("name"),
    ],
    datasourceTemplate: "go",
  },
  golangGo: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +['\"]?(go)?(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/go[ \\n]" % $.wrapQuote("version"),
      " +%s *: +['\"]?golang/go@(go)?(?<currentValue>[^'\" \\n]+)['\"]?" % $.wrapQuote("name"),
    ],
    extractVersionTemplate: "^go(?<version>.*)$",
    datasourceTemplate: "github-tags",
    depNameTemplate: "golang/go",
  },
  kubectl: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +['\"]?v(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=kubernetes/kubectl[ \\n]" % $.wrapQuote("version"),
      " +%s *: +['\"]?kubernetes/kubectl@v(?<currentValue>[^'\" \\n]+)['\"]?" % $.wrapQuote("name"),
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
      " +%s *: +['\"]?gopls/(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/tools/gopls[ \\n]" % $.wrapQuote("version"),
      " +%s *: +['\"]?golang/tools/gopls@gopls/(?<currentValue>[^'\" \\n]+)['\"]?" % $.wrapQuote("name"),
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
