#!/usr/bin/env bash
set -euo pipefail

CACHE_DIR="${TMPDIR:-/tmp}/zensical-external-repos"
mkdir -p "${CACHE_DIR}"

sync_to_docs() {
  local repo_url="$1"
  local repo_name="$2"
  local dest_dir="$3"
  local clone_dir="${CACHE_DIR}/${repo_name}"

  if [ -d "${clone_dir}/.git" ]; then
    git -C "${clone_dir}" pull --ff-only
  else
    git clone --depth 1 "${repo_url}" "${clone_dir}"
  fi

  mkdir -p "${dest_dir}"
  rsync -av --delete \
    --exclude='.git/' \
    --exclude='.github/' \
    --exclude='.gitignore' \
    "${clone_dir}/" "${dest_dir}/"
}

# Sync the-morning-word with language-specific structure
sync_the_morning_word() {
  local repo_url="$1"
  local repo_name="$2"
  local clone_dir="${CACHE_DIR}/${repo_name}"

  if [ -d "${clone_dir}/.git" ]; then
    git -C "${clone_dir}" pull --ff-only
  else
    git clone --depth 1 "${repo_url}" "${clone_dir}"
  fi

  # Sync content for each language into the respective language folder
  for lang in en zh ms; do
    local source_dir="${clone_dir}/content/${lang}"
    local dest_dir="docs/${lang}/faith/the-morning-word"

    if [ -d "${source_dir}" ]; then
      mkdir -p "${dest_dir}"
      rsync -av --delete \
        --exclude='.git/' \
        --exclude='.github/' \
        --exclude='.gitignore' \
        "${source_dir}/" "${dest_dir}/"
    fi
  done
}

sync_the_morning_word "https://github.com/tiongchong/the-morning-word.git" "the-morning-word"

echo "External repositories synced into language-specific folders."
