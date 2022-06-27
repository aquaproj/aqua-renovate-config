# clivm-renovate-config

[Renovate Config Preset](https://docs.renovatebot.com/config-presets/) to update [clivm](https://github.com/clivm/clivm), [clivm-installer](https://github.com/clivm/clivm-installer), packages, and registries.

https://clivm.github.io/

Example: https://github.com/clivm/test-clivm-renovate-config

## Reference about Renovate

* [Renovate documentation](https://docs.renovatebot.com/)
* [Renovate Config Preset](https://docs.renovatebot.com/config-presets/)
  * How to use Preset
  * How to specify preset version and parameter
* [Custom Manager Support using Regex](https://docs.renovatebot.com/modules/manager/regex/)
  * This Preset updates tools with custom regular expression by Renovate Regex Manager

## List of Presets

* [default](default.json)
  * clivm.yaml
  * GitHub Actions [clivm/clivm-installer](https://github.com/clivm/clivm-installer)'s `clivm_version`
  * [clivm/clivm-renovate-config](https://github.com/clivm/clivm-renovate-config)
  * [golang/go](https://github.com/golang/go)
  * [kubernetes-sigs/kustomize](https://github.com/kubernetes-sigs/kustomize)
  * [kubernetes/kubectl](https://github.com/kubernetes/kubectl)
  * [grpc/grpc-go/protoc-gen-go-grpc](https://github.com/grpc/grpc-go)
* [base](base.json)
  * clivm.yaml
* [action](action.json)
  * GitHub Actions [clivm/clivm-installer](https://github.com/clivm/clivm-installer)'s `clivm_version`
* [file](file.json)
  * clivm.yaml. `fileMatch` is parameterized
* [installer-script](installer-script.json)
  * the shell script [clivm/clivm-installer](https://github.com/clivm/clivm-installer). `fileMatch` is parameterized
* [golang-go](golang-go.json)
  * [golang/go](https://github.com/golang/go). `fileMatch` is parameterized
* [kubernetes-sigs-kustomize](kubernetes-sigs-kustomize.json)
  * [kubernetes-sigs/kustomize](https://github.com/kubernetes-sigs/kustomize). `fileMatch` is parameterized
* [kubernetes-kubectl](kubernetes-kubectl.json)
  * [kubernetes/kubectl](https://github.com/kubernetes/kubectl). `fileMatch` is parameterized

## How to use

We recommend specifying the Preset version.

* :thumbsup: `"github>clivm/clivm-renovate-config#1.1.0"`
* :thumbsdown: `"github>clivm/clivm-renovate-config"`

### `default` Preset

```json
{
  "extends": [
    "github>clivm/clivm-renovate-config#1.1.0"
  ]
}
```

e.g.

```yaml
registries:
- type: standard
  ref: v3.3.0 # renovate: depName=clivm/clivm-registry

packages:
- name: open-policy-agent/conftest@v0.28.3
- name: GoogleCloudPlatform/terraformer/aws@0.8.18
```

The default preset updates GitHub Actions [clivm/clivm-installer](https://github.com/clivm/clivm-installer)'s `clivm_version` in `.github` too.

```yaml
- uses: clivm/clivm-installer@v0.4.0
  with:
    clivm_version: v1.14.0
```

### `file` Preset

You can specify the file path clivm.yaml.
This is especially useful when you split the list of packages.

https://clivm.github.io/docs/tutorial-extras/split-config

```json
{
  "extends": [
    "github>clivm/clivm-renovate-config:file#1.1.0(clivm/.*\\.ya?ml)"
  ]
}
```

### `installer-script` Preset

The preset `installer-script` updates the shell script clivm-installer.
You have to pass fileMatch as parameter.

```json
{
  "extends": [
    "github>clivm/clivm-renovate-config:installer-script#1.1.0(scripts/.*\\.sh)"
  ]
}
```

```sh
curl -sSfL https://raw.githubusercontent.com/clivm/clivm-installer/v1.0.0/clivm-installer | bash
```

## License

[MIT](LICENSE)
