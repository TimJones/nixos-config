{
  self,
  ...

}:
{
  flake.modules = self.factory.user {
    username = "test";
    isAdmin = true;
    hasSSH = true;
    hasPwdHash = true;
  };

  flake.homeConfigurations = self.lib.mkHomeManager "x86_64-linux" "test";
}
