# Contributing

Please read the following document.

- https://github.com/suzuki-shunsuke/oss-contribution-guide

## Jsonnet

Our Renovate Config Presets (`*.json`) are generated from [jsonnet/*.jsonnet](jsonnet) by [google/go-jsonnet](https://github.com/google/go-jsonnet).
About Jsonnet, please see [the official document](https://jsonnet.org/).

1. Please install google/go-jsonnet by aqua.

```sh
aqua i -l
```

2. Please edit `jsonnet/*.jsonnet` and run `scripts/generate.sh`.

```sh
bash scripts/generate.sh
```

### Why Jsonnet?

To improve the maintenability by making the configuration DRY.
Jsonnet supports code comment while JSON doesn't.

## Test

Presets are tested by Renovate's dry-run (`--dry-run=extract`).
Each directory [tests/<preset>](tests) has files scanned by Renovate (`files/`) and dependencies Renovate is expected to extract from them (`expected.json`).
When you change a preset, please add lines to `files/` covering the change and update `expected.json`.

```sh
bash scripts/test.sh # Test all presets
bash scripts/test.sh installer-script # Test specific presets
UPDATE=true bash scripts/test.sh # Update expected.json
```

Please check the diff of `expected.json` to confirm that Renovate extracts what you expect.
Node.js is required.
