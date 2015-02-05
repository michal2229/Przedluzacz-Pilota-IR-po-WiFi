wifi.setmode(wifi.STATIONAP)
cfg={}; 
cfg.ssid="ESP8266_" .. wifi.ap.getmac(); 
cfg.pwd="mypassword"; 
wifi.ap.config(cfg); 
--wifi.sta.config("UPC1143468", "ADDXMHXB")

dofile("kodHtml.lua")

server = net.createServer(net.TCP) 
server:listen(80, function(conn)
	conn:on("receive", function(conn, receivedData) 
		if (receivedData ~= nil) then
			if (string.find(receivedData, "GET /kod") ~= nil) then
				wiadomoscDoAtmegi = string.sub(receivedData, string.find(receivedData, "GET /kod.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				if wiadomoscDoAtmegi then print(wiadomoscDoAtmegi) end
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
			end
			if (string.find(receivedData, "GET /ustawienia") ~= nil) then
				dofile("kodHtmlUstawienia.lua")
				conn:send("HTTP/1.1 200 OK\r\n")
				conn:send("Content-Length:" .. string.len(kodHtmlUstawienia) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
				conn:send("Connection:close\r\n\r\n")
				conn:send(kodHtmlUstawienia); kodHtmlUstawienia = nil
			end
			if (string.find(receivedData, "HTTP") ~= nil) then
				conn:send("HTTP/1.1 200 OK\r\n")
				conn:send("Content-Length:" .. string.len(kodHtml) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
				conn:send("Connection:close\r\n\r\n")
				conn:send(kodHtml);
			end
		end
	end) 
	conn:on("sent", function(conn) 
          collectgarbage() 
	end)
end)

