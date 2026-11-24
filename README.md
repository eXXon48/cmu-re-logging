# Logging

`cmu-re-logging` · Revised Store package · Mazda CMU150, firmware 74.00.324A

Sets the log level of the JCI services (Info, Warn or Error). Warn writes about a tenth of the boot log lines of Info, so boot is faster. Takes effect after a restart.

## Why

Every JCI service logs at Info by default, and during boot that is a lot of lines through syslog. Warn writes about a tenth of them. The level is chosen in the Store app (Info, Warn, Error); the package bind-mounts its own `settings.txt` over the stock one at boot, so nothing on the rootfs changes.

## What it changes

| File | How | Why |
|---|---|---|
| `/jci/scripts/start_normal_mode.sh` | 3way | boot hook after the tripwire line: bind-mounts the package's log settings over the stock /config/common/log/settings.txt (nothing on the rootfs changes) before the service manager starts any JCI service |

New files (in the package directory on `data_persist`): `bin/log-level.sh`, `settings.txt.tpl`.

`xml-node` edits address single nodes by XPath; `3way` edits are small diffs against the stock file. The Store merges them with every other installed package, refuses a real clash, and takes them back out on uninstall. No stock file is replaced as a whole.

## Install and uninstall

Install from the Revised Store app on the unit, then restart. Uninstall the same way: after the restart the unit behaves as stock again.

Safety: every change is recorded in the Store's vanilla index, so the boot-loop tripwire reverts it on its own if the unit fails to boot several times in a row. No package edits the boot script above the tripwire line.

## Requires

- `cmu-re-store (>= 0.13.4)`

## Part of

- `cmu-re-speedup-boot`

## Develop

```sh
sh test/run.sh                                  # manifest and payload checks
sh tools/mkpkg.sh <version> <rvp-pack> out.rvp   # build the .rvp
```

Releases: a `dev/vN` tag on `develop` gives a dev prerelease, a `vN` tag on `main` a release; CI packs the `.rvp` and attaches it to the GitHub release.
