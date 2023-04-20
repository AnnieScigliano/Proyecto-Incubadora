--package.path = package.path .. ';../?.lua'
--require("app.SendToGrafana")

describe("busted", function()
	local obj1, obj2
	local util

	setup(
		function()
			print("setup")
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

	it("sets up vars with the before_each", function()
		print("it 1")
		obj2 = { test = "no" }
		assert.are_not.same(obj1, obj2)
	end)

	it("sets up vars with the before_each", function()
		print("it 1")
		-- obj2 is reset thanks to the before_each
		assert.same(obj1, obj2)
	end)

	describe("nested", function()
		pending("I should finish this test later")
		print("anidada")
		it("also runs the before_each here", function()
			print("it 2 anidad")
			-- if this describe also had a before_each, it would run
			-- both, starting with the parents'. You can go n-deep.
		end)
	end)
end)
