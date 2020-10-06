#!/bin/bash
# DWM status script
# Colors: 1 = normal, 2 = selected, 3 = urgent

dte(){
  dte="$(date +"%a %b %d %Y, %H:%M:%S")"
  echo -e "$dte"
}

bat(){
  perc="$(awk 'NR==1 {print +$4}' <(acpi -V))"
  online="$(grep "on-line" <(acpi -V))"
  if [ -z "$online" ] && [ "$perc" -gt "50" ]; then
    echo -e "$perc%"
    elif [ -z "$online" ] && [ "$perc" -le "49" ]; then
    echo -e "$perc%"
    elif [ -z "$online" ] && [ "$perc" -le "15" ]; then
    echo -e "$perc%"
    elif [ -z "$online" ] && [ "$perc" -le "5" ]; then
    echo -e "$perc%"
  else
    echo -e "$perc%"
  fi
}

vol(){
  mute=`amixer get Master | grep "t: Playback" | awk '{print $6}'`
  if [[ "$mute" == *"[on]" ]]
  then
    vol=`amixer get Master | grep -m 1 -o '[0-9][0-9]*%'`
    echo -e "$vol"
  else
    echo -e ""
  fi
}

net(){
  essid=`iwgetid | awk -F ':' '{print $2}' | sed -e 's/"//g'`
  signal=`awk '/wlp2s0:/ {print $3}' /proc/net/wireless |sed -e 's/\.//g'`
  perc=`echo $[$signal *100 /70]`
  echo -e "$essid $perc"
}

disk(){
  #diskinfo=`df -h | awk '/^\/dev\//{print $6 "=" $3 "/" $2}'`
  #root=`df -h | grep rootfs | awk '{print $3"/"$2":"$5}'`
  root=`df -h | grep \/dev\/sda3 | awk '{print $3}'`
  #windows=`df -h | grep media | awk '{print $3"/"$2":"$5}'`
  echo -e "$root"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d MiB/%d MiB\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "$mem"
}

cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  temp=`acpi -t | awk '/Thermal 0/ {printf("%d", $4)}'`
  echo -e "$cpu% | $temp°C"
}

backlight(){
  backlight=`cat /sys/class/backlight/intel_backlight/brightness | awk '{printf("%d\n",$1 + 0.5)}'`
  echo -e "$backlight%"
}

# Pipe to status bar
while true ; do
  xsetroot -name "$(cpu) | $(mem) | $(disk) | $(net) | $(vol) | $(bat) | $(backlight) | $(dte)"
  sleep 1s
done &
