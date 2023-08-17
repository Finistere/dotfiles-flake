{
  description = "Benjamin's machines";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
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
    nixpkgs-stable,
    darwin,
    home-manager,
    home-manager-stable,
    agenix,
    flake-utils,
    ...
  } @ inputs: let
    userName = "brabier";
    publicKeys = import ./public-keys.nix;
    nixConfig = [
      ({pkgs, ...}: {
        nixpkgs = {
          config.allowUnfree = true;
        };
        nix = {
          package = pkgs.nixFlakes;
          settings = {
            auto-optimise-store = true;
            experimental-features = ["nix-command" "flakes"];
          };
        };
      })
    ];
    darwinSystem = hostName: extraModules: let
      system = "aarch64-darwin";
    in {
      darwinConfigurations.${hostName} = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs userName hostName publicKeys system;};
        modules =
          nixConfig
          ++ [
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
    nixosStableSystem = hostName: extraModules: let
      system = "x86_64-linux";
    in {
      nixosConfigurations.${hostName} = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs userName hostName publicKeys system;};
        modules =
          nixConfig
          ++ [
            agenix.nixosModules.default
            home-manager-stable.nixosModule
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
      (nixosStableSystem "bach" [
        ./modules/desktop/nixos.nix
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
