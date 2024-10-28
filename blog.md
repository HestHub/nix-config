


## My accidental path to NixOS

It started as a simple wish to spice up a blog post with some AI-generated images,
but ended with a ruined OS and a weekend spent writing config and reading docs.

While writing my last blogpost, I had the idea to zhuzh it up a bit with some images,
and just so happend to be, i have quite the powerful GPU sitting in my PC, begging for some AI rendering experimentation.

The first step seemed simple enough: install ROCM, AMD's version of CUDA to get the AI and GPU talking.
Running PopOS, installation is as easy as running apt install, and that will be all it takes to start rendering?

Not quite, as it turns out.

For anyone else, this might have been it, but my attempt failed, and failed so utterly and so brutally that the SSD containing the bootloader disappeared from the system, gone with a digital wind,never to be seen again.

So after a dark, stormy, week-long troubleshooting session compressed into a single sunday afternoon, pulling both hair and SATA cables, i finally threw in the towel and tallied up the system as condemned. 

Now that the OS was beyond salvation, the only way forward was to raze the ruins of my once working PC, 
pave over the lot and rebuild from scratch.

So not every step went exactly according to plan, but i did find a silverlining in this catastrphic failure: NixOS.
Being forced to start from strach did push me to pick up and old project that had been puttering along in my ever increasing backlog of personal projects, trying out NixOS as a daily driver.

## What is Nix, and why use it?

So what is Nix? it seesm like depending on how you hold it and which parts you are exposed to first, you could describe something completely different.

Is it an operating system? A package manager? A configuration language? A development environment?

The answer is: yes.

Nix is actually an entire ecosystem of tools that work together and can help us build immutable, reproducable systems.


### The nix Ecosystem
- Nix (the package manager): the package manager the entire ecosystem is built around. 
the novelty of this manager comperd to traditional ones such as apt, dnf or pacman is that every package get installed in its own isolated box, preventing one package from breaking another, and avoiding the "dependecy hell" that can arise on other distros.
- Nix (the language): a purely functinal language designed for package and config management.
- Nix (the operating system): A linux distribution built around the nix package manager, here the entire system is treated as one reproducable package.
- Modules: The building blocks of nix configuratrion. Each module is a self-contained unit containing its own options, servies and configurations.
- Channels: Simillar to linux distribution repositories, these collelctions of packages and modules are different streams of software nix can fetch from, each stream having its own update frequency and stability.
  - nixos-unstable: bleeding edge, rolling release updates
  - nixos-YY-MM: stable, regular release stream, updated every 6 month (YY.04 and YY.11)
- Nix store: located at `/nix/store`, this is where all packages and configuration is found. Each package is stored under a unique hash that also contains all of the packages dependecies. this structure is what enables nix to guarantee both reproducablity and a promise that updates wont break existing packages.
- Generations: A nix generation is a snapshot of the systems current state. Every time the system configuration is changed, a package is added or removed, a new generation is created. These generations can be used like git commits, we can jump back to a previsous commit if the latest is not up to par, and just like git handles diffs between commits, the unchanged packages in the nix store are shared between generations, meaning large storage savings on the disk.


### Nix compared to traditional distributions

Compared to a traditional distribution , a nix configuaration is completly declarative, so everything i stored in documeted, version-controlled files. 
So instead of having a system state that evolves and changes over time, nix is closer to a "Infrastrucute-as-code" approach,
the system is the code, and we cah build, backup and deploy it just like code.

A nix system is immutable, so unlike other sytems where installing a new package might silently update a shared dependcy, every package in nix is isolated, and in this containerized enviroment, everything the package needs to function is included, so having different version fo the same software is no longer an issue.

Updating and testing new features with nix is safe and easy, building a new generation is an atomic operation, so either everything works together, or the generation wont build at all. And if something would turn out broken in the newly build generation, swapping back to a working system is as easy as a reboot.


### the future features

My nix journey will start from scratch, and i will, atleast for today, keep myself to the nix core, but there are two adanved nix features that i would like to take a look at in the future:

#### flakes

Flakes are the "new" feature of nixos, which has been in an experimental state since 2021. 
Flakes brings an additional layer of reporducabiltiiy and structure to a nix config, allowing nix to:

- Lock all your dependencies to specific versions
- Create reproducible development environments
- Share configurations between machines easily
- Define modular system components that can be mixed and matched

A simple flake might look something like this:


```
{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    #system configuration here
  };
}

```

There is much discussion around flakes being the next evolution within nix,
but its a bit more complex to wrap your head around, and will add to an already quite steep learing curve,
so atleast for today, i will leave them be.


#### homeManager

Home Manager is nix approach to manage personal user environment. 
Instead of manually configuration a pile of different dotfiles (.zshrc, .vimrc) and installing user specific package, we can piggyback on nix and get all the benefits from our system config and apply them to user config aswell.

So everything normaly spread out into dotfiles and optiosn menues would be handled together with our system, backed up and secured, ready to be deployed on any machine, anytime. 

So in short we could say the main benefits of a nix system is:

- its declarative
- config can be backed up
- config can be deployed to multiple machines
- possible to rollback changes if anything breaks
- package updates cant break other packages dependcies
- different version of the same package can coexist
- system changes are safe and easy to manage


Is there a learning curve? Absolutely. Nix thinks differently about system configuration, and it takes time to adjust to.
But from everything ive heard from others using nix its worth it, once you get a hang of it, its hard to imagine going back to the old ways.

## installation

### live-booting

Step 1 - Livebooting nixOS and installing it on my Desktop.

- picked up a a NixOS Image from here [NixOS](https://nixos.org/download/#nixos-iso)
- burned it to a USB stick and booted from it. 

From the live boot enivronment we can poke around and get a feel for the system, but here its hard to tell it apart from other distros,
and like many other we can use a graphical installation wizard to permantenlty install the OS.

otherwise a normal installation wizard, i setup my locale, keyboard, user, desktop manager and hardrive partitioning.
The only thing sticking out is the option to "Allow unfree software". 
The default behaivour of nix is to only allow free, open source software, and you have to opt in to allow propriatary software to be installed on your system. 

TODO picture of installation

### first boot

After a quick restart, booting into the system, its time to install some software. 

during the installation, two very important nix files have been generated: the config files.

In nixos, we dont have access to a package manger like apt, or a software center to install new software. 

Instead we have to use these configuration files if we want to add something new. 

firstly is the hardware-configuration.nix, this file tells nix what hardware its working with, CPU architecture, hard-drives, network card, and also sets up the firmware we need, sets CPU architecture and points out hard-drive partitions. 

So in short, hardware config lives here, and is something managed by nix itself, we dont edit this file by hand.

   ```
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/cca9e208-4d2a-4a8e-8b87-0c17d0a96475";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E961-AFB0";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fcc5c3f9-836c-4eee-80d9-f03360b526ea"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

   ```


next up is the configuration.nix file, and here is where the magic happens. 

this file works like a blueprint of the OS we want to setup, any changes we want to do to our system, its done using this file. 

Here is the biggest difference between Nix and other distributions, since the OS is immutable, we dont install anything in the normal way, but we instead rebuild the entire system, with the added software bundled into it. 

So if we take a look at my config file at first boot: 


   ```
 Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hest = {
    isNormalUser = true;
    description = "hest";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "hest";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
   ```

here we can se a couple of intreseting things: 

we have a set of different domains that we configure in this file, 
first a couple that get configured during the installation, and that ill leave as is:

- boot
- networking
- time
- i18n (Internationalization) 
- users


and then we have the three main domains that will add software to our system: 

#### systempackages

```
environment.systemPackages = with pkgs; [
  vim
  git
  firefox
];

```

this is the basic form of installtion, simply making a binary available systemwide, without any extra options of config.
Simillar to running apt install.

#### programs

```
programs = {
  vim = {
    enable = true;
    defaultEditor = true;
    extraConfig = '''
      set number
      set relativenumber
    ''';
  };
};
```
programs lets us add some extra configuration to an app or tool that we install.
This is a great options if we want to add some config right from the get go, use some nix specific integration, or setup system default when a new app is added.


#### services

```
services = {
  nginx = {
    enable = true;
    virtualHosts."example.com" = {
      root = "/var/www/example";
    };
  };
};
```

Services handles everything to do with background task, here we can use an additional setup to setup background processes after the install and configuration step. Servies allows us to setup VPNs, databases, web servers and anyting handled as background deamons.


So im basing my decision on which to use on three quesitons:

  1. Just need the sofware available? - systemPackages
  2. Need som extra configuraiton? - programs
  3. Will it run in the background? - services

But of course availablitity will also factor in, there are alot more packages compared to programs in the nix package manager, so sometimes the hand is forced.

Thats if for installation, lets move on and add some apps.

## configuration

### first updates

So lets give it a go, first on the list:
 
- vim (instead of the bundled nano)
- bitwarden as a password manager
- fish as my interactive shell
- git
- vscodium
- gnomeExtensions.pop-shell (to handle tiled windows)
- steam (game store/library)
- discord
- slack


adding all of this is as simple as writing a couple of lines to my systemPackage attribute like this:

```
environment.systemPackages = with pkgs; [
   vim 
   gnomeExtensions.pop-shell
   bitwarden
   discord
   slack
   git
   vscodium
  ];

```

For steam, which has some extra config options we can provide, I'll add this:

```
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

```

and as a final touch, I want to add fish as the default shell for my user, updating the users item for my user:

```
 users.users.hest = {
    isNormalUser = true;
    description = "hest";
    shell = pkgs.fish;  # NEW LINE
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

```

Adding this to the configuraiton file itself wont do much, but the blueprint for new generataion is ready to be built.

this is done using the nix cli command `nixos-rebuild`.

`nixos-rebuild switch` will build the config and activate the new generation right away, so any new binaries install are available, and will also add a new record to the boot-loader menu, making the new generation default. 

TODO PICTURE OF BOOTLOADER

Its also possible to tag the generation, just add the flag `-p NAME` or `--profile-name NAME`, giving a more discriptive name other than the date it was built.


So first generation has been created, and all the new packages are available right away, just like that.

### auto login
Great, now its much more manageble to edit files with vim, so lets add some more config, next up is a small tweak to autologin on boot: 

first attempt didn't quite pan out, went to [nix options search]() and found this, which looked promising

```
  # autologin without password
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "hest";

```

added the lines to config and did a `nixos-rebuild switch`, no problem detected, new generation created.
But when i rebooted to test it, something wasn't quite right. the OS booted alright, and even logged in automaticly, but a second later i was kicked out it went back and forth like that. 

No worries, lets just reboot into the previous generation, and everything is as good as rain again.

After som scanning around the forums i found a workaround: 

```
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
```

not about the root cause, but if it works it works right? [forum discussion](https://discourse.nixos.org/t/gnome-display-manager-fails-to-login-until-wi-fi-connection-is-established/50513/14)


### containerization and VPN

next up - virtualization and VPN

Im using [Tailscale](https://tailscale.com/) for a private network between my machine, and setting up this in nix is a oneliner service addition:

Virtualization with podman is handled in its own "domain" called "Virtualisation":

```
  # enable tailscale VPN
  services.tailscale.enable = true;

  # enable containerization ( podman ) 
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

```

then lets add some useful CLI tools: 

```

  environment.systemPackages = with pkgs; [
   ... same as before

   # VPN
   tailscale
   trayscale

   # containers
   podman
   podman-compose
   podman-desktop
   
   ];

```

One `nixos-rebuild switch` later, and we have tailscale VPN and podman containers ready to go.


### nix shell

But what if i just need a cli tools once in a blue moon, or just want to get a feel for some alternatives before you permanently install it?

Thats where the nix-shell comes into play.

nix shell lets me create a temporary PATH enviroment, install all the dependencies needed by a package and have it availible only as long as the current session is running. Rebooting the system will clean up all the temporary files the package has used.

So say i need to get some data from a json, but cant be bothered installing jq the normal route: editing config, rebuilding, creating a new generation, just for a one off command?

Lets handle it with nix-shell: 

```

hest@nixos ~> jq
The program 'jq' is not in your PATH. You can make it available in an
ephemeral shell by typing:
  nix-shell -p jq
hest@nixos ~ [127]> nix-shell -p jq
these 55 paths will be fetched (74.04 MiB download, 349.22 MiB unpacked):
...
...
...

```

5 seconds later, the nix shell is ready to go:

```
[nix-shell:~]$ echo {} | jq .
{}

```

A nice feature to have, being able to setup a quick test environment, test out some fun app or CLI i found online, and when im done, not having to worry about just files and unused packages clogging down the system. 


### nix-command and flakes

Speaking of features, lets do a quick detour and take at nix flakes.

I know i said i wont be using flakes today, but this will be quick, just makeing the system ready for it, and test out a flake i found.

So in order to enable some experimental features, we add this line to our config:

```
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

rebuild, and we have both flakes and the new nix command at our fingertips. 

To test it out,I did do some experimentation with this flake: [nixified-AI](github:nixified-ai/flake#invokeai-amd) a flake of [InvokeAI](https://www.invoke.com/), a platform to run text-to-image AI locally. 

at first i tried to run it directly from github

```
nix run github:nixified-ai/flake#textgen-amd
```

But something didn't click, the installation stalled and never finish, or truth be told, i gave up when it was still running after i had been away for 20 minutes. 

The next attempt was to download the repo and run it locally. 

```
git clone https://github.com/nixified-ai/flake
cd flake
nix run .#invokeai-amd

```

2-3 min of installation later,and i have a local text-to-image AI running on my GPU, working like a charm.

### Gaming and mounting extra hard-drives


Right about now im feeling good with the programs and tools installed, everything installed "just works" right out of the bat. 

Next up was setting up the main puropose if this machine: Gaming.
Steam installed, proton enabled, [Against the Storm](https://store.steampowered.com/app/1336490/Against_the_Storm/) downloaded and off we go. 

Works perfectly, great FPS, no screen tearing, artifacts or other graphical issues.
No strange behaiviour with keyboard or mouse, and i think the GPU barely started up the fans running it, 10/10. 

But since i have multiple SSDs in my system and the OS installed my "tiny" 500GB M.2 drive, i would prefer to put all my games the 1TB NVME drive, just incase i once again manage to ruin the OS, and to be honest it does feel inevitable, given enough time and tinkering. 


Right now i can only see the main disk, so seems my extra Sata drives are not mounted, lets see how that can be remidied.


This is where to hardware-configuration.nix shines.

The solution i found did require a couple of manual steps, but im sure it can be handled automaticly, either with scripts or with some deeper nix knowledge, but what i did was:

  1. mount the drives (make sure they are mounted under /mnt and not /tmp/run/ which gnomes "disks" app will do by default; It wont work if they are in temp folder)
  2. update the hardware config by running `sudo nixos-generate-config` 
  3. profit, now we have the disk mounted at boot, managed by nix.

No, its not to much trouble, and yes, i would survive manually performing this herculean feat of strength every time i set up a system from scratch, but wouldn't it be nice if this was done for you? For now i put it aside and put my future hopes toward [HomeManager] and [Flakes] to solve this.

### found issue with command not found 

Ran into to an issue when typing away at the terminal, an unplesant database error popped up every time I fat-fingered a command.

```
hest@nixos ~> claer
DBI connect('dbname=/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite','',...) failed: unable to open database file at /run/current-system/sw/bin/command-not-found line 13.
cannot open database `/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.
hest@nixos ~ [127]> 
```

Seems this had something to do with the channel nix was listening to by default, and the programs.sqlite database is only handling channels prefixed by `nixos-` and not `nixpkgs-`,
Just adding the proper nixos-unstable channel and a quick update, and no more DB issues.


```
hest@nixos ~> nix-channel --add https://nixos.org/channels/nixos-unstable nixos
hest@nixos ~> nix-channel --update
hest@nixos ~/D/nix-config (nixos)> nix-channel --list
nixos https://nixos.org/channels/nixos-unstable
```

```
hest@nixos ~> claer
claer: command not found
hest@nixos ~ [127]> 

```

As a added "benefit", this also updated me from using the stable "LTS" release of 24.04 to nixos-unstable, the rolling release.

### clean up the nix store

As a final step in this config i wanted to tidy up a bit around the nix store and bootloader. 

with all the different derivations and generations after a couple of weeks of tinkering and rebuilding, the size of the nix store can grow rather large.

```
hest@nixos ~> du /nix/store/ -sh
21G	/nix/store/
```

21 GB might not be to bad, but this will grow quickly, every new package adding to the total, and every generation will add a new record to our bootloader, making that swell up aswell.

TODO picture of bootloader


Step one: Lets see how it can be done manually.

Starting out by finding all the stored generations on the system:

```
nix-env --list-generations
```

Will do the trick, but since i have installed everything system-wide (using the sytemPackages domain),
I also need to point out that im using the system profile in this case:

```
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

   1   2024-10-12 02:11:56   
   2   2024-10-12 15:33:14   
   3   2024-10-12 17:59:32   
   4   2024-10-12 21:59:04   
   5   2024-10-20 13:16:04   
   6   2024-10-20 13:21:57   
   7   2024-10-20 20:45:41   
   8   2024-10-22 21:23:08   (current)

```

For this manual step, we can try to clear up all the older generations

```
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

   8   2024-10-22 21:23:08   (current)

```
Great, no trouble here, so lets look at the store now that we have some dangling packagees from the old generations. 
The nix-store cli lets us do manual garbage-collection:

```
nix-store --gc
deleting unused links...
note: currently hard linking saves 4337.25 MiB
1155 store paths deleted, 654.20 MiB freed

```

But according to the documentation, this is a command you should not have to handle manually in normal circumstances.

So lets automate this using our configuration instead.

The [Wiki](https://nixos.wiki/wiki/Storage_optimization) 
shows that its possbile to handle cleanup for both the generations and the store automaticly in a couple of different ways.

The most straightforward options seems to be a scheduled cleanup, and i think I will go for once a week,
and only keep the last 3 generations, so if anything goes wrong in the future, i have something to revert back to.

For the store cleanup i opted for an even easier option, optimise after every build, so from now on,
every time i build a new generation, a cleanup of dangling packages will be performed.

```
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +3";
  };

  nix.settings.auto-optimise-store = true;

```


## outro

And with that the MVP config for my NixOS build is complete, 
and this is the configuration ive been using as a daily driver for about two-three weeks now.

Almost all of the config work was done upfront, and during the last two weeks
ive only added some minor tweaks: replacing a package here, adding some extra config there.
Overall the system has been rock solid, and so far im really happy with how it turned out. 

Now for the finishing touch, the pièce de résistance of this build:
I will completly wipe my hard-drive, reinstall NixOS from strach using my config file and see if there is anything missing.

So lets save this config to github, wipe it all and see what happends.

TODO add pictures of Installation


And were back! 

the whole installation took about 30 min, from pressing reboot until i started writing here again, and that is after checking that everything is in place, logging into a couple of apps and settings up github access. 

all in all, the manual step i still need to perform are:
- copy my configuration file from pulic github repo
- nixos-rebuild switch
- reboot to get the gnome extension pop-shell show up. 
- enable pop shell and toggle tiling windows.
- mount disks + run sudo nixos-generate-config
- update nix-channel to handle "command not found"
- login to bitwarden, firefox google account, slack, discord, spotube, supersonic
- login to steam, enable compatability layer, add extra harddrives.
- pair up PS5 controller over bluetooth. 

So there are still some small "issues" that i would like to remedy, and with [flakes]() and [homemanager]() i think most can be resolved. 

Im not sure if its possible, or even desirable to handle app logins through config, perhaps a private Github gist with secrets and access tokens could handle it? something i have to look into in the future. 

Adding to that, i might aswell provide my current TODO list for NixOS while im at it, in no particular order:

- handle config
  - [Flakes]()
  - [HomeManager]()
- look into nix linters:
  - https://github.com/oppiliappan/statix
  - https://github.com/NixOS/nixfmt
  - https://github.com/kamadorueda/alejandra
- security hardening
  - https://github.com/cynicsketch/nix-mineral
- package management
  - NUR https://github.com/nix-community/NUR/
  - sofware center https://github.com/snowfallorg/nix-software-center
- building widgets
  - AGS https://github.com/Aylur/ags
- extra inspiration
  - https://github.com/nix-community/awesome-nix
  - https://github.com/nix-community/nixpkgs-wayland?tab=readme-ov-file#packages
  - https://discourse.nixos.org/t/tips-tricks-for-nixos-desktop/28488/4
- Userfriendly alternative
  - https://snowflakeos.org/

But for today i will leave it at that, and i hope i managed to show a fair view of what a journey with NixOS Desktop can entail, atleast from a beginners point of view.

Thank you for sticking around, and i will leave you with a look at the final config for this session.


#### configuration.nix

```
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # autologin without password
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "hest";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # enable tailscale VPN
  services.tailscale.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.hest = {
    isNormalUser = true;
    description = "hest";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # enable containerization ( podman ) 
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # basics
    wget
    vim
    gnomeExtensions.pop-shell

    # CLI 
    navi
    tealdeer
    jq
    yq
    dasel # https://github.com/tomwright/dasel
    lf
    bat
    eza
    fzf
    zellij
    tre-command
    radeontop
    xclip

    # pw-manager 
    bitwarden

    # coms
    discord
    slack

    # media
    supersonic
    spotube

    # containers
    podman
    podman-compose
    podman-desktop

    # dev 
    git
    gh
    vscodium
    mise

    # VPN
    tailscale

    # Nix
    nixfmt-rfc-style
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than +3";
  };

  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.05"; # Did you read the comment?

}

```

#### hardware-configuration.nix

```
# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d15bc54f-14a3-46ad-ac2e-4491cf0ef8e1";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8DB2-391E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/17a50a65-0cf0-43f3-ad12-c04a35e5e00d" =
    { device = "/dev/disk/by-uuid/17a50a65-0cf0-43f3-ad12-c04a35e5e00d";
      fsType = "ext4";
    };

  fileSystems."/mnt/bb0d0a4f-d7af-44ad-8dda-89bd4b8b646b" =
    { device = "/dev/disk/by-uuid/bb0d0a4f-d7af-44ad-8dda-89bd4b8b646b";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ba63ca35-0d86-408c-b15c-623de0039ec8"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp38s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

```