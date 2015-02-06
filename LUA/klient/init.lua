uart.setup( 0, 38400, 8, 0, 1, 1 )
wifi.setmode(wifi.STATION)
wifi.sta.config("ESP8266_1A-FE-34-9E-0B-FE","mypassword")
wifi.sta.connect()

function sendMessage(wiadomosc, zrodlo) 
    if (wifi.sta.getip() ~= nil) and (wiadomosc ~= nil) then 		
		socket = net.createConnection(net.TCP, 0)
		socket:on("receive", function(socket, receivedData)
			
		end) 
		socket:on("connection", function(socket) 
			socket:send(wiadomosc) 
               socket:close(); socket = nil
		end)
		socket:connect(80, "192.168.4.1")
	else
		print("brak polaczenia...")
          wifi.sta.connect()
	end
    collectgarbage() 
end
