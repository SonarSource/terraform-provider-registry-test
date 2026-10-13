#!/usr/bin/env bash
# Build the two release archives and the checksum file. Signing happens in CI.
set -euo pipefail

VERSION="${VERSION:-0.0.1-alpha.1}"
NAME="terraform-provider-registry-test"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${ROOT}/dist"

rm -rf "${OUT}"
mkdir -p "${OUT}"

build_archive() {
  local os="$1"
  local arch="$2"
  local binary="${NAME}_v${VERSION}"
  local archive="${NAME}_${VERSION}_${os}_${arch}.zip"
  local stage
  stage="$(mktemp -d)"
  CGO_ENABLED=0 GOOS="${os}" GOARCH="${arch}" go build \
    -o "${stage}/${binary}" \
    -ldflags "-X main.version=${VERSION}" \
    "${ROOT}"
  (
    cd "${stage}"
    zip -q -X "${OUT}/${archive}" "${binary}"
  )
  rm -rf "${stage}"
}

cd "${ROOT}"
build_archive linux amd64
build_archive darwin arm64

cat > "${OUT}/${NAME}_${VERSION}_manifest.json" <<EOF
{
  "version": 1,
  "metadata": {
    "protocol_versions": ["6.0"]
  }
}
EOF

(
  cd "${OUT}"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum \
      "${NAME}_${VERSION}_linux_amd64.zip" \
      "${NAME}_${VERSION}_darwin_arm64.zip" \
      "${NAME}_${VERSION}_manifest.json" \
      > "${NAME}_${VERSION}_SHA256SUMS"
  else
    shasum -a 256 \
      "${NAME}_${VERSION}_linux_amd64.zip" \
      "${NAME}_${VERSION}_darwin_arm64.zip" \
      "${NAME}_${VERSION}_manifest.json" \
      > "${NAME}_${VERSION}_SHA256SUMS"
  fi
)
