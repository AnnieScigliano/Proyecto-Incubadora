local restapi = {
    incubator = nil
}

function restapi.add(a, b)
    print(a + b)
end

function restapi.init(a)
    print(a)
end
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

function restapi.init_module(incubator_object)
    -- * start local server
    restapi.incubator = incubator_object
    print("starting server .. fyi maxtemp " .. restapi.incubator.max_temp)
    httpd.start({
        webroot = "web",
        auto_index = httpd.INDEX_ALL
    })

    -- * dynamic routes to serve
    httpd.dynamic(httpd.GET, "/version", restapi.version)
    httpd.dynamic(httpd.GET, "/maxtemp", restapi.max_temp_get)
    httpd.dynamic(httpd.POST, "/maxtemp", restapi.max_temp_post)
    httpd.dynamic(httpd.GET, "/mintemp", restapi.min_temp_get)
    httpd.dynamic(httpd.POST, "/mintemp", restapi.min_temp_post)
    httpd.dynamic(httpd.GET, "/date", restapi.date)
end

return restapi
