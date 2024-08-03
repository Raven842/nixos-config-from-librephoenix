{ pkgs, ... }:

{
  # Enable openGL and install Rocm
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      rocmPackages_5.clr
      rocmPackages_5.rocminfo
      rocmPackages_5.rocm-runtime

    ];
  };
#  hardware.hardware.extraPackages = with pkgs; [ 
#      rocmPackages_5.clr.icd
#      rocmPackages.clr.icd
#      rocmPackages_5.clr
#      rocmPackages_5.rocminfo
#      rocmPackages_5.rocm-runtime
#      rocmPackages.clr.icd
#      rocmPackages.clr.icd
#      rocmPackages.clr
#      rocmPackages.rocminfo
#      rocmPackages.rocm-runtime
#        
#  ];
  # This is necesery because many programs hard-code the path to hip
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];
}
