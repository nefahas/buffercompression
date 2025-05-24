-- andrew10635
-- @nepaha

-- read README module under the script for documentation
local ReplicatedFirst = game:GetService('ReplicatedFirst')
local RunService = game:GetService('RunService')

local PacketModule = require(script.packet)
local ReplicationModule = require(script.replication)

local rng = Random.new()

local compressionKey = rng:NextInteger(15, 255) + rng:NextNumber(0.1, 0.4) -- to round down, make the key invalid if directly viewed without any internal knowledge

local module = {}

function module.newPacket(type: string)
	assert(typeof(type) == 'string', 'type not a valid string')
	
	return PacketModule.new(type)
end

function module.new(type: string, packetType: string, ...)
	local replicator = ReplicationModule.new(type, ...)
	local packet = module.newPacket(packetType)
	
	replicator:definePacket(packet)
	
	assert(packet.write ~= nil, 'packet was supplied invalid type "' .. packetType .. '"')
	
	return replicator
end

-- got told to add a key system
-- it just offsets strings any anything that works off strings (eg. enums, instances) by n bits so theyre unreadable in buffer.tostring()
-- i didnt feel like implementing it to everything else but it could be good for event security / obfuscating
-- but i do think how it is right now can easily be grabbed by an exploiter with any getgc capabilities and it definitely could be implemented better
-- but i dont really want to deal with that
do
	if RunService:IsServer() then
		script:AddTag(tonumber(compressionKey))
		local rem = Instance.new('RemoteEvent')
		rem.Name = 'Test'
		rem.Parent = script
		
		local keyComp = module.new('reliable', 'uint8', rem)
		local handled = {}
		
		keyComp:connect(function(player: Player, a: number)
			if not table.find(handled, player) and a == 1 then
				table.insert(handled, player)
				keyComp:sendToClient(player, compressionKey)
			end
		end)
		
		task.wait()
		
		script.compAlgClient.Value.Value = script
		
		script.compAlgClient.Enabled = true
		script.compAlgClient.Parent = game:GetService('StarterGui')
	end
end

return module
