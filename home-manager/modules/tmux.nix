{ pkgs, ... }:
let
  tpm = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "3.0.0"; # Replace with your desired version or commit hash
    sha256 = "hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc="; # Correct hash
  };
in
{
  home.file = {
    ".tmux/plugins/tpm".source = tpm;
  };

  home.file = {
    ".tmux.conf".text = ''
      # tmux configuration
      # created by : bluecosmo

      # refresh binding
      unbind r
      bind r source-file ~/.tmux.conf

      # navigation
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key -n C-M-h resize-pane -L 3
      bind-key -n C-M-j resize-pane -D 3
      bind-key -n C-M-k resize-pane -U 3
      bind-key -n C-M-l resize-pane -R 3

      # keep current working directory across panes
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # options
      set -g mouse on
      setw -g mode-keys vi
      set-option -g prefix C-Space
      set-option -g status-position top
      set-option -g default-shell /home/bluecosmo/.nix-profile/bin/bash
      set -g pane-active-border-style fg=#FFFFFF

      # copy mode (vim keybinds)
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip"
      bind P paste-buffer
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip"

      # tpm
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'christoomey/vim-tmux-navigator'

      # status bar theme
      set -g @plugin 'niksingh710/minimal-tmux-status'
      set -g @minimal-tmux-bg "#ccffff"
      set -g status-left-length 15
      set -g @minimal-tmux-indicator-str "$USER"
      set -g @minimal-tmux-status "bottom"
      set -g @minimal-tmux-justify "centre"
      bind-key b set-option status

      # run tpm
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}

