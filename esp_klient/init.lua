uart.setup( 0, 38400, 8, 0, 1, 0 ) -- ustawienie polaczenia UART na 38400 bodow, brak echa
wifi.setmode(wifi.STATION) -- ustawienie urzadzenia jako urzadzenie laczace sie do punktu dostepowego
wifi.sta.config("ESP8266_1A-FE-34-9E-0B-FE","mypassword") -- ustawienie punktu dostepowedo, do ktorego laczy sie urzadzenie
wifi.sta.connect() -- laczenie z punktemdostepowym

function sendMessage(wiadomosc) -- definicja funkcji wysolywanej przez mikrokontroler
    if (wifi.sta.getip() ~= nil) and (wiadomosc ~= nil) then -- jesli jest polaczenie z punktem dostepowym i wiadomosc nie jest pusta
		socket = net.createConnection(net.TCP, 0) -- utworzenie gniazda polaczenia za pomoca TCP
		socket:on("receive", function(socket, receivedData) -- w przypadku odebrania wiadomosci od serwera
			socket:close(); socket = nil
			collectgarbage()
		end) 
		socket:on("connection", function(socket)  -- w przypadku nawiazania polaczenia
			socket:send(wiadomosc)  -- wyslij wiadomosc przez gniazdo
			socket:close(); socket = nil -- zamknij gniazdo, zwolnij pamiec
			collectgarbage()
		end)
		socket:connect(80, "192.168.4.1") -- polacz z urzadzeniem serwera Wi-Fi
	else -- w innym przypadku
		print("brak polaczenia...") -- wyslij przez UART komunikat o braku polaczenia
		wifi.sta.connect() -- probuj ponownie zawiazac polaczenie
	end
    collectgarbage() -- zwolnij pamiec z niepotrzebnych danych
end
