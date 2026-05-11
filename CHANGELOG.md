# Changelog

All notable changes to phpvm. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is [SemVer](https://semver.org/).

## [2.1.0] - 2026-05-11

### Added
- `phpvm --auto --print [dir]` — print resolved project PHP version without switching. Used by `phpvm-gui` so the GUI and CLI share one constraint solver.
- `phpvm-gui --foreground` / `-F` — keep the GUI attached to the terminal (errors visible, useful for debugging).
- `phpvm-gui` now double-forks on launch so the calling shell returns immediately and the GUI survives terminal close. `.desktop` launchers and `phpvm --window` benefit too.

### Changed
- Auto-switch from shell hooks (`phpvm --auto --quiet`) now uses `sudo -n`. Without the nopasswd rule the hook no longer hangs on a silent password prompt — it sends a labeled desktop notification telling you what's asking and how to fix it.
- `do_switch` failures return rc=77 when password is required; cmd_auto branches on this to show a contextual notification instead of a generic "failed to switch".
- Sudoers glob tightened from `/usr/bin/php*` to `/usr/bin/php[0-9].[0-9]` — the old glob also matched `phpunit`, `php-config`, etc.
- `install.sh --upgrade` detects the old `php*` glob and rewrites the sudoers file to the tighter pattern.
- `phpvm-gui` REFRESH_MS bumped 5s → 15s and per-version SAPI/xdebug/ini lookups are now memoized per session (cleared on switch). Was forking PHP for every installed version every 5 seconds.
- `phpvm-gui` composer detection now shells out to `phpvm --auto --print` first so behavior matches the shell side exactly (supports `^`, `~`, ranges, `|`).
- `install.sh` no longer prompts when stdin isn't a tty (defaults to CLI+GUI, skips sudoers/hook prompts) — works under `curl … | sudo bash`.
- `uninstall.sh` cleans both `/usr/local/bin`/`/etc/phpvm` AND `~/.local/bin`/`~/.phpvm` instead of either/or.
- `install.sh` rewrites `git@host:owner/repo` remote URLs to `https://host/owner/repo` when recording REPO_URL, so `phpvm --self-update` works without an ssh-agent.

### Fixed
- `do_switch` no longer swallows `update-alternatives` stderr — failure messages reach the user.
- `.php-version` parsing now normalizes `php8.2`, `8.2.0`, leading/trailing whitespace to `X.Y`. Was a silent miss before.
- `phpvm --set-project` validates input and prompts before overwriting an existing `.php-version` with a different value.
- `phpvm --window` pre-checks for python3-gi/GTK3 and reports the install command instead of silently failing.
- Tray indicator guide string `"PHP 8.88"` → `"PHP 99.99"` so labels don't truncate on PHP 10.x or 8.10+.

### Security
- Sudoers glob tightening (see Changed) closes the case where the old `php*` rule could authorize unrelated `php-config` / `phpunit` binaries if they ever shipped at `/usr/bin/php…`.

---

## [2.0.0] - 2026-05-07

Initial public release.

- Interactive TUI version picker.
- System tray GUI (`phpvm-gui`) with SAPI / xdebug / FPM / EOL badges.
- Detached GTK picker window (`phpvm --window`).
- Per-project PHP via `.php-version` or `composer.json`.
- Auto-switch shell hooks for bash, zsh, fish.
- Passwordless sudo opt-in via installer.
- `phpvm --self-update`.
