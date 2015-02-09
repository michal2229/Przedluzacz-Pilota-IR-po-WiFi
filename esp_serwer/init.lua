uart.setup( 0, 38400, 8, 0, 1, 1 ) -- konfiguracja UART - 38400 bodów, echo
wifi.setmode(wifi.STATIONAP) -- ustawienie urzadzenia jako punkt dostepowy i jednoczesnie jako urzadzenie laczace sie z routerem
cfg={}; -- zmienna konfiguracyjna punktu dostepowego urzadzenia
cfg.ssid="ESP8266_" .. wifi.ap.getmac(); -- tworzenie identyfikatora sieci punktu dostepowego
cfg.pwd="mypassword"; -- tworzenie hasla punktu dostepowego
wifi.ap.config(cfg); cfg = nil -- konfiguracja punktu dostepowego urzadzenia
collectgarbage() -- zwalnianie pamieci

server = net.createServer(net.TCP, 1) -- tworzenie obiektu serwera TCP
server:listen(80, function(socket) -- definicja portu nasluchiwania serwera oraz funkcji, ktora ma byc wywolywana w przypadku nawiazania polaczenia
	socket:on("receive", function(socket, receivedData) -- w przypadku odebrania danych
		collectgarbage() -- zwolnij pamiec z niepotrzebnych danych
		 --print(node.heap())
		if (receivedData ~= nil) then -- jesli dane odebrane nie sa pusta zmienna
			if (string.find(receivedData, "GET /kod") ~= nil) then -- jesli dane zawieraja dany ciag znakow
				wiadomoscDoAtmegi = string.sub(receivedData, string.find(receivedData, "GET /kod.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				if (wiadomoscDoAtmegi ~= nil) then print(wiadomoscDoAtmegi) end -- jesli wiadomosc do atmegi nie jest pusta, wyslij wiadomosc do atmegi
				wiadomoscDoAtmegi = nil; collectgarbage() -- zwolnij pamiec z niepotrzebnych danych				 
			end
			if (string.find(receivedData, "GET /routerAP") ~= nil) then -- jesli dane zawieraja dany ciag znakow
				daneRoutera = string.sub(receivedData, string.find(receivedData, "GET /routerAP.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
				ssid = string.sub(daneRoutera, string.find(receivedData, "ssid=.-&")) -- wydobywanie danych routera z wiadomosci
				ssid = string.sub(ssid, 6, -2)
				--print("ssid: " .. ssid)
				pwd = string.sub(daneRoutera, string.find(receivedData, "pwd=.- ")) -- wydobywanie hasla do routera
				pwd = string.sub(pwd, 5, -2)
				--print("pwd: " .. pwd)
				wifi.sta.config(ssid, pwd) -- laczenie z routerem
				ssid = nil; pwd = nil; collectgarbage() -- zwolnij pamiec z niepotrzebnych danych 
			end
			if (string.find(receivedData, "GET /ustawienia") ~= nil) then -- jesli dane zawieraja dany ciag znakow
				dofile("kodHtmlUstawienia.lua") -- generowanie kodu html
				socket:send("HTTP/1.1 200 OK\r\n") -- wysylanie wiadomosci http
				socket:send("Content-Length:" .. string.len(kodHtmlUstawienia) .. "\r\n")
				socket:send("Connection:close\r\n\r\n")
				socket:send(kodHtmlUstawienia); kodHtmlUstawienia = nil
			else 
				if (string.find(receivedData, "HTTP") ~= nil) then -- jesli dane zawieraja dany ciag znakow
					dofile("kodHtml.lua") -- generowanie kodu html
					socket:send("HTTP/1.1 200 OK\r\n") -- wysylanie wiadomosci http
					socket:send("Content-Length:" .. string.len(kodHtml) .. "\r\n")
					socket:send("Connection:close\r\n\r\n")
					socket:send(kodHtml); kodHtml = nil
				end
			end
		end
		receivedData = nil; collectgarbage() -- zwolnij pamiec z niepotrzebnych danych 
	end)
	socket:on("sent", function(socket) -- w przypadku wyslania wiadomosci przez Wi-Fi
		socket:close() -- zamknij gniazdo polaczenia
		socket = nil; collectgarbage() -- zwolnij pamiec z niepotrzebnych danych 
	end)
end)

