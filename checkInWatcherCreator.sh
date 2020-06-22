#!/bin/zsh

## Run this script on your endpoints to prepare them for instantaneous policy execution via configuration profile
## This script will create and load the checkinwatcher LaunchDaemon and script called by the LaunchDaemon to actually execute the check-in

## Set your org name here (no spaces)
orgName=""

#### DO NOT EDIT BELOW THIS LINE ####

## Make the directory structure for your org if it doesn't already exist
mkdir -p "/Library/Application Support/$orgName"

## Write out the script
cat << EOF > "/Library/Application Support/$orgName/checkin.sh"
#!/bin/bash
shopt -s extglob

if [[ -e "/Library/Managed Preferences/com.$orgName.checkin.plist" ]]; then
	policyid=\$(defaults read "/Library/Managed Preferences/com.$orgName.checkin.plist" policyid)
	case "\$policyid" in
		+([[:digit:]]) )
			/usr/local/bin/jamf policy -id \$policyid
			;;
		default)
			/usr/local/bin/jamf policy
			;;
		*)
			;;
	esac

/usr/local/bin/jamf recon -room "none"

fi
EOF

## Make script executable
chmod +x "/Library/Application Support/$orgName/checkin.sh"

## Write out the LaunchDaemon
cat << EOF > "/Library/LaunchDaemons/com.$orgName.checkinwatcher.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.$orgName.checkinwatcher</string>
	<key>ProgramArguments</key>
	<array>
		<string>sh</string>
		<string>/Library/Application Support/$orgName/checkin.sh</string>
	</array>
	<key>WatchPaths</key>
	<array>
		<string>/Library/Managed Preferences/com.$orgName.checkin.plist</string>
	</array>
</dict>
</plist>
EOF

## Set permissions and load the LaunchDaemon
chown root:wheel /Library/LaunchDaemons/com.$orgName.checkinwatcher.plist
chmod 644 /Library/LaunchDaemons/com.$orgName.checkinwatcher.plist
launchctl load -w /Library/LaunchDaemons/com.$orgName.checkinwatcher.plist