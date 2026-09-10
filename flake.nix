{
  description = "Flake systems, and the subset Hercules CI can build";

  # For usage, see the README.md
  outputs = _: rec {
    flakeModules.default = ./flake-module.nix;
    flakeModule = flakeModules.default;
  };
}
