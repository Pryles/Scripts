local Players = game:GetService("Players")
local DataStore = game:GetService("DataStoreService")

type Client = Player & {[any]: any}
type BaseValue = ValueBase & {[any]: any}

local Values = {
	{"Diamonds", "IntValue", 5},
	{"Ores", "IntValue", 0}
}

local DataStores = {
	Diamonds = DataStore:GetDataStore("Diamonds"),
	Ores = DataStore:GetDataStore("Ores")
}


local function LoadData(Key: string, Data: string)
	local Value = DataStores[Data]:GetAsync(Key)

	return (Value)
end

local function SaveData(Key: string, Data: string, Value: number)
	DataStores[Data]:SetAsync(Key, Value)
end

local function PlayerAdded(Player: Client)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = Player

	for _, v in next, (Values) do
		local Value: BaseValue, Data, Key: string do
			Key = tostring(Player.UserId..v[1].."!")

			Value = Instance.new(v[2])
			Value.Name = v[1]

			Data = LoadData(Key, v[1])

			Value.Value = Data or v[3]
			Value.Parent = leaderstats
		end
	end
end

local function PlayerRemoving(Player: Client)
	for _, v: BaseValue in next, (Player.leaderstats:GetChildren()) do
		local Key = tostring(Player.UserId..v.Name.."!")

		print(v.Name, v.Value)

		SaveData(Key, v.Name, v.Value)
	end
end

game:BindToClose(function()
	for _, v: Client in Players:GetPlayers() do
		for _, x: BaseValue in v.leaderstats:GetChildren() do
			local Key = tostring(v.UserId..x.Name.."!")
			SaveData(Key, x.Name, x.Value)
		end
	end
end)

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
