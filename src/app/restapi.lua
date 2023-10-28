local restapi = {
    incubator = nil
}

-------------------------------------
-- ! @function max_temp   print the current temperature
--
-- !	@param req  				server request
-------------------------------------
function restapi.max_temp_get(req)

    local body_data = {
        message = "success",
        maxtemp = restapi.incubator.max_temp
    }

    local body_json = sjson.encode(body_data)

    return {
        status = "200 OK",
        type = "application/json",
        body = body_json
    }

end -- end function

-------------------------------------
-- ! @function min_temp   print the current temperature
--
-- !	@param req  				server request
-------------------------------------
function restapi.min_temp_get(req)
    local body_data = {
        message = "success",
        mintemp = restapi.incubator.min_temp
    }

    local body_json = sjson.encode(body_data)

    return {
        status = "200 OK",
        type = "application/json",
        body = body_json
    }

end -- end function

-- ! @function maxtemp   print the current temperature
--
-- !	@param req  				server request
-------------------------------------
function restapi.max_temp_post(req)
    local reqbody = req.getbody()
    print(reqbody,"max_temp_post")
    local body_json = sjson.decode(reqbody)

    -- Obtener el nuevo valor de max_temp del cuerpo de la solicitud POST
    print(body_json.maxtemp)
    local new_max_temp = body_json.maxtemp

    if type(new_max_temp) == "number" and new_max_temp < 42 and new_max_temp >= 0 and new_max_temp >= restapi.incubator.min_temp then

        restapi.incubator.max_temp = new_max_temp

        return {
            status = "201 Created"
        }
    else

        return {
            status = "400 Bad Request"
        }
    end
end

-- ! @function maxtemp   print the current temperature
--
-- !	@param req  				server request
-------------------------------------
function restapi.min_temp_post(req)

    local reqbody = req.getbody()
    print(reqbody)

    local body_json = sjson.decode(reqbody)

    -- Obtener el nuevo valor de max_temp del cuerpo de la solicitud POST
    print(body_json.mintemp)
    local new_min_temp = body_json.mintemp
    if (type(new_min_temp) == "number") then
        if new_min_temp >= 0 and new_min_temp <= restapi.incubator.max_temp then

            restapi.incubator.min_temp = new_min_temp
            return {
                status = "201 Created"
            }

        else
            return {
                status = "400 Bad Request"
            }

        end
    end
end
-------------------------------------
-- ! @function date   		print the current date
--
-- !	@param req  				server request
-------------------------------------

function restapi.date(req)
    local inc_date = time.get()
    local body_data = {
        message = "success",
        date = inc_date
    }

    return {
        status = "200 OK",
        type = "application/json",
        body = sjson.encode(body_data)
    }

end -- end function

-------------------------------------

-------------------------------------
-- ! @function version   print the current version
--
-- !	@param req  				server request 
-------------------------------------

function restapi.version(req)

    local body_data = {
        message = "success",
        version = "0.0.1"
    }

    local body_json = sjson.encode(body_data)

    return {
        status = "200 OK",
        type = "application/json",
        body = body_json
    }

end -- end function

-------------------------------------
--! @function wifi_scan_get   print the current avaliables networks
--
--!	@param req  		      		server request
-------------------------------------

local response_data = {
    message = "error",
    error_message = err
}
  
function restapi.scan_callback(err, arr)
    

    if err then
        response_data = {
        message = "error",
        error_message = err
        }
    else
        local networks = {}
        for i, ap in ipairs(arr) do
            local network_info = {
                ssid = ap.ssid,
                rssi = ap.rssi
            }
            table.insert(networks, network_info)
        end
        response_data = {
            message = "success",
            networks = networks
        }
    end

end


    
function restapi.wifi_scan_get(req)

    wifi.sta.scan({ hidden = 1 }, restapi.scan_callback)
    
    local response_json = sjson.encode(response_data)

    return {
    status = "200 OK",
    type = "application/json",
    body = response_json
    }

end

function restapi.wifi_scan_post(req)
    
    local data = sjson.decode(req.body)

    local response_data = {}

    if data and data.action == "scan" then
        wifi.sta.scan({ hidden = 1 }, function(err, arr)
            if err then
                response_data = {
                message = "error",
                error_message = err
                }
            else
                local networks = {}
                for i, ap in ipairs(arr) do
                    local network_info = {
                        ssid = ap.ssid,
                        rssi = ap.rssi
                    }
                    table.insert(networks, network_info)
                end
                response_data = {
                    message = "success",
                    networks = networks
                }
            end
        end)
    else
        response_data = {
            message = "invalid_request",
            error_message = "Invalid request."
        }
    end

    local response_json = sjson.encode(response_data)

    return {
        status = "200 OK",
        type = "application/json",
        body = response_json
    }
end

function restapi.init_module(incubator_object)
    -- * start local server
    restapi.incubator = incubator_object
    print("starting server .. fyi maxtemp " .. restapi.incubator.max_temp)
    httpd.start({
        webroot = "web",
        auto_index = httpd.INDEX_ALL
    })

    -- * dynamic routes to serve
    httpd.dynamic(httpd.GET, "/maxtemp", restapi.max_temp_get)
    httpd.dynamic(httpd.POST, "/maxtemp", restapi.max_temp_post)
    httpd.dynamic(httpd.GET, "/mintemp", restapi.min_temp_get)
    httpd.dynamic(httpd.POST, "/mintemp", restapi.min_temp_post)
    httpd.dynamic(httpd.GET, "/wifi", restapi.wifi_scan_get)
    httpd.dynamic(httpd.POST, "/wifi", restapi.wifi_scan_post)
end

return restapi
