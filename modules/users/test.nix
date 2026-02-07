{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user {
      username = "test";
      isAdmin = true;
    })
    {
      nixos.test.users.users.test.password = "test";
    }
  ];
}
