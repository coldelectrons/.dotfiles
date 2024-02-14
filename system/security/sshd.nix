{ userSettings, ... }:

{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # For greater security, consider putting authorized keys in this file
      # and disabling password authentication.
      # While testing, though, it's probably best to leave it enabled.
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  users.users.${userSettings.username}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpytdNG6IGBInjwqVUn+tqN2MzU5anVKGzIpfJChzOnECMuw8Qb1j8E1mAhwA5Nn6umLed4ag6s/Sc5Ed/DvxTb76sHj9YzjZeblu0m/e7fewoAjRrDfdrcj3kRd+aeKQEhTzmbR8RrK6aeMD/zBMQFg4PouXmd22oEOZxxxtVj274ZB2tOiDSGbibQIDX7c1zfm3/92CYnxz6lCDoNKtGIkF5lOIDqXl4YXybAEyj7SklWJhI6sqxOeoH7Jvo50mDlJOBhMomTtB8l1STTfg72QikyHwpP+nZvAVcUUy5pdYuQYjIYZKxqB5k0ggu3rcqH2zwHyZhBvhWhzzfcXiywSnIPgQaGBDGY+HugE/cd8/UPDu4T0W8xes2EIvcC6IHStg8fw7PdhS9C4t9/UplX7OI9MPbO/jbh9fdGSXwjpVWOz7cZMo8D9vWIgZuOPBfOvurxX/EkB81zR0nsh5TMh1i64iF/sNW2J1umstI4qhmJ2RTc5rgieuxswsJA0c= thomas@stickers"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC14FJS9uO6+IRF5avmnrNf6JkFvVBviyOCQMxNvIYsj7gf8P1dcrIoQrAgjPypmgTSp/umhfa9B0TVAE9pVAfweLMgWpZHMpNRIAKcExd5tyEFKCjMfuKbe8fZcXAcmPCkQvJDf+b5ob8AiMFLzFVvr1OEDYLAmFIpOiffHoGZgqDgMrVk/wIPAWssbOktrzt3Bh/lq+etptA61rhZ/mTwD2rs8OcoyQFNDou+68aS5zquAPkzzkCkZsCtEwqBMTF0E2BqjNZe2ClOLfpIjzGRNHQf6mBL2AFOabJUyb2Rf0bjKuzcqQVxuPhsmAKOtd1HgUdBwHiPtrf71Mk1xrkahhEt7lXVdrjrcNkfDJ55jX27YyJOG8vCzK2VH5LkLboTQJ8lDlrqqYAryu2oi2Hb7t7Wea+tTD3vREAmu2ocRZqSfHaiXt8bCv1JnDYmgolqb7C2B9sDqDxoZ3M/S3Pm5anK7RDKPsjO7WtdNapGc7dzhHPRFhAN3I8IZ0I/yHU= thomas@diodelaser"
  ];
}
