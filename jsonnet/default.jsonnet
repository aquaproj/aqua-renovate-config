local githubTagsPackages = [
  "golang/go",
  "golang/tools",
  "kubernetes/kubectl",
  "twistedpair/google-cloud-sdk"
];

local aquaYAMLMatchPaths = [
  ".aqua.yaml",
  ".aqua.yml",
  "aqua.yaml",
  "aqua.yml"
];

local aquaYAMLFileMatch = ["\\.?aqua\\.ya?ml"];

local aquaPackageMatchStrings(depName, prefix) = [
  " +['\"]?version['\"]? *: +['\"]?" + prefix + "(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=" + depName + "[ \\n]",
  " +['\"]?name['\"]? *: +['\"]?" + depName + "@" + prefix + "(?<currentValue>[^'\" \\n]+)['\"]?"
];

local prefixRegexManager(depName, prefix) = {
  "fileMatch": aquaYAMLFileMatch,
  "matchStrings": aquaPackageMatchStrings(depName, prefix),
  "extractVersionTemplate": "^" + prefix + "(?<version>.*)$",
  "datasourceTemplate": "github-releases",
  "depNameTemplate": depName,
};

local ipinfo(name) = prefixRegexManager("ipinfo/cli/" + name, name + "-") + {
  "packageNameTemplate": "ipinfo/cli",
};

local packageRegexManager = {
  "fileMatch": aquaYAMLFileMatch,
  "matchStrings": [
    " +['\"]?(version|ref)['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+?)['\"]? +# renovate: depName=(?<depName>[^\\n]+)",
    " +['\"]?name['\"]? *: +['\"]?(?<depName>[^'\" .@/\\n]+/[^'\" @/\\n]+)(/[^'\" /@\\n]+)*@(?<currentValue>[^'\" \\n]+)['\"]?"
  ],
  "datasourceTemplate": "github-releases"
};

{
  "packageRules": [
    // Some packages are updated by github-tags datasource.
    // So disable github-releases against those packages.
    {
      "matchPackageNames": githubTagsPackages,
      "matchPaths": aquaYAMLMatchPaths,
      "matchDatasources": ["github-releases"],
      "enabled": false
    },
    // By default github-tags is disabled.
    {
      "matchPaths": aquaYAMLMatchPaths,
      "matchDatasources": ["github-tags"],
      "enabled": false
    },
    // github-tags is enabled against only those packages.
    {
      "matchPackageNames": githubTagsPackages,
      "matchPaths": aquaYAMLMatchPaths,
      "matchDatasources": ["github-tags"],
      "enabled": true
    }
  ],
  "regexManagers": [
    {
      // Update aqua-installer action
      "fileMatch": ["^\\.github/.*\\.ya?ml$"],
      "matchStrings": [
        " +['\"]?aqua_version['\"]? *: +['\"]?(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "depNameTemplate": "aquaproj/aqua",
      "datasourceTemplate": "github-releases"
    },
    {
      // Update aqua-renovate-config
      "fileMatch": [
        "^renovate\\.json5?$",
        "^\\.github/renovate\\.json5?$",
        "^\\.gitlab/renovate\\.json5?$",
        "^\\.renovaterc\\.json$",
        "^\\.renovaterc$"
      ],
      "matchStrings": [
        "\"github>aquaproj/aqua-renovate-config#(?<currentValue>[^\" \\n\\(]+)",
        "\"github>aquaproj/aqua-renovate-config:.*#(?<currentValue>[^\" \\n\\(]+)",
        "\"github>aquaproj/aqua-renovate-config/.*#(?<currentValue>[^\" \\n\\(]+)"
      ],
      "datasourceTemplate": "github-releases",
      "depNameTemplate": "aquaproj/aqua-renovate-config"
    },
    packageRegexManager,
    packageRegexManager + {
      "datasourceTemplate": "github-tags",
    },
    packageRegexManager + {
      "datasourceTemplate": "go",
    },
    {
      "fileMatch": aquaYAMLFileMatch,
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?(go)?(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/go[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?golang/go@(go)?(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^go(?<version>.*)$",
      "datasourceTemplate": "github-tags",
      "depNameTemplate": "golang/go"
    },
    {
      "fileMatch": aquaYAMLFileMatch,
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?gopls/(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=golang/tools/gopls[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?golang/tools/gopls@gopls/(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^gopls/(?<version>.*)$",
      "datasourceTemplate": "github-releases",
      "depNameTemplate": "golang/tools"
    },
    {
      "fileMatch": aquaYAMLFileMatch,
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?cmd/protoc-gen-go-grpc/(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=grpc/grpc-go[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?grpc/grpc-go/protoc-gen-go-grpc@cmd/protoc-gen-go-grpc/(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^cmd/protoc-gen-go-grpc/(?<version>.*)$",
      "datasourceTemplate": "github-releases",
      "depNameTemplate": "grpc/grpc-go"
    },
    {
      "fileMatch": aquaYAMLFileMatch,
      "matchStrings": [
        " +['\"]?version['\"]? *: +['\"]?v(?<currentValue>[^'\" \\n]+)['\"]? +# renovate: depName=kubernetes/kubectl[ \\n]",
        " +['\"]?name['\"]? *: +['\"]?kubernetes/kubectl@v(?<currentValue>[^'\" \\n]+)['\"]?"
      ],
      "extractVersionTemplate": "^kubernetes-(?<version>.*)$",
      "datasourceTemplate": "github-tags",
      "depNameTemplate": "kubernetes/kubectl"
    },
    prefixRegexManager("kubernetes-sigs/kustomize", "kustomize/"),
    prefixRegexManager("orf/gping", "gping-"),
    prefixRegexManager("oven-sh/bun", "bun-"),
    prefixRegexManager("mongodb/mongodb-atlas-cli/atlascli", "atlascli/") + {
      "packageNameTemplate": "mongodb/mongodb-atlas-cli",
    },
    prefixRegexManager("ipinfo/cli", "ipinfo-"),
    ipinfo("cidr2ip"),
    ipinfo("cidr2range"),
    ipinfo("range2cidr"),
    ipinfo("prips"),
    ipinfo("splitcidr"),
    ipinfo("randip"),
    ipinfo("grepip"),
    ipinfo("range2ip"),
  ]
}
