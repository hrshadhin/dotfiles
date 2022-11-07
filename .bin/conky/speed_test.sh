#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# Repository: https://github.com/hectorm/fast-cli
# License:    MIT, https://opensource.org/licenses/MIT

set -eu
export LC_ALL=C

getFastToken() {
	fastMainURL='https://fast.com'
	fastJSPath=$(curl -sf "${fastMainURL:?}" | awk '
		match($0, /\/app-[A-Za-z0-9]+\.js/) {
			print(substr($0, RSTART, RLENGTH));
			exit;
		}
	')
	fastToken=$(curl -sf "${fastMainURL:?}${fastJSPath:?}" | awk '
		match($0, /token:"[A-Za-z0-9]+"/) {
			print(substr($0, RSTART+7, RLENGTH-8));
			exit;
		}
	')
	printf -- '%s' "${fastToken:?}"
}

getFastURLs() {
	fastToken=${1:?}; fastUseHTTPS=${2:?}; fastURLCount=${3:?}
	fastAPIURL='https://api.fast.com/netflix/speedtest/v2'
	fastAPIParams="token=${fastToken:?}&https=${fastUseHTTPS:?}&urlCount=${fastURLCount:?}"
	fastURLs=$(curl -sf "${fastAPIURL:?}?${fastAPIParams:?}" | awk '
		{while(match($0, /"url":"[^"]+"/)) {
			print(substr($0, RSTART+7, RLENGTH-8));
			$0=substr($0, RSTART+RLENGTH);
		}}
	')
	printf -- '%s' "${fastURLs:?}"
}

setFastURLRange() {
	printf -- '%s' "${1:?}" | awk -v s="${2:?}" -v e="${3:?}" 'sub("/speedtest", "/speedtest/range/"s"-"e)'
}

# Moves the cursor to the beginning of the current line, deletes it, and prints text
printr() { printf -- '\r\033[K%s' "${1:?}"; }

# Prints random bytes
randomBytes() { dd if=/dev/urandom bs="${1:?}" count=1 2>/dev/null; }

# Some arithmetic methods with AWK
add() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a + b)}'; }
sub() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a - b)}'; }
mul() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a * b)}'; }
div() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a / b)}'; }
min() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a < b ? a : b)}'; }
max() { awk -v a="${1:?}" -v b="${2:?}" 'BEGIN{printf("%0.2f\n", a > b ? a : b)}'; }
sToMs() { mul "${1:?}" 1000; }
bpsToMbps() { div "${1:?}" 125000; }

main() {
	fastToken=$(getFastToken); fastUseHTTPS=true; fastURLCount=5
	fastURLs=$(getFastURLs "${fastToken:?}" "${fastUseHTTPS:?}" "${fastURLCount:?}")

	# The API does not necessarily respond with the number of requested URLs
	fastURLCount=$(printf -- '%s' "${fastURLs:?}" | awk 'END{print(NR)}')

	# Maximum allowed range (extracted from /app-*.js)
	fastMaxPayloadBytes=26214400

	# Latency tests
	###############
	latencyCount=0; latencySum=0
	avgLatency=

	for url in $fastURLs; do
		latencyCount=$((latencyCount + 1))

		url=$(setFastURLRange "${url:?}" "0" "0")
		curLatency=$(sToMs "$(curl -sfw '%{time_connect}' -o /dev/null "${url:?}")")
		latencySum=$(add "${latencySum:?}" "${curLatency:?}")

		if [ "${latencyCount:?}" = 1 ]; then
			avgLatency=${curLatency:?}

		else
			avgLatency=$(div "${latencySum:?}" "${latencyCount:?}")
		fi
	done
	printf '%s' "├ Ping: ${avgLatency:?} ms"
	printf '\n'

	# Download speed tests
	######################

	dlSpeedCount=0; dlSpeedSum=0
	avgDlSpeed=

	for url in $fastURLs; do
		dlSpeedCount=$((dlSpeedCount + 1))

		url=$(setFastURLRange "${url:?}" "0" "${fastMaxPayloadBytes:?}")
		curDlSpeed=$(bpsToMbps "$(curl -sfw '%{speed_download}' -o /dev/null "${url:?}")")
		dlSpeedSum=$(add "${dlSpeedSum:?}" "${curDlSpeed:?}")

		if [ "${dlSpeedCount:?}" = 1 ]; then
			avgDlSpeed=${curDlSpeed:?}
		else
			avgDlSpeed=$(div "${dlSpeedSum:?}" "${dlSpeedCount:?}")
		fi
	done
	
	printf '%s' "├ Download: ${avgDlSpeed:?} Mbps"
	printf '\n'

	# # Upload speed tests
	# ####################

	ulSpeedCount=0; ulSpeedSum=0
	avgUlSpeed=

	for url in $fastURLs; do
		ulSpeedCount=$((ulSpeedCount + 1))

		url=$(setFastURLRange "${url:?}" "0" "0")
		curUlSpeed=$(bpsToMbps "$(randomBytes "${fastMaxPayloadBytes:?}" | curl -sfw '%{speed_upload}' -X POST -d @- "${url:?}")")
		ulSpeedSum=$(add "${ulSpeedSum:?}" "${curUlSpeed:?}")

		if [ "${ulSpeedCount:?}" = 1 ]; then
			avgUlSpeed=${curUlSpeed:?}
		else
			avgUlSpeed=$(div "${ulSpeedSum:?}" "${ulSpeedCount:?}")
		fi
	done

	printf '%s' "└ Upload: ${avgUlSpeed:?} Mbps"
}

main "$@"
