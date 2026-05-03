local M = {}

local misc = require("mini.misc")

local on_event = function(events, f)
  misc.safely("event:" .. events, f)
end

local function plugin_name(spec)
  return spec.name or (spec.src or ""):match("/([^/]+)$")
end

local function is_src_spec(spec)
  return spec.src ~= nil
end

local function is_pack_spec(spec)
  return spec.pack ~= nil
end

local function validate_spec(spec)
  local has_src = spec.src ~= nil
  local has_pack = spec.pack ~= nil
  if has_src and has_pack then
    error("spec must have either 'src' or 'pack', not both")
  end
  if not has_src and not has_pack then
    error("spec must have either 'src' or 'pack'")
  end
end

local function to_pack_spec(spec)
  if not is_src_spec(spec) then
    return nil
  end
  local url = spec.src
  local pack_spec = { src = url }
  if spec.version then
    pack_spec.version = spec.version
  end
  if spec.data then
    pack_spec.data = spec.data
  end
  return pack_spec
end

local function plugin_dir(name)
  return vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt", name)
end

local function load_spec(spec)
  if is_src_spec(spec) then
    vim.pack.add({ to_pack_spec(spec) })
  elseif is_pack_spec(spec) then
    vim.cmd.packadd(spec.pack)
  end
end

local function run_data_load(spec)
  local load = ((spec or {}).data or {}).load
  if type(load) ~= "function" then
    return
  end

  pcall(load, {
    spec = to_pack_spec(spec),
    name = plugin_name(spec),
    path = plugin_dir(plugin_name(spec)),
  })
end

local function make_loader(spec)
  local loaded = false

  return function()
    if loaded then
      return
    end
    load_spec(spec)
    run_data_load(spec)
    if spec.setup then
      spec.setup()
    end
    loaded = true
  end
end

local function register_key_triggers(spec, load)
  if not spec.keys then
    return
  end
  for _, key in ipairs(spec.keys) do
    local mode = key.mode or "n"
    local rhs = key.rhs
    local opts = key.opts or {}
    vim.keymap.set(mode, key.lhs, function()
      load()
      rhs()
    end, opts)
  end
end

local function load_eager(specs)
  local src_specs = {}
  local pack_specs = {}

  for _, spec in ipairs(specs) do
    if is_src_spec(spec) then
      table.insert(src_specs, spec)
    elseif is_pack_spec(spec) then
      table.insert(pack_specs, spec)
    end
  end

  if #src_specs > 0 then
    local pack_specs_only = vim.tbl_map(function(s) return to_pack_spec(s) end, src_specs)
    vim.pack.add(pack_specs_only)
  end

  for _, spec in ipairs(pack_specs) do
    vim.cmd.packadd(spec.pack)
  end

  for _, spec in ipairs(specs) do
    run_data_load(spec)
    if spec.setup then
      spec.setup()
    end
  end
end

function M.setup(specs)
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local plugin = ev.data
      local run = (plugin.spec.data or {}).run
      if plugin.kind ~= "delete" and type(run) == "function" then
        pcall(run, vim.tbl_extend("force", plugin, { path = plugin_dir(plugin.spec.name) }))
      end
    end,
  })

  vim.keymap.set("", "<C-S>", function()
    vim.pack.update()
  end, { silent = true, desc = "Update plugins" })

  local eager_specs = {}

  for _, spec in ipairs(specs) do
    validate_spec(spec)

    local loader = make_loader(spec)
    local trigger = spec.event or spec.keys

    if not trigger then
      table.insert(eager_specs, spec)
    elseif spec.event then
      on_event(spec.event, function()
        loader()
      end)
    elseif spec.keys then
      register_key_triggers(spec, loader)
    end
  end

  load_eager(eager_specs)
end

return M