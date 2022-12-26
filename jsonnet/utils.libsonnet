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
  currentDigest: "(?<currentDigest>[^'\" \\n]+)",

  prefixRegexManager(depName, prefix):: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(depName, prefix),
    extractVersionTemplate: "^%s(?<version>.*)$" % prefix,
    datasourceTemplate: "github-releases",
    depNameTemplate: depName,
  },
  prefixDigestRegexManager(depName, prefix):: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageDigestMatchStrings(depName, prefix),
    extractVersionTemplate: "^%s(?<version>.*)$" % prefix,
    datasourceTemplate: "github-tags",
    depNameTemplate: depName,
  },

  ipinfo(name):: $.prefixRegexManager("ipinfo/cli/" + name, name + "-") + {
    "packageNameTemplate": "ipinfo/cli",
  },

  aquaPackageMatchStrings(depName, prefix):: [
    " +%s *: +%s%s +# +renovate: +depName=%s[ \\n]" % [$.wrapQuote("version"), prefix, $.currentValue, depName],
    " +%s *: +'%s%s' +# +renovate: +depName=%s[ \\n]" % [$.wrapQuote("version"), prefix, $.currentValue, depName],
    " +%s *: +\"%s%s\" +# +renovate: +depName=%s[ \\n]" % [$.wrapQuote("version"), prefix, $.currentValue, depName],

    " +%s *: +%s@%s%s" % [$.wrapQuote("name"), depName, prefix, $.currentValue],
    " +%s *: +'%s@%s%s'" % [$.wrapQuote("name"), depName, prefix, $.currentValue],
    " +%s *: +\"%s@%s%s\"" % [$.wrapQuote("name"), depName, prefix, $.currentValue],
  ],

  aquaPackageDigestMatchStrings(depName, prefix):: [
    " +%s *: +%s +# +renovate: +tag=%s%s +depName=%s[ \\n]" % [$.wrapQuote("version"), $.currentDigest, prefix, $.currentValue, depName],
    " +%s *: +'%s' +# +renovate: +tag=%s%s +depName=%s[ \\n]" % [$.wrapQuote("version"), $.currentDigest, prefix, $.currentValue, depName],
    " +%s *: +\"%s\" +# +renovate: +tag=%s%s +depName=%s[ \\n]" % [$.wrapQuote("version"), $.currentDigest, prefix, $.currentValue, depName],

    " +%s *: +%s@%s +# +renovate: +tag=%s%s" % [$.wrapQuote("name"), depName, $.currentDigest, prefix, $.currentValue],
    " +%s *: +'%s@%s' +# +renovate: +tag=%s%s" % [$.wrapQuote("name"), depName, $.currentDigest, prefix, $.currentValue],
    " +%s *: +\"%s@%s\" +# +renovate: +tag=%s%s" % [$.wrapQuote("name"), depName, $.currentDigest, prefix, $.currentValue],
  ],

  // GitHub User and Organization name doesn't include periods.
  depName: "(?<depName>(?<packageName>[^'\" .@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  // Go Module Name includes a period.
  goModuleDepName: "(?<depName>[^\\n]+\\.[^\\n]+)",

  registryRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# +renovate: +depName=%s" % [$.wrapQuote("ref"), $.currentValue, $.depName],
      " +%s *: +'%s' +# +renovate: +depName=%s" % [$.wrapQuote("ref"), $.currentValue, $.depName],
      " +%s *: +\"%s\" +# +renovate: +depName=%s" % [$.wrapQuote("ref"), $.currentValue, $.depName],
    ],
    datasourceTemplate: "github-releases",
  },
  registryDigestRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("ref"), $.currentDigest, $.currentValue, $.depName],
      " +%s *: +'%s' +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("ref"), $.currentDigest, $.currentValue, $.depName],
      " +%s *: +\"%s\" +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("ref"), $.currentDigest, $.currentValue, $.depName],
    ],
    datasourceTemplate: "github-tags",
  },

  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# +renovate: +depName=%s" % [$.wrapQuote("version"), $.currentValue, $.depName],
      " +%s *: +'%s' +# +renovate: +depName=%s" % [$.wrapQuote("version"), $.currentValue, $.depName],
      " +%s *: +\"%s\" +# +renovate: +depName=%s" % [$.wrapQuote("version"), $.currentValue, $.depName],

      " +%s *: +%s@%s" % [$.wrapQuote("name"), $.depName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote("name"), $.depName, $.currentValue],
      " +%s *: +\"%s@%s\"" % [$.wrapQuote("name"), $.depName, $.currentValue],
    ],
    datasourceTemplate: "github-releases",
  },
  packageDigestRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("version"), $.currentDigest, $.currentValue, $.depName],
      " +%s *: +'%s' +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("version"), $.currentDigest, $.currentValue, $.depName],
      " +%s *: +\"%s\" +# +renovate: +tag=%s +depName=%s" % [$.wrapQuote("version"), $.currentDigest, $.currentValue, $.depName],

      " +%s *: +%s@%s +# +renovate: +tag=%s" % [$.wrapQuote("name"), $.depName, $.currentDigest, $.currentValue],
      " +%s *: +'%s@%s' +# +renovate: +tag=%s" % [$.wrapQuote("name"), $.depName, $.currentDigest, $.currentValue],
      " +%s *: +\"%s@%s\" +# +renovate: +tag=%s" % [$.wrapQuote("name"), $.depName, $.currentDigest, $.currentValue],
    ],
    datasourceTemplate: "github-tags",
  },
  goPkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      " +%s *: +%s +# +renovate: depName=%s" % [$.wrapQuote("version"), $.currentValue, $.goModuleDepName],
      " +%s *: +'%s' +# +renovate: depName=%s" % [$.wrapQuote("version"), $.currentValue, $.goModuleDepName],
      " +%s *: +\"%s\" +# +renovate: depName=%s" % [$.wrapQuote("version"), $.currentValue, $.goModuleDepName],

      " +%s *: +%s@%s" % [$.wrapQuote("name"), $.goModuleDepName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote("name"), $.goModuleDepName, $.currentValue],
      " +%s *: +\"%s@%s\"" % [$.wrapQuote("name"), $.goModuleDepName, $.currentValue],
    ],
    datasourceTemplate: "go",
  },
  kubectlConvert: {
    datasourceTemplate: "github-releases",
    depNameTemplate: "kubernetes/kubectl-convert",
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(self.depNameTemplate, ""),
    packageNameTemplate: "kubernetes/kubernetes"
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
    $.packageDigestRegexManager,
    $.registryRegexManager,
    $.registryDigestRegexManager,
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
    $.kubectlConvert,
    $.kubectl,
    $.kustomize,
    $.prefixRegexManager("mongodb/mongodb-atlas-cli/atlascli", "atlascli/") + {
      packageNameTemplate: "mongodb/mongodb-atlas-cli",
    },
    $.prefixRegexManager("orf/gping", "gping-"),
    $.protocGenGoGRPC,
  ]
}
