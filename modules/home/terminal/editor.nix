{
  pkgs,
  inputs,
  system,
  me,
  ...
}: {
  home = {
    sessionVariables = {
      EDITOR = "vi";
      VISUAL = "vi";
    };
    packages = with pkgs; [
      inputs.neovim.packages.${system}.default
    ];
  };

  programs = {
    #   helix = {
    #     enable = false;
    #     package = let
    #       extraPackages = with pkgs; [
    #         rust-analyzer-unwrapped
    #         lua-language-server
    #         nil # Nix
    #         nodePackages.bash-language-server
    #         nodePackages.typescript-language-server
    #         nodePackages.pyright
    #         nodePackages.yaml-language-server
    #         nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
    #         marksman # Markdown
    #         # formatting
    #         nodePackages.prettier
    #         alejandra
    #         taplo
    #       ];
    #     in
    #       inputs.helix.packages.${system}.default.override {
    #         makeWrapperArgs = [
    #           ''--prefix PATH : "${pkgs.lib.makeBinPath extraPackages}"''
    #         ];
    #       };
    #     settings = {
    #       inherit (me) theme;
    #       editor = {
    #         bufferline = "multiple";
    #         line-number = "relative";
    #         color-modes = true;
    #         cursorline = true;
    #         file-picker.hidden = false;
    #         lsp = {
    #           display-inlay-hints = true;
    #         };
    #         soft-wrap.enable = true;
    #         indent-guides = {
    #           render = true;
    #           character = "│";
    #           skip-levels = 1;
    #         };
    #       };
    #       keys = {
    #         normal = {
    #           "C-e" = "scroll_down";
    #           "C-y" = "scroll_up";
    #         };
    #       };
    #     };
    #     languages = {
    #       language-server.rust-analyzer = {
    #         command = pkgs.rust-analyzer-unwrapped + /bin/rust-analyzer;
    #         config.check.command = "clippy";
    #       };
    #       language = [
    #         {
    #           name = "nix";
    #           formatter.command = "alejandra";
    #           auto-format = true;
    #         }
    #         {
    #           name = "markdown";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "markdown"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "javascript";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "javascript"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "typescript";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "typescript"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "html";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "html"];
    #           };
    #         }
    #         {
    #           name = "css";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "css"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "json";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "json"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "yaml";
    #           formatter = {
    #             command = "prettier";
    #             args = ["--parser" "yaml"];
    #           };
    #           auto-format = true;
    #         }
    #         {
    #           name = "rust";
    #           auto-format = true;
    #         }
    #       ];
    #     };
    #   };

    fish.shellAliases = {
      vimdiff = "nvim -d";
      vi = "nvim";
    };
  };
}
