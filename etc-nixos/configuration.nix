# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  boot.initrd.luks.devices."luks-fb117270-f8f2-44ea-a997-2a8364ebc1a7".device = "/dev/disk/by-uuid/fb117270-f8f2-44ea-a997-2a8364ebc1a7";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
   
  hardware.bluetooth = {
   enable = true;
   powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Select internationalisation properties.
  # Locale
  #
  # Use an explicitly UTF-8 locale for LANG / LC_CTYPE.
  # Keep Indian regional formatting for the individual categories.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultCharset = "UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."warlock" = {
    isNormalUser = true;
    description = "Pradeep";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     tmux
     glib
     kdePackages.dolphin
     kdePackages.okular
     go
     wget
     pciutils
     kitty
     alacritty
     waybar
     wlogout
     networkmanager_dmenu     
     networkmanagerapplet
     pavucontrol
     brightnessctl
     nwg-look
     papirus-icon-theme
     fuzzel
     swaynotificationcenter
     libnotify
     hyprpaper
     hyprlock
     hypridle
     grim
     slurp
     swappy
     wl-clipboard
     adw-gtk3
     nwg-dock-hyprland
     cava
     wallust
         # Desktop applications
     vlc
     # Development
     python314

     # Rust toolchain manager
     rustup
     gcc

     # Developer / terminal tools
     git
     ripgrep
     fd
     eza
     bat
     fastfetch
     btop
     fzf
     nixd
     pyright
     ruff
     lua-language-server
     taplo
     # Whiteboard & Notes
     xournalpp
     rnote
     obsidian
     typora
     
     # Office & Document Workflow
     libreoffice-fresh
     sioyek
     pdfarranger
     typst

     # Screen Recording & Presentation
     obs-studio
     gromit-mpx
     pavucontrol

     # Screenshot & Utilities
     flameshot
     # Pandoc ecosystem
     pandoc
     #haskellPackages.pandoc-crossref
     tectonic
     gtk3
     gsettings-desktop-schemas
     numix-icon-theme
     numix-icon-theme-circle
     yazi
     # Lightweight modern PDF engine
     # Optional: CSS/HTML-based PDF generator
     # texlive.combined.scheme-medium # Alternative: if offline LaTeX is strictly required
   ];
 
  programs.dconf.enable = true;

  environment.etc."xdg/menus/applications.menu".source =
  "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.sessionVariables = {
  XDG_DATA_DIRS = [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
   ];
  };

  programs.neovim = {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  
  # environment.etc."xdg/menus/applications.menu".source =
  #  "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  configure = {
    # Keep ~/.config/nvim/init.lua as the configuration
    # you personally edit and understand.
  customLuaRC = ''
    local user_config = vim.fn.stdpath("config") .. "/init.lua"
  
    if vim.fn.filereadable(user_config) == 1 then
      dofile(user_config)
    end
  '';
    packages.core = with pkgs.vimPlugins; {
      start = [
        plenary-nvim
        telescope-nvim
        nvim-lspconfig
        nvim-web-devicons
	    gitsigns-nvim
        lualine-nvim
        bufferline-nvim
        indent-blankline-nvim
        which-key-nvim

        (nvim-treesitter.withPlugins (p: with p; [
          bash
          json
          lua
          nix
          python
          rust
          toml
          vim
          vimdoc
        ]))
      ];

      opt = [ ];
     };
    };
  };

  programs.starship = {
  enable = true;

  settings = {
    add_newline = true;

    format = "$directory$git_branch$git_status$python$rust$nix_shell$cmd_duration$line_break$character";

    directory = {
      style = "bold #89b4fa";
      truncation_length = 4;
      truncate_to_repo = false;
    };

    git_branch = {
      symbol = " ";
      style = "bold #cba6f7";
    };

    git_status = {
      style = "bold #f9e2af";
    };

    python = {
      symbol = " ";
      style = "bold #89b4fa";
    };

    rust = {
      symbol = " ";
      style = "bold #fab387";
    };

    nix_shell = {
      symbol = " ";
      style = "bold #89dceb";
    };

    cmd_duration = {
      min_time = 2000;
      format = "took [$duration]($style) ";
      style = "bold #a6adc8";
    };

    character = {
      success_symbol = "[❯](bold #a6e3a1)";
      error_symbol = "[❯](bold #f38ba8)";
      vimcmd_symbol = "[❮](bold #89b4fa)";
    };
   };
  };
  
  programs.bash.shellAliases = {
  ll = "eza -lah --icons=auto --group-directories-first";
  tree = "eza --tree --icons=auto";
  catp = "bat --paging=never";
  };

  
  programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
  };

  qt = {
  enable = true;
  platformTheme = "kde";
  style = "breeze";
  };
 
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    noto-fonts
  ];
 
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA + AMD hybrid graphics
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware.nvidia = {
    # Required/recommended for Wayland.
    modesetting.enable = true;
  
    # RTX 3070 Ti is Ampere, so it supports NVIDIA's open kernel module.
    # Userspace NVIDIA libraries are still proprietary.
    open = true;
  
    prime = {
      amdgpuBusId = "PCI:6@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";
  
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # NVIDIA userspace packages are unfree.
  nixpkgs.config.allowUnfree = true; 
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05"; # Did you read the comment?

}
