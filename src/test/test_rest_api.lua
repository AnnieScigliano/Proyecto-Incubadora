--package.path = package.path .. ';../?.lua'
--require("app.SendToGrafana")
local http = require("socket.http")
local apiendpoint = "http://127.0.0.1:5000/"


describe("Api REST test", function()
	items = {

		{ ["category"] = "config_param", ["name"] = "maxtemp", ["value"] = 50,  ["comparator"] = "=" },
		{ ["category"] = "config_param", ["name"] = "mintemp", ["value"] = 20,  ["comparator"] = "=" },
		{ ["category"] = "geters",       ["name"] = "version", ["value"] = "0.0.1", ["comparator"] = "=" },
		--get the actual date and assert that the date from the device is in the future
		{ ["category"] = "geters",       ["name"] = "date",    ["value"] = 0,   ["comparator"] = "<" },

	}
	setup(

		function()
			http.TIMEOUT = 100
			print("setup")
			JSON              = require("JSON")
			inspect           = require("inspect")
			items[4]["value"] = os.time(os.date("!*t"))- 20000
			counter           = 0
		end
	)

	teardown(
		function()
			print("teardown")
		end)

	before_each(
		function()

		end)

	it("get space station location", function()
		local body, code, headers, status = http.request("http://api.open-notify.org/iss-now.json")
		print(code, status, body)
		local lua_value = JSON:decode(body) -- decode example
		print(lua_value.message)
		assert.are_equal(lua_value.message, "success")
	end)

	it("json playground", function()
		local raw_json_text    = "[1,2,[3,4]]"

		local lua_value        = JSON:decode(raw_json_text) -- decode example
		local raw_json_text    = JSON:encode(lua_value)  -- encode example
		local pretty_json_text = JSON:encode_pretty(lua_value) -- "pretty printed" version

		print(inspect(lua_value))
		print(inspect(raw_json_text))
		print(inspect(pretty_json_text))
		print("it 1")
		-- obj2 is reset thanks to the before_each
		assert.same(obj1, obj2)
	end)

	local function get_and_assert_200(atribute)
		local body, code, headers, status = http.request(apiendpoint .. atribute)
		print(code, status, body, headers, atribute)
		assert.are_equal(code, 200)
		return body
	end

	local function post_and_assert_201(atribute, value)
		--In that case, if a body is provided as a string, the function will perform a POST method in the url.
		body, code, headers, status = http.request(apiendpoint .. atribute, value)
		print(code, status, body, headers, atribute, value)
		assert.are_equal(201, code)
		return body
	end

	describe("parametrized geters", function()
		pending("get time and version ... ")
		for k, v in pairs(items) do
			if v["category"] == "geters" then
				it("get and check " .. v["name"] .. " ", function()
					--get the actual max
					body            = get_and_assert_200(v["name"])
					local lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					print(lua_value[v["name"]],"successsssssssssssssssssss")
					if v["comparator"] == "<" then
						print(tonumber(v["value"]),"  ",tonumber(lua_value[v["name"]]))
						assert(tonumber(v["value"])  < tonumber(lua_value[v["name"]]))
					else
						assert.are_equal(v["value"], lua_value[v["name"]])
					end
				end)
			end
			
			if v["category"] == "config_param" then
				it("get and set " .. v["name"] .. " ", function()
					--get the actual max
					body            = get_and_assert_200(v["name"])
					local lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					print(lua_value[v["name"]])
					assert.is_number(lua_value[v["name"]])
					local actual_val = lua_value[v["name"]]
					local new_val = v["value"]
					--assert.are_not_equal(actual_val, new_val)
					--set the new max
					post_and_assert_201(v["name"], '{"'.. v["name"]..'":'.. new_val..'}' )
					--get the new max
					body            = get_and_assert_200(v["name"])
					local lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					print(lua_value[v["name"]])
					assert.is_number(lua_value[v["name"]])
					assert.are_equal(new_val, lua_value[v["name"]])
					--restore the old value
					post_and_assert_201(v["name"], '{"'.. v["name"]..'":'.. actual_val..'}' )
					body = get_and_assert_200(v["name"])
					lua_value = JSON:decode(body) -- decode example
					assert.are_equal(actual_val, lua_value[v["name"]])

					
				end)
			end
		end
	end)
end)
