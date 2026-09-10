# flake-parts module. Sets ciSystems and nothing else: importers keep their own
# `systems = import inputs.systems;`, so there is one definition of the option
# and the flake still offers every system it did before.
{
  flake.herculesCI.ciSystems = import ./ci.nix;
}
