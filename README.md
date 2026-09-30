# Dustin's dotfiles (fork of mathias')

![Screenshot of my shell prompt](https://i.imgur.com/xEPOKcF.png)

## Installation

_Note: this is a fork of [mathiasbyrnes/dotfiles](https://github.com/mathiasbynens/dotfiles). Check out the original for the latest and greatest._

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

1. Clone: `git clone https://github.com/DSchau/dotfiles.git`
1. `./init/init.sh`: creates `~/Projects/{Personal,Work,Scripts}`, copies VSCode and Ghostty config, creates an SSH key and `~/.ssh/config`, and installs oh-my-zsh, nvm and bun
1. `./bootstrap.sh`: copies the dotfiles (`.zshrc`, `.bash_profile`, `.aliases`, …) into `~`, copies Claude Code commands to `~/.claude/commands`, and sets up [pi](#pi)
1. `./brew.sh`: installs Homebrew, CLI tools and apps (casks)
1. `./init/mas.sh`: installs the Mac App Store apps listed in `init/mas_apps.txt` (sign in to the App Store first)
1. `./.macos`: sets macOS defaults and can optionally download extra apps (`init/install-applications.sh`)
1. Optional: `./git.sh` clones the repos in `git_repos.txt` into `~/Projects/{Personal,Work/<Org>}`

`./init/doctor.sh` checks for installed apps and global dependencies.

To update, from this repo: `source bootstrap.sh` (use `set -- -f; source bootstrap.sh` to skip the prompt).

### pi

`bootstrap.sh` installs [pi](https://pi.dev) if it's missing (to `~/.pi/agent`, added to `$PATH` in `.bash_profile`). It then merges `pi/settings.json` into `~/.pi/agent/settings.json` and installs the packages listed there (e.g. [`pi-open-tui`](https://pi.dev/packages/pi-open-tui)). The repo's `packages` list replaces your local one.

The default provider is OpenRouter. The API key is **not** committed. Set it in `~/.secrets` (git-ignored and loaded by `.bash_profile`):

```bash
export OPENROUTER_API_KEY="sk-or-..."
# or read it from 1Password:
# export OPENROUTER_API_KEY="$(op read 'op://Private/OpenRouter/credential')"
```

Create a key at [openrouter.ai/keys](https://openrouter.ai/keys), or run `/login` in pi (saves it to `~/.pi/agent/auth.json`; never commit that file).

### Local overrides

- `~/.path`: sourced first; use it to extend `$PATH`, e.g. `export PATH="/usr/local/bin:$PATH"`
- `~/.extra`: extra settings (git name/email); tracked and copied by `bootstrap.sh`
- `~/.secrets`: API keys; never committed or copied

## Feedback

Suggestions/improvements [welcome](https://github.com/mathiasbynens/dotfiles/issues)!

If specific to this repository, feel free to use [these issues](https://github.com/dschau/dotfiles/issues).

## Author

Original author

| [![twitter/mathias](http://gravatar.com/avatar/24e08a9ea84deb17ae121074d0f17125?s=70)](http://twitter.com/mathias "Follow @mathias on Twitter") |
|---|
| [Mathias Bynens](https://mathiasbynens.be/) |

## Thanks to…

* @ptb and [his _macOS Setup_ repository](https://github.com/ptb/mac-setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](https://butt.zone/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* Lauri ‘Lri’ Ranta for sharing [loads of hidden preferences](https://web.archive.org/web/20161104144204/http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](https://matijs.brinkhu.is/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](https://sindresorhus.com/)
* [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [macOS-Defaults project](https://github.com/kevinSuttle/macOS-Defaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
* [Haralan Dobrev](https://hkdobrev.com/)
* Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
