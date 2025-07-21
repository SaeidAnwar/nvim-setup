return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      log_level = 'info',
      auto_session_enable_last_session = true, -- Auto load last session on startup
      auto_session_sync_cwd = true, -- Sync cwd to session root
      auto_session_enabled = true,
      auto_session_create_enabled = true,
      auto_session_next_terminal_cwd = true,
    }
  end
}
