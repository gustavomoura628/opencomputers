local gitdata = io.open('gitdata','r')
while true do
    local line = gitdata:read()
    if line == nil then break end
    local files,filee = string.find(line,'^[^ ]*')
    local file = string.sub(line,files,filee)
    local address = string.sub(line,filee+2)
    print("File: "..file..", Address: "..address)
end
gitdata:close()
