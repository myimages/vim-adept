require 'vim-adept.vim'
require 'vim-adept.normal_mode'
require 'vim-adept.visual_mode'
require 'vim-adept.visual_line_mode'

keys['esc'] = function()
  _VIM.normalMode()
  _VIM.state.repeat_count = nil
end
events.connect(events.UPDATE_UI, function()
  _VIM.setStatusBar()
  _VIM.setCursor()
end)

_VIM.normalMode()
