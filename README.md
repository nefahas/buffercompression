# buffercompression
https://create.roblox.com/store/asset/102777072380082/Compression

roblox remote event / remote function compression based on buffers
not very documented or exported much since i made this for myself and for entertainment, but it works like this

-- SERVER:

	local compression = require(ReplicatedStorage.Compression) -- require the module

	local newRem = compression.new('unreliable', 'anything') -- create a new replicator and packet
	local remote = newRem.connector -- this is the actual remote event instance

	newRem:connect(function(player: Player, ...) -- actually connects the remote to a function, auto determines if on server or not
		warn(player, ...)
	end)
	
	newRem:sendToAllClients('Hi')
	
	newRem:sendToClient(game.Players.Player1, 'Hi')
	
for remote functions:
	
	newRem:getFromFunc(game.Players.Player1, ...) -- properly returns what is specified (eg. a dictionary) from the client

CLIENT:
due to how i made this, you have to wait for the remote usually
if you have already made remotes in the game, you can do this on the server the exact same way as this v

	local rem = ReplicatedStorage:WaitForChild('Hi')

	local compression = require(ReplicatedStorage.Compression)

	local rem = compression.new('unreliable', 'anything', rem)
	
	rem:connect(function()
		-- on client event / on client invoke
	end)
	
	rem:sendToServer(...) -- send type to server (eg. anything)

 
if you only want a packet that can read / write specific buffers on a type:

	compressionmodule.newPacket(type: string): packet


for the whole replicator and a remote handled by it (for proper server <-> client communication)
this method calls .newPacket internally

	compressionmodule.new(type: string): replicator

all types:

	  anything,
	  array,
	  bool,
	  brickcolor,
	  cframe,
	  color3,
	  dictionary,
	  enum,
	  float32,
	  float64,
	  instance,
	  int16,
	  int8,
	  nil,
	  string,
	  uint16,
	  uint8,
	  vector2,
	  vector3

when creating a compression replicator, a specific type is to be specified (above: 'anything' in the .new call)
if you want to send whatever you want, use the anything type, otherwise it will try to compress only on the specific type given
^ eg: if i specify dictionary but send a number, itll fail

nothing is really pcalled or handles errors, i try to just invalidate anything but most of the time it errors so you'll know
this isnt really professionally made at all if u cant tell and i dont really like how some of it is scripted (like how i make new packets for arrays just to read it)
