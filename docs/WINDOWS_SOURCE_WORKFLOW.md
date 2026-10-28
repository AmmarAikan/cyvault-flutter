# Windows source workflow

The Windows checkout is a small Git-linked source tree, not a build mirror.

```powershell
Set-Location 'C:\My Projects\Flutter Projects\CyVault'
git status --short --branch
git pull --ff-only origin main
```

Before pulling, stop if there are local changes/untracked files or the remote is
not `AmmarAikan/cyvault-flutter`. Never use `git reset --hard` or `git clean` to
solve divergence. Clone a timestamped sibling and compare instead.

The checkout must not contain `.dart_tool`, `build`, `.gradle`, Flutter/Android
SDKs, APK/AAB, keystores or `key.properties`. Install tooling/build on Windows
only if explicitly needed later; normal development artifacts remain on Ubuntu
or GitHub Actions.
