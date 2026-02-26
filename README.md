# jenkins-cli

Standalone distribution of the generated Jenkins Bash CLI.

## Install (curl | sh)

```bash
curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/install.sh \
  | sh -s -- --repo <org>/<repo>
```

Alternative using environment variable:

```bash
export JENKINS_CLI_REPO="<org>/<repo>"
curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/install.sh | sh
```

## Install a specific tag

```bash
curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/install.sh \
  | sh -s -- --repo <org>/<repo> --version v1.0.0
```

## Install into custom directory

```bash
curl -fsSL https://raw.githubusercontent.com/<org>/<repo>/main/install.sh \
  | sh -s -- --repo <org>/<repo> --bin-dir "$HOME/bin"
```

## Verify checksums

After downloading release assets, verify integrity with `SHA256SUMS`:

```bash
sha256sum -c SHA256SUMS
```

## Release automation

- CI workflow: `.github/workflows/ci.yml`
- Release workflow: `.github/workflows/release.yml`
- Any pushed tag matching `v*` publishes a GitHub Release with:
  - `jenkins-cli`
  - `install.sh`
  - `jenkins-cli-<tag>.tar.gz`
  - `jenkins-cli-<tag>.zip`
  - `SHA256SUMS`

## Command usage example

```bash
JOB_URLSTYLE="KAIF_repos/job/KAIF_repos/job/mercury-dynamics/job/PR-35"
BUILD=1
RAW_COOKIE="$(cat "$HOME/jenkins.cookies.txt")"

JENKINS_CREDS= jenkins-cli \
  getJobProgressiveText \
  --host "$JENKINS_HOST" \
  "Cookie:$RAW_COOKIE" \
  name="$JOB_URLSTYLE" \
  number="$BUILD" \
  start=0
```

## Notes

- Keep `JENKINS_CREDS` empty when using cookie-based auth to avoid unintended basic auth.
- `~/jenkins.cookies.txt` is expected to contain a raw cookie header string.
