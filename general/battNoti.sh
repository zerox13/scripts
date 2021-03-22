# we Can echo DBUS_SESSION_BUS_ADDRESS to see its value if this does not work!
# You need to run crontab -e
# And add the below line to make the notification work
# */4 * * * * /home/zerox/scripts/general/battNoti.sh

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
if [ $battery_level -le 25 ]
then
echo $battery_level
   env DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" /usr/bin/notify-send "Battery low" "Battery level is ${battery_level}%!"
fi
