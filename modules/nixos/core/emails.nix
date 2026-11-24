{lib, ...}: {
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
      postmark = "postmark@graysn.com";
      personal = "hello@graysn.com";
      work = "grayson@inspry.com";
    };
  };
}
