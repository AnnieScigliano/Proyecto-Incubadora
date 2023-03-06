
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
    end -- end if 
  end) -- end function
  
end -- end function

scan()