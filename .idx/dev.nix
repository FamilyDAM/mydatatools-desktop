{ pkgs, ... }: {
  channel = "stable-23.11"; # "stable-23.11" or "unstable"
  packages = [
    pkgs.nodePackages.firebase-tools
    pkgs.jdk17
  ];
  idx.extensions = [];
  idx.previews = {
    enable = true;
    previews = [
        {
            command = ["flutter" "run" "--machine" "-d" "linux"];
            id = "linux";
            manager = "flutter";
            cwd = "client";
        }
    ];
  };
}
