if [[ -n ${SLURM_JOB_ID-} ]]; then
	case $- in
		*i* )
			tput setaf 1
			echo >&2 "Beginning slurm session on $(hostname -s)"
			tput sgr0
			;;
	esac
fi
