ip = nil
mytimer = tmr.create()



function scan()
    wifi.sta.scan({ hidden = 1 }, function(err,arr)
      mytimer:register(1000, tmr.ALARM_SINGLE, check_wifi)
      mytimer:start()
      if err then
        print ("Scan failed:", err)
      else
        print(string.format("%-26s","SSID"),"Channel BSSID              RSSI Auth Bandwidth")
        for i,ap in ipairs(arr) do
          print(string.format("%-32s",ap.ssid),ap.channel,ap.bssid,ap.rssi,ap.auth,ap.bandwidth)
        end
        print("-- Total APs: ", #arr)
      end
    end)
    
end

function check_wifi()
 print("check wifi...")
 if(ip==nil) then
   print("Connecting...")
 else
  print("Connected to AP!")
  print(ip)
  scan()
 end
end

mytimer:register(1000, tmr.ALARM_SINGLE, check_wifi)

wifi.sta.on("got_ip", function(ev, info)
  mytimer:register(1000, tmr.ALARM_SINGLE, check_wifi)
  ip=info.ip
  mytimer:start()
  print("NodeMCU IP config:", info.ip, "netmask", info.netmask, "gw", info.gw)
end)


wifi.start()
wifi.mode(wifi.STATION)
wifi.sta.disconnect()
scan()
station_cfg={}

station_cfg.ssid="4374"
station_cfg.pwd="12345666"
station_cfg.auto=false
wifi.sta.config(station_cfg, true);
wifi.sta.connect();




