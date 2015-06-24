function connmqtt()
	m = mqtt.Client("sheen", 120)
	m:on("offline", function(con) print ("offline")
		m:connect("192.168.7.1", 1883, 0)
	 end)
	m:on("connect", function(con) print ("mqtt connected")
		m:publish("/relayr","sheen@relayr - booted",0,0)
		dofile("i2c.lc") -- put your own file here to execute
	 end)
	m:connect("192.168.7.1", 1883, 0)
end

print("Connecting to WIFI!")
  gpio.write(0,gpio.HIGH) 
  tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() ~= nil then
   	connmqtt()
   	dofile("obbutton.lc")
   	tmr.stop(0)
   	tmr.stop(2)
   	print("IP Address: " .. wifi.sta.getip())
   	gpio.write(0,gpio.LOW)
   end
       end )  -- Zero as third parameter. Call once the file.

