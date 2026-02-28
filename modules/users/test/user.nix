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
}
