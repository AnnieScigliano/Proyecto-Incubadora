sudo apt install lua5.1 liblua5.1-dev
sudo update-alternatives --config lua-interpreter
sudo update-alternatives --config lua-compiler
luarocks install lapis --local --lua-version 5.1
luarocks path --lua-version 5.1 >> ~/.bashrc 
http://openresty.org/en/linux-packages.html#ubuntu
