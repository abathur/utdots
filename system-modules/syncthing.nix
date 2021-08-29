{ config, lib, pkgs, nodes, ... }:

with lib;

{
  options = {
    dotfiles.syncthing.enabled = mkEnableOption "syncthing";
    dotfiles.syncthing.syncthingId = mkOption { type = types.str; };
  };

  config = mkIf config.dotfiles.syncthing.enabled {
     services.syncthing = {
      enable = true;
      user = config.dotfiles.params.username;
      configDir = "/home/${config.dotfiles.params.username}/.config/syncthing";
      overrideDevices = true;
      devices =
        with pkgs.lib;
          pipe
            nodes
            [ (mapAttrs (_k: v: v.config))
              (filterAttrs (_k: v: v.networking.hostName != config.networking.hostName))
              (mapAttrs (_k: v:
                { id = v.dotfiles.syncthing.syncthingId;
                  addresses = [ "tcp://${v.dotfiles.params.ip}:22000" ];
                }))
            ];

      overrideFolders = true;
      folders = {
        "/home/${config.dotfiles.params.username}/sync" = {
           id = "homesync";
           devices =
             with pkgs.lib;
               pipe
                 nodes
                 [ (mapAttrs (_k: v: v.config))
                   (filterAttrs (_k: v: v.networking.hostName != config.networking.hostName))
                   (mapAttrs (_k: v: v.networking.hostName))
                   attrValues
                 ];
             };
      };

      extraOptions = {
        options = {
          localAnnounceEnabled = false;
          globalAnnounceEnabled = false;
          relaysEnabled = false;
          natEnabled = false;
          listenAddresses = [ "tcp://${config.dotfiles.params.ip}:22000" ];
        };
      };
    };
  };
}
