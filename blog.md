



1. pop fucked, tear down the lot, pave over and rebuild from scratch, now we are all or nothing on NixOS.


2. added some simple programs


3. added autologin, which broke the build, pc kepts loging in and out -  fix was workaround seen in config.


4. added virtualization and  VPN services.

5. added experimental features flakes and nix command to run nix shell

6. added mounted extra disks, the solution was to mount as i wanted them, the ran "sudo nixos-generate-config", which updates the hardware config, adding my other SSDs permanently to the setup

7. looking into how to keep the nix store clean, each generation is its own, imutable setup, so can take up alot of space on the harddrive.

since im doing system wide install, the way to list all generations is sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

which results in a list like this:

   1   2024-10-11 19:23:36   
   2   2024-10-11 19:42:37   
   3   2024-10-11 20:02:58   
   4   2024-10-12 00:39:28   
   5   2024-10-12 00:41:47   
   6   2024-10-12 02:11:56   (current)

