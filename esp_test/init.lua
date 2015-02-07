wifi.setmode(wifi.STATIONAP)
cfg={}; 
cfg.ssid="ESP8266_" .. wifi.ap.getmac(); 
cfg.pwd="mypassword"; 
wifi.ap.config(cfg); 
--wifi.sta.config("UPC1143468", "ADDXMHXB")

dofile("kodHtml.lua")
local strsub = string.sub
local strfind = string.find
local strlen = string.len
local crtSrv = net.createServer
server = crtSrv(net.TCP) 
server:listen(80, function(socket)
     socket:on("receive", function(socket, receivedData) 
          if (receivedData ~= nil) then
               if (strfind(receivedData, "GET /kod") ~= nil) then
                    local wiadomoscDoAtmegi = strsub(receivedData, strfind(receivedData, "GET /kod.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
                    if wiadomoscDoAtmegi then print(wiadomoscDoAtmegi) end
               end
               if (strfind(receivedData, "GET /routerAP") ~= nil) then
                    local daneRoutera = strsub(receivedData, strfind(receivedData, "GET /routerAP.- ")); -- wyrazenia regularne -- http://www.lua.org/pil/20.2.html
                    local ssid = strsub(daneRoutera, strfind(receivedData, "ssid=.-&"))
                    ssid = strsub(ssid, 6, -2)
                    --print("ssid: " .. ssid)
                    local pwd = strsub(daneRoutera, strfind(receivedData, "pwd=.- "))
                    pwd = strsub(pwd, 5, -2)
                    --print("pwd: " .. pwd)
                    wifi.sta.config(ssid, pwd)
                    ssid = nil; pwd = nil
               end
               if (strfind(receivedData, "GET /ustawienia") ~= nil) then
                    dofile("kodHtmlUstawienia.lua")
                    socket:send("HTTP/1.1 200 OK\r\n")
                    socket:send("Content-Length:" .. strlen(kodHtmlUstawienia) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
                    socket:send("Connection:close\r\n\r\n")
                    socket:send(kodHtmlUstawienia); kodHtmlUstawienia = nil
               end
               if (strfind(receivedData, "HTTP") ~= nil) then
                    socket:send("HTTP/1.1 200 OK\r\n")
                    socket:send("Content-Length:" .. strlen(kodHtml) .. "\r\n") -- potrzebne do zgodnosci z bardziej 'czepialskimi' urzadzeniami
                    socket:send("Connection:close\r\n\r\n")
                    socket:send(kodHtml);
               end
          end
     end)
     socket:on("sent", function(socket) 
          collectgarbage() 
     end)
end)

