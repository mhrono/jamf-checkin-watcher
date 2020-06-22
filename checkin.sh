#!/bin/bash
shopt -s extglob

if [[ -e "/Library/Managed Preferences/com.$orgName.checkin.plist" ]]; then
	policyid=$(defaults read "/Library/Managed Preferences/com.$orgName.checkin.plist" policyid)
	case "$policyid" in
		+([[:digit:]]) )
			/usr/local/bin/jamf policy -id $policyid
			;;
		default)
			/usr/local/bin/jamf policy
			;;
		*)
			;;
	esac

/usr/local/bin/jamf recon -room "none"

fi
