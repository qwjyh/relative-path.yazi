# relative-path.yazi

Yazi plugin to copy file path relative to where yazi was started.

## Installation

```
ya pkg add qwjyh/relative-path
```

## Usage

Add following to `init.lua`:
```lua
require("relative-path").setup {}
```

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

### Options

Following options are available in `setup` function.

- `notify`(bool): Notify the copied path.
