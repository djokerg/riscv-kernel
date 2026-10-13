#!/usr/bin/env bash
# Boots every test in headless QEMU and checks that the kernel shuts down
# cleanly. Interactive tests get scripted keyboard input over the serial port:
# 3 producers, buffer size 10, the text "hello", then ESC to stop.
#
# Run inside the toolchain image:  ./run.sh test
set -u
cd "$(dirname "$0")/.."

TESTS="threads-c threads-cpp sleep sync-c sync-cpp full"
QEMU="qemu-system-riscv64 -machine virt -bios none -kernel kernel -m 128M -smp 1 -nographic"
LOGS=build/test-logs
failed=0

keyboard() {
    sleep 2; printf '3\r'; sleep 1; printf '10\r'
    sleep 3; printf 'hello'; sleep 3; printf '\033'
    sleep 60
}

mkdir -p "$LOGS"
for t in $TESTS; do
    if ! make -s TEST="$t" >"$LOGS/$t.build.log" 2>&1; then
        echo "FAIL  $t (build, see $LOGS/$t.build.log)"
        failed=1
        continue
    fi

    keyboard | timeout 60 $QEMU >"$LOGS/$t.log" 2>&1

    if grep -q "Kernel finished" "$LOGS/$t.log"; then
        echo "PASS  $t"
    else
        echo "FAIL  $t (see $LOGS/$t.log)"
        tail -n 20 "$LOGS/$t.log"
        failed=1
    fi
done

exit $failed
