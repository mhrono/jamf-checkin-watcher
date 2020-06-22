# Jamf Check-In Watcher

By default, jamf-enrolled devices can only check in for new policies as frequently as every 15 minutes. If you create a policy that you want a device (or group of devices) to run immediately, you're mostly out of luck...until now!

This workflow will allow you to use a configuration profile (delivered instantly via APNS) to initiate a check-in. You can either trigger a normal check-in (like running `sudo jamf policy`), or specifiy a policy ID number to call explicitly.

See the wiki for more info on how it works!
