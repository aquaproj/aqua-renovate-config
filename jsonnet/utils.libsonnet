{
  aquaYAMLMatchPaths: [
    '**/.aqua.yaml',
    '**/.aqua.yml',
    '**/aqua.yaml',
    '**/aqua.yml',
  ],
  githubTagsPackages: [
    'golang/go',
    'golang/tools',
    'kubernetes/kubectl',
    'twistedpair/google-cloud-sdk',
  ],
  aquaYAMLFileMatch: ['\\.?aqua\\.ya?ml'],
  wrapQuote(s):: "(?:%s|'%s'|\"%s\")" % [s, s, s],
  currentValue: "(?<currentValue>[^'\" \\n]+)",
  prefixRegexManager(depName, prefix):: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(depName, prefix),
    extractVersionTemplate: '^%s(?<version>.*)$' % prefix,
    datasourceTemplate: 'github-releases',
    depNameTemplate: depName,
  },
  ipinfo(name):: $.prefixRegexManager('ipinfo/cli/' + name, name + '-') + {
    packageNameTemplate: 'ipinfo/cli',
  },

  aquaPackageMatchStrings(depName, prefix):: [
    ' +%s *: +%s%s +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), prefix, $.currentValue, depName],
    " +%s *: +'%s%s' +# renovate: depName=%s[ \\n]" % [$.wrapQuote('version'), prefix, $.currentValue, depName],
    ' +%s *: +"%s%s" +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), prefix, $.currentValue, depName],

    ' +%s *: +%s@%s%s' % [$.wrapQuote('name'), depName, prefix, $.currentValue],
    " +%s *: +'%s@%s%s'" % [$.wrapQuote('name'), depName, prefix, $.currentValue],
    ' +%s *: +"%s@%s%s"' % [$.wrapQuote('name'), depName, prefix, $.currentValue],
  ],

  // GitHub User and Organization name doesn't include periods.
  depName: "(?<depName>(?<packageName>[^'\" .@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  goModuleDepName: '(?<depName>golang\\.org/[^\\n]+)',
  crateDepName: 'crates\\.io/(?<depName>[^\\n]+)',

  registryRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('ref'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
    ],
    datasourceTemplate: 'github-releases',
  },
  packageRegexManager: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.depName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.depName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.depName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.depName, $.currentValue],
    ],
    datasourceTemplate: 'github-releases',
  },
  goPkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
    ],
    datasourceTemplate: 'go',
  },
  cratePkg: {
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
    ],
    datasourceTemplate: 'crate',

    // https://docs.renovatebot.com/modules/versioning/#cargo-versioning
    // The default is 'cargo`, but 'cargo' didnt't update skim 0.10.1 to 0.10.4, so we use 'semver'.
    versioningTemplate: 'semver',
  },
  kubectlConvert: {
    datasourceTemplate: 'github-releases',
    depNameTemplate: 'kubernetes/kubectl-convert',
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: $.aquaPackageMatchStrings(self.depNameTemplate, ''),
    packageNameTemplate: 'kubernetes/kubernetes',
  },
  kubectl: $.prefixRegexManager('kubernetes/kubectl', 'v') + {
    extractVersionTemplate: '^kubernetes-(?<version>.*)$',
    datasourceTemplate: 'github-tags',
  },
  golangGo: $.prefixRegexManager('golang/go', '(go)?') + {
    extractVersionTemplate: '^go(?<version>.*)$',
    datasourceTemplate: 'github-tags',
    versioningTemplate: 'regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.?(?<patch>\\d+)?$',
  },
  gopls: $.prefixRegexManager('golang/tools/gopls', 'gopls/') + {
    packageNameTemplate: 'golang/tools',
  },
  kustomize: $.prefixRegexManager('kubernetes-sigs/kustomize', 'kustomize/'),
  argFileMatch: {
    fileMatch: ['{{arg0}}'],
  },
  protocGenGoGRPC: $.prefixRegexManager('grpc/grpc-go/protoc-gen-go-grpc', 'cmd/protoc-gen-go-grpc/') + {
    packageNameTemplate: 'grpc/grpc-go',
  },
  fileMatches(fileMatch, managers):: [
    manager {
      fileMatch: fileMatch,
    }
    for manager in managers
  ],
  pkgManagers: [
    $.packageRegexManager,
    $.registryRegexManager,
    $.goPkg,
    $.cratePkg,
    $.prefixRegexManager('oven-sh/bun', 'bun-'),
    $.golangGo,
    $.gopls,
    $.prefixRegexManager('ipinfo/cli', 'ipinfo-'),
    $.ipinfo('cidr2ip'),
    $.ipinfo('cidr2range'),
    $.ipinfo('range2cidr'),
    $.ipinfo('prips'),
    $.ipinfo('splitcidr'),
    $.ipinfo('randip'),
    $.ipinfo('grepip'),
    $.ipinfo('range2ip'),
    $.kubectlConvert,
    $.kubectl,
    $.kustomize,
    $.prefixRegexManager('mongodb/mongodb-atlas-cli/atlascli', 'atlascli/') + {
      packageNameTemplate: 'mongodb/mongodb-atlas-cli',
    },
    $.prefixRegexManager('orf/gping', 'gping-'),
    $.protocGenGoGRPC,
  ],
}
