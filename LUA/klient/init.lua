wifi.setmode(wifi.STATION)
wifi.sta.config("ESP8266_1A-FE-34-9E-0B-FE","mypassword")
wifi.sta.connect()

function sendMessage(wiadomosc, zrodlo) 
    if (wifi.sta.getip() ~= nil) and (wiadomosc ~= nil) then 		
		polaczenie = net.createConnection(net.TCP, 0)  
		polaczenie:on("receive", function(polaczenie, receivedData)
			polaczenie:close(); polaczenie = nil
		end) 
		polaczenie:on("connection", function(polaczenie) 
			polaczenie:send(wiadomosc) 
		end )
		polaczenie:connect(80, "192.168.4.1")
	else
		print("brak polaczenia...")
	end
    collectgarbage() 
end
