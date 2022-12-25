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
  currentValue: "(?<currentValue>[^'\" \\n]+)",
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

  aquaPackageMatchStrings(depName, prefix):: [
    " +%s *: +['\"]?%s%s['\"]? +# renovate: depName=%s[ \\n]" % [$.wrapQuote("version"), prefix, $.currentValue, depName],
    " +%s *: +['\"]?%s@%s%s['\"]?" % [$.wrapQuote("name"), depName, prefix, $.currentValue],
  ],
  depName: "(?<depName>(?<packageName>[^'\" @/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  versionMatchString(key):: " +%s *: +['\"]?%s['\"]? +# renovate: depName=%s" % [$.wrapQuote(key), $.currentValue, $.depName],

  registryRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      $.versionMatchString("ref"),
    ],
    datasourceTemplate: "github-releases",
  },
  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      $.versionMatchString("version"),
      " +%s *: +['\"]?%s@%s['\"]?" % [$.wrapQuote("name"), $.depName, $.currentValue],
    ],
    datasourceTemplate: "github-releases",
  },
  goPkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +['\"]?%s['\"]? +# renovate: depName=(?<depName>[^\\n]+)" % [$.wrapQuote("version"), $.currentValue],
      " +%s *: +['\"]?(?<depName>[^\\n]+\\.[^\\n]+)*@%s['\"]?" % [$.wrapQuote("name"), $.currentValue],
    ],
    datasourceTemplate: "go",
  },

  kubectl: $.prefixRegexManager("kubernetes/kubectl", "v") + {
    extractVersionTemplate: "^kubernetes-(?<version>.*)$",
    datasourceTemplate: "github-tags",
  },
  golangGo: $.prefixRegexManager("golang/go", "(go)?") + {
    extractVersionTemplate: "^go(?<version>.*)$",
    datasourceTemplate: "github-tags",
  },
  gopls: $.prefixRegexManager("golang/tools/gopls", "gopls/") + {
    packageNameTemplate: "golang/tools",
  },
  kustomize: $.prefixRegexManager("kubernetes-sigs/kustomize", "kustomize/"),
  argFileMatch: {
    fileMatch: ["{{arg0}}"],
  },
  protocGenGoGRPC: $.prefixRegexManager("grpc/grpc-go/protoc-gen-go-grpc", "cmd/protoc-gen-go-grpc/") + {
    packageNameTemplate: "grpc/grpc-go",
  },
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
    $.prefixRegexManager("oven-sh/bun", "bun-"),
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
