file.open("init.lua","w")
-- ESP8266 API: https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en
print("pozostalo " .. node.heap() .. " bajtow pamieci sterty\n") -- w tej linii zaczyna sie kod wpisywany do pliku init.lua - uruchamia sie on podczas startu modulu ESP8266
--wifi.setmode(wifi.STATIONAP)
--cfg={}; cfg.ssid="ESP8266_AP"; cfg.pwd="533525218"; wifi.ap.config(cfg)
--wifi.sta.config("UPC1143468","ADDXMHXB")
wifi.sta.connect() -- bez tego tez dziala
print(wifi.ap.getip())
print(wifi.sta.getip())

pin1, pin2 = 4, 5 --piny do ktorych sa podlaczone diody: 8 - GPIO0, 9 - GPIO2 // zmiana na 4,5
pinState1, pinState2 = gpio.HIGH, gpio.LOW
gpio.mode(pin1, gpio.OUTPUT); gpio.mode(pin2, gpio.OUTPUT)
gpio.write(pin1, pinState1); gpio.write(pin2, pinState2)

log = "" -- tu beda wpisywane informacje o danych wysylanych do Atmegi

 
tmr.alarm(3, 60000, 1, function() -- przerwanie co 60s na timerze 2
	polaczenie2 = net.createConnection(net.TCP, 0)  
	polaczenie2:on("receive", function(polaczenie2, payload) print(payload) end) 
	polaczenie2:connect(80,"184.106.153.149")
	polaczenie2:send("GET /update?key=E0HZNU7GBSWVL2E1&field1=" .. tmr.now()/1000000 .. "\r\n") 
	polaczenie2:send("Host: http://thingspeak.com\r\n")  
	polaczenie2:send("Accept: */*\r\n") 
	polaczenie2:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n") 
	polaczenie2:send("\r\n")  
end)

serwer = net.createServer(net.TCP) 
serwer:listen(80, function(polaczenie) 
	polaczenie:on("receive", function(polaczenie, daneOdebrane) -- GET /kod?typKodu=NEC&wartoscKodu=0x123456 
		if string.find(daneOdebrane, "favicon") == nil then -- http://www.lua.org/pil/20.2.html
			pinState1, pinState2 = pinState2, pinState1
			gpio.write(pin1, pinState1); gpio.write(pin2, pinState2)
			
			wiadomoscDoAtmegi = string.sub(daneOdebrane, string.find(daneOdebrane, "GET .- "));
			print(wiadomoscDoAtmegi) -- http://www.lua.org/pil/20.html
			log = log .. tmr.now()/1000000 .. "s: " .. wiadomoscDoAtmegi .. "<br>\n"; wiadomoscDoAtmegi = nil
			if string.len(log) > 340 then 
				log = string.sub(log, string.len(log) - 320) 
				_, j = string.find(log, "<br>") 
				log = string.sub(log, j + 1)
			end
			
			apIP, staIP = "nil", "nil"
			if wifi.ap.getip()  then apIP  = wifi.ap.getip()  end
			if wifi.sta.getip() then staIP = wifi.sta.getip() end
			kodHtml = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><title>kawalek mojej inzynierki</title></head>"
			.. "<body><h1> timer: " .. tmr.now() .. "</h1>"
			.. "<br> <form action=\"kod\" method=\"get\">  <input name=\"typKodu\" value=\"SAMSUNG\"> <input name=\"wartoscKodu\" value=\"0xE0E040BF\">  <button>Send</button> </form>"
			.. "<br> led1: " .. pinState1 .. " led2: " .. pinState2 
			.. "<br>     pozostalo " .. node.heap() .. " bajtow pamieci sterty"
			.. "<br>     wifi.ap.getip(): " .. apIP .. ", wifi.sta.getip(): " .. staIP .. "<br><br> log: <br><font size=\"1\" color=\"gray\">" .. log
			.. "</font> </body></html>"
			polaczenie:send("HTTP/1.1 200 OK\r\n") -- bez tego nie przejdzie
			polaczenie:send("Content-Length:" .. string.len(kodHtml) .. "\r\n")
			polaczenie:send("Connection:close\r\n\r\n")
			polaczenie:send(kodHtml); kodHtml = nil
		else 
			polaczenie:send("nie dam ci ikonki :P")
		end
	end) 
	polaczenie:on("sent", function(polaczenie) 
		--polaczenie:close() 
	end)
end) -- tu konczy sie kod wpisywany do pliku init.lua
file.close()
node.restart()