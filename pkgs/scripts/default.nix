{ writeShellScriptBin }:

{
  git-remote-url = writeShellScriptBin "git-remote-url" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Get current pane's directory
    pane_path=$(tmux run "echo #{pane_current_path}")
    cd "$pane_path" || exit 1
    
    # Check if git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      echo "Not a git repository"
      exit 0
    fi
    
    # Get remote URL
    url=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ -z "$url" ]]; then
      echo "No remote 'origin' found"
      exit 0
    fi
    
    # Open URL (Linux)
    xdg-open "$url" 2>/dev/null || echo "Failed to open: $url"
  '';
}
