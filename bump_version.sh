#!/usr/bin/env bash
set -euo pipefail

DATE=$(date "+%Y-%m-%d_%H_%M_%S")

echo "$DATE" >VERSION

sed -i "s/version \".*\"/version \"${DATE}\"/" Formula/denver.rb

git add VERSION Formula/denver.rb
git commit -m "Bump version to ${DATE}"
git tag -f "${DATE}"
git push -f origin main --tags
