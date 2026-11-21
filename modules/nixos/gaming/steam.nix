{
  inputs,
  pkgs,
  ...
}: let
  gamescopePkgDir = "${inputs.nixpkgs-unstable}/pkgs/by-name/ga/gamescope";
in {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  # 3.16.30 fixes lag bomb (see https://wiki.archlinux.org/title/Gamescope).
  # Built against stable, not taken from pkgs-unstable: Steam preloads its
  # overlay into gamescope, which needs libGL from the FHS env's glibc.
  programs.gamescope.package = pkgs.gamescope.overrideAttrs (old: rec {
    version = "3.17.0";
    src = pkgs.fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      tag = version;
      fetchSubmodules = true;
      hash = "sha256-7+KC69Ps86IkICMJdtg2x9b0A6SwE7ITKP0yibZ2bx8=";
    };
    patches = [
      "${gamescopePkgDir}/shaders-path.patch"
      "${gamescopePkgDir}/gamescopereaper.patch"
      (pkgs.fetchpatch {
        url = "https://github.com/ValveSoftware/gamescope/commit/4ce1a91fb219f570b0871071a2ec8ac97d90c0bc.diff";
        hash = "sha256-O358ScIIndfkc1S0A8g2jKvFWoCzcXB/g6lRJamqOI4=";
      })
      (pkgs.fetchpatch {
        url = "https://github.com/ValveSoftware/gamescope/commit/d49a2aded261030e649fee42ad295f1ef56b736b.diff";
        hash = "sha256-Uh08ZRaV912ZOsl1DMpbVLxIgh4jEXevgihQf2W9KFk=";
      })
    ];
    postPatch =
      builtins.replaceStrings
      ["src/reshade_effect_manager.cpp"] ["src/Utils/DirHelpers.cpp"]
      old.postPatch;
    buildInputs = old.buildInputs ++ [pkgs.catch2_3];
  });
}
