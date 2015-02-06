uart.setup( 0, 38400, 8, 0, 1, 1 )
wifi.setmode(wifi.STATIONAP)
cfg={}; 
cfg.ssid="ESP8266_" .. wifi.ap.getmac(); 
cfg.pwd="mypassword"; 
wifi.ap.config(cfg); cfg = nil
collectgarbage() 

server = net.createServer(net.TCP, 1) 
server:listen(80, function(socket)
	socket:on("receive", function(socket, receivedData) 
          collectgarbage()
          --print(node.heap())
          --print("l")
		if (receivedData ~= nil) then
			if (string.find(receivedData, "GET /kod") ~= nil) then
				wiadomoscDoAtmegi = string.sub(receivedData, string.find(receivedData, "GET /kod.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				if (wiadomoscDoAtmegi ~= nil) then print(wiadomoscDoAtmegi) end
                    wiadomoscDoAtmegi = nil
                    collectgarbage()                     
			end
			if (string.find(receivedData, "GET /routerAP") ~= nil) then
				daneRoutera = string.sub(receivedData, string.find(receivedData, "GET /routerAP.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				ssid = string.sub(daneRoutera, string.find(receivedData, "ssid=.-&"))
				ssid = string.sub(ssid, 6, -2)
				--print("ssid: " .. ssid)
				pwd = string.sub(daneRoutera, string.find(receivedData, "pwd=.- "))
				pwd = string.sub(pwd, 5, -2)
				--print("pwd: " .. pwd)
				wifi.sta.config(ssid, pwd)
				ssid = nil; pwd = nil
                    collectgarbage() 
			end
			if (string.find(receivedData, "GET /ustawienia") ~= nil) then
				dofile("kodHtmlUstawienia.lua")
				socket:send("HTTP/1.1 200 OK\r\n")
				socket:send("Content-Length:" .. string.len(kodHtmlUstawienia) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
				socket:send("Connection:close\r\n\r\n")
				socket:send(kodHtmlUstawienia); kodHtmlUstawienia = nil
			else 
     		     if (string.find(receivedData, "HTTP") ~= nil) then
          			dofile("kodHtml.lua")
          			socket:send("HTTP/1.1 200 OK\r\n")
          			socket:send("Content-Length:" .. string.len(kodHtml) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
          			socket:send("Connection:close\r\n\r\n")
          			socket:send(kodHtml); kodHtml = nil
     			end
               end
		end
          receivedData = nil
          collectgarbage() 
	end)
	socket:on("sent", function(socket) 
          --print("m")
          socket:close()
          socket = nil
          collectgarbage() 
	end)
end)

