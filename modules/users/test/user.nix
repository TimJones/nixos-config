{
  inputs,
  self,
  lib,
  ...

}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user {
      username = "test";
      isAdmin = true;
      hasSSH = true;
      hasPwdHash = true;
    })
    {
      homeManager."test" = {
        imports = with inputs.self.modules.homeManager; [
          system-minimal
          git
        ];
        home.username = "test";
      };
    }
  ];

  flake.homeConfigurations = self.lib.mkHomeManager "x86_64-linux" "25.11" "test";
}
