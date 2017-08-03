function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

require 'vim-adept.vim'
require 'vim-adept.normal_mode'
require 'vim-adept.visual_mode'
require 'vim-adept.visual_line_mode'

keys['esc'] = function()
  _VIM.normalMode()
  _VIM.state.repeat_count = nil
end
events.connect(events.UPDATE_UI, _VIM.setStatusBar)

_VIM.normalMode()