{
  description = "NixOS from Scratch";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode.url = "github:anomalyco/opencode";
  };

  outputs = { self, nixpkgs, home-manager, opencode, ... }:
    let
      system = "x86_64-linux";
      opencodePkg = opencode.packages.${system}.default;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ph = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit opencodePkg;
              };
            };
          }
        ];
      };
    };
}
