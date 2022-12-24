local utils = import 'utils.libsonnet';

{
  regexManagers: [
    utils.packageRegexManager + utils.argFileMatch,
    utils.kustomize + utils.argFileMatch,
    utils.golangGo + utils.argFileMatch,
    utils.kubectl + utils.argFileMatch,
    utils.protocGenGoGRPC + utils.argFileMatch,
    utils.prefixRegexManager("orf/gping", "gping-") + utils.argFileMatch,
    utils.gopls + utils.argFileMatch,
    utils.goPkg + utils.argFileMatch,
    utils.bun + utils.argFileMatch,
  ],
}
