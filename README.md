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
	
	newRem:sendToAllClients('Hi') -- sends to all clients (equiv. of fireallclients, works on remotefunctions but any exploiters could cause it to yield)
	
	newRem:sendToClient(game.Players.Player1, 'Hi') -- send to specific client
	
for remote functions:
	
	newRem:getFromFunc(game.Players.Player1, ...) -- properly returns what is specified (eg. a dictionary) from the client

CLIENT:

due to how i made this, you have to wait for the remote usually

if you have already made remotes in the game, you can do this on the server the exact same way as this v (put the event in the 3rd argument of the .new method)

	local rem = ReplicatedStorage:WaitForChild('Hi')

	local compression = require(ReplicatedStorage.Compression)

	local rem = compression.new('unreliable', 'anything', rem)
	
	rem:connect(function(...)
		-- on client event / on client invoke
  		print(...)
	end)
	
	rem:sendToServer(...) -- send type to server (eg. anything)

 
if you only want a packet that can read / write specific buffers on a type:

	compressionmodule.newPacket(type: string): packet


for the whole replicator and a remote handled by it (for proper server <-> client communication)

this method calls .newPacket internally

	compressionmodule.new(type: string): replicator

all types supported:

	anything, (eg: :sendToServer('hi', {}, true, false, 100, workspace))
	array, (eg: :sendToserver({Hi, true, false, 10}) (number indexes)
	bool, (eg: :sendToServer(true))
	brickcolor, (eg: :sendToServer(BrickColor.White()))
	cframe, (eg: :sendToServer(CFrame.identity))
	color3, (eg: :sendToServer(Color3.new(1, 0.5, 0.25)))
	dictionary, (eg: :sendToServer({hi = true, wow = {hey = false}, [workspace] = 'Hi'}))
	enum, (eg: :sendToServer(Enum.UserInputType.MouseButton1))
	float32, (eg: :sendToServer(3.14159265359)) -- 32 bit
	float64, (eg :sendTosServer(3.14159265359)) -- 64 bit equiv of float32
	instance, (eg :sendToServer(workspace))
	int16, (eg: :sendToServer(32767))
	int8, (eg: :sendToServer(127))
	nil, (eg: :sendToServer())
	string, (eg: :sendToServer('Hi'))
	uint16, (eg: :sendToServer(65535))
	uint8, (eg: :sendToServer(255))
	vector2, (eg: :sendToServer(Vector2.zero))
	vector3, (eg: :sendToServer(Vector3.zero))
 	udim2, (eg: :sendToServer(UDim2.new(0.5, 100, 0.25, 100)))
  	udim (eg:  :sendToServer(UDim.new(0.5, 100)))

when creating a compression replicator, a specific type is to be specified (above: 'anything' in the .new call)

if you want to send whatever you want, use the anything type, otherwise it will try to compress only on the specific type given

^ eg: if i specify dictionary but send a number, itll fail

nothing is really pcalled or handles errors, i try to just invalidate anything but most of the time it errors so you'll know if something is wrong

this isnt really professionally made at all if u cant tell and i dont really like how some of it is scripted (like how i make new packets for arrays just to read it)
