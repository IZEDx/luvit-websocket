exports.name = "websocketutils"
exports.version = "0.0.1"
exports.author = "Niklas Kühtmann"

local bitmap = require('bitmap')
local bit = require('bit')
local bytemap = require('bytemap')
local b64 = require("base64")
local sha1 = require("sha1")
local string = require("string")

string.split = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end

    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

exports.disassemblePacket = function(buffer)
    local bytemap = bytemap.fromString(buffer)


    -- flag evaluation
    local bitmap = bitmap.fromNumber(bytemap[1])
  local flags  = toBits(bytemap[1])

  for k,v in pairs(flags) do
    print(k, v, bitmap[k])
  end


    local fin = bitmap[1]
    local rsv1 = bitmap[2]; rsv2 = bitmap[3]; rsv3 = bitmap[4]
    local opcode = tonumber(bitmap[5] .. bitmap[6] .. bitmap[7] .. bitmap[8], 2)
    print("Flags: ", fin, rsv1, rsv2, rsv3, opcode)
    if not fin then
        return print("WebSocket Error: Message Fragmentation not supported.")
    end

    if bitmap[4] then return 2 end

    if bitmap:areSet(5,7) and bitmap:areNotSet(6,8) then
        bitmap[6] = true
        bitmap[7] = false
        bytemap[1] = bitmap:toNumber()
        return 1, bytemap:toString()
    end

    bytemap:popStart()


    -- get packet size (needed for message fragmentation later on, sits inbetween so get it, why not)
    -- need to know where to cut off anyway
    local length = bytemap[1] - 128
    bytemap:popStart()
    if length == 126 then
        length = bytemap:toNumber(1,2)
        bytemap:popStart(2)
    elseif length == 127 then
        length = bytemap:toNumber(1,2,3,4,5,6,7,8)
        bytemap:popStart(8)
    end    

    -- get mask
    local mask = {bytemap:get(1,2,3,4)}
    bytemap:popStart(4)

    local ret = ""
    bytemap:forEach(function(k,v)
        ret = ret .. string.char(bit.bxor(mask[(k % 4)+1], v))
    end)

    return ret
end

exports.assemblePacket = function(buffer)
    local flags = "10000001"
    local bytemap = bytemap.new({tonumber(flags, 2), #buffer})
    
    if bytemap[2] >= 65536 then
        local length = bytemap[2]
        for i = 10, 3, -1 do
            bytemap[i] = bit.band(length, 0xFF)
            length = bit.rshift(length, 8)
        end
        bytemap[2] = 127
    elseif bytemap[2] >= 126 then
        bytemap[4] = bit.band(bit.rshift(bytemap[2], 8), 0xFF)
        bytemap[3] = bit.band(bytemap[2], 0xFF)
        bytemap[2] = 126
    end
    for i = 1, #buffer do
        bytemap:push(string.byte(buffer:sub(i, i)))
    end

    local ret = ""
    bytemap:forEach(function(k,v)
        ret = ret .. string.char(v)
    end)

    return ret
end

exports.assembleHandshakeResponse = function(handshake)
    local lines = handshake:split('\r\n')
    local title = lines[1]
    lines[1] = nil
    local data = {}

    for k,v in pairs(lines) do
      if #v > 2 then
        local line = v:split(": ")
        data[line[1]] = line[2]
      end
    end


    local responseKey = data["Sec-WebSocket-Key"] .. '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
    responseKey = b64.encode(sha1.binary(responseKey))
    
    return  "HTTP/1.1 101 Switching Protocols\r\n"
          .."Connection: Upgrade\r\n"
          .."Upgrade: websocket\r\n"
          .."Sec-WebSocket-Accept: " .. responseKey .. "\r\n"
          .."\r\n"
end