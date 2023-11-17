return {
  debounce = function(ms, fn)
    local timer = vim.loop.new_timer()
    return function(...)
      local argv = { ... }
      timer:start(ms, 0, function()
        timer:stop()
        vim.schedule_wrap(fn)(unpack(argv))
      end)
    end
  end,

  -- Common kill function for bdelete and bwipeout
  -- credits: based on bbye and nvim-bufdel
  ---@param kill_command? string defaults to "bd"
  ---@param bufnr? number defaults to the current buffer
  ---@param force? boolean defaults to false
  buf_kill = function(kill_command, bufnr, force)
    kill_command = kill_command or "bd"

    local bo = vim.bo
    local api = vim.api
    local fmt = string.format
    local fn = vim.fn


    if bufnr == 0 or bufnr == nil then
      bufnr = api.nvim_get_current_buf()
    end


    local bufname = api.nvim_buf_get_name(bufnr)

    if not force then
      local choice
      if bo[bufnr].modified then
        choice = fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
        if choice == 1 then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("w")
          end)
        elseif choice == 2 then
          force = true
        else
          return
        end
      elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
        choice = fn.confirm(fmt([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
        if choice == 1 then
          force = true
        else
          return
        end
      end
    end


    -- Get list of windows IDs with the buffer to close
    local windows = vim.tbl_filter(function(win)
      return api.nvim_win_get_buf(win) == bufnr
    end, api.nvim_list_wins())

    if force then
      kill_command = kill_command .. "!"
    end


    -- Get list of active buffers
    local buffers = vim.tbl_filter(function(buf)
      return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
    end, api.nvim_list_bufs())


    -- If there is only one buffer (which has to be the current one), vim will
    -- create a new buffer on :bd.
    -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
    if #buffers > 1 and #windows > 0 then
      for i, v in ipairs(buffers) do
        if v == bufnr then
          local prev_buf_idx = i == 1 and #buffers or (i - 1)
          local prev_buffer = buffers[prev_buf_idx]
          for _, win in ipairs(windows) do
            api.nvim_win_set_buf(win, prev_buffer)
          end
        end
      end
    end

    -- Check if buffer still exists, to ensure the target buffer wasn't killed
    -- due to options like bufhidden=wipe.
    if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
      vim.cmd(string.format("%s %d", kill_command, bufnr))
    end
  end,

  -- stolen from LunarVim
  icons = {
    kind = {
      Array = "",
      Boolean = "",
      Class = "",
      Color = "",
      Constant = "",
      Constructor = "",
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "",
      Folder = "󰉋",
      Function = "",
      Interface = "",
      Key = "",
      Keyword = "",
      Method = "",
      Module = "",
      Namespace = "",
      Null = "󰟢",
      Number = "",
      Object = "",
      Operator = "",
      Package = "",
      Property = "",
      Reference = "",
      Snippet = "",
      String = "",
      Struct = "",
      Text = "",
      TypeParameter = "",
      Unit = "",
      Value = "",
      Variable = "",
    },
    git = {
      LineAdded = "",
      LineModified = "",
      LineRemoved = "",
      FileDeleted = "",
      FileIgnored = "◌",
      FileRenamed = "",
      FileStaged = "S",
      FileUnmerged = "",
      FileUnstaged = "",
      FileUntracked = "U",
      Diff = "",
      Repo = "",
      Octoface = "",
      Branch = "",
    },
    ui = {
      ArrowCircleDown = "",
      ArrowCircleLeft = "",
      ArrowCircleRight = "",
      ArrowCircleUp = "",
      BoldArrowDown = "",
      BoldArrowLeft = "",
      BoldArrowRight = "",
      BoldArrowUp = "",
      BoldClose = "",
      BoldDividerLeft = "",
      BoldDividerRight = "",
      BoldLineLeft = "▎",
      BookMark = "",
      BoxChecked = "",
      Bug = "",
      Stacks = "",
      Scopes = "",
      Watches = "󰂥",
      DebugConsole = "",
      Calendar = "",
      Check = "",
      ChevronRight = "",
      ChevronShortDown = "",
      ChevronShortLeft = "",
      ChevronShortRight = "",
      ChevronShortUp = "",
      Circle = " ",
      Close = "󰅖",
      CloudDownload = "",
      Code = "",
      Comment = "",
      Dashboard = "",
      DividerLeft = "",
      DividerRight = "",
      DoubleChevronRight = "»",
      Ellipsis = "",
      EmptyFolder = "",
      EmptyFolderOpen = "",
      File = "",
      FileSymlink = "",
      Files = "",
      FindFile = "󰈞",
      FindText = "󰊄",
      Fire = "",
      Folder = "󰉋",
      FolderOpen = "",
      FolderSymlink = "",
      Forward = "",
      Gear = "",
      History = "",
      Lightbulb = "",
      LineLeft = "▏",
      LineMiddle = "│",
      List = "",
      Lock = "",
      NewFile = "",
      Note = "",
      Package = "",
      Pencil = "󰏫",
      Plus = "",
      Project = "",
      Search = "",
      SignIn = "",
      SignOut = "",
      Tab = "󰌒",
      Table = "",
      Target = "󰀘",
      Telescope = "",
      Text = "",
      Tree = "",
      Triangle = "󰐊",
      TriangleShortArrowDown = "",
      TriangleShortArrowLeft = "",
      TriangleShortArrowRight = "",
      TriangleShortArrowUp = "",
    },
    diagnostics = {
      BoldError = "",
      Error = "",
      BoldWarning = "",
      Warning = "",
      BoldInformation = "",
      Information = "",
      BoldQuestion = "",
      Question = "",
      BoldHint = "",
      Hint = "󰌶",
      Debug = "",
      Trace = "✎",
    },
    misc = {
      Robot = "󰚩",
      Squirrel = "",
      Tag = "",
      Watch = "",
      Smiley = "",
      Package = "",
      CircuitBoard = "",
    },

  }
}
