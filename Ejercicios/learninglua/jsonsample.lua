--https://leafo.net/guides/customizing-the-luarocks-tree.html--
--https://github.com/craigmj/json4lua
json = require('json')
print(json.encode({ 1, 2, 'fred', {first='mars',second='venus',third='earth'} }))

testString = [[ { "one":1 , "two":2, "primes":[2,3,5,7] } ]]
decoded = json.decode(testString)
table.foreach(decoded, print)
print ("Primes are:")
table.foreach(decoded.primes,print)