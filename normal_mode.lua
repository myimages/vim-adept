keys.normal_mode = {
  ['h'] = _VIM.act(buffer.char_left),
  ['j'] = _VIM.act(buffer.line_down),
  ['k'] = _VIM.act(buffer.line_up),
  ['l'] = _VIM.act(buffer.char_right),
  ['w'] = _VIM.act(buffer.word_right),
  ['b'] = _VIM.act(buffer.word_left),
  ['e'] = _VIM.act(buffer.word_right_end),
  ['0'] = function()
    if _VIM.state.repeat_count == nil then
      buffer.home()
    else
      _VIM.state.repeat_count = _VIM.state.repeat_count .. '0'
    end
  end,
  ['$'] = buffer.line_end,
  ['u'] = buffer.undo,
  ['cr'] = buffer.redo,
  ['%'] = textadept.editing.match_brace,
  ['*'] = textadept.editing.highlight_word,
  ['v'] = function()
    _VIM.visualMode()
  end,
  ['V'] = function()
    _VIM.visualLineMode()
  end,
  ['p'] = function()
    if _VIM.state.line_copy then
      buffer.line_end()
      buffer.new_line()
      buffer.home()
      buffer.paste()
      buffer.line_delete()
      buffer.line_up()
    else
      buffer.paste()
    end
  end,
  ['.'] = function()
    if _VIM.state.last_action then
      _VIM.state.repeat_count = _VIM.state.last_repeat_count
      _VIM.act(_VIM.state.last_action)()
    end
  end,
  ['{'] = _VIM.act(buffer.para_up),
  ['}'] = _VIM.act(buffer.para_down),
  ['^'] = buffer.vc_home,
  ['x'] = _VIM.act(buffer.clear),
  ['J'] = _VIM.act(textadept.editing.join_lines),
  ['n'] = function()
    if _VIM.state.forward_search == true then
      ui.find.find_next()
    else
      ui.find.find_prev()
    end
  end,
  ['N'] = function()
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
      buffer.goto_line(tonumber(_VIM.state.repeat_count) - 1)
      _VIM.state.repeat_count = nil
    else
      buffer.goto_line(buffer.line_count)
    end
    buffer.home()
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
    buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_right()
    buffer.word_chars = old_chars
  end),
  ['B'] = _VIM.act(function()
    local old_chars = buffer.word_chars
    buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_left()
    buffer.word_chars = old_chars
  end),
  ['E'] = _VIM.act(function()
    local old_chars = buffer.word_chars
    buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
    buffer.word_right_end()
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
      buffer.goto_pos(0)
    end,
    ['c'] = {
      ['c'] = textadept.editing.block_comment,
    },
  },
  ['y'] = {
    ['y'] = function()
      buffer.line_copy()
      _VIM.state.line_copy = true
    end,
  },
  ['z'] = {
    ['z'] = buffer.vertical_centre_caret,
  },
  ['d'] = {
    ['d'] = _VIM.act(function()
      buffer.line_copy()
      buffer.line_delete()
      _VIM.state.line_copy = true
    end),
    ['w'] = _VIM.act(function()
      buffer.del_word_right()
    end),
    ['W'] = _VIM.act(function()
      local old_chars = buffer.word_chars
      buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
      buffer.del_word_right()
      buffer.word_chars = old_chars
    end),
    ['b'] = _VIM.act(buffer.del_word_left),
    ['B'] = _VIM.act(function()
      local old_chars = buffer.word_chars
      buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
      buffer.delword_left()
      buffer.word_chars = old_chars
    end),
    ['e'] = _VIM.act(buffer.del_word_right_end),
    ['E'] = _VIM.act(function()
      local old_chars = buffer.word_chars
      buffer.word_chars = buffer.word_chars .. buffer.punctuation_chars
      buffer.del_word_right_end()
      buffer.word_chars = old_chars
    end),
    ['$'] = _VIM.act(function()
      buffer.del_line_right()
    end),
    ['0'] = _VIM.act(function()
      buffer.del_line_left()
    end),
    ['^'] = _VIM.act(function()
      local current_pos = buffer.current_pos
      buffer.vc_home()
      local home_pos = buffer.current_pos
      buffer.delete_range(home_pos, current_pos - home_pos)
    end),
  },
  ['c'] = {
    ['c'] = function()
      buffer.vc_home()
      buffer.del_line_right()
      _VIM.insertMode()
    end,
    ['w'] = function()
      keys.normal_mode.d.w()
      _VIM.insertMode()
    end,
    ['W'] = function()
      keys.normal_mode.d.W()
      _VIM.insertMode()
    end,
    ['b'] = function()
      keys.normal_mode.d.b()
      _VIM.insertMode()
    end,
    ['B'] = function()
      keys.normal_mode.d.B()
      _VIM.insertMode()
    end,
    ['e'] = function()
      keys.normal_mode.d.e()
      _VIM.insertMode()
    end,
    ['E'] = function()
      keys.normal_mode.d.E()
      _VIM.insertMode()
    end,
    ['$'] = function()
      keys.normal_mode.d['$']()
      _VIM.insertMode()
    end,
    ['0'] = function()
      keys.normal_mode.d['0']()
      _VIM.insertMode()
    end,
    ['^'] = function()
      keys.normal_mode.d['^']()
      _VIM.insertMode()
    end,
  },
  ['>'] = {
    ['>'] = _VIM.act(function()
      buffer.vc_home()
      buffer.tab()
    end),
  },
  ['<'] = {
    ['<'] = _VIM.act(function()
      buffer.vc_home()
      buffer.back_tab()
    end),
  },
}

-- Return an empty function so undefined keys don't do anything
setmetatable(keys.normal_mode, {__index = function(t, key)
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