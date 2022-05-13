local options = {
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.keybinds"] = {
      config = {
        default_keybinds = false,
        hook = function(keybinds)
          local leader = keybinds.leader

          -- Map all the below keybinds only when the "norg" mode is active
          keybinds.map_event_to_mode("norg", {
            n = { -- Bind keys in normal mode

              -- Keys for managing TODO items and setting their states
              { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
              { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
              { "gtd", "core.norg.qol.todo_items.todo.task_done" },
              { "gth", "core.norg.qol.todo_items.todo.task_on_hold" },
              { "gtc", "core.norg.qol.todo_items.todo.task_cancelled" },
              { "gtr", "core.norg.qol.todo_items.todo.task_recurring" },
              { "gti", "core.norg.qol.todo_items.todo.task_important" },
              { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },

              -- Keys for managing GTD
              { leader .. "tc", "core.gtd.base.capture" },
              { leader .. "tv", "core.gtd.base.views" },
              { leader .. "te", "core.gtd.base.edit" },

              -- Keys for managing notes
              { leader .. "nn", "core.norg.dirman.new.note" },

              { "<CR>", "core.norg.esupports.hop.hop-link" },
              { "<M-CR>", "core.norg.esupports.hop.hop-link", "vsplit" },

              -- mnemonic: markup toggle
              { leader .. "mt", "core.norg.concealer.toggle-markup" },
            },

            o = {
              { "ah", "core.norg.manoeuvre.textobject.around-heading" },
              { "ih", "core.norg.manoeuvre.textobject.inner-heading" },
              { "at", "core.norg.manoeuvre.textobject.around-tag" },
              { "it", "core.norg.manoeuvre.textobject.inner-tag" },
              { "al", "core.norg.manoeuvre.textobject.around-whole-list" },
            },
          }, {
            silent = true,
            noremap = true,
          })

          -- Map the below keys on gtd displays
          keybinds.map_event_to_mode("gtd-displays", {
            n = {
              { "<CR>", "core.gtd.ui.goto_task" },

              -- Keys for closing the current display
              { "q", "core.gtd.ui.close" },
              { "<Esc>", "core.gtd.ui.close" },

              { "e", "core.gtd.ui.edit_task" },
              { "<Tab>", "core.gtd.ui.details" },
            },
          }, {
            silent = true,
            noremap = true,
            nowait = true,
          })

          -- Map the below keys only when traverse-heading mode is active
          keybinds.map_event_to_mode("traverse-heading", {
            n = {
              -- Rebind j and k to move between headings in traverse-heading mode
              { "j", "core.integrations.treesitter.next.heading" },
              { "k", "core.integrations.treesitter.previous.heading" },
            },
          }, {
            silent = true,
            noremap = true,
          })

          -- Apply the below keys to all modes
          keybinds.map_to_mode("all", {
            n = {
              { leader .. "mn", ":Neorg mode norg<CR>" },
              { leader .. "mh", ":Neorg mode traverse-heading<CR>" },
              { leader .. "gv", ":Neorg gtd views<CR>" },
              { leader .. "gc", ":Neorg gtd capture<CR>" },
              { leader .. "ge", ":Neorg gtd edit<CR>" },
            },
          }, {
            silent = true,
            noremap = true,
          })
        end,
      },
    },
    ["core.norg.concealer"] = {},
    ["core.norg.manoeuvre"] = {},
    ["core.norg.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    ["core.norg.esupports.metagen"] = {
      config = {
        type = "auto",
      },
    },
    ["core.gtd.base"] = {
      config = {
        workspace = "gtd",
      },
    },
    ["core.gtd.ui"] = {},
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          gtd = "~/gtd",
        },
      },
    },
  },
}

require("neorg").setup(options)
