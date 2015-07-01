gpio.mode(0,gpio.OUTPUT)
dofile("obcfg.lua") --load onboarding configuration

if OB == "y" then -- check the On boarding flag
	print(node.heap())
	dofile("relayrob.lc")
else
	dofile("relayrmqtt.lc")
end

tmr.alarm(2, 400, 1, function()
	if wifi.sta.getip() == nil then
		gpio.write(0,1 - gpio.read(0)) --toggle the LED if WIFI is not connected
	end
end) 

