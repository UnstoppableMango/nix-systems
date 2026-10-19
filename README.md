# nix-systems

[![Hercules CI](https://hercules-ci.com/api/v1/site/github/account/UnstoppableMango/project/nix-systems/badge)](https://hercules-ci.com/github/UnstoppableMango/nix-systems)

A [nix-systems](https://github.com/nix-systems) pin, plus the subset of those systems CI can build.

| File               | Contents                                              |
| ------------------ | ----------------------------------------------------- |
| `default.nix`      | `aarch64-darwin`, `aarch64-linux`, `x86_64-linux`     |
| `ci.nix`           | `x86_64-linux`                                        |
| `flake-module.nix` | flake-parts module setting `herculesCI.ciSystems`     |

The two lists differ because the Hercules CI agents are `x86_64-linux` only.
A flake that offers darwin outputs queues them against an agent that does not exist, and the job sits pending forever.
`ciSystems` restricts what CI builds without changing what the flake offers.

## Usage

```nix
{
  inputs = {
    systems.url = "github:UnstoppableMango/nix-systems";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [ inputs.systems.flakeModule ];
    };
}
```

`systems = import inputs.systems;` stays.
The module sets `herculesCI.ciSystems` and nothing else, so there is one definition of flake-parts' `systems` option and darwin outputs remain available locally.

Keeping `default.nix` at the root is what lets this stand in for any other nix-systems repo, including through `inputs.someInput.inputs.systems.follows = "systems"`.
Consumers such as flake-utils call `import inputs.systems` and expect a plain list.

## Changing the lists

Edit here, then let Renovate's lockfile maintenance carry the change into every consumer.
Adding an `aarch64-linux` agent means adding that string to `ci.nix`; nothing in the consuming repos changes.
