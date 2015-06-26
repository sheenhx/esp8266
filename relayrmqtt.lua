function connmqtt()
	m = mqtt.Client(CLIENT, 120, USER, PASS)
	m:on("offline", function(con) print ("mqtt offline, if you see mutiple this message, please onboard again!")
    tmr.alarm(3, 3000, 0, function() -- leave users 3s for pressing the FLASH button
		m:connect("mqtt.relayr.io", 1883, 0)
    end)
	 end)
	m:on("connect", function(con) print ("mqtt connected")
		dofile("relayri2c.lc") -- put your own file here to execute
	 end)
	m:connect("mqtt.relayr.io", 1883, 0)
end

print("Connecting to WIFI!")
  gpio.write(0,gpio.HIGH) 
  tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() ~= nil then
   	connmqtt()
   	dofile("relayrobbutton.lc")
   	tmr.stop(0)
   	tmr.stop(2)
   	print("IP Address: " .. wifi.sta.getip())
   	gpio.write(0,gpio.LOW)
   end
       end )  -- Zero as third parameter. Call once the file.

