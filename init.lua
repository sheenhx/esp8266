gpio.mode(0,gpio.OUTPUT)
dofile("obcfg.lua") --load onboarding configuration

if OB == "y" then
	print(node.heap())
	dofile("relayrob.lc")
else
	dofile("mqtt.lc")
end

tmr.alarm(2, 400, 1, function()
	if wifi.sta.getip() == nil then
		gpio.write(0,1 - gpio.read(0))
	end
end) 

