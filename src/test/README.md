# Testing guide

LibrePollo has unit tests that help us add new features while keeping maintenance effort contained.

We encourage contributors to write [tests](https://en.wikipedia.org/wiki/Unit_testing)  when adding new functionality and also while fixing [regressions](https://en.wikipedia.org/wiki/Regression_testing).

LibreMesh unit testing is based in the powerful [busted](https://lunarmodules.github.io/busted/) library which has a very good documentation.

## Modules 
* [LuaSockets](https://github.com/lunarmodules/luasocket)
* [json-lua](https://github.com/tiye/json-lua)
* [inspect](https://github.com/kikito/inspect.lua)
* [colors](https://github.com/kikito/ansicolors.lua)

## Install required software
```sh
apt-get install luarocks
sudo luarocks --lua-version 5.1 install --server=https://luarocks.org/dev ltn12
sudo luarocks --lua-version 5.1 install luasockets
sudo luarocks --lua-version 5.1 install busted
sudo luarocks --lua-version 5.1 install json-lua 
sudo luarocks --lua-version 5.1 install inspect
sudo luarocks --lua-version 5.1 install ansicolors
```
## How to run the tests

Just execute ```busted test_*``` inside test folder.

If you want to run a test excluding a specific one, you can do it with:

```bash
 busted --exclude-tags="wifi" ./test_rest_api.lua
```
To do this, you must add a tag to identify the test as in this example:

[![imagen.png](https://i.postimg.cc/SRFfVXtR/imagen.png)](https://postimg.cc/XGL5YvW6)
## Testing directory structure

Test files for source module `foo.lua` live inside a `test` directory with its names begining with `test_`:

```bash
test/test_foo.lua

```

Testing utilities, fake libraries and integration tests live inside a root `test/` directory:

```bash
tests/test_some_integration_tests.lua
tests/test_other_general_tests.lua
tests/fake/bazlib.lua
tests/tests/test_bazlib.lua
```
In the case of the rest api, it is located in a folder called ```tdd_api_rest``` for organizational reasons.
the steps to follow are:

```bash
cd test/tdd_api_rest
```

```bash
 busted ./test_rest_api.lua
```

you should see something like this:

[![imagen.png](https://i.postimg.cc/SRRBGMB8/imagen.png)](https://postimg.cc/m1xpLt22)


## How to write tests

Here is a very simple test of a library `foo`:
```lua
local foo = require 'foo'

describe('foo library tests', function()
    it('very simple test of f_sum(a, b)', function()
        assert.is.equal(4, foo.f_sum(2, 2))
        assert.is.equal(2, foo.f_sum(2, 0))
        assert.is.equal(0, foo.f_sum(2, -2))
    end)
end)
```

