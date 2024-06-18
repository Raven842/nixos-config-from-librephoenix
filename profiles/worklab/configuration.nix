{ userSettings, ... }:

{
  imports = [ ../homelab/base.nix
              ( import ../../system/security/sshd.nix {
                inherit userSettings; })
            ];
}
