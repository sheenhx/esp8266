pin = 1 -- GPIO5 is connected to DHT22
local status,temp,humi,temp_decimial,humi_decimial
function readDHT()
	status,temp,humi,temp_decimial,humi_decimial = dht.read(pin)
	if( status == dht.OK ) then
	  -- Integer firmware using this example
	  print(     
	    string.format(
	      "DHT Temperature:%d.%03d;Humidity:%d.%03d\r\n",
	      math.floor(temp),
	      temp_decimial,
	      math.floor(humi),
	      humi_decimial
	    )
	  )
	end

end
 

 tmr.alarm(0, relayrfq or 500, 1, function()  --check the register using the received parameter
 	readDHT()
      m:publish("/v1/"..USER.."/data", ' [{"meaning":"temperature","value": '..math.floor(temp)..'.'..temp_decimial..'},{"meaning":"humidity","value": '..math.floor(humi)..'.'..humi_decimial..'}]',0,0)

   end)