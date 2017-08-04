keys.visual_line_mode = {
  ['j'] = _VIM.act(function()
    buffer.line_down()
    buffer.home()
  end),
  ['k'] = _VIM.act(function()
    buffer.line_up()
    buffer.home()
  end),
  ['u'] = buffer.undo,
  ['cr'] = buffer.redo,
  ['x'] = _VIM.act(buffer.clear),
  ['G'] = function()
    if _VIM.state.repeat_count then
      local old_start = buffer.selection_start
      buffer.goto_line(tonumber(_VIM.state.repeat_count) - 1)
      buffer.set_selection(buffer.current_pos, old_start)
      _VIM.state.repeat_count = nil
    else
      buffer.document_end()
    end
    buffer.home()
    buffer.line_end()
  end,
  ['A'] = function()
    buffer.line_end()
    _VIM.insertMode()
  end,
  ['I'] = function()
    buffer.vc_home()
    _VIM.insertMode()
  end,
  ['O'] = function()
    buffer.line_up()
    buffer.line_end()
    buffer.new_line()
    _VIM.insertMode()
  end,
  ['C'] = function()
    buffer.del_back()
    _VIM.insertMode()
  end,
  ['D'] = function()
    buffer.delete_back()
    buffer.line_delete()
  end,
  ['a'] = function()
    _VIM.insertMode()
    buffer.char_right()
  end,
  ['o'] = function()
    buffer.line_end()
    buffer.new_line()
  end,
  ['i'] = function()
    _VIM.insertMode()
  end,
  ['g'] = {
    ['g'] = function()
      local old_start = buffer.selection_start
      buffer.goto_pos(0)
      buffer.set_selection(buffer.current_pos, old_start)
    end,
    ['c'] = textadept.editing.block_comment,
  },
  ['y'] = function()
    buffer.copy()
    _VIM.state.line_copy = false
    _VIM.normalMode()
  end,
  ['z'] = {
    ['z'] = buffer.vertical_centre_caret,
  },
  ['d'] = function()
    buffer.cut()
    buffer.line_delete()
    _VIM.normalMode()
  end,
  ['c'] = function()
    buffer.cut()
    _VIM.insertMode()
  end,
  ['esc'] = function()
    _VIM.normalMode()
  end,
  ['>'] = _VIM.act(function()
    buffer.vc_home()
    buffer.tab()
  end),
  ['<'] = _VIM.act(function()
    buffer.vc_home()
    buffer.back_tab()
  end),
}

-- Return an empty function so undefined keys don't do anything
setmetatable(keys.visual_line_mode, {__index = function(t, key)
  if #key > 1 then
    -- If this is an unrecognized control sequence (e.g. 'ms' for Cmd-S) then pass it down the main mode.
    return keys[key]
  else
    return function()
      --ui.print(dump(t))
      --ui.print(key)
      if key >= '1' and key <= '9' then
        if _VIM.state.repeat_count == nil then
          _VIM.state.repeat_count = key
        else
          _VIM.state.repeat_count = _VIM.state.repeat_count .. key
        end
      end
    end
  end
end})