#!/usr/bin/env bash

function cmdcheck() { type >/dev/null 2>&1 "$@"; }

function fixedsed_src() {
	# NOTE: treat delim as '/'
	# TODO: add arg option
	sed -e 's/[\/&]/\\&/g'
}
function fixedsed_src_E() {
	# NOTE: treat delim as '/'
	# TODO: add arg option
	sed -E 's/([$+/|.*\[()?]|]|\^)/\\&/g'
}
function fixedsed_dst() {
	# NOTE: treat delim as '/'
	# TODO: add arg option
	sed -e 's/[\/&]/\\&/g'
}

function fixedsed() {
	# TODO: add help
	local src_text=$(printf '%s' "$1" | fixedsed_src)
	local dst_text=$(printf '%s' "$2" | fixedsed_dst)
	[[ -z $src_text ]] && local src_text='$^'
	# NOTE: for debug only
	# command echo sed "s/$src_text/$dst_text/g" >>$LOG
	sed "s/$src_text/$dst_text/g"
}
function fixedsed_E() {
	# TODO: add help
	local src_text=$(printf '%s' "$1" | fixedsed_src_E)
	local dst_text=$(printf '%s' "$2" | fixedsed_dst)
	[[ -z $src_text ]] && local src_text='$^'
	# NOTE: for debug only
	# command echo sed -E "s/$src_text/$dst_text/g" >>$LOG
	sed -E "s/$src_text/$dst_text/g"
}

function test() {
	INPUT="oresed.sh"
	LOG="$INPUT.log"
	OUTPUT="$INPUT.out"

	# sed test
	: >$LOG
	: >$OUTPUT
	echo '[sed test][START]'
	cat "$INPUT" | awk 1 | while IFS= read -r LINE; do
		command echo "$LINE" | fixedsed "$LINE" "$LINE" >>"$OUTPUT"
	done
	echo '[sed test][END]'
	icdiff -U 1 --line-numbers $INPUT $OUTPUT || { echo "[FAILED]" && exit 1; }

	# sed -E test
	: >$LOG
	: >$OUTPUT
	echo '[sed -E test][START]'
	cat "$INPUT" | awk 1 | while IFS= read -r LINE; do
		command echo "$LINE" | fixedsed_E "$LINE" "$LINE" >>"$OUTPUT"
	done
	echo '[sed -E test][END]'

	if cmdcheck icdiff; then
		icdiff -U 1 --line-numbers $INPUT $OUTPUT || { echo "[FAILED]" && exit 1; }
	else
		diff $INPUT $OUTPUT || { echo "[FAILED]" && exit 1; }
	fi
}

[[ $# == 0 ]] && echo 1>&2 "$(basename $0) [function name(fixedsed_{,_E,src,src_E,dst})] [ARGS]"

if [[ $1 == "test" ]]; then
	test
	exit $?
fi

FUNC=$1
if [[ $(type -t $FUNC) == "function" ]]; then
	shift
	$FUNC "$@"
else
	echo 1>&2 "Not found function $FUNC"
fi
