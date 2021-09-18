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
  ref: v0.8.4 # renovate: depName=suzuki-shunsuke/aqua-registry

packages:
- name: open-policy-agent/conftest
  registry: standard
  version: v0.27.0 # renovate: depName=open-policy-agent/conftest
```

## License

[MIT](LICENSE)
