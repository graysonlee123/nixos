# Personal age identity for manual `age` encrypt/decrypt with coworkers.
# Private key stored in secrets/headed.yaml, so sops-nix materializes the same
# identity on the headed machines (corbelan/nostromo) at a stable path.
# Imported from the headed home profile only (not Sulaco).
# Usage: age -d -i ~/.config/age/inspry.txt file.age
{config, ...}: {
  sops.secrets."age/inspry/key" = {
    sopsFile = ../../../secrets/headed.yaml;
    path = "${config.home.homeDirectory}/.config/age/inspry.txt";
  };
}
