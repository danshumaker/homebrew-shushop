return {
  -- Neo-tree file explorer plugin
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for icons
    "MunifTanjim/nui.nvim",
  },

  opts = {
    close_if_last_window = false, -- we'll manually close via custom key
    enable_git_status = true,
    enable_diagnostics = true,
    popup_border_style = "rounded",

    window = {
      position = "left",
      width = 38,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<cr>"] = "open", -- keep default Enter behaviour
        ["q"] = "close_window", -- optional manual close

        -- Custom mapping: press "g" to open file AND close Neo-tree
        ["g"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type == "directory" then
            require("neo-tree.sources.filesystem.commands").toggle_directory(state)
          else
            require("neo-tree.utils").open_file(state, path)
            require("neo-tree.command").execute({ action = "close" })
          end
        end,
      },
    },

    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },

    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          -- optional: add custom actions here if desired
          -- print("Opened file: " .. file_path)
        end,
      },
    },
  },

  keys = {
    -- convenient toggle for Neo-tree
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
  },
}
