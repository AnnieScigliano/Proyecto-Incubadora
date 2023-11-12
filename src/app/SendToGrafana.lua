-- ! Modules 
require('credentials')

-- ! Local Variables 
local token_grafana = "token:e98697797a6a592e6c886277041e6b95"
local url = SERVER


------------------------------------------------------------------------------------
-- ! @function create_grafana_message    to read the data from the bme sensor 
-- !                                     and send it by post request 
------------------------------------------------------------------------------------

function create_grafana_message(temperature,humidity,pressure,INICIALES,time)
	local data = "mediciones,device=" .. INICIALES .. " temp=" ..
									temperature .. ",hum=" .. humidity .. ",press=" .. pressure .." " .. time
	print(data)
	return data
end


------------------------------------------------------------------------------------
-- ! @function send_data_grafana         to read the data from the bme sensor 
-- !                                     and send it by post request 
------------------------------------------------------------------------------------

function send_data_grafana(temperature,humidity,pressure,INICIALES)

		--todo: add time source 
		local data = create_grafana_message(temperature,humidity,pressure,INICIALES, string.format("%.0f", ((time.get()) *1000000000))) 
		local headers = {
				["Content-Type"] = "text/plain",
				["Authorization"] = "Basic " .. token_grafana
		}
		http.post(url, {headers = headers}, data,
			
			function(code_return, data_return) print("HTTP POST return " .. code_return)
			
		end) -- * post function end
end -- * send_data_grafana end

------------------------------------------------------------------------------------
-- ! @function send_data_uptime         to read the uptime from the esp32
-- !                                     and send it by post request 
------------------------------------------------------------------------------------

function send_data_uptime()
    local uptime = node.uptime()
    local data = "uptime,device=cto-bme280 value=" .. tonumber(uptime)
    local headers = {
        ["Content-Type"] = "text/plain",
        ["Authorization"] = "Basic " .. token_grafana
    }

    http.post(url, { headers = headers }, data,
        function(code_return, data_return)
            print("HTTP POST return " .. code_return)
        end)
end

------------------------------------------------------------------------------------
-- ! @function send_data_heap         to read the heap from the esp32
-- !                                     and send it by post request 
------------------------------------------------------------------------------------

function send_data_heap()
local heap = node.heap()
local data = "heap,device=cto-bme280 value=" .. tonumber(heap)
local headers = {
	["Content-Type"] = "text/plain",
	["Authorization"] = "Basic " .. token_grafana
}

http.post(url, { headers = headers }, data,
	function(code_return, data_return)
			print("HTTP POST return " .. code_return)
	end)
end 

