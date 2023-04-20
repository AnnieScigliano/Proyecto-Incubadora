package.path = package.path .. ';../?.lua'
require("app.SendToGrafana")

describe('test grafana message compostition', function()
    it('very simple test of send to grafana with te new time mark functionality', function()
        assert.is.equal("mediciones,device=XX-bme280 temp=29,hum=60,press=800 1676515676854775806", create_grafana_message(29,60,800,"XX-bme280",1676515676854775806))
    end)
end)
