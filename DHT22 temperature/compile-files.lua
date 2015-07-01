--use this lua script to compile all the relayr lua files
local luaFile= {}

local l = file.list();
    for k,v in pairs(l) do
      luaFile[#luaFile+1] = string.match(k, "(relayr(.*).lua)")
    end

print(table.concat( luaFile, "\n"))

for i, f in ipairs(luaFile) do

     if file.open(f) then

      file.close()

       print("Compile File:"..f)

      node.compile(f)

  print("Remove File:"..f)

       file.remove(f)

     end

end

    
