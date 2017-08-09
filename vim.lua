_VIM = {
  pristine_state = {
    forward_search = true,
    line_copy = false,
    repeat_count = nil,
    last_repeat_count = nil,
    last_action = nil,
  },
  state = {
    forward_search = true,
    line_copy = false,
    repeat_count = nil,
    last_repeat_count = nil,
    last_action = nil,
  },
  resetState = function()
    _VIM.state = {table.unpack(_VIM.pristine_state)}
  end,
  insertMode = function()
    keys.MODE = nil
    _VIM.setStatusBar()
    _VIM.setCursor()
  end,
  normalMode = function()
    buffer.cancel()
    buffer.set_empty_selection(buffer.current_pos)
    keys.MODE = 'normal_mode'
    _VIM.setStatusBar()
    _VIM.setCursor()
  end,
  visualMode = function()
    buffer.selection_start = buffer.current_pos
    buffer.selection_end = buffer.current_pos
    keys.MODE = 'visual_mode'
    _VIM.setStatusBar()
    _VIM.setCursor()
  end,
  visualLineMode = function()
    keys.MODE = 'visual_line_mode'
    _VIM.setStatusBar()
    _VIM.setCursor()
    _VIM.visual_line_start_pos = buffer.current_pos
    textadept.editing.select_line()
  end,
  setCursor = function()
    if keys.MODE == 'normal_mode' or keys.MODE == 'visual_mode' or keys.MODE == 'visual_line_mode' then
      buffer.caret_style = buffer.CARETSTYLE_BLOCK
    else
      buffer.caret_style = buffer.CARETSTYLE_LINE
    end
  end,
  setStatusBar = function()
    if keys.MODE == 'normal_mode' then
      ui.statusbar_text = 'NORMAL'
    elseif keys.MODE == nil then
      ui.statusbar_text = 'INSERT'
    elseif keys.MODE == 'visual_mode' then
      ui.statusbar_text = 'VISUAL'
    elseif keys.MODE == 'visual_line_mode' then
      ui.statusbar_text = 'VISUAL LINE'
    end
  end,
  act = function(f)
    return function()
      local repeat_count = tonumber(_VIM.state.repeat_count)
      if repeat_count == nil or repeat_count <= 1 then repeat_count = 1 end
      for i = 1,repeat_count do f() end
      _VIM.state.last_repeat_count = _VIM.state.repeat_count
      _VIM.state.last_action = f
      _VIM.state.repeat_count = nil
    end
  end
}