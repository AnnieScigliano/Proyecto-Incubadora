-----------------------------------------------------------------------------
-- Implementation to train lua functions.
--
--  Jere Castro
--
------------------------------------------------------------------------------

local my_math = {}
-------------------------------------------------------------------------------
--! @function add		add to numbers 
--! @return 				sum result
--! @param a        a number is expected
--! @param b        a number is expected
-------------------------------------------------------------------------------

function my_math.add(a, b)
	return a + b
end

-------------------------------------------------------------------------------
--! @function sub		subtract two numbers
--! @return 				substract result
--! @param a        a number is expected
--! @param b        a number is expected
-------------------------------------------------------------------------------

function my_math.sub(a, b)
	return a - b
end

-------------------------------------------------------------------------------
--! @function mul		multiply two numbers
--! @return 				multiply result
--! @param a        a number is expected
--! @param b        a number is expected
-------------------------------------------------------------------------------

function my_math.mul(a, b)
	return a * b
end

-------------------------------------------------------------------------------
--! @function div		divide two numbers
--! @return 				divide result
--! @param a        a number is expected
--! @param b        a number is expected
------------------------------------------------------------------------------- 

function my_math.div(a, b)
	return a / b
end

return my_math