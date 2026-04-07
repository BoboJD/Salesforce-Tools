# Release Process

This project uses a structured branching strategy to release changes. The `make release` command drives all release flows — the behavior depends on the current branch.

## Branch Overview

| Branch | Purpose |
|---|---|
| `develop` | Main development branch |
| `release/X.Y.Z` | Version release branch (package changes) |
| `scripts/<name>` | Script-only release branch (no package change) |
| `master` | Production branch |

---

## Releasing a Package Version

Use this flow when Salesforce metadata or Apex changes need to be packaged and deployed.

### Steps

1. On `develop`, commit and push your changes.
2. Run `make version` — this will:
   - Check and update npm dependencies
   - Run linting
   - Bump the version number in `sfdx-project.json`
   - Create and promote a new Salesforce package version
   - Create a `release/X.Y.Z` branch from `develop`
3. Commit and push the version bump on the `release/X.Y.Z` branch.
4. Run `make release` — this will:
   - Merge `release/X.Y.Z` into `master`
   - Tag the release as `vX.Y.Z` on `master`
   - Merge `release/X.Y.Z` into `develop`
   - Delete the `release/X.Y.Z` branch

---

## Releasing Script-Only Changes

Use this flow when only bash scripts have changed and no new package version is needed.

### Steps

1. Create a branch from `develop`: `git checkout -b scripts/<name>`
2. Commit and push your script changes.
3. Run `make release` — this will:
   - Merge `scripts/<name>` into `master`
   - Merge `scripts/<name>` into `develop`
   - Delete the `scripts/<name>` branch

> No version bump or package creation is performed.
