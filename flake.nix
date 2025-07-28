{
  description = "Base system for raspberry pi 4";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
  let
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    packages.aarch64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        inherit system;
        format = "sd-aarch64";
        modules = [
          ./extra-config.nix
          {
            system.stateVersion = "24.11";

            users.users.admin = {
              password = "admin123"; # This is temporary password. It will be changed on first boot
              isNormalUser = true;
              extraGroups = [ "wheel" ];
            };

            # Raspberry Pi specific optimizations
           # hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
           # hardware.deviceTree.enable = true;

            # Reduce closure size for faster builds
            documentation.nixos.enable = false;
            services.udisks2.enable = false;
          }
        ];
      };
    };

    # For easy access from any system
    packages.x86_64-darwin.sdcard = self.packages.aarch64-linux.sdcard;
    packages.aarch64-darwin.sdcard = self.packages.aarch64-linux.sdcard;
  };
}
