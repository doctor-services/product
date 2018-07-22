#!/bin/bash
set -eo pipefail
shopt -s nullglob
# if command starts with an option, prepend imaginary
if [ "${1:0:1}" = '-' ]; then
	set -- /go/bin/product-server "$@"
fi

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env 'MONGO_HOST'
if [ -z "$MONGO_HOST" ]; then
			echo >&2 'error: Mongo host has not set yet '
			echo >&2 '  You need to specify queue server hostname or ip'
			exit 1
fi

file_env 'MONGO_PORT'
if [ -z "$MONGO_PORT" ]; then
			echo >&2 'error: Mongo port has not set yet '
			echo >&2 '  You need to specify queue pass'
			exit 1
fi
file_env 'MONGO_PASS'
if [ -z "$MONGO_PASS" ]; then
			echo >&2 'error: Mongo password has not set yet '
			echo >&2 '  You need to specify queue pass'
			exit 1
fi
file_env 'MONGO_USER'
if [ -z "$MONGO_USER" ]; then
			echo >&2 'error: Mongo username has not set yet '
			echo >&2 '  You need to specify queue pass'
			exit 1
fi
file_env 'MONGO_DB'
if [ -z "$MONGO_DB" ]; then
			echo >&2 'error: Mongo database name has not set yet '
			echo >&2 '  You need to specify queue pass'
			exit 1
fi
file_env 'MONGO_AUTH_DB'
if [ -z "$MONGO_AUTH_DB" ]; then
			echo >&2 'error: Mongo authentication database name has not set yet '
			echo >&2 '  You need to specify queue pass'
			exit 1
fi

# file_env 'USERNAME'
# file_env 'PASSWORD'

exec "$@"
