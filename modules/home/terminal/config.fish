#!/usr/bin/env fish

# Install fish-plugin-git
emit git_install

function gc
  if count $argv >/dev/null
    git checkout $argv
  else
    git branch --sort=-committerdate --color | fzf --ansi --prompt 'checkout ' | xargs -o git checkout
  end
end

function gb
  if count $argv >/dev/null
    set new_base "$argv[1]"
  else
    set new_base "$(git branch --sort=-committerdate --color | fzf --ansi --prompt 'onto ' | xargs)"
  end
  set branch_root "$(git log -n 500 --pretty=format:'%Cgreen%h%Creset %s' --no-merges | fzf --ansi --prompt 'branch root '| cut -c -7)"
  set branch "$(git rev-parse --abbrev-ref HEAD)"
  git rebase --onto "$new_base" "$branch_root~1" "$branch"
end

if test (uname) = Darwin
  function os-switch
    sudo nix run ~/flakes/dotfiles#darwin-rebuild -- switch --flake ~/flakes/dotfiles
  end
  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"

  ### Add nix binary paths to the PATH
  # https://github.com/LnL7/nix-darwin/issues/122
  # Perhaps someday will be fixed in nix or nix-darwin itself
  fish_add_path --prepend --global "$HOME/.nix-profile/bin" /run/current-system/sw/bin
else
  function os-switch
    sudo nixos-rebuild switch --flake ~/flakes/dotfiles
  end
end

