{
  config,
  lib,
  ...
}: {
  options = {
    emails = lib.mkOption {
      description = "Email addresses, keyed by purpose.";
      default = {};
      type = lib.types.attrsOf lib.types.str;
    };
  };
  config = {
    emails = {
      gmail = "graysonleegantek@gmail.com";
      postmark = "postmark@${config.domains.personal}";
      personal = "hello@${config.domains.personal}";
      work = "grayson@inspry.com";
    };
  };
}
