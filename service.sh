: ${progname=$(basename $0)}
: ${extra_commands=""}
: ${gdb_command="gdb"}
: ${gdb_flags=""}

load_rc() {
	local rcfile=$1
	if [ -f $rcfile ]; then
		. $rcfile
	fi
}

run_command() {
	commands="start stop restart status $extra_commands"

	local arg=${1-""}
	if [ -z "$arg" ]; then
		usage
		return 0
	fi
	if ! echo "${commands} debug" | grep -q "$arg"; then
		echo 1>&2 "${progname}: invalid command -- $arg"
		return 1
	fi

	shift
	command_$arg $@
}

is_locked() {
	local lockfile=$1
	! flock -n $lockfile -c "rm -f $lockfile; true"
}

pwait() {
	local pid=$1
	while [ -d /proc/$pid ]; do
		sleep 1
	done
}

usage() {
	echo "Usage: $progname ($(echo ${commands} | tr ' ' '|'))"
}

command_start() {
	eval local program=\$${name}_program
	eval local flags=\$${name}_flags
	echo "Starting $progname."
	exec $program $flags
}

command_stop() {
	eval local pidfile=\$${name}_pidfile
	echo "Stopping $progname."
	if is_locked $pidfile; then
		local pid=$(cat $pidfile)
		kill $pid
		echo -n "Waiting for pid $pid..."
		pwait $pid
		echo
	fi
}

command_restart() {
	( command_stop )
	( command_start )
}

command_status() {
	eval local pidfile=\$${name}_pidfile
	if is_locked $pidfile; then
		echo "$progname is running as pid $(cat $pidfile)."
	else
		echo "$progname is not running."
		return 1
	fi
}

command_debug() {
	eval local program=\$${name}_program
	eval local flags=\$${name}_flags
	echo "Starting $progname under debugger."
	exec $gdb_command -q -ex run $gdb_flags --args $program $flags -D -d ${1-"0"}
}
