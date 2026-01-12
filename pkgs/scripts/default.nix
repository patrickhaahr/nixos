{ writeShellScriptBin }:

{
  git-remote-url = writeShellScriptBin "git-remote-url" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    pane_path=$(tmux run "echo #{pane_current_path}")
    cd "$pane_path" || exit 1
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
      echo "Not a git repository"
      exit 0
    fi
    
    url=$(git remote get-url origin 2>/dev/null || echo "")
    if [[ -z "$url" ]]; then
      echo "No remote 'origin' found"
      exit 0
    fi
    
    # Convert SSH URLs to HTTPS for browser compatibility
    # Handles: git@host:path.git → https://host/path
    # Handles: ssh://git@host/path.git → https://host/path
    # Removes .git suffix for cleaner URLs
    url=$(echo "$url" | sed -E \
      -e 's|^git@([^:]+):|https://\1/|' \
      -e 's|^ssh://git@|https://|' \
      -e 's|\.git$||')
    
    xdg-open "$url" > /dev/null 2>&1 || echo "Failed to open: $url"
  '';
}
