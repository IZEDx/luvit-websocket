luvit-websocket
===============

Websocket Library for Luvit.io.

Server works, client is still a WIP.

In the current version luvit-websocket only supports the websocket standard [RFC 6455](http://tools.ietf.org/html/rfc6455),
thus it will only be able to handle connections from Chrome 16, Firefox 11, IE 10 and above.

Also it does not yet support Message Fragmentation.

Besides that, using a simple WebSocket connection in a moden browser should work fine.

Installation:
============
You can use [npm](https://www.npmjs.org/) to install luvit-websocket:
> npm install luvit-websocket

Usage:
============
```lua
  local WebSocket = require('luvit-websocket')

  local WS = WebSocket.server(1734)

  WS:on('connect', function(client)
      print("Client connected.")
      client:send("random message")
  end)

  WS:on('data', function(client, message)
      print(message)
  end)

  WS:on('disconnect', function(client)
      print("Client disconnected.")
  end)

```
