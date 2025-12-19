#!/usr/bin/env bash

directory="$1"
platform="$2"
# arch="${platform%-*}"
os="${platform#*-}"

tmux_conf="${directory}/tmux.conf"
tmux_conf_tmp="${tmux_conf}.tmp"

find "$directory" -type f -print0 | while IFS= read -r -d '' f; do
  # sessionx
  perl -i -pe \
    's|^.*/tmux-plugins/sessionx/.+\.tmux|set -g \@plugin "omerxx/tmux-sessionx"|g' \
    "$f"
  # vim-tmux-navigator
  perl -i -pe \
    's|^.*/tmux-plugins/vim-tmux-navigator/.+\.tmux|set -g \@plugin "christoomey/vim-tmux-navigator"|g' \
    "$f"
  # tmux-plugins
  perl -i -pe \
    's|^.*/tmux-plugins/([^/]+)/.+\.tmux|set -g \@plugin "tmux-plugins/tmux-$1"|g' \
    "$f"

  # Copy/paste commands
  if [ "$os" = 'darwin' ]; then
    perl -i -pe 's|wl-copy|pbcopy|g' "$f"
    perl -i -pe 's|wl-paste|pbpaste|g' "$f"
  fi

  echo "Sanitized: ${f}"
done

echo "set -g @plugin 'tmux-plugins/tpm'" >"$tmux_conf_tmp"
cat "$tmux_conf" >>"$tmux_conf_tmp"
echo "run '~/.tmux/plugins/tpm/tpm'" >>"$tmux_conf_tmp"
mv -f "$tmux_conf_tmp" "$tmux_conf"
