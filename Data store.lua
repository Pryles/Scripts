--[[
	Credits: iPryle
	
	This is made for educational purposes only.
]]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Players = game:GetService("Players")
local Binary = require(ReplicatedStorage.Modules.Binary)

local Datas = {}
local Values = {
	{"Coins", "IntValue", 0},
	{"Diamonds", "IntValue", 0}
}

for Index, Value in Values do
	Datas[Value[1]] = DataStoreService:GetDataStore(Value[1])
end

local function GetAsync(Key: string,Name: string)
	assert(Datas[Name], "Error, try again later")

	return Datas[Name]:GetAsync(Key)
end

local function SetAsync(Key: string, Name: string, Value)
	Datas[Name]:SetAsync(Key, Value)
end

local function PlayerAdded(Player: Player & {[any]: any})
	local Key = tostring(Binary:EncodeTable({Player.UserId}))
	local Leaderboard = Instance.new("Folder", Player)
	Leaderboard.Name = "leaderstats"
	
	for _, Value in Values do
		local Data = GetAsync(Key, Value[1])
		local Instances: ValueBase & {[any]: any} = Instance.new(Value[2], Leaderboard)
		Instances.Name = Value[1]
		
		Instances.Value = Data or Value[3]
	end
end

local function PlayerRemoving(Player: Player & {[any]: any, any: any})
	local Key = tostring(Binary:EncodeTable({Player.UserId}))
	
	for _, Value: ValueBase & {[any]: any} in Player.leaderstats:GetChildren() do
		SetAsync(Key, Value.Name, Value.Value)
	end
end

local function BindToClose()
	for _, Player in Players:GetPlayers() do
		local Key = tostring(Binary:EncodeTable({Player.UserId}))
		
		for _, Value: ValueBase & {[any]: any, any: any} in Player.leaderstats:GetChildren() do
			SetAsync(Key, Value.Name, Value.Value)
		end
	end
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)

game:BindToClose(BindToClose)
