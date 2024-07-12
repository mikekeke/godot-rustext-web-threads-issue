# TBD

## .so compilation

Workdir: `gdext_lib`

`cargo build`

## WASM compilation

Workdir: `gdext_lib`

My Debian

```bash
source /home/mike/dev/mlabs/godot-wallet-project/emsdk/emsdk_env.sh
```

My Ubuntu

```bash
source /home/mike/emsdk/emsdk_env.sh
```

```bash
emcc --version && cargo +nightly build -Zbuild-std --target wasm32-unknown-emscripten
```

## Running export

Workdir: repo root

Do web export (export config is set already).

### If in Nix shell

```bash
make godot-website
```

Then go to `http://localhost:8060/index.html`

### If NOT in Nix shell

Need to serve [web-export](./web-export/) with headers analogous to [web-export/serve.py](./web-export/serve.py)
