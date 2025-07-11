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
  aquaYAMLFileMatch: ['/\\.?aqua\\.ya?ml/'],
  wrapQuote(s):: "(?:%s|'%s'|\"%s\")" % [s, s, s],
  currentValue: "(?<currentValue>[^'\" \\n]+)",
  prefixRegexManager(depName, prefix):: {
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
  aquaPackageMatchStringsWithSuffix(depName, suffix):: [
    ' +%s *: +%s%s +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), $.currentValue, suffix, depName],
    " +%s *: +'%s%s' +# renovate: depName=%s[ \\n]" % [$.wrapQuote('version'), $.currentValue, suffix, depName],
    ' +%s *: +"%s%s" +# renovate: depName=%s[ \\n]' % [$.wrapQuote('version'), $.currentValue, suffix, depName],

    ' +%s *: +%s@%s%s' % [$.wrapQuote('name'), depName, $.currentValue, suffix],
    " +%s *: +'%s@%s%s'" % [$.wrapQuote('name'), depName, $.currentValue, suffix],
    ' +%s *: +"%s@%s%s"' % [$.wrapQuote('name'), depName, $.currentValue, suffix],
  ],

  aquaRenovateConfigPreset: {
    // Update aqua-renovate-config
    matchStrings: [
      '[\'"]github>aquaproj/aqua-renovate-config#(?<currentValue>[^\'" \\n\\(]+)',
      '[\'"]github>aquaproj/aqua-renovate-config:.*#(?<currentValue>[^\'" \\n\\(]+)',
      '[\'"]github>aquaproj/aqua-renovate-config/.*#(?<currentValue>[^\'" \\n\\(]+)',
    ],
    datasourceTemplate: 'github-releases',
    depNameTemplate: 'aquaproj/aqua-renovate-config',
  },

  // GitHub User and Organization name doesn't include "." and "_".
  depName: "(?<depName>(?<packageName>[^'\" _.@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*)",
  golangOrgDepName: '(?<depName>golang\\.org/[^\\n]+)',
  goModuleDepName: '(?<depName>_go/(?<packageName>[^#\\n]+)(?:#.*)?)',
  crateDepName: '(?<depName>crates\\.io/(?<packageName>[^\\n]+))',
  gitlabDepName: '(?<depName>gitlab\\.com/(?<packageName>[^\\n]+))',
  giteaDepName: '(?<depName>gitea\\.com/(?<packageName>[^\\n]+))',

  registryRegexManager: {
    matchStrings: [
      ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
      " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('ref'), $.currentValue, $.depName],
      ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('ref'), $.currentValue, $.depName],
    ],
    datasourceTemplate: 'github-releases',
  },
  packageRegexManager: {
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
  argFileMatch: {
    managerFilePatterns: ['/{{arg0}}/'],
  },
  fileMatches(fileMatch, managers):: [
    manager {
      managerFilePatterns: fileMatch,
    }
    for manager in managers
  ],
  setCustomTypeRegex(managers):: [
    manager {
      customType: 'regex',
    }
    for manager in managers
  ],

  customManagers: $.setCustomTypeRegex([
    $.packageRegexManager,
    $.registryRegexManager,
    {
      // golang.org
      datasourceTemplate: 'go',
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.golangOrgDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.golangOrgDepName, $.currentValue],
      ],
    },
    {
      // Go module
      datasourceTemplate: 'go',
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.goModuleDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.goModuleDepName, $.currentValue],
      ],
    },
    {
      // Rust crates.io
      datasourceTemplate: 'crate',
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.crateDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.crateDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.crateDepName, $.currentValue],
      ],
      // https://docs.renovatebot.com/modules/versioning/#cargo-versioning
      // The default is 'cargo`, but 'cargo' didnt't update skim 0.10.1 to 0.10.4, so we use 'semver'.
      versioningTemplate: 'semver',
    },
    {
      // Gitlab
      datasourceTemplate: 'gitlab-releases',
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.gitlabDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.gitlabDepName, $.currentValue],
      ],
    },
    {
      // Gitea
      datasourceTemplate: 'gitea-releases',
      matchStrings: [
        ' +%s *: +%s +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
        " +%s *: +'%s' +# renovate: depName=%s" % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],
        ' +%s *: +"%s" +# renovate: depName=%s' % [$.wrapQuote('version'), $.currentValue, $.giteaDepName],

        ' +%s *: +%s@%s' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
        " +%s *: +'%s@%s'" % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
        ' +%s *: +"%s@%s"' % [$.wrapQuote('name'), $.giteaDepName, $.currentValue],
      ],
    },
    $.prefixRegexManager('oven-sh/bun', 'bun-'),
    $.prefixRegexManager('golang/go', '(go)?') + {
      extractVersionTemplate: '^go(?<version>.*)$',
      datasourceTemplate: 'github-tags',
      versioningTemplate: 'regex:^(?<major>\\d+)\\.(?<minor>\\d+)\\.?(?<patch>\\d+)?$',
    },
    $.prefixRegexManager('golang/tools/gopls', 'gopls/') + {
      packageNameTemplate: 'golang/tools',
    },
    $.prefixRegexManager('ipinfo/cli', 'ipinfo-'),
    $.ipinfo('cidr2ip'),
    $.ipinfo('cidr2range'),
    $.ipinfo('range2cidr'),
    $.ipinfo('prips'),
    $.ipinfo('splitcidr'),
    $.ipinfo('randip'),
    $.ipinfo('grepip'),
    $.ipinfo('range2ip'),
    {
      depNameTemplate: 'kubernetes/kubectl-convert',
      datasourceTemplate: 'github-releases',
      matchStrings: $.aquaPackageMatchStrings(self.depNameTemplate, ''),
      packageNameTemplate: 'kubernetes/kubernetes',
    },
    $.prefixRegexManager('kubernetes/kubectl', 'v') + {
      extractVersionTemplate: '^kubernetes-(?<version>.*)$',
      datasourceTemplate: 'github-tags',
    },
    $.prefixRegexManager('kubernetes-sigs/kustomize', 'kustomize/'),
    $.prefixRegexManager('mongodb/mongodb-atlas-cli/atlascli', 'atlascli/') + {
      packageNameTemplate: 'mongodb/mongodb-atlas-cli',
    },
    $.prefixRegexManager('orf/gping', 'gping-'),
    $.prefixRegexManager('jqlang/jq', 'jq-'),
    $.prefixRegexManager('apache/maven', 'maven-'),
    $.prefixRegexManager('grpc/grpc-go/protoc-gen-go-grpc', 'cmd/protoc-gen-go-grpc/') + {
      packageNameTemplate: 'grpc/grpc-go',
    },
    $.prefixRegexManager('awslabs/mountpoint-s3', 'mountpoint-s3-') + {
      datasourceTemplate: 'github-tags',
    },
    {
      packageNameTemplate: '@trunkio/launcher',
      depNameTemplate: 'trunk-io/launcher',
      matchStrings: $.aquaPackageMatchStrings('trunk-io/launcher', ''),
      datasourceTemplate: 'npm',
    },
    $.prefixRegexManager('bitwarden/clients', 'cli-'),
    $.prefixRegexManager('wasmCloud/wasmCloud/wash', 'wash-v') + {
      packageNameTemplate: 'wasmCloud/wasmCloud',
    },
  ]),

  packageRules(matchFileNames):: [
    // Some packages are updated by github-tags datasource.
    // So disable github-releases against those packages.
    {
      matchDepNames: $.githubTagsPackages,
      matchFileNames: matchFileNames,
      matchDatasources: ['github-releases'],
      enabled: false,
    },
    // By default github-tags is disabled.
    {
      matchFileNames: matchFileNames,
      matchDatasources: ['github-tags'],
      enabled: false,
    },
    // github-tags is enabled against only those packages.
    {
      matchDepNames: $.githubTagsPackages,
      matchFileNames: matchFileNames,
      matchDatasources: ['github-tags'],
      enabled: true,
    },
    {
      allowedVersions: '/-esoctl$/',
      matchFileNames: matchFileNames,
      matchDepNames: [
        'external-secrets/external-secrets/esoctl',
      ],
    },
    {
      allowedVersions: '/^wash-v/',
      matchFileNames: matchFileNames,
      matchDepNames: [
        'wasmCloud/wasmCloud/wash',
      ],
    },
    {
      allowedVersions: '/^cmd\\/protoc-gen-go-grpc\\//',
      matchFileNames: matchFileNames,
      matchDepNames: [
        'grpc/grpc-go/protoc-gen-go-grpc',
      ],
    },
    {
      matchPackageNames: ['aquaproj/aqua-renovate-config'],
      groupName: 'aquaproj/aqua-renovate-config',
    },
  ],
}
