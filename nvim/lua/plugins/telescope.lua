return {
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Find Buffers' },
      { '<leader>fd', '<cmd>Telescope diagnostics<cr>', desc = 'Find Diagnostics' },
      { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files' },
      { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Find Word' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Find Keymaps' },
      { '<leader>fh', '<cmd>Telescope highlights<cr>', desc = 'Find Highlights' },
      { '<leader>fo', '<cmd>Telescope oldfiles<cr>', desc = 'Recently opened files' },
      { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = 'Find Quickix' },
      { '<leader>fw', '<cmd>Telescope grep_string<cr>', desc = 'Find Word Under Cursor' },
      { '<leader>fu', '<cmd>Telescope undo<cr>', desc = 'Find Undo' },
      { '<leader>fr', '<cmd>Telescope registers<cr>', mode = {'n', 'x'}, desc = 'Find registers' },
      { '<leader>fz', '<cmd>Telescope zoxide list<cr>', desc = 'Find Directory' },
      { '<leader>s/', function() require('telescope.builtin').live_grep({ grep_open_files = true, prompt_title = 'Live Grep in Open Files'}) end, desc = '[S]earch [/] in Open Files' }
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'jvgrootveld/telescope-zoxide',
    },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          selection_caret = '▎ ',
          multi_icon = ' │ ',
          winblend = 0,
          borderchars = {'─', '│', '─', '│', '┌', '┐', '┘', '└'},
          mappings = {
            i = {
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<c-enter>'] = 'to_fuzzy_refine'
            },
            n = {
              ['q'] = require('telescope.actions').close,
              ['<C-d>'] = actions.preview_scrolling_down,
              ['<C-u>'] = actions.preview_scrolling_up
            }
          },
          layout_config = {
            prompt_position = 'top',
            preview_width = 0.56,
            width = 0.87,
            height = 0.70
          },
          sorting_strategy = 'ascending',
          file_ignore_patterns = {'node_modules'}
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['<C-e>'] = 'delete_buffer',
                ['l'] = 'select_default'
              }
            },
            initial_mode = 'normal'
          },
        },
        extensions = {
          undo = {
            initial_mode = 'normal',
            layout_config = {
              preview_width = 0.7
            }
          },
          advanced_git_search = {
            diff_plugin = 'diffview'
          }
        }
      })
      require('telescope').load_extension('undo')
      require('telescope').load_extension('zoxide')
    end
  }
}
