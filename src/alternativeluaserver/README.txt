sudo apt install lua5.1 liblua5.1-dev
sudo update-alternatives --config lua-interpreter
sudo update-alternatives --config lua-compiler
luarocks install lapis --local --lua-version 5.1
luarocks path --lua-version 5.1 >> ~/.bashrc 
http://openresty.org/en/linux-packages.html#ubuntu

src/alternativeluaserver$ lapis server
curl -i -XGET 'localhost:8080' -u token:e98697797a6a592e6c886277041e6 --data-binary "mediciones,device=jj-bme280 temp=38,hum=66,press=800"

los datos estaran en src/alternativeluaserver/datos.txt
