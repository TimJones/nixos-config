{
  inputs,
  self,
  lib,
  ...

}:
let
  user = "tim";
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user {
      username = "${user}";
      isAdmin = true;
      hasSSH = true;
      hasPwdHash = true;
    })
    {
      homeManager."${user}" = {
        imports = with inputs.self.modules.homeManager; [
          system-minimal
          git
        ];
        home.username = "${user}";

      };
    }
  ];

  flake.homeConfigurations = self.lib.mkHomeManager "x86_64-linux" "26.05" "${user}";
}
