{
  description = "Benjamin's machines";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    neovim.url = "github:finistere/neovim-flake";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mac-app-util.url = "github:hraban/mac-app-util";
    tokyonight-nvim = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      agenix,
      mac-app-util,
      nix-index-database,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      nixConfig = _: {
        nixpkgs.config.allowUnfree = true;
        nix = {
          registry.nixpkgs.flake = inputs.nixpkgs;
          nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
          optimise.automatic = true;
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            trusted-users = [
              "root"
              "brabier"
            ];
          };
        };
      };
      mkMe = hostName: system: {
        inherit hostName system;
        userName = "brabier";
        publicKeys = import ./public-keys.nix;
        theme = "tokyonight_moon";
        lib = rec {
          matchOs = cases: if null == builtins.match "^.*-darwin$" system then cases.linux else cases.darwin;
          ifLinuxOr =
            default: value:
            matchOs {
              linux = value;
              darwin = default;
            };
          ifDarwinOr =
            default: value:
            matchOs {
              linux = default;
              darwin = value;
            };
        };
      };
      mkDarwin =
        {
          hostName,
          manageNix ? true,
          extraModules ? [ ],
        }:
        let
          system = "aarch64-darwin";
          me = mkMe hostName system;
        in
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs me;
          };
          modules = [
            mac-app-util.darwinModules.default
            {
              nixpkgs.config.allowUnfree = true;
              system.primaryUser = me.userName;
              age.identityPaths = [ "/etc/ssh/host_ed25519" ];
            }
            # Debug agenix with:
            # sudo launchctl debug system/org.nixos.activate-agenix --stdout --stderr
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            ./machines/${hostName}
            {
              home-manager.users.${me.userName}.imports = [
                mac-app-util.homeManagerModules.default
              ];
            }
          ]
          ++ nixpkgs.lib.optional manageNix nixConfig
          ++ extraModules;
        };
      mkNixos =
        hostName: extraModules:
        let
          system = "x86_64-linux";
          me = mkMe hostName system;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs me;
          };
          modules = [
            nixConfig
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            ./machines/${hostName}
            nix-index-database.nixosModules.nix-index
            { programs.command-not-found.enable = false; }
          ]
          ++ extraModules;
        };
    in
    {
      darwinConfigurations = {
        stravinsky = mkDarwin {
          hostName = "stravinsky";
          extraModules = [ ./modules/desktop/darwin.nix ];
        };
        zelenka = mkDarwin {
          hostName = "zelenka";
          manageNix = false;
          extraModules = [ ./modules/desktop/darwin.nix ];
        };
      };
      nixosConfigurations.bruckner = mkNixos "bruckner" [
        ./modules/desktop/nixos
        ./modules/desktop/nixos/dev.nix
        ./modules/desktop/nixos/gaming.nix
      ];
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              agenix.packages.${system}.default
            ];
          };
        }
      );
      apps.aarch64-darwin.darwin-rebuild = {
        type = "app";
        program = "${darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild";
        meta.description = "Rebuild a nix-darwin system";
      };
    };
}
