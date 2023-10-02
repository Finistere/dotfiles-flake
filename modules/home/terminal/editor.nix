{
  pkgs,
  inputs,
  system,
  ...
}: {
  home = {
    # sessionVariables = {
    #   EDITOR = "vi";
    #   VISUAL = "vi";
    # };
    packages = with pkgs; [
      inputs.neovim.packages.${system}.default
    ];
  };

  programs = {
    helix = {
      enable = true;
      defaultEditor = true;
      package = let
        extraPackages = with pkgs; [
          rust-analyzer-unwrapped
          lua-language-server
          nil # Nix
          nodePackages.bash-language-server
          nodePackages.typescript-language-server
          nodePackages.pyright
          nodePackages.yaml-language-server
          nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
          marksman # Markdown
          # formatting
          nodePackages.prettier
          alejandra
          taplo
        ];
      in
        inputs.helix.packages.${system}.default.override {
          makeWrapperArgs = [
            ''--prefix PATH : "${pkgs.lib.makeBinPath extraPackages}"''
          ];
        };
      settings = {
        editor = {
          bufferline = "multiple";
          "line-number" = "relative";
          "color-modes" = true;
          "cursorline" = true;
          lsp = {
            display-inlay-hints = true;
          };
        };
      };
    };

    fish.shellAliases = {
      vimdiff = "nvim -d";
      vi = "nvim";
    };
  };
}
