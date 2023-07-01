function gpa() {
	OPTIND=1
	local cur_head="$(git rev-parse --abbrev-ref HEAD)"
	local m_flag="$(date +'%y%m%d - %H:%M') @ Lab"

	push_all() {
		git pull origin "$1"
		git add -a
		git commit -m "$2"
		git push
	}

	while getopts 'm:' flag; do
		case "$flag" in
		m) m_flag="$OPTARG" ;;
		*) exit ;;
		esac
	done

	push_all "$cur_head" "$m_flag"
}

function dpa() {
	OPTIND=1
	local b_flag=shell
	local m_flag="$(date +'%y%m%d - %H:%M') @ $(hostname -s)"

	push_all() {
		local curr_head="$(vcsh ${1}-config rev-parse --abbrev-ref HEAD)"

		vcsh "${1}-config" pull origin "$curr_head"
		vcsh "${1}-config" add -u
		vcsh "${1}-config" commit -m "$2"
		vcsh "${1}-config" push
	}

	while getopts 'm:b:' flag; do
		case "$flag" in
		m) m_flag="$OPTARG" ;;
		b) b_flag="$OPTARG" ;;
		*) exit ;;
		esac
	done

	push_all "$b_flag" "$m_flag"
}

function ldapdecode() {
	perl -MMIME::Base64 -n -00 -e \
		's/\n +//g;s/(?::: )(\S+)/": " . decode_base64($1)/eg;print'
}
