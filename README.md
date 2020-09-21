# MeterpreterScripts

Some useful scripts you can use if you gain a meterpreter shell during penetration testing.

Recommendations
---------------

Download to your Kali linux /opt directory "/opt/MeterpreterScripts". Copy over to your /usr/share/metasploit-framework/scripts/meterpreter directory.

Description
-----------
- socks_proxy.rb: Set up an open socks proxy on port 1080 on a windows host as a service
- lower_defences.rb: Disable windows defender, the firewall, and an open powershell execution policy

Usage
-----

With a meterpreter shell open: "run #script_name#" (without the file extension)

eg: meterpreter> run socks_proxy
