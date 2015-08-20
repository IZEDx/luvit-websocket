WebSocket for luvit2
===============

Websocket Library for Luvit.io 2.

In the current version luvit-websocket only supports the websocket standard [RFC 6455](http://tools.ietf.org/html/rfc6455),
thus it will only be able to handle connections from Chrome 16, Firefox 11, IE 10 and above.

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
