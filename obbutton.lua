-- use pin 3 as the input pulse width counter
gpio.mode(3,gpio.INT)
function pin3cb(level)
	if level == 0 then
		print("Press 2s then go to relayr OnBoarding mode")
		tmr.alarm(1, 2000, 0, function()
			if gpio.read(3) == 0 then
				file.open("obcfg.lua","w+") --"w+": update mode, all previous data is erased
				file.writeline('OB="y"')
				file.flush()
				file.close()
				print "Restarting..."
				node.restart()
			end
		end)
	end
end
gpio.trig(3, "down",pin3cb)