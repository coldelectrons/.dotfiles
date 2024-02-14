{ userSettings, ... }:

{
  # Enable incoming ssh
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  users.users.${userSettings.username}.openssh.authorizedKeys.keys = [
    "AAAAB3NzaC1yc2EAAAADAQABAAABAQDKXITe4+4ZUKIFLlEqsbdct5xcmgUIk+GzPejeZK1qKhG+pU9HnkmYDFNfkfhyiheF2UwSe+n72hflj1dohW7jN1rSucI6p5J+r9Y2gd5yu6XgPuYBtTzxc+RFnx2iYd+j5wQccD87iXzZ/rCYpS21FrrGglIWpazlI2GucgJPYKkRFfPa2ufVVLWqakzVtZyW//eyKolYXsGFZpj8tdRdmZAnk1JTr+DufwObQRpDs6mP86Ncuyqn+4XvBEJpoR/v/pOKHonCJZGlebbN6JSo3FSRFphBur7LsgmTocuhUAx2i38eUjnPPA5DO53zufqY51v5Nu5EhCKyvl2Rtpj9 thomas@linuxdesktop"
  ];
}
