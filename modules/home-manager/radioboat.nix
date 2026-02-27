{
  xdg.configFile."radioboat/urls.csv" = {
    text = ''
      url,name
      https://somafm.com/groovesalad.pls,Groove Salad
      http://rdstream-0625.dez.ovh:8000/radio.mp3,Chillofi Radio
      https://stream.bigfm.de/lofifocus/mp3-128/radiobrowser,bigFM LoFi Focus
      https://stream.drugradio.ru:8020/stream128,DEEP IN SPACE
      https://stream.epic-piano.com/chillout-piano,CHILLOUT PIANO
      http://usa9.fastcast4u.com/proxy/jamz?mp=/1,Lofi 24/7
      https://icecast.walmradio.com:8443/classic,walmradio.com - Classic
      https://icecast.walmradio.com:8443/jazz,walmradio.com - Jazz
      http://www.101smoothjazz.com/101-smoothjazz.m3u,101smoothjazz.com
      http://198.15.94.34:8006/stream,deephouseloungue.com
      http://radio.stereoscenic.com/asp-h,ambientsleepingpill.com
      http://relax.stream.publicradio.org/relax.mp3,yourclassical.org
      https://listen.reyfm.de/original_192kbps.mp3,REYFM
    '';
    force = true; # Make read-only to enforce declarative management
  };
}

