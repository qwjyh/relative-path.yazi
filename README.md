# relative-path.yazi

Yazi plugin to copy file path relative to where yazi was started.

## Installation

```
ya pkg add qwjyh/relative-path
```

## Usage

Modify `keymap.toml` to run `plugin relative-path`.
For example:

```toml
[mgr]
append_keymap = [
    { on = [
        "c",
        "r",
    ], run = "plugin relative-path", desc = "Copy relative path from the started path" },
]
```

