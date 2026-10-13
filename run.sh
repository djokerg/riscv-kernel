#!/usr/bin/env sh
# Build and boot the kernel in QEMU inside Docker - no local toolchain needed.
#
#   ./run.sh                 run the default test (full)
#   ./run.sh threads-cpp     run a specific test
#   ./run.sh test            run all tests headless and report PASS/FAIL
#   ./run.sh shell           open a shell in the build container
#
# Quit QEMU with Ctrl-A, then X.
set -e

IMAGE=os1-toolchain
cd "$(dirname "$0")"

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    echo "Building toolchain image (one time, ~1 min)..."
    docker build -t "$IMAGE" .
fi

TTY=""
[ -t 0 ] && TTY="-it"

case "${1:-full}" in
    test)  exec docker run --rm -v "$PWD":/os1 "$IMAGE" scripts/run-tests.sh ;;
    shell) exec docker run --rm $TTY -v "$PWD":/os1 "$IMAGE" bash ;;
    *)     exec docker run --rm $TTY -v "$PWD":/os1 "$IMAGE" make qemu TEST="${1:-full}" ;;
esac
