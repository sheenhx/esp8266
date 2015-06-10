local luaFile = {"pub.lua"}
for i, f in ipairs(luaFile) do
     if file.open(f) then
      file.close()
       print("Compile File:"..f)
      node.compile(f)
  print("Remove File:"..f)
       file.remove(f)
     end
end
    
    
dofile("pub.lc");