file.open("init.lua","w")

--print(wifi.sta.getip())
--0.0.0.0
--wifi.setmode(wifi.STATION)
--wifi.sta.config("UPC1143468","ADDXMHXB")
--print(wifi.sta.getip())
--192.168.18.110
	
kodHtml = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head>"
.. "<body><h1> timer: " .. tmr.now() .. "</h1>"
.. "<br> <form action=\"asd\" method=\"get\">  <input name=\"msg1\" value=\"hello\"> <button>Send</button> </form>"
.. "<form action=\"qwe\" method=\"get\">  <input name=\"msg2\" value=\"bye\">  <button>Send</button> </form><br>"
.. "</body></html>"


pin1, pin2 = 8, 9
pinState1, pinState2 = gpio.HIGH, gpio.HIGH
gpio.mode(pin1, gpio.OUTPUT); gpio.mode(pin2, gpio.OUTPUT)

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
	conn:on("receive",function(conn,payload) 
		conn:send(kodHtml)

		if string.find(payload, "favicon") == nil then
			i, j = string.find(payload, "hello")
			k, l = string.find(payload, "bye")
		
			if j~=nil then pinState1 = gpio.LOW; print(string.sub(payload, i, j)) else pinState1 = gpio.HIGH end
			if l~=nil then pinState2 = gpio.LOW; print(string.sub(payload, k, l)) else pinState2 = gpio.HIGH end
			gpio.write(pin1, pinState1); gpio.write(pin2, pinState2)
		end
	end) 
	conn:on("sent",function(conn) 
		conn:close() 
	end)
end)


file.close()
node.restart()