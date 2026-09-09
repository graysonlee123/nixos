{pkgs, ...}: {
  home.packages = [pkgs.radioboat];

  # radioboat 0.7.0+ reads only radioboat.toml; urls.csv format is gone.
  # Volume/stations are config-only now (CLI --volume / --track-file removed).
  xdg.configFile."radioboat/radioboat.toml" = {
    text = ''
      # Managed declaratively by home-manager. Do not edit by hand.
      volume = 75
      muted = false

      [[stations]]
      name = "Groove Salad"
      url = "https://somafm.com/groovesalad.pls"

      [[stations]]
      name = "Chillofi Radio"
      url = "http://rdstream-0625.dez.ovh:8000/radio.mp3"

      [[stations]]
      name = "bigFM LoFi Focus"
      url = "https://stream.bigfm.de/lofifocus/mp3-128/radiobrowser"

      [[stations]]
      name = "DEEP IN SPACE"
      url = "https://stream.drugradio.ru:8020/stream128"

      [[stations]]
      name = "CHILLOUT PIANO"
      url = "https://stream.epic-piano.com/chillout-piano"

      [[stations]]
      name = "Lofi 24/7"
      url = "http://usa9.fastcast4u.com/proxy/jamz?mp=/1"

      [[stations]]
      name = "walmradio.com - Classic"
      url = "https://icecast.walmradio.com:8443/classic"

      [[stations]]
      name = "walmradio.com - Jazz"
      url = "https://icecast.walmradio.com:8443/jazz"

      [[stations]]
      name = "101smoothjazz.com"
      url = "http://www.101smoothjazz.com/101-smoothjazz.m3u"

      [[stations]]
      name = "deephouseloungue.com"
      url = "http://198.15.94.34:8006/stream"

      [[stations]]
      name = "ambientsleepingpill.com"
      url = "http://radio.stereoscenic.com/asp-h"

      [[stations]]
      name = "yourclassical.org"
      url = "http://relax.stream.publicradio.org/relax.mp3"

      [[stations]]
      name = "REYFM"
      url = "https://listen.reyfm.de/original_192kbps.mp3"
    '';
    force = true; # Overwrite any existing writable config to enforce declarative management
  };
}
