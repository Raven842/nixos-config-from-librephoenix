{ userSettings, authorizedKeys ? [], ... }:

{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true; #need to change later
      PermitRootLogin = "no";
    };
  };
  # users.users.${userSettings.username}.openssh.authorizedKeys.keys = authorizedKeys;
}
