{
  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
    ];
    directories = [
      "/var/log"
    ];
  };
}
