{
  config = {
    programs.claude-code = {
      enable = true;
      memory.text = ''
        - In all interactions and commit messages, be extremely concise and sacrifice grammar for the sake of concision.
        - At the end of each plan, give me a list of unresolved questions to answer, if any. Make the questions extremely concise and sacrifice grammar for the sake of consision.
        - Besides the expected ones, binaries I have installed that may be useful to you include tree, docker, ripgrep, zip, unzip, wl-copy, wl-paste, and wp-cli.
      '';
    };
  };
}
