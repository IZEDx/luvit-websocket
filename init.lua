local WebSocket = {}

WebSocket.server = require('./libs/server.lua')
WebSocket.client = require('./libs/client.lua')

return WebSocket
