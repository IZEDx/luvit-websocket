luvit-websocket
===============

Websocket Library for Luvit.io.

Server works, client is still a WIP.

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
