--package.path = package.path .. ';../?.lua'
--require("app.SendToGrafana")
local http = require("socket.http")
local ltn12 = require("ltn12")

describe("Api REST test", function()
	local obj1, obj2
	local util

	setup(
		function()
			print("setup")
			JSON    = require("JSON")
			inspect = require("inspect")
		end
	)

	teardown(
		function()
			print("teardown")
		end)

	before_each(
		function()
			print("before_each")
			obj1 = { test = "yes" }
			obj2 = { test = "yes" }
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

	describe("meter verduras", function()
		pending("I should finish this test later")
		print("anidada")
		it("set max limit", function()
			local value = '{"maxtemp":"verdura"}'

			body, code, headers, status = http.request {
				url = "http://0.0.0.0/maxtemp",
				headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
				},
				method = "POST",
				source = ltn12.source.string(value),
			}

			assert.are_equal(401, code)




			-- Post con texto
		end)
	end)

	describe("temperatura minima > maxima", function()
		pending("I should finish this test later")
		print("anidada")
		it("set max limit", function()
			local value = '{"maxtemp": 38}'

			body, code, headers, status = http.request {
				url = "http://0.0.0.0/maxtemp",
				headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
				},
				method = "POST",
				source = ltn12.source.string(value),
			}

			assert.are_equal(201, code)

			value = '{"mintemp": 39 }'
			body, code, headers, status = http.request {
				url = "http://0.0.0.0/mintemp",
				headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
				},
				method = "POST",
				source = ltn12.source.string(value),
			}

			assert.are_equal(400, code)
		end)

		it("mintemp < 0", function()
			local value = '{"mintemp": -1}'

			body, code, headers, status = http.request {
				url = "http://0.0.0.0/mintemp",
				headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
				},
				method = "POST",
				source = ltn12.source.string(value),
			}

			assert.are_equal(400, code)
		end)

		it("maxtemp > 42", function()
			local value = '{"maxtemp": 42}'

			body, code, headers, status = http.request {
				url = "http://0.0.0.0/maxtemp",
				headers = {
					["content-Type"] = 'application/json',
					["Accept"] = 'application/json',
					["content-length"] = tostring(#value)
				},
				method = "POST",
				source = ltn12.source.string(value),
			}

			assert.are_equal(400, code)
		end)
	end)
end)
