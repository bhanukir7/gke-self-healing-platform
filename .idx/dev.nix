{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"

  # A list of packages to make available in your workspace.
  # For a searchable list of available packages, see https://search.nixos.org/packages
  packages = [
    pkgs.python3
    pkgs.google-cloud-sdk
  ];

  # Environment variables to set in your workspace.
  env = {
  };

  # Used to configure your VS Code extensions and workspace settings.
  # For more details, see https://www.jetpack.io/devbox/docs/ide-integration/vscode/
  idx = {
    # A list of extensions to install from the Open VSX Registry.
    # See https://open-vsx.org/ for available extensions.
    extensions = [
      "ms-python.python"
      "googlecloudtools.cloudcode"
    ];
    workspace = {
      onCreate = {
        install-deps = "pip install -r requirements.txt";
      };
    };
  };
}
