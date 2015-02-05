if (wifi.sta.getip() ~= nil) then staIP = wifi.sta.getip() else staIP = "nil" end
                    
kodHtmlUstawienia = "<html><head><title>Michal Bokiniec</title></head>\n"
.."<body'>\n"
.."STA: " .. staIP .. "<br>\n"
.."HEAP: " .. node.heap() .. "B<br>\n"
.."ChipID: " .. node.chipid() .. "<br>\n"
.."STA MAC: " .. wifi.sta.getmac() .. "<br>\n"
.."AP MAC: " .. wifi.ap.getmac() .. "<br><br>\n"

.."Ustawienia routera: <br><form action='routerAP' method='get'>\n"
.."<input name='ssid' value='ssid'>\n"
.."<input name='pwd' value='haslo'>\n"
.."<button id='wyslij'>OK</button>\n"
.."</form>\n"

.."</body>\n"
.."</html>\n"