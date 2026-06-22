#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"
trap 'rm -rf .tmp/proto-gen' EXIT

if ! command -v protoc >/dev/null 2>&1; then
  echo "protoc is required but was not found in PATH" >&2
  exit 1
fi

if ! command -v protoc-gen-go >/dev/null 2>&1; then
  echo "protoc-gen-go is required but was not found in PATH" >&2
  echo "install: go install google.golang.org/protobuf/cmd/protoc-gen-go@latest" >&2
  exit 1
fi

if ! command -v protoc-gen-go-grpc >/dev/null 2>&1; then
  echo "protoc-gen-go-grpc is required but was not found in PATH" >&2
  echo "install: go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest" >&2
  exit 1
fi

rm -rf gen
mkdir -p gen/go

protoc \
  -I . \
  --go_out=gen/go \
  --go_opt=paths=source_relative \
  --go-grpc_out=gen/go \
  --go-grpc_opt=paths=source_relative \
  service.proto

if [ -d src ]; then
  mapfile -t sdk_proto_files < <(cd src && find . -name '*.proto' -type f | sort | sed 's#^\./##')
  if [ "${#sdk_proto_files[@]}" -gt 0 ]; then
    (
      cd src
      protoc \
        -I . \
        --go_out="$ROOT_DIR/gen" \
        --go_opt=paths=source_relative \
        "${sdk_proto_files[@]}"
    )
  fi
fi
