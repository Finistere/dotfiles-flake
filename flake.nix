{
  description = "Benjamin's machines";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
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
    neovim.url = "github:finistere/neovim-flake";
    # helix = {
    #   url = "github:helix-editor/helix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
  };
  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    agenix,
    flake-utils,
    ...
  } @ inputs: let
    nixConfig = _: {
      nixpkgs.config.allowUnfree = true;
      nix = {
        registry.nixpkgs.flake = inputs.nixpkgs;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes"];
        };
      };
    };
    wayland = _: {
      nix.settings = {
        # add binary caches
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nixpkgs-wayland.cachix.org"
        ];
      };

      # use it as an overlay
      nixpkgs.overlays = [inputs.nixpkgs-wayland.overlay];
    };
    mkMe = hostName: system: {
      inherit hostName system;
      userName = "brabier";
      publicKeys = import ./public-keys.nix;
      theme = "tokyonight_moon";
      lib = rec {
        matchOs = cases:
          if null == builtins.match ''^.*-darwin$'' system
          then cases.linux
          else cases.darwin;
        ifLinux = list:
          matchOs {
            linux = list;
            darwin = [];
          };
        ifDarwin = list:
          matchOs {
            linux = [];
            darwin = list;
          };
        ifLinuxAttrs = attrs:
          matchOs {
            linux = attrs;
            darwin = {};
          };
        ifDarwinAttrs = attrs:
          matchOs {
            linux = {};
            darwin = attrs;
          };
      };
    };
    darwinSystem = hostName: extraModules: let
      system = "aarch64-darwin";
      me = mkMe hostName system;
    in {
      darwinConfigurations.${hostName} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs me;};
        modules =
          [
            nixConfig
            {
              services.nix-daemon.enable = true;
              age.identityPaths = ["/etc/ssh/host_ed25519"];
            }
            # Debug agenix with:
            # sudo launchctl debug system/org.nixos.activate-agenix --stdout --stderr
            agenix.darwinModules.default
            home-manager.darwinModules.home-manager
            ./machines/${hostName}
          ]
          ++ extraModules;
      };
    };
    nixosSystem = hostName: extraModules: let
      system = "x86_64-linux";
      me = mkMe hostName system;
    in {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs me;};
        modules =
          [
            nixConfig
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
            agenix.nixosModules.default
            home-manager.nixosModule
            ./machines/${hostName}
          ]
          ++ extraModules;
      };
    };
    # https://stackoverflow.com/questions/54504685/nix-function-to-merge-attributes-records-recursively-and-concatenate-arrays
    recursiveMerge = attrList:
      with nixpkgs.lib; let
        f = attrPath:
          zipAttrsWith (
            n: values:
              if tail values == []
              then head values
              else if all isList values
              then unique (concatLists values)
              else if all isAttrs values
              then f (attrPath ++ [n]) values
              else last values
          );
      in
        f [] attrList;
  in
    # Systems
    (recursiveMerge [
      (darwinSystem "stravinsky" [
        ./modules/desktop/darwin.nix
      ])
      (nixosSystem "bach" [
        ./modules/desktop/nixos
      ])
      (nixosSystem "bruckner" [
        ./modules/desktop/nixos
        ./modules/desktop/nixos/dev.nix
        ./modules/desktop/nixos/gaming.nix
        wayland
      ])
    ])
    # Shells
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          agenix.packages.${system}.default
        ];
      };
    });
}
