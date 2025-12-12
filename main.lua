local M = {}

---@class Opts
---@field notify boolean? Default true.

---@param opts Opts?
M.setup = ya.sync(function(state, opts)
    state.opts = opts or {}
    local init_path, err = fs.cwd()
    ya.dbg("initial cwd: " .. tostring(init_path) .. ", err: " .. tostring(err))
    if err ~= nil then
        ya.notify {
            title = "relative-path",
            content = "Failed to get cwd during the setup: err = " .. tostring(err),
            timeout = 5,
            level = "error",
        }
    else
        state.init_path = init_path
    end
end)

---@return Opts
local get_opts = ya.sync(function(state)
    return state.opts
end)

local init_path_blk = ya.sync(function(state)
    return Url(state.init_path)
end)

local target_path_blk = ya.sync(function()
    local hovered = cx.active.current.hovered
    if not hovered then return end
    if not hovered.url.is_absolute then return end
    return hovered.url
end)

local function make_relative_path(parent_level, diff_from_ancestor)
    if parent_level == 0 then
        return diff_from_ancestor
    else
        local diff_path = Url("../")
        for _ = 2, parent_level do
            diff_path = Url("../"):join(diff_path)
        end
        diff_path = diff_path:join(diff_from_ancestor)
        return diff_path
    end
end

M.entry = function()
    ---@type Url?
    local target_path = target_path_blk()
    ---@type Url
    local init_path = init_path_blk()
    if not target_path then
        ya.notify {
            title = "relative-path",
            content = "Hovered target is not a regular file",
            timeout = 5,
            level = "error",
        }
        return
    end
    local parent_level = 0
    local diff_path
    if target_path == init_path then
        diff_path = Url(".")
    else
        while init_path ~= nil do
            local diff = target_path:strip_prefix(init_path)
            if diff then
                diff_path = make_relative_path(parent_level, diff)
                break
            end
            parent_level = parent_level + 1
            init_path = init_path.parent
        end
    end
    ---@type Opts
    local opts = get_opts()
    if opts.notify then
        ya.notify {
            title = "Set to clipboard",
            content = tostring(diff_path),
            timeout = 3,
        }
    end
    ya.clipboard(tostring(diff_path))
end

return M
