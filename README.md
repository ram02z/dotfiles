## dotfiles

### Prerequisites:
- chezmoi
- (opt) gpg and rbw for personal setup

#### Setup

##### SSH

`$ chezmoi init ram02z --ssh`

##### HTTPS

`$ chezmoi init ram02z`

Use `one-shot` flag during init for a one time initialisation

#### Tested on:
- Ubuntu WSL2 20.04
- Ubuntu 21.04
- Void Linux
- macOS Big Sur
- Arch Linux (needs more testing)
