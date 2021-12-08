# aqua-renovate-config

[Renovate Configuration](https://docs.renovatebot.com/config-presets/) to update packages and registries of [aqua](https://github.com/aquaproj/aqua).

## How to use

```json
{
  "extends": [
    "github>aquaproj/aqua-renovate-config"
  ]
}
```

Add the comment `# renovate: depName=(?<depName>.*)` in aqua.yaml for Renovate's Regex Manager.

e.g.

```yaml
registries:
- type: standard
  ref: v0.11.0 # renovate: depName=aquaproj/aqua-registry

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
    "github>aquaproj/aqua-renovate-config",
    "github>aquaproj/aqua-renovate-config:file(aqua/.*\\.ya?ml)"
  ]
}
```

## License

[MIT](LICENSE)
