# aqua-renovate-config

[Renovate Configuration](https://docs.renovatebot.com/config-presets/) to update packages and registries of [aqua](https://github.com/suzuki-shunsuke/aqua).

## How to use

```json
{
  "extends": [
    "github>suzuki-shunsuke/aqua-renovate-config"
  ]
}
```

Add the comment `# renovate: depName=(?<depName>.*)` in aqua.yaml for Renovate's Regex Manager.

e.g.

```yaml
registries:
- type: standard
  ref: v0.10.5 # renovate: depName=suzuki-shunsuke/aqua-registry

packages:
- name: open-policy-agent/conftest
  registry: standard
  version: v0.28.3 # renovate: depName=open-policy-agent/conftest
```

### Parameterize `fileMatch`

https://docs.renovatebot.com/config-presets/#preset-parameters

```json
{
  "extends": [
    "config:base",
    "github>suzuki-shunsuke/aqua-renovate-config",
    "github>suzuki-shunsuke/aqua-renovate-config:file(aqua/.*\\.ya?ml)"
  ]
}
```

## License

[MIT](LICENSE)
