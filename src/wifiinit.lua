-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile("credentials.lua")
ONLINE = 0
IPADD= nil
IPGW= nil

function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        -- the actual application is stored in 'application.lua'
        dofile("application.lua")
    end
end

function configwifi()
    print("Running")
    wifi.sta.on("got_ip", wifi_got_ip_event)
    wifi.sta.on("connected", wifi_connect_event)
    wifi.sta.on("disconnected", wifi_disconnect_event)
    wifi.mode(wifi.STATION)
    wifi.start()
    station_cfg={}
    station_cfg.ssid=SSID
    station_cfg.pwd=PASSWORD
    wifi.sta.config(station_cfg)
    wifi.sta.connect()
end


-- Define WiFi station event callbacks 
wifi_connect_event = function(ev, info)
  print("Connection to AP("..info.ssid..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end  
end

wifi_got_ip_event = function(ev, info)
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().    
  ONLINE = 1
  IPADD=info.ip
  IPGW= info.gw
  print("NodeMCU IP config:", info.ip, "netmask", info.netmask, "gw", info.gw)
  print("Startup will resume momentarily, you have 3 seconds to abort.")
  print("Waiting...")
  
end

wifi_disconnect_event = function(ev, info)
  ONLINE = 0
  print(info)
  print(info.reason)
  print(info.ssid)
  if info.reason == 8 then 
    --the station has disassociated from a previously connected AP
    return 
  end
  -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
  local total_tries = 10
  print("\nWiFi connection to AP(".. info.ssid ..") has failed!")

  --There are many possible disconnect reasons, the following iterates through 
  --the list and returns the string corresponding to the disconnect reason.

      print("Disconnect reason: "..info.reason)


  if disconnect_ct == nil then 
    disconnect_ct = 1 
  else
    disconnect_ct = disconnect_ct + 1 
  end
  if disconnect_ct < total_tries then 
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    mytimer = tmr.create()
    mytimer:register(10000, tmr.ALARM_SINGLE, configwifi)
    mytimer:start()
    disconnect_ct = nil  
  end
end

configwifi()
print("Connecting to WiFi access point...")

