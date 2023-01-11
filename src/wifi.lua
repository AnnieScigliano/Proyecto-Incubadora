function scan()
    wifi.sta.scan({ hidden = 1 }, function(err,arr)
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


wifi.start()
wifi.mode(wifi.STATION)
wifi.sta.disconnect()

station_cfg={}
station_cfg.ssid="4374"
station_cfg.pwd="12345666"
station_cfg.auto=false
wifi.sta.config(station_cfg, true);
wifi.sta.connect();

local mytimer = tmr.create()

-- oo calling scan ... sometimes doesn't work when executed fast 
mytimer:register(5000, tmr.ALARM_SINGLE, scan)
mytimer:start()
mytimer = nil
