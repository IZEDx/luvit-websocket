local WebSocket = require('../init.lua')
local http = require("http")

----------------------------------------------- WebSocket Client
http.createServer(function (req, res)
  local body = [[
		<script>
	     var ws = new WebSocket("ws://localhost:1734/echo");
	     ws.onopen = function()
	     {
				  console.log("Test123 is sent...");
	        ws.send("Test123");
	     };
	     ws.onmessage = function (evt)
	     {
	        var received_msg = evt.data;
	        console.log("Message is received..." + received_msg);
	     };
	     ws.onclose = function()
	     {
	        console.log("Connection is closed...");
	     };
		</script>
	]]

  res:writeHead(200, {
    ["Content-Type"] = "text/html",
    ["Content-Length"] = #body
  })
  res:finish(body)
end):listen(80)

----------------------------------------------- WebSocket Server
local WS = WebSocket.server(1734)

WS:on('connect', function(client)
		print("Client connected.")
		client:send("vfx62HIRNLgRLhNrgWiYK0b3VzztgzscNdRJoNYObNUI2nQ8MNDd87h7OrFenzvF83QD0MKTFpKoscs6C7")
end)

WS:on('data', function(client, message)
		print(message)
end)

WS:on('disconnect', function(client)
		print("Client disconnected.")
end)
