{ config, lib, pkgs, ... }:
{
  # Enable SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Disable firewall for easier initial setup
  networking.firewall.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Essential packages
  environment.systemPackages = with pkgs; [
    openssh
    sudo
    nano
    htop
    neovim
  ];

  # Enable sudo for wheel group
  security.sudo.wheelNeedsPassword = false;
}
