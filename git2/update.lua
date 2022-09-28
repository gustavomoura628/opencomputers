--OpenComputers Version
local function getWord(line, n)
    local byte = 1
    local i=1
    local j=1
    local word = ""
    for j = 1, n, 1
    do
        while true 
        do
            byte = string.byte(line,i)
            i = i + 1
            if byte == nil then break end
            if string.char(byte) == ' ' then break end
            word = word .. string.char(byte)
        end
        if(j==n)
        then
            return word
        end
        word = ""
        if byte == nil then break end
    end
    return nil
end
--aa
local DATAFILEPATH = "updateData.lua"
local datafile = fs.open(DATAFILEPATH,"r")
while true do
    local line = datafile.readLine()
    if(line == nil)then break end
    local FILENAME = getWord(line, 1)
    local IXIOID = getWord(line, 2)
    print(FILENAME.."  id: "..IXIOID)
    res, err = http.get('http://ix.io/'..IXIOID)
    if not res then error(err) end
    --teste
    local code = res.readAll()
     
    if not(fs.exists(FILENAME))
    then
        local newFile = fs.open(FILENAME, 'w')
        newFile.close()
    end
    
    local readFile = fs.open(FILENAME, 'r')
    local oldCode = readFile.readAll()
    readFile.close()
     
    local file = fs.open(FILENAME, 'w')
    if oldCode == code
    then
        file.write(oldCode)
        print('NO CHANGES MADE - Same Code')
    else
        file.write(code)
        print('WRITING UPDATE')
        byteDiff = string.len(code) - string.len(oldCode)
     
        if byteDiff >= 0
        then
            print(tostring(math.abs(byteDiff)) .. ' bytes added')
        else
            print(tostring(math.abs(byteDiff)) .. ' bytes removed')
        end
    end
    res.close()
    file.close()
    print()
end
datafile.close()
