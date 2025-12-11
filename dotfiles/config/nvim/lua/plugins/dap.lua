-- lua/plugins/dap.lua
return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Install/ensure the PHP adapter
      require("mason-nvim-dap").setup({
        ensure_installed = { "php" }, -- this installs vscode-php-debug
        automatic_installation = true,
        handlers = {
          function(_) end, -- default handler (keeps auto configs)
          php = function(source_name)
            -- mason-nvim-dap already sets the adapter.
            -- We just add our configurations below.
          end,
        },
      })

      -- UI/virtual text
      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      -- Auto-open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- PHP configurations (listen for Xdebug like your VSCodium config)
      -- Note: Docksal container path is /var/www → local repo root.
      local local_root = vim.fn.getcwd() -- repo root in Neovim
      dap.configurations.php = {
        {
          name = "PHP: Listen for Xdebug (9000)",
          type = "php",
          request = "launch",
          port = 9000, -- Xdebug v2 default or v3 if you configured it that way
          log = false,
          -- Mirrors your VSCodium pathMappings
          pathMappings = { ["/var/www"] = local_root },
          -- Helpful for Drupal routing includes:
          -- xdebugSettings = { max_children = 2048, max_data = 2048, show_hidden = 1 },
        },
        {
          name = "PHP: Listen for Xdebug (9003)",
          type = "php",
          request = "launch",
          port = 9003, -- Xdebug v3 default
          log = false,
          pathMappings = { ["/var/www"] = local_root },
        },
      }

      -- Keymaps (LazyVim-friendly but standalone)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = "DAP: " .. (desc or ""), silent = true })
      end

      map("n", "<F5>", function()
        dap.continue()
      end, "Continue/Start") -- starts listening
      map("n", "<S-F5>", function()
        dap.terminate()
      end, "Terminate")
      map("n", "<F9>", function()
        dap.toggle_breakpoint()
      end, "Toggle Breakpoint")
      map("n", "<F10>", function()
        dap.step_over()
      end, "Step Over")
      map("n", "<F11>", function()
        dap.step_into()
      end, "Step Into")
      map("n", "<F12>", function()
        dap.step_out()
      end, "Step Out")
      map("n", "<leader>db", function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
          if cond then
            dap.set_breakpoint(cond)
          end
        end)
      end, "Set Conditional Breakpoint")
      map("n", "<leader>dr", function()
        dap.repl.toggle()
      end, "Toggle REPL")
      map("n", "<leader>du", function()
        dapui.toggle()
      end, "Toggle UI")
    end,
  },
}
