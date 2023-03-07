<<<<<<< HEAD
-----------------------------------
-- module          math operations
-----------------------------------

local my_math = {}
-----------------------------------
--function adds two numbers
--@param x  any number
--@param y  any numbers
--returns   sum of both numbers
-----------------------------------

function my_math.add(x,y)
    return x + y
end

-----------------------------------
--function substracts two numbers
--@param x  any number
--@param y  any numbers
--returns   sub of both numbers
-----------------------------------

function my_math.sub(x,y)
    return x - y
end

-----------------------------------
--function multiplication two numbers
--@param x  any number
--@param y  any numbers
--returns   multiplys of both numbers
-----------------------------------

function my_math.mul(x,y)
    return x * y
end

-----------------------------------
--function divides two numbers
--@param x  any number
--@param y  any numbers
--returns   divition of both numbers
-----------------------------------

function my_math.div(x,y)
    return x/y
=======
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
>>>>>>> main
end

return my_math