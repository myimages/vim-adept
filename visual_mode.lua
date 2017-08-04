keys.visual_mode = {
  ['h'] = _VIM.act(buffer.char_left_extend),
  ['j'] = _VIM.act(buffer.line_down_extend),
  ['k'] = _VIM.act(buffer.line_up_extend),
  ['l'] = _VIM.act(buffer.char_right_extend),
  ['w'] = _VIM.act(buffer.word_right_extend),
  ['b'] = _VIM.act(buffer.word_left_extend),
  ['e'] = _VIM.act(buffer.word_right_end_extend),
  ['0'] = function()
    if _VIM.state.repeat_count == nil then
      buffer.home_extend()
    else
      _VIM.state.repeat_count = _VIM.state.repeat_count .. '0'
    end
  end,
  ['$'] = buffer.line_end_extend,
  ['u'] = buffer.undo,
  ['cr'] = buffer.redo,
  ['%'] = function()
    local old_start = buffer.selection_start
    textadept.editing.match_brace(true)
    buffer.selection_start = old_start
  end,
  -- This on has complicated behavior. May have to come back to it later
  --['*'] = textadept.editing.highlight_word,
  -- p is unvetted
  --['p'] = function()
    --if _VIM.state.line_copy then
      --buffer.line_end()
      --buffer.new_line()
      --buffer.home()
      --buffer.paste()
      --buffer.line_delete()
      --buffer.line_up()
    --else
      --buffer.paste()
    --end
  --end,
  --['.'] = function()
    --if _VIM.state.last_action then
      --_VIM.state.repeat_count = _VIM.state.last_repeat_count
      --_VIM.act(_VIM.state.last_action)()
    --end
  --end,
  ['{'] = _VIM.act(buffer.para_up_extend),
  ['}'] = _VIM.act(buffer.para_down_extend),
  ['^'] = buffer.vc_home_extend,
  ['x'] = _VIM.act(buffer.clear),
  ['n'] = function()
    _VIM.normalMode()
    if _VIM.state.forward_search == true then
      ui.find.find_next()
    else
      ui.find.find_prev()
    end
  end,
  ['N'] = function()
    _VIM.normalMode()
    if _VIM.state.forward_search == true then
      ui.find.find_prev()
    else
      ui.find.find_next()
    end
  end,
  ['?'] = function()
    local return_code, search_text = ui.dialogs.inputbox({
      title = "Search String",
      string_output = true,
      text = ui.find.find_entry_text,
    })
    if return_code == '_OK' then
      _VIM.state.forward_search = false
      ui.find.find_entry_text = search_text
      ui.find.find_incremental(search_text, false, true)
    end
  end,
  ['/'] = function()
    local return_code, search_text = ui.dialogs.inputbox({
      title = "Search String",
      string_output = true,
      text = ui.find.find_entry_text,
    })
    if return_code == '_OK' then
      _VIM.state.forward_search = true
      ui.find.find_entry_text = search_text
      ui.find.find_incremental(search_text, true, true)
    end
  end,
  ['G'] = function()
    if _VIM.state.repeat_count then
      local old_start = buffer.selection_start
      buffer.goto_line(tonumber(_VIM.state.repeat_count) - 1)
      buffer.set_selection(buffer.current_pos, old_start)
      _VIM.state.repeat_count = nil
    else
      buffer.document_end_extend()
    end
    buffer.home_extend()
    buffer.char_right_extend()
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
    buffer.del_line_right()
    _VIM.insertMode()
  end,
  ['D'] = buffer.del_line_right,
  ['W'] = _VIM.act(function()
    local old_chars = buffer.word_chars
    buffver.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_right_extend()
    buffer.word_chars = old_chars
  end),
  ['B'] = _VIM.act(function()
    local old_chars = buffer.word_chars
    buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_left_extend()
    buffer.word_chars = old_chars
  end),
  ['E'] = _VIM.act(function()
    local old_chars = buffer.word_chars
    buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_right_end_extend()
    buffer.word_chars = old_chars
  end),
  ['a'] = function()
    _VIM.insertMode()
    buffer.char_right()
  end,
  ['o'] = function()
    buffer.line_end()
    buffer.new_line()
    _VIM.insertMode()
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
setmetatable(keys.visual_mode, {__index = function(t, key)
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