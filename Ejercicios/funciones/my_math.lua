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
end

return my_math