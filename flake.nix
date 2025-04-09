{
  description = "Benjamin's machines";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:finistere/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    mac-app-util.url = "github:hraban/mac-app-util";
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
    mac-app-util,
    ...
  } @ inputs: let
    nixConfig = _: {
      nixpkgs.config.allowUnfree = true;
      nix = {
        registry.nixpkgs.flake = inputs.nixpkgs;
        nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        optimise.automatic = true;
        settings = {
          experimental-features = ["nix-command" "flakes"];
        };
        extraOptions = ''
          trusted-users = root brabier
        '';
      };
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
        ifLinuxOr = default: value:
          matchOs {
            linux = value;
            darwin = default;
          };
        ifDarwinOr = default: value:
          matchOs {
            linux = default;
            darwin = value;
          };
      };
    };
    darwinSystem = hostName: extraModules: let
      system = "aarch64-darwin";
      me = mkMe hostName system;
    in {
      darwinConfigurations.${hostName} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit inputs me;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
          };
        };
        modules =
          [
            nixConfig
            mac-app-util.darwinModules.default
            {
              services.nix-daemon.enable = true;
              age.identityPaths = ["/etc/ssh/host_ed25519"];
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
          ++ extraModules;
      };
    };
    nixosSystem = hostName: extraModules: let
      system = "x86_64-linux";
      me = mkMe hostName system;
    in {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs me;
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
          };
        };
        modules =
          [
            nixConfig
            inputs.flake-programs-sqlite.nixosModules.programs-sqlite
            agenix.nixosModules.default
            home-manager.nixosModules.home-manager
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
