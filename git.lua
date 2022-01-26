local internet = require("internet")

local gitdata = io.open('gitdata','r')
while true do
    local line = gitdata:read()
    if line == nil then break end
    local files,filee = string.find(line,'^[^ ]*')
    local file = string.sub(line,files,filee)
    local address = string.sub(line,filee+2)
    print("File: "..file..", Address: "..address)
    local fileHandle = io.open(file,"w")
    local webHandle = internet.request(address)
    local webText = ""
    for chunk in webHandle do webText = webText..chunk end
    --print("Response = \n"..webText)
    fileHandle:close()
end
gitdata:close()

print("Done!")
print("I dont understand")
