local name = "javier"

local t = {
     name = "Jack",
     age = "18",
     friend = {"Fred"},
     print_name = function (self)
          print(self.name .. " is fed")
          print(name .. " is NOT fed")
      end
 }
 print(t.friend[1])
 print(t.age)
 t:print_name()
 
 

 local function Pet(name)
     return {
         name = name,
         status = 'hungry',

         feed = function (self)
             print(name .. " is fed")
             self.status = 'Full'
         end
     }
 end


local function Dog(name, breed)
    local dog = Pet(name)
    
    dog.breed = breed
    dog.loyalty = 0

    dog.is_loyal = function (self)
        return self.loyalty >= 10
        
    end

    dog.feed = function (self)
        print(name .. " is fed")
        self.status = 'Full'
        self.loyalty = 100
    end

    dog.bark = function (self)
        print("woof woof ")
        
    end
    
    return dog
end

local function Cat(name, breed)
    local cat = Pet(name)
    
    dog.breed = breed
    dog.loyalty = 0

    dog.is_loyal = function (self)
        return self.loyalty >= 10
        
    end

    dog.meau = function (self)
        print("meau meau ")
        
    end
    
    return cat
end

local lassy = Dog("Lassy", "Poodle")

lassy:feed()
if lassy:is_loyal() then
    print("Will protect against indruder")
else
    print("Will NOT protect against indruder")
end



local a = 5
print(a) --> 5

--[[
LuCI - Lua Configuration Interface
Copyright 2013 Nicolas Echaniz <nicoechaniz@altermundi.net>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
	http://www.apache.org/licenses/LICENSE-2.0
]]--

do
  print(a) --> 5
end


do
  local a = 6 -- create a new local inside the do block instead of changing the existing a
  print(a) --> 6
end

print(a) --> 5

