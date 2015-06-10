gpio.mode(0,gpio.OUTPUT)
CMDFILE = "mqtt.lc"   -- File that is executed after connection
-- Change the code of this function that it calls your code.
function launch()
  print("Connecting to WIFI!")
  gpio.write(0,gpio.HIGH) 
  tmr.alarm(0, 1000, 1, function()
   dofile(CMDFILE)
   if wifi.sta.getip() ~= nil then
   	tmr.stop(0)
   	print("IP Address: " .. wifi.sta.getip())
   	gpio.write(0,gpio.LOW)
   end
       end )  -- Zero as third parameter. Call once the file.
end  -- !!! Increase the delay to like 10s if developing mqtt.lua file otherwise firmware reboot loops can happen

launch()