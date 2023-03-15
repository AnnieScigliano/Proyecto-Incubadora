local token = "<tokenBot>"
local idChat = "ChatID"
local temperature = 100
local temperatura = "https://api.telegram.org/" ..token .. "/sendMessage?chat_id=" .. idChat .."&text=%20Temperatura%20actual%20" .. temperature / 100
print (temperatura)
local temperature = 10
print (temperatura)
