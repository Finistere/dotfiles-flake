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
    userName = "brabier";
    publicKeys = import ./public-keys.nix;
    nixConfig = _: {
      nixpkgs = {
        config.allowUnfree = true;
      };
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
    darwinSystem = hostName: extraModules: let
      system = "aarch64-darwin";
    in {
      darwinConfigurations.${hostName} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs userName hostName publicKeys system;};
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
    in {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs userName hostName publicKeys system;};
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
  in
    # Systems
    (nixpkgs.lib.fold (a: b: a // b) {} [
      (darwinSystem "stravinsky" [
        ./modules/desktop/darwin.nix
      ])
      (nixosSystem "bach" [
        ./modules/desktop/nixos
      ])
      (nixosSystem "bruckner" [
        ./modules/desktop/nixos
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
