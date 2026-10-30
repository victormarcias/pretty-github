#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

if [ -f .env ]; then
  set -a
  source .env
  set +a
fi
: "${GCP_PROJECT:?Set GCP_PROJECT in .env or export it before running}"

# Deploys (doesn't call) this repo as the "serve_pretty_github" Cloud
# Function.
# It only serves the app itself (public/) — the dev-docs notes are fetched
# live from GitHub by the browser, not by this function, so only changes
# to this repo need a redeploy.
gcloud functions deploy serve_pretty_github \
  --project="$GCP_PROJECT" \
  --gen2 \
  --runtime=python312 \
  --region=us-east4 \
  --entry-point=serve_pretty_github \
  --trigger-http \
  --allow-unauthenticated \
  --source=.
