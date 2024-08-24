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
    'awslabs/mountpoint-s3',
    'aws/aws-cli',
    'catenacyber/perfsprint',
    'golang/vuln/govulncheck',
  ],
  aquaYAMLFileMatch: ['\\.?aqua\\.ya?ml'],
  wrapQuote(s):: "(?:%s|'%s'|\"%s\")" % [s, s, s],
  currentValue: "(?<currentValue>[^'\" \\n]+)",
  prefixRegexManager(depName, prefix):: {
    customType: 'regex',
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

  python: {
    // Update python_version
    // https://docs.renovatebot.com/modules/datasource/python-version/
    // https://github.com/aquaproj/aqua-registry/issues/1138
    customType: 'regex',
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s' % [$.wrapQuote('python_version'), $.currentValue],
    ],
    datasourceTemplate: 'python-version',
    depNameTemplate: 'python',
    matchStringsStrategy: 'any',
    versioningTemplate: 'python',
  },

  aquaRenovateConfigPreset: {
    // Update aqua-renovate-config
    customType: 'regex',
    matchStrings: [
      '"github>aquaproj/aqua-renovate-config#(?<currentValue>[^" \\n\\(]+)',
      '"github>aquaproj/aqua-renovate-config:.*#(?<currentValue>[^" \\n\\(]+)',
      '"github>aquaproj/aqua-renovate-config/.*#(?<currentValue>[^" \\n\\(]+)',
    ],
    datasourceTemplate: 'github-releases',
    depNameTemplate: 'aquaproj/aqua-renovate-config',
  },

  // GitHub User and Organization name doesn't include periods.
  depName: "(?<depName>(?<packageName>[^'\" .@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  goModuleDepName: '(?<depName>golang\\.org/[^\\n]+)',
  crateDepName: '(?<depName>crates\\.io/(?<packageName>[^\\n]+))',
  gitlabDepName: '(?<depName>gitlab\\.com/(?<packageName>[^\\n]+))',
  giteaDepName: '(?<depName>gitea\\.com/(?<packageName>[^\\n]+))',

  registryRegexManager: {
    customType: 'regex',
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('ref'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
    ],
    datasourceTemplate: 'github-releases',
  },
  packageRegexManager: {
    customType: 'regex',
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
    customType: 'regex',
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
    customType: 'regex',
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
  gitlabPkg: {
    customType: 'regex',
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
    ],
    datasourceTemplate: 'gitlab-releases',
  },
  giteaPkg: {
    customType: 'regex',
    fileMatch: $.aquaYAMLFileMatch,
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],

      ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
      " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
      ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
    ],
    datasourceTemplate: 'gitea-releases',
  },
  kubectlConvert: {
    customType: 'regex',
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
  awslabsMountpointS3: $.prefixRegexManager('awslabs/mountpoint-s3', 'mountpoint-s3-') + {
    datasourceTemplate: 'github-tags',
  },
  trunkLauncher: {
    customType: 'regex',
    matchStrings: $.aquaPackageMatchStrings('trunk-io/launcher', ''),
    fileMatch: $.aquaYAMLFileMatch,
    datasourceTemplate: 'npm',
    packageNameTemplate: '@trunkio/launcher',
    depNameTemplate: 'trunk-io/launcher',
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
    $.gitlabPkg,
    $.giteaPkg,
    $.prefixRegexManager('oven-sh/bun', 'bun-'),
    $.golangGo,
    $.gopls,
    $.python,
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
    $.prefixRegexManager('jqlang/jq', 'jq-'),
    $.protocGenGoGRPC,
    $.awslabsMountpointS3,
    $.trunkLauncher,
  ],
}
