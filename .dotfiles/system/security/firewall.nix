{ ... }:

{
  # Firewall
  networking.firewall.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 3333 18081 18083 ];
  networking.firewall.allowedUDPPorts = [ 3333 18081 18083 ]; 
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
