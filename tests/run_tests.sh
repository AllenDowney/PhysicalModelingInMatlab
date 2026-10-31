#!/bin/bash
# Run the code for each chapter in GNU Octave, headless, on a copy of code/
# (some scripts save figures to ../../book/figs/, which must not touch the book).
#
# Usage: tests/run_tests.sh [octave command]   (default: octave)

OCTAVE=${1:-octave}
HERE=$(cd "$(dirname "$0")" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
cp -r "$HERE/../code" "$WORK/code"
mkdir -p "$WORK/book/figs"

pass=0; fail=0; xfail=0; failed=()
while IFS='|' read -r folder code expect; do
    [[ -z "${folder// }" || "$folder" == \#* ]] && continue
    xf=0
    if [[ "$folder" == XFAIL* ]]; then xf=1; folder=${folder#XFAIL}; fi
    folder=$(echo $folder); code=$(echo "$code" | sed 's/^ *//; s/ *$//'); expect=$(echo "$expect" | sed 's/^ *//; s/ *$//')
    out=$(cd "$WORK/code/$folder" && timeout 300 $OCTAVE --no-gui --quiet --no-window-system --eval "
        warning('off', 'Octave:shadowed-function');
        addpath('$HERE/stubs');
        set(0, 'defaultfigurevisible', 'off');
        try
            $code
            disp('TEST-OK')
        catch e
            disp(['TEST-ERROR: ' e.message])
        end" 2>&1)
    ok=0
    if grep -q '^TEST-OK' <<< "$out"; then
        ok=1
        [[ -n "$expect" ]] && ! grep -qF -- "$expect" <<< "$out" && ok=0
    fi
    if (( xf )); then
        if (( ok )); then echo "XPASS $folder: $code"; fail=$((fail+1)); failed+=("$folder: $code (expected to fail)")
        else echo "xfail $folder: $code"; xfail=$((xfail+1)); fi
    elif (( ok )); then
        echo "ok    $folder: $code"; pass=$((pass+1))
    else
        echo "FAIL  $folder: $code"
        grep -v '^\s*$' <<< "$out" | tail -5 | sed 's/^/      /'
        [[ -n "$expect" ]] && echo "      expected output containing: $expect"
        fail=$((fail+1)); failed+=("$folder: $code")
    fi
done < "$HERE/cases.txt"

echo
echo "$pass passed, $fail failed, $xfail expected failures"
for f in "${failed[@]}"; do echo "  failed: $f"; done
(( fail == 0 ))
