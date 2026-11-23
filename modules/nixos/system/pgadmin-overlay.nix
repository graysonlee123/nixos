# pgadmin4 9.14 fails its "Reverse Engineered SQL" regression suite (resql).
# Skip just that suite; the rest of the browser suite still runs.
# TODO: drop once nixpkgs#589528 (pgadmin4 9.14 -> 9.18) lands in nixos-26.05.
# https://github.com/NixOS/nixpkgs/issues/589968
{lib, ...}: {
  nixpkgs.overlays = [
    (_: prev: {
      pgadmin4 =
        if lib.versionOlder prev.pgadmin4.version "9.15"
        then
          # overrideAttrs (not overridePythonAttrs) keeps .override, which
          # pgadmin4-desktopmode needs. Python builder runs checkPhase as
          # installCheckPhase.
          prev.pgadmin4.overrideAttrs (old: {
            # resql also runs inside the browser suite unless excluded there.
            installCheckPhase =
              builtins.replaceStrings
              [
                "python regression/runtests.py --pkg resql"
                "--pkg browser --exclude "
              ]
              [
                ""
                "--pkg browser --exclude resql,"
              ]
              old.installCheckPhase;
          })
        else prev.pgadmin4;
    })
  ];
}
