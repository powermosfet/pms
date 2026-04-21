# PMS
Personal Memo Sender

A webservice that publishes a memo to an ntfy topic.

## Configuration

- `APP_PORT` (required)
- `NTFY_TOPIC` (required)
- `NTFY_HOST` (optional, defaults to `https://ntfy.sh`)

## Nix

- Dev shell: `nix develop` (or direnv with `.envrc`)
- Build: `nix build`
- Run: `nix run`
