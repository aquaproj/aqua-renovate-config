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
    " +%s *: +%s +# renovate: depName=%s[ \\n]" % [$.wrapQuote("version"), "%s%s" % [prefix, $.currentValue], depName],
    " +%s *: +%s" % [$.wrapQuote("name"), "%s@%s%s" % [depName, prefix, $.currentValue]],
  ],

  // GitHub User and Organization name doesn't include periods.
  depName: "(?<depName>(?<packageName>[^'\" .@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  // Go Module Name includes a period.
  goModuleDepName: "(?<depName>[^\\n]+\\.[^\\n]+)",

  versionMatchString(key):: " +%s *: +%s +# renovate: depName=%s" % [$.wrapQuote(key), $.wrapQuote($.currentValue), $.depName],

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
      " +%s *: +%s" % [$.wrapQuote("name"), "%s@%s" % [$.depName, $.currentValue]],
    ],
    datasourceTemplate: "github-releases",
  },
  goPkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# renovate: depName=%s" % [$.wrapQuote("version"), $.wrapQuote($.currentValue), $.goModuleDepName],
      " +%s *: +%s" % [$.wrapQuote("name"), "%s@%s" % [$.goModuleDepName, $.currentValue]],
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
