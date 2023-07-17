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
