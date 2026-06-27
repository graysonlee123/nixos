{
  services.teamspeak3 = {
    enable = true;
    dataDir = "/var/lib/teamspeak3-server";
    defaultVoicePort = 9987;
    logPath = "/var/log/teamspeak3-server";
    openFirewall = true;
  };
}
