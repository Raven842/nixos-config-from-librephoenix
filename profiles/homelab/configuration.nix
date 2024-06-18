{ userSettings, ... }:

{
  imports = [ ./base.nix
              ( import ../../system/security/sshd.nix {
                inherit userSettings; })
            ];
}
