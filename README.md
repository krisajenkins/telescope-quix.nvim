
# Telescope Quix
A Neovim Telescope plugin for Quix.

## Installation
```lua
{
  'krisajenkins/telescope-quix.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  event = 'VeryLazy',
  config = function()
    require('telescope').load_extension('telescope_quix')
    require('telescope_quix').setup {}
  end,
}
```
## Testing
```sh
make
```
## TODO
* See this [github issue](https://github.com/quixio/quix-cli/issues/11) about the Quix CLI output format.
