#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  scripts/transcribe-voice.sh <audio-file> [--out /path/to/out.txt] [extra transcribe.sh args...]

Loads the OpenAI key from OPENAI_API_KEY or OpenClaw config:
  $OPENCLAW_CONFIG_PATH
  ~/.openclaw/openclaw.json
EOF
  exit 2
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

skill_script="$(npm root -g 2>/dev/null)/openclaw/skills/openai-whisper-api/scripts/transcribe.sh"
if [[ ! -f "$skill_script" ]]; then
  echo "Missing OpenClaw transcription skill script: $skill_script" >&2
  exit 1
fi

if [[ "${OPENAI_API_KEY:-}" == "" ]]; then
  OPENAI_API_KEY="$(
    node -e '
const fs = require("fs");
const configPath = process.env.OPENCLAW_CONFIG_PATH || `${process.env.HOME}/.openclaw/openclaw.json`;
try {
  const cfg = JSON.parse(fs.readFileSync(configPath, "utf8"));
  const key =
    cfg?.skills?.entries?.["openai-whisper-api"]?.apiKey ||
    cfg?.skills?.["openai-whisper-api"]?.apiKey ||
    cfg?.openai?.apiKey ||
    "";
  process.stdout.write(key);
} catch {
  process.stdout.write("");
}
'
  )"
  export OPENAI_API_KEY
fi

if [[ "$OPENAI_API_KEY" == "" ]]; then
  echo "Missing OPENAI_API_KEY and no openai-whisper-api apiKey found in OpenClaw config" >&2
  exit 1
fi

exec bash "$skill_script" "$@"
