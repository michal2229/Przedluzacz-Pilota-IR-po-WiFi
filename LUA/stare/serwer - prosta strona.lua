-------------------------------------------------------------------------------------
-- ESP8266 API: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en
--
-------------------------------------------------------------------------------------


-- local zmienna = 'costam'

file.open("init.lua", "w")
	-- uart.setup(0,115200,8,0,1,1) 
	wifi.setmode(wifi.STATIONAP)
	cfg={}; cfg.ssid="ESP8266_" .. wifi.ap.getmac(); cfg.pwd="533525218"; wifi.ap.config(cfg)
	wifi.sta.config("UPC1143468","ADDXMHXB")
	--wifi.sta.config("ESP8266_1A-FE-34-9C-D7-70","533525218") -- ceramiczny - esp-03
	--wifi.sta.config("ESP8266_1A-FE-34-9E-0B-FE","533525218") -- pcb antena - esp-01
	wifi.sta.connect() -- bez tego tez dziala
	print(wifi.ap.getip())
	print(wifi.sta.getip())
	
	dofile("status.lua")
	dofile("przerwanieTimer2.lua")
	dofile("serwer.lua")
file.close()

----------------------------------------------
file.open("status.lua", "w")
	print("pozostalo " .. node.heap() .. "B pamieci sterty")
	l = file.list();
    for k,v in pairs(l) do
		print("name:"..k..", size:"..v)
    end
	l = nil
file.close()

----------------------------------------------
file.open("przerwanieTimer2.lua", "w")
	tmr.alarm(2, 60000, 1, function() -- przerwanie co 60s na timerze 2
		print("alarm 2...")
		polaczenie2 = net.createConnection(net.TCP, 0)  
		polaczenie2:on("receive", function(polaczenie2, payload) 
			print(payload) 
			polaczenie2:close()
			collectgarbage() -- to ciekawe...
		end) 
		polaczenie2:connect(80,"184.106.153.149")
		--polaczenie2:connect(80,"192.168.4.1")
		polaczenie2:send("GET /update?key=E0HZNU7GBSWVL2E1&field1=" .. tmr.now()/1000000 .. " \r\n") 
		polaczenie2:send("Host: http://thingspeak.com\r\n")  
		polaczenie2:send("Accept: */*\r\n") 
		polaczenie2:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n") 
		polaczenie2:send("\r\n") 
		--polaczenie2:send("GET / HTTP/1.1\r\nHost: 192.168.4.1\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
		print("sent in alarm 2...")
	end)
	
	
file.close()

----------------------------------------------
file.open("serwer.lua", "w")
	--pin1, pin2, pin3 = 8, 9, 1 --piny do ktorych sa podlaczone diody: 8 - GPIO0, 9 - GPIO2
	--pinState1, pinState2, pinState3 = gpio.HIGH, gpio.LOW, gpio.LOW 
	--gpio.mode(pin1, gpio.OUTPUT); gpio.mode(pin2, gpio.OUTPUT); gpio.mode(pin3, gpio.OUTPUT)
	--gpio.write(pin1, pinState1); gpio.write(pin2, pinState2); gpio.write(pin3, pinState3)

	serwer = net.createServer(net.TCP) 
	serwer:listen(80, function(polaczenie) 
		polaczenie:on("receive", function(polaczenie, daneOdebrane) -- GET /kod?typKodu=NEC&wartoscKodu=0x123456 
			if string.find(daneOdebrane, "favicon") == nil then -- http://www.lua.org/pil/20.2.html
				--pinState1, pinState2,  pinState3= pinState2, pinState3, pinState1
				--gpio.write(pin1, pinState1); gpio.write(pin2, pinState2); gpio.write(pin3, pinState3)
				
				wiadomoscDoAtmegi = string.sub(daneOdebrane, string.find(daneOdebrane, "GET .- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				print(wiadomoscDoAtmegi)
				print(daneOdebrane)
				
				log = tmr.now()/1000000 .. "s: " .. wiadomoscDoAtmegi .. "<br>\n"; wiadomoscDoAtmegi = nil; 
				
				apIP, staIP = "nil", "nil"
				if wifi.ap.getip()  then apIP  = wifi.ap.getip()  end; if wifi.sta.getip() then staIP = wifi.sta.getip() end
				--<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
				kodHtml = "<html><head><title>moja inzynierka</title></head>"
				.. "<body><h1> timer: " .. tmr.now() .. "</h1>"
				.. "<br> <form action=\"kod\" method=\"get\">  <input name=\"typKodu\" value=\"SAMSUNG\"> <input name=\"wartoscKodu\" value=\"0xE0E040BF\">  <button>Send</button> </form>"
				--.. "<br> led1: " .. pinState1 .. " led2: " .. pinState2 
				.. "<br> pozostalo " .. node.heap() .. "B pamieci sterty"
				.. "<br> wifi.ap.getip(): " .. apIP .. ", wifi.sta.getip(): " .. staIP .. "<br><br> log: <br><font size=\"1\" color=\"gray\">" .. log
				.. "</font> </body></html>"
				polaczenie:send("HTTP/1.1 200 OK\r\n") -- bez tego nie przejdzie
				polaczenie:send("Content-Length:" .. string.len(kodHtml) .. "\r\n")
				polaczenie:send("Connection:close\r\n\r\n")
				polaczenie:send(kodHtml); kodHtml = nil; log = nil
			else 
				polaczenie:send("nie dam ci ikonki :P")
			end
			
		end) 
		polaczenie:on("sent", function(polaczenie) 
			--polaczenie:close() 
			collectgarbage() -- to ciekawe...
		end)
	end)
file.close()

----------------------------------------------
node.restart()