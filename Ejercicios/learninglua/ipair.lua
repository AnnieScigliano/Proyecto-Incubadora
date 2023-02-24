array = {}
print(array)

array[0] = 10
array["key"] = "value"
array["amigos"] = "amigos"
array[1] = 20
array["que"] = "que"
array["tal"] = "tal"
array[2] = 30
array[3] = 33

print(array)


print("Ipairs....")
for i,value in ipairs(array) do
  print("Key: " .. i)
  print("Value: " .. value)
end

print("Ppairs .....")
for key,value in pairs(array) do
  print("Key: " .. key)
  print("Value: " .. value)
end