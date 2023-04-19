-- luarocks install busted
-- Defining Tests
-- Set up your tests using describe and it blocks. These take a description (to be used for output) and a callback (which either defines more blocks or contains the tests themselves. Describe blocks can have more decribe blocks nested. You can also use the functions before_each and after_each to define functions that should be run before any nested tests, and setup and teardown for functions that should be run before and after the describe block.
-- You can also use the pending method to leave a placeholder for a test you plan on writing later.
-- Tag your tests with #hashtags to run specific tests. When you run busted from the command line, add the -t flag to run a given tag. Seperate tags by commas to run more than one tag.
-- Describe: Context blocks
-- describe takes a title and a callback, and can be nested. You can also use context as an alias if you like.

describe("a test", function()
	-- tests go here

	describe("a nested block", function()
		describe("can have many describes", function()
			-- tests
		end)
	end)

	-- more tests pertaining to the top level
end)

-- Describe: Insulate & Expose blocks
-- insulate and expose blocks are describe aliases that control the level of sandboxing performed by busted for that context block. Like their names suggest, an insulate block insulates the test environment, while an expose block exposes the test environment to outer context blocks. By default each test file runs in a separate insulate block, which can be disabled with the --no-auto-insulate flag.
-- Test environment insulation saves the global table _G and any currently loaded packages package.loaded, restoring them to their original state at the completion of the insulate block.
insulate("an insulated test", function()
	require("mymodule")
	_G.myglobal = true

	-- tests go here

	describe("a nested block", function()
		describe("can have many describes", function()
			-- tests
		end)
	end)

	-- more tests pertaining to the top level
end)

describe("a test", function()
	it("tests insulate block does not update environment", function()
		assert.is_nil(package.loaded.mymodule) -- mymodule is not loaded
		assert.is_nil(_G.myglobal)       -- _G.myglobal is not set
		assert.is_nil(myglobal)
	end)

	-- tests go here
end)

-- Exposing a test environment exports any changes made to _G and package.loaded to subsequent context blocks. In addition, any global variables created inside an expose block are created in the environment of the context block 2 levels out. Using expose at the root of a file will promote any require's and globals to the root environment, which will spillover into subsequent test files.

-- test1_spec.lua
expose("an exposed test", function()
	require("mymodule")
	_G.myglobal = true

	-- tests can go here

	describe("a nested block", function()
		describe("can have many describes", function()
			-- tests
		end)
	end)

	-- more tests pertaining to the top level
end)

describe("a test in same file", function()
	it("tests expose block updates environment", function()
		assert.is_truthy(package.loaded.mymodule) -- mymodule is still loaded
		assert.is_true(_G.myglobal)         -- _G.myglobal is still set
		--assert.is_equal(myglobal)
	end)

	-- tests go here
end)

-- test2_spec.lua
describe("a test in separate file", function()
	it("tests expose block updates environment", function()
		assert.is_truthy(package.loaded.mymodule) -- mymodule is still loaded
		assert.is_true(_G.myglobal)         -- _G.myglobal is still set
		assert.is_equal(_G.myglobal, myglobal)
	end)

	-- tests go here
end)

--Describe: Tagging Tests
-- Tag tests using #tags, and run using the -t flag to only run that test.
describe("a test #tag", function()
	-- tests go here
end)

describe("a nested block #another", function()
	describe("can have many describes", function()
		-- tests
	end)

	-- more tests pertaining to the top level
end)

-- busted -t "tag" ./test.lua
-- This runs the first group of tests, but not the second.

-- busted -t "tag,another" ./test.lua

-- This runs both groups.

-- You can also exclude tests that use tags with the --exclude-tags flag. This can be useful, for example, if tests using a certain tag take a long time to run and you want busted to skip them. This would run all tests except the second group in the example above.

-- busted --exclude-tags="another" ./test.lua

-- If you use -t, --tags and --exclude-tags together then --exclude-tags always takes precedence.

describe("a test with two tags #one #two", function()
	-- tests
end)

-- busted --tags="one" --exclude-tags="two" ./test.lua

-- Both tags refer to the same test but busted will not run it since --exclude-tags takes precedence.

-- busted --tags="one" --exclude-tags="one" ./test.lua

-- It is ok for different tags to refer to the same tests, but using the exact same tag name with --tags and --exclude-tags at the same time is an error.
-- Randomizing Tests

-- You can cause nested tests and describes to be randomized by calling randomize().

describe("a ramdomized test", function()
	randomize()

	it("runs a test", function()
	end)
	it("runs another test", function()
	end)
end)

--If randomization has been enabled for all tests with the --shuffle flag, you can turn off randomization for nested tests and describes by calling randomize(false).

describe("a non-randomized test", function()
	randomize(false)

	it("runs a test", function()
	end)
	it("runs another test", function()
	end)
end)

--It: Defining tests

--An it block takes a title and a callback. Tests fail if an uncaptured error is thrown (assert functions throw errors for failed tests). You can also use spec or test as aliases if you like.

describe("busted", function()
	it("has tests", function()
		local obj1 = { test = "yes" }
		local obj2 = { test = "yes" }
		assert.same(obj1, obj2)
	end)
end)

--Before Each & After Each; Setup & Teardown
--before_each runs before each child test, and after_each (you guessed it) runs after. setup runs first in a describe block, and teardown runs last in a describe block.
--setup and teardown blocks can be made lazy or strict. lazy_setup and lazy_teardown will only run if there is at least one child test present in the current or any nested describe blocks. Conversely, strict_setup and strict_teardown will always run in a describe block, even if no child tests are present. By default setup and teardown are strict, but can be made lazy with the --lazy flag.

describe("busted", function()
	local obj1, obj2
	local util

	setup(function()
		--util = require("util")
	end)

	teardown(function()
		---util = nil
	end)

	before_each(function()
		obj1 = { test = "yes" }
		obj2 = { test = "yes" }
	end)

	it("sets up vars with the before_each", function()
		obj2 = { test = "no" }
		assert.are_not.same(obj1, obj2)
	end)

	it("sets up vars with the before_each", function()
		-- obj2 is reset thanks to the before_each
		assert.same(obj1, obj2)
	end)

	describe("nested", function()
		it("also runs the before_each here", function()
			-- if this describe also had a before_each, it would run
			-- both, starting with the parents'. You can go n-deep.
		end)
	end)
end)

--finally is also available as a lighter alternative that avoids setting upvalues.
it('checks file contents', function()
	local f = io.popen('stupid_process')
	print("about to sleep for 1 seconds ")
	local f2 = io.popen('sleep 1')
	print("sleeping... ")
	-- ensure that once test has finished f:close() is called
	-- independent of test outcome
	finally(function()
		f:close()
		f2:close()
		print("finally")
	end)
	print("done")
	-- do things with f
end)

--Pending
--Pending functions are placeholders for tests you plan to write (or fix) later.

describe("busted pending tests", function()
	pending("I should finish this test later")
end)

--Asserts

--Asserts are the core of busted; they're what you use to actually write your tests. Asserts in busted work by chaining a modifier value by using is or is_not, followed by the assert you wish to use. It's easy to extend busted and add your own asserts by building an assert with a commmon signature and registering it.

-- Busted uses the luassert library to provide the assertions. Note that some of the assertion/modifiers are Lua keywords ( true, false, nil, function, and not) and they cannot be used using '.' chaining because that results in compilation errors. Instead chain using '_' (underscore) or use one or more capitals in the reserved word, whatever your coding style prefers.
-- Is & Is Not

-- is and is_not flips the expected value of the assertion; if is_not is used, the assertion fails if it doesn't throw an error. are, are_not, has_no, was, and, was_not are aliased as well to appease your grammar sensibilities. is and its aliases are always optional.

describe("some assertions", function()
	it("tests positive assertions", function()
		assert.is_true(true) -- Lua keyword chained with _
		assert.True(true) -- Lua keyword using a capital
		assert.are.equal(1, 1)
		assert.has.errors(function() error("this should fail") end)
		local expected = { name = "Jack" }
		local obj = { name = "Jack" }

		assert.are.same(expected, obj)
	end)

	it("tests negative assertions", function()
		assert.is_not_true(false)
		assert.are_not.equals(1, "1")
		assert.has_no.errors(function()
		end)
	end)
end)


-- Error

-- Makes sure an error exception is fired that you expect.

describe("some asserts", function()
	it("should throw an error", function()
		assert.has_error(function() error("Yup,  it errored") end)
		assert.has_no.errors(function()
		end)
	end)

	it("should throw the error we expect", function()
		local errfn = function()
			error("DB CONN ERROR")
		end

		assert.has_error(errfn, "DB CONN ERROR")
	end)
end)

-- Spies, Stubs, & Mocks

-- Spies are essentially wrappers around functions that keep track of data about how the function was called, and by default calls the function. Stubs are the same as spies, except they return immediately without calling the function. mock(table, stub) returns a table whose functions have been wrapped in spies or stubs.
-- Spies

-- Spies contain two methods: on and new. spy.on(table, method_name) does an in-place replacement of a table's method, and when the original method is called, it registers what it was called with and then calls the original function.

describe("spies", function()
	it("registers a new spy as a callback", function()
		local s = spy.new(function()
		end)

		s(1, 2, 3)
		s(4, 5, 6)

		assert.spy(s).was.called()
		assert.spy(s).was.called(2)      -- twice!
		assert.spy(s).was.called_with(1, 2, 3) -- checks the history
	end)

	it("replaces an original function", function()
		local t = {
			greet = function(msg) print(msg) end
		}

		local s = spy.on(t, "greet")

		t.greet("Hey!") -- prints 'Hey!'
		assert.spy(t.greet).was_called_with("Hey!")

		t.greet:clear() -- clears the call history
		assert.spy(s).was_not_called_with("Hey!")

		t.greet:revert() -- reverts the stub
		t.greet("Hello!") -- prints 'Hello!', will not pass through the spy
		assert.spy(s).was_not_called_with("Hello!")
	end)
end)

-- Stubs
-- Stubs act similarly to spies, except they do not call the function they replace. This is useful for testing things like data layers.

describe("stubs", function()
	it("replaces an original function", function()
		local t = {
			greet = function(msg) print(msg) end
		}


		stub(t, "greet")

		t.greet("Hey!") -- DOES NOT print 'Hey!'
		assert.stub(t.greet).was.called_with("Hey!")

		t.greet:revert() -- reverts the stub
		t.greet("Hey!") -- DOES print 'Hey!'
	end)
end)

-- Mocks

-- Mocks are tables whose functions have been wrapped in spies, or optionally stubs. This is useful for checking execution chains. Wrapping is recursive, so wrapping functions in sub-tables as well.

describe("mocks", function()
	it("replaces a table with spies", function()
		local t = {
			thing = function(msg) print(msg) end
		}

		local m = mock(t) -- mocks the table with spies, so it will print

		m.thing("Coffee")
		assert.spy(m.thing).was.called_with("Coffee")
	end)

	it("replaces a table with stubs", function()
		local t = {
			thing = function(msg) print(msg) end
		}

		local m = mock(t, true) -- mocks the table with stubs, so it will not print

		m.thing("Coffee")
		assert.stub(m.thing).was.called_with("Coffee")
		mock.revert(m) -- reverts all stubs/spies in m
		m.thing("Tea") -- DOES print 'Tea'
	end)
end)

-- Matchers
-- Matchers are used to provide flexible argument matching for called_with and returned_with asserts. Just like with asserts, you can chain a modifier value using is or is_not, followed by the matcher you wish to use. Extending busted with your own matchers is done similar to asserts as well; just build a matcher with a common signature and register it. Furthermore, matchers can be combined using composite matchers.
describe("match arguments", function()
	local match = require("luassert.match")

	it("tests wildcard matcher", function()
		local s = spy.new(function()
		end)
		local _ = match._

		s("foo")

		assert.spy(s).was_called_with(_)  -- matches any argument
		assert.spy(s).was_not_called_with(_, _) -- does not match two arguments
	end)

	it("tests type matchers", function()
		local s = spy.new(function()
		end)

		s("foo")

		assert.spy(s).was_called_with(match.is_string())
		assert.spy(s).was_called_with(match.is_truthy())
		assert.spy(s).was_called_with(match.is_not_nil())
		assert.spy(s).was_called_with(match.is_not_false())
		assert.spy(s).was_called_with(match.is_not_number())
		assert.spy(s).was_called_with(match.is_not_table())
	end)

	it("tests more matchers", function()
		local s = spy.new(function()
		end)

		s(1)

		assert.spy(s).was_called_with(match.is_equal(1))
		assert.spy(s).was_called_with(match.is_same(1))
	end)
end)

--Reference Matchers
--If you're creating a spy for functions that mutate any properties on an table (for example self) and you want to use was_called_with, you should use match.is_ref(obj).

describe("combine matchers", function()
	local match = require("luassert.match")

	it("tests ref matchers for passed in table", function()
		local t = { cnt = 0, }
		function t.incrby(t, i) t.cnt = t.cnt + i end

		local s = spy.on(t, "incrby")

		s(t, 2)

		assert.spy(s).was_called_with(match.is_ref(t), 2)
	end)

	it("tests ref matchers for self", function()
		local t = { cnt = 0, }
		function t:incrby(i) self.cnt = self.cnt + i end

		local s = spy.on(t, "incrby")

		t:incrby(2)

		assert.spy(s).was_called_with(match.is_ref(t), 2)
	end)
end)

--Composite Matchers
--Combine matchers using composite matchers.


describe("combine matchers", function()
	local match = require("luassert.match")

	it("tests composite matchers", function()
		local s = spy.new(function()
		end)

		s("foo")

		assert.spy(s).was_called_with(match.is_all_of(match.is_not_nil(), match.is_not_number()))
		assert.spy(s).was_called_with(match.is_any_of(match.is_number(), match.is_string(), match.is_boolean()))
		assert.spy(s).was_called_with(match.is_none_of(match.is_number(), match.is_table(), match.is_boolean()))
	end)
end)

--Extending Your Own Matchers
--Add in your own matchers to reuse commonly written code. Note that only when boolean true returned, it is considered a match. For example, you should write "value:find(sub) ~= nil" instead of just "value:find(sub)".


local function is_even(state, arguments)
	return function(value)
		return (value % 2) == 0
	end
end

local function is_gt(state, arguments)
	local expected = arguments[1]
	return function(value)
		return value > expected
	end
end

assert:register("matcher", "even", is_even)
assert:register("matcher", "gt", is_gt)

describe("custom matchers", function()
	it("match even", function()
		local s = spy.new(function()
		end)

		s(2)

		assert.spy(s).was_called_with(match.is_even())
	end)

	it("match greater than", function()
		local s = spy.new(function()
		end)

		s(10)

		assert.spy(s).was_called_with(match.is_gt(5))
	end)
end)

--Async Tests
--Sometimes you need to write tests that work with asynchronous calls such as when dealing with HTTP requests, threads, or database calls. Call async() at the top of an it to specify that your test should wait, and call done() to complete a test.
-- describe('API integration tests', function()
--   it('loads user data', function()
--     async()

--     local user_id = 1

--     makeAPICall(function(data)
--       -- do things
--       assert.are.equal(user_id, data.id)
--       done()
--     )
--   end)
-- end)

-- Private

-- Busted does not define any global variables for testing internal/private helper functions . We believe the correct way to address this is to refactor your code to make it more externally testable. However, if you wish to expose private elements for testing purposes only you can do the following:
-- a new module with private elements to be tested
 local mymodule = {}
 local private_element = {"this", "is", "private"}

-- function mymodule:display()
--   print(string.concat(private_element, " "))
-- end

-- -- export locals for test
-- if _TEST then
--   -- setup test alias for private elements using a modified name
--   mymodule._private_element = private_element
-- end

-- return mymodule

-- --In the test specs it can be tested:

-- local mymodule

-- describe("Going to test a private element", function()

--   setup(function()
--     _G._TEST = true
--     mymodule = require("mymodule")
--   end)

--   teardown(function()
--     _G._TEST = nil
--   end)

--   it("tests the length of the table", function()
--     assert.is.equal(#mymodule._private_element, 3)
--   end)

-- end)

describe('Busted unit testing framework', function()
	describe('should be awesome', function()
		it('should be easy to use', function()
			assert.truthy('Yup.')
		end)

		it('should have lots of features', function()
			-- deep check comparisons!
			assert.same({ table = 'great' }, { table = 'great' })

			-- or check by reference!
			assert.is_not.equals({ table = 'great' }, { table = 'great' })

			assert.falsy(nil)
			assert.error(function() error('Wat') end)
		end)

		it('should provide some shortcuts to common functions', function()
			assert.unique({ { thing = 1 }, { thing = 2 }, { thing = 3 } })
		end)

		it('should have mocks and spies for functional tests', function()
			local thing = require('mymodule')
			spy.on(thing, 'greet')
			thing.greet('Hi!')

			assert.spy(thing.greet).was.called()
			assert.spy(thing.greet).was.called_with('Hi!')
		end)

		it("replaces an original function", function()
			local thing = require('mymodule')
			thing.greet("Hey!") -- DOES NOT print 'Hey!'
			stub(thing, "greet")
			thing.greet("Hey!") -- DOES NOT print 'Hey!'
			print("will print HEY only once")
			assert.stub(thing.greet).was.called_with("Hey!")

			thing.greet:revert() -- reverts the stub
			thing.greet("Hey!") -- DOES print 'Hey!'
			print("will print HEY twice even though it was called three times")

		end)
	end)
end)
