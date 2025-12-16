{
  home-manager,
  impermanenceModule,
  module,
  pname,
  pkgs,
  ...
}:
let
  username = "testUser";
in
pkgs.testers.runNixOSTest {
  name = "m3l6h-${pname}-test";

  nodes = {
    machine =
      { ... }:
      {
        imports = [
          home-manager.nixosModules.home-manager
        ];

        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          password = "test";
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} =
            { ... }:
            {
              imports = [
                impermanenceModule
                module
              ];

              home = {
                inherit username;
                homeDirectory = "/home/${username}";
                stateVersion = "24.05";
              };

              m3l6h.${pname}.enable = true;
            };
        };
      };
  };

  testScript = ''
    print("Starting test...")

    start_all()

    machine.wait_for_unit("default.target")

    print("Machines started")

    # Wait for boot and login availability
    machine.wait_for_unit("multi-user.target")

    # Switch to the test user and verify basic tmux functionality
    machine.succeed("su - ${username} -c 'tmux -V'")

    # Copy files for output
    machine.copy_from_vm("/home/${username}/.config/tmux/tmux.conf", "output")
  '';
}
