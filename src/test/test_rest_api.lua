--package.path = package.path .. ';../?.lua'
--require("app.SendToGrafana")
local http = require("socket.http")


describe("Api REST test", function()
	items = {

		{ ["category"] = "config_param", ["name"] = "maxtemp", ["value"] = 50,  ["quantity"] = 5 },
		{ ["category"] = "config_param", ["name"] = "mintemp", ["value"] = 20,  ["quantity"] = 5 },
		{ ["category"] = "geters",       ["name"] = "version", ["value"] = 0.1, ["quantity"] = 1 },
		{ ["category"] = "geters",       ["name"] = "date",    ["value"] = 0,   ["quantity"] = 2000 },

	}
	setup(

		function()
			http.TIMEOUT = 1
			print("setup")
			JSON              = require("JSON")
			inspect           = require("inspect")
			items[4]["value"] = os.time(os.date("!*t"))
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

		print("it 1")
		obj2 = { test = "no" }
		assert.are_not.same(obj1, obj2)
		---"message": "success",
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
		local body, code, headers, status = http.request("http://192.168.1.1/" .. atribute)
		print(code, status, body, headers, atribute)
		assert.are_equal(code, 200)
		return body
	end

	local function post_and_assert_201(atribute, value)
		--In that case, if a body is provided as a string, the function will perform a POST method in the url.
		body, code, headers, status = http.request("http://192.168.1.1/" .. atribute, value)
		print(code, status, body, headers, atribute, value)
		assert.are_equal(201, code)
		return body
	end

	describe("getersandseters", function()
		pending("get and set max temperature")
		it("set max limit", function()
			--get the actual max
			body            = get_and_assert_200("maxtemp")
			local lua_value = JSON:decode(body) -- decode example
			assert.are_equal(lua_value.message, "success")
			print(lua_value.temp)
			assert.is_number(lua_value.temp)
			local actual_max = lua_value.temp
			local new_max = 53
			assert.are_not_equal(actual_max, new_max)
			--set the new max
			post_and_assert_201("maxtemp", new_max)
			--get the new max
			body = get_and_assert_200("maxtemp")
			lua_value = JSON:decode(body) -- decode example
			assert.are_equal(lua_value.message, "success")
			assert.is_number(lua_value.temp)
			assert.are_equal(new_max, lua_value.temp)
			--restore the old max
			post_and_assert_201("maxtemp", actual_max)
		end)
	end)

	describe("parametrized geters", function()
		pending("get time and version ... ")
		for k, v in pairs(items) do
			if v["category"] == "geters" then
				it("get and check " .. v["name"] .. " ", function()
					--get the actual max
					body            = get_and_assert_200(v["name"])
					local lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					print(lua_value.v["name"])
					assert.is_number(lua_value.temp)
					local actual_val = lua_value.temp
					local new_val = v["value"]
					assert.are_not_equal(actual_max, new_val)
					--set the new max
					post_and_assert_201(v["name"], new_val)
					--get the new max
					body = get_and_assert_200(v["name"])
					lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					assert.is_number(lua_value.temp)
					assert.are_equal(new_max, lua_value.temp)
					--restore the old max
					post_and_assert_201(v["name"], actual_val)
				end)
			end
			if v["category"] == "config_param" then
				it("get and set " .. v["name"] .. " ", function()
					--get the actual max
					body            = get_and_assert_200(v["name"])
					local lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					print(lua_value.v["name"])
					assert.is_number(lua_value.temp)
					local actual_val = lua_value.temp
					local new_val = v["value"]
					assert.are_not_equal(actual_max, new_val)
					--set the new max
					post_and_assert_201(v["name"], new_val)
					--get the new max
					body = get_and_assert_200(v["name"])
					lua_value = JSON:decode(body) -- decode example
					assert.are_equal(lua_value.message, "success")
					assert.is_number(lua_value.temp)
					assert.are_equal(new_max, lua_value.temp)
					--restore the old max
					post_and_assert_201("maxtemp", actual_val)
				end)
			end
		end
	end)
end)
