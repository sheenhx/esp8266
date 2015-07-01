-- onboardingserver
-- Author: Sheen, Daniel

function sta_ap()
	print('Entering AP/Sta Mode')
	wifi.setmode(wifi.STATIONAP)
	local cfg={}
	cfg.ssid="ESP-"..node.chipid()
	print('Connect to '..cfg.ssid..' and go to http://192.168.4.1')
	cfg.pwd=nill
	wifi.ap.config(cfg)
	cfg = nil
	collectgarbage()
end
   sta_ap()
   local s = net.createServer(net.TCP)
   s:listen(
      80,
      function (conn)
		local function onReceive(connection, payload)
			collectgarbage()
			print(payload) -- for debugging
			-- parse payload and decide what to serve.
			-- print ap list
			local ap = ""
			-- aggregate the SSID and send as a select list.
			local function listap(t)
				collectgarbage()		
				for k,v in pairs(t) do
					local rssi = string.match(v, '(-%d+)')
					ap = ap ..'<option value="'..k..'">'..k..',RSSI:'..rssi..'dBm</option>'
			    end
			    conn:send(ap)
			    conn:send('</select><br><br>Password: <input type="textarea" name="key" size="25">\
				            <h1>Relayr Prototype Credentials:</h1>\
				            <p>Get the credentials from developer.relayr.io:</p>\
				            <br>Username:<input type="textarea" name="user" size="36"><br>\
				            <br>Password:<input type="textarea" name="pass" size="12"><br>\
				            <br>ClientID:<input type="textarea" name="client" size="23"><br>\
				            <br><input type="submit" value="Save"></form>\
				            </body></html>')
			end
			if string.find(payload, "GET / HTTP") then
				wifi.sta.getap(listap)
			    conn:send('HTTP/1.1 200 OK\n\n\
			    	<!DOCTYPE html><html><body>\
		                    <h1>ESP On Boarding</h1><h3>Choose your WiFi AP:</h3><p>')
			    conn:send('<form method="get" action=\"\"><p>Please refresh manually if you don\'t see your AP...</p><select name="ssid">')
			elseif string.find(payload, "ssid") then
				conn:send('HTTP/1.1 200 OK\n\n<html><body><h2>Done, storing credentials and restarting...</body></html>')
	            conn:close()
	            conn = nil
	            local ssid, key, user, pass, client = string.gmatch(payload, "ssid=(.*)&key=(.*)&user=(.*)&pass=(.*)&client=(%w+)")()
	            if string.len(key)>8 then -- TODO verify key more effectively
	                print('SSID: '..ssid..', PASS: '..key)
	                print ("Connecting..")
	                wifi.setmode(wifi.STATION)
	                wifi.sta.config(ssid, key)
	                wifi.sta.autoconnect(1)
	                --Store configuration in onb.cfg and restart
	                file.open("obcfg.lua","w+") --"w+": update mode, all previous data is erased
	                if ssid then file.writeline("SSID=\'"..ssid.."\'") end
	                if key then file.writeline("KEY=\'"..key.."\'") end
	                if user then file.writeline("USER=\'"..user.."\'") end
	                if pass then file.writeline("PASS=\'"..pass.."\'") end
	                if client then file.writeline("CLIENT=\'"..client.."\'") end
	                file.flush()
	                file.close()
	                print "Restarting..."
	                node.restart()
	            else
	                print 'Error:WIFI Password is less than 8'
	                node.restart()
	            end
			end
    	end
    	conn:on("receive", onReceive)
	end)
