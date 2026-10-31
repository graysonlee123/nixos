# Global Composer packages. Read-only, so `composer global require` won't work:
# add packages here, switch, then run `composer global update`.
{...}: {
  xdg.configFile."composer/composer.json" = {
    force = true;
    text = builtins.toJSON {
      require = {
        "inspry/dev-tooling" = "^1.0";
      };
      repositories = [
        {
          name = "inspry-dev-tooling";
          type = "vcs";
          url = "git@inspry.github.com:inspry/dev-tooling.git";
        }
      ];
    };
  };
}
