nmap-welcome-home
=================

A quick set of scripts to recognise when specific (ie: mobile) devices join your WLAN and fire events

*/5 * * * * nmap -sS -oX /home/clockwerx/nmap-welcome-home/scan.xml 192.168.1.* 
 > /dev/null
