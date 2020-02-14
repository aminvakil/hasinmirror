#!/bin/sh
set -e
DEFAULT_DOWNLOAD_URL="http://mirror.saminserver.com"
if [ -z "$DOWNLOAD_URL" ]; then
	DOWNLOAD_URL=$DEFAULT_DOWNLOAD_URL
fi
command_exists() {
        command -v "$@" > /dev/null 2>&1
}
user="$(id -un 2>/dev/null || true)"
get_distribution() {
	lsb_dist=""
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	echo "$lsb_dist"
}
do_change() {
	user="$(id -un 2>/dev/null || true)"
	sh_c='sh -c'
	if [ "$user" != 'root' ]; then
		if command_exists sudo; then
			sh_c='sudo -E sh -c'
		elif command_exists su; then
				sh_c='su -c'
		else
			cat >&2 <<-'EOF'
			Error: this installer needs the ability to run commands as root.
			We are unable to find either "sudo" or "su" available to make this happen.
			EOF
			exit 1
		fi
	fi
	lsb_dist=$( get_distribution )
	lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"
	case "$lsb_dist" in
		alpine)
			dist_version="$(sed -r 's/([^.]+.[^.]*).*/\1/' /etc/alpine-release)"
		;;
		ubuntu)
			if command_exists lsb_release; then
				dist_version="$(lsb_release --codename | cut -f2)"
			fi
			if [ -z "$dist_version" ] && [ -r /etc/lsb-release ]; then
				dist_version="$(. /etc/lsb-release && echo "$DISTRIB_CODENAME")"
			fi
		;;
		debian)
			dist_version="$(sed 's/\/.*//' /etc/debian_version | sed 's/\..*//')"
			case "$dist_version" in
				10)
					dist_version="buster"
				;;
				9)
					dist_version="stretch"
				;;
				8)
					dist_version="jessie"
				;;
			esac
		;;
		centos)
			if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
				dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
			fi
		;;
	esac
	case "$lsb_dist" in
		alpine)
			$sh_c "mv /etc/apk/repositories_saminback /etc/apk/repositories"
			$sh_c 'apk update'
			echo "Samin Mirrors removed successfully!"
			exit 0
			;;
		ubuntu)
			$sh_c "mv /etc/apt/sources.list_saminback /etc/apt/sources.list"
			$sh_c 'apt-get update'
			echo "Samin Mirrors removed successfully!"
			exit 0
			;;
		debian)
			$sh_c "mv /etc/apt/sources.list_saminback /etc/apt/sources.list"
			$sh_c 'apt-get update'
			echo "Samin Mirrors removed successfully!"
			exit 0
			;;
		centos)
			yum_repo="$DOWNLOAD_URL/$lsb_dist-$repo_file"
			repos="base updates extras"
			echo "Installing requirements for managing yum repos..."
                        if [ "$lsb_dist" = "fedora" ]; then
                                pkg_manager="dnf"
                                config_manager="dnf config-manager"
                                pre_reqs="dnf-plugins-core"
                                pkg_suffix="fc$dist_version"
                        else
                                pkg_manager="yum"
                                config_manager="yum-config-manager"
                                pre_reqs="yum-utils"
                                pkg_suffix="el"
                        fi			
                        $sh_c "$pkg_manager install -y -q $pre_reqs"
			echo "Enabling default repos..."
                        $sh_c "$config_manager --enable $repos"
			echo "Removing Samin Repos..."
			$sh_c "$config_manager --del-repo $yum_repo"
			echo "Updating metadata from fresh repos..."
			$sh_c "$pkg_manager makecache"
			echo "Samin Mirrors removed successfully!"
			exit 0
			;;
		*)
			echo
			echo "ERROR: Unsupported distribution '$lsb_dist'"
			echo
			exit 1
			;;
	esac
	exit 1
}
do_change
