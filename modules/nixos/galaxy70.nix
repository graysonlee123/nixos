# Fixes the mode of the function keys on my Galaxy 70 keyboard

{
  config = {
    boot.extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
  };
}

