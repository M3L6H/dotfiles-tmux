<h1>
  dotfiles-tmux
  <img align="right" alt="GitHub Release" src="https://img.shields.io/github/v/release/m3l6h/dotfiles-tmux">
  <img align="right" alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/m3l6h/dotfiles-tmux/.github%2Fworkflows%2Fcheck.yml?branch=main&label=check">
  <img align="right" alt="GitHub License" src="https://img.shields.io/github/license/m3l6h/dotfiles-tmux">
</h1>

Nix-based repository containing my [tmux](https://github.com/tmux/tmux) configuration.

Provides both a home-manager module and dotfiles for easy consumption.

Latest release can be found [here](https://github.com/M3L6H/dotfiles-tmux/releases/latest).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [dependencies](#dependencies)
- [development](#development)
  - [dotfiles](#dotfiles)
  - [testing](#testing)
  - [release](#release)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## dependencies

The following dependencies are required to be installed for the dotfiles to work.
If using the included flake, they will be installed automatically.

- a clipboard program:
  - pbcopy on mac
  - [wl-clipboard](https://github.com/bugaevc/wl-clipboard) on Wayland
- [bat](https://github.com/sharkdp/bat)
- [fzf](https://github.com/junegunn/fzf)

## development

All modules have been defined in the `modules/` folder.

### dotfiles

Generate dotfiles with:

```sh
./scripts/generate-dotfiles.sh
```

The generated files can be found in the `output/` directory.

### testing

Run check tests with:

```sh
nix flake check
```

View test results with:

```sh
nix-store --read-log result
```

Perform interactive testing with:

```sh
nix build .#checks.x86_64-linux.m3l6h-tmux-test.driverInteractive
```

### release

Ensure tag signing is enabled:

```sh
git config --global tag.gpgSign true
```

Run the release cut script:

```sh
./scripts/release-dotfiles.sh v<version>
```
