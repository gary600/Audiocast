--[[

Audiocast - audio broadcast system
by Gary600 / G-Soft Develoment

]]--

local c = require("component")
local json = require("JSON")
local modem = c.modem


-- Constants
PORT = 56
CHUNKSIZE = 512

-- Other vars
isRunning = true

-- Grab the cast programming
progf = io.open("programming.json")
prog = json:decode(progf:read("*all"))
progf:close()

-- Open the port
modem.open(56)

while isRunning do
  for _, v in pairs(prog.programming) do
    programf = io.open("dfpwm/" .. v.file, "rb")
    program = programf:read("*all")
    programf:close()

    for i=1, math.ceil(#program/CHUNKSIZE) do
      chunk = program.sub(((i-1)*CHUNKSIZE)+1, i*CHUNKSIZE)
      modem.broadcast(PORT, v.title, chunk)
      os.sleep(0.5)
      print("Sending chunk " .. tostring(i) .. " of file " .. v)
    end
  end
  if not prog.info.loop then isRunning = false end
end
