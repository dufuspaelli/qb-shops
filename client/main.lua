local QBCore = exports['qb-core']:GetCoreObject()
local shopNotOpen = true
-- Functions

local function SetupItems(shop)
    local products = Config.Locations[shop].products
    local playerJob = QBCore.Functions.GetPlayerData().job.name
    local items = {}
    for i = 1, #products do
        if not products[i].requiredJob then
            items[#items+1] = products[i]
        else
            for i2 = 1, #products[i].requiredJob do
                if playerJob == products[i].requiredJob[i2] then
                    items[#items+1] = products[i]
                end
            end
        end
    end
    return items
end

local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

-- Events

RegisterNetEvent('qb-shops:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('qb-shops:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('qb-shops:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('qb-shops:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] ~= nil then
        for k, v in pairs(Config.Locations[shop]["products"]) do
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

-- Threads


CreateThread(function()
	for store, _ in pairs(Config.Locations) do
		if Config.Locations[store]["showblip"] then
			StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
			SetBlipColour(StoreBlip, 0)

			if Config.Locations[store]["products"] == Config.Products["normal"] then
				SetBlipSprite(StoreBlip, 52)
				SetBlipScale(StoreBlip, 0.6)
			elseif Config.Locations[store]["products"] == Config.Products["coffeeplace"] then
				SetBlipSprite(StoreBlip, 52)
				SetBlipScale(StoreBlip, 0.6)
			elseif Config.Locations[store]["products"] == Config.Products["gearshop"] then
				SetBlipSprite(StoreBlip, 52)
				SetBlipScale(StoreBlip, 0.6)
			elseif Config.Locations[store]["products"] == Config.Products["hardware"] then
				SetBlipSprite(StoreBlip, 402)
				SetBlipScale(StoreBlip, 0.8)
			elseif Config.Locations[store]["products"] == Config.Products["weapons"] then
				SetBlipSprite(StoreBlip, 110)
				SetBlipScale(StoreBlip, 0.85)
			elseif Config.Locations[store]["products"] == Config.Products["leisureshop"] then
				SetBlipSprite(StoreBlip, 52)
				SetBlipScale(StoreBlip, 0.6)
				SetBlipColour(StoreBlip, 3)
			elseif Config.Locations[store]["products"] == Config.Products["mustapha"] then
				SetBlipSprite(StoreBlip, 225)
				SetBlipScale(StoreBlip, 0.6)
				SetBlipColour(StoreBlip, 3)
			elseif Config.Locations[store]["products"] == Config.Products["coffeeshop"] then
				SetBlipSprite(StoreBlip, 140)
				SetBlipScale(StoreBlip, 0.55)
			elseif Config.Locations[store]["products"] == Config.Products["casino"] then
				SetBlipSprite(StoreBlip, 617)
				SetBlipScale(StoreBlip, 0.70)
            elseif Config.Locations[store]["products"] == Config.Products["blackmarket"] then
                SetBlipSprite(StoreBlip, 80)
                SetBlipScale(StoreBlip, 0.70)
                SetBlipColour(StoreBlip, 69)
            end

			SetBlipDisplay(StoreBlip, 4)
			SetBlipAsShortRange(StoreBlip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
			EndTextCommandSetBlipName(StoreBlip)
		end
	end
end)

RegisterNetEvent('qb-shops:marketshop')
AddEventHandler('qb-shops:marketshop', function(shop, itemData, amount)
local PlayerPed = PlayerPedId()
local PlayerPos = GetEntityCoords(PlayerPed)

for shop, _ in pairs(Config.Locations) do
   local position = Config.Locations[shop]["coords"]
   for _, loc in pairs(position) do
      local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
      if dist < 2 then
         local ShopItems = {}
         ShopItems.items = {}
         QBCore.Functions.TriggerCallback('qb-shops:server:getLicenseStatus', function(result)
         ShopItems.label = Config.Locations[shop]["label"]
         if Config.Locations[shop].type == "weapon" then
            if result then
               ShopItems.items = Config.Locations[shop]["products"]
            else
               for i = 1, #Config.Locations[shop]["products"] do
                  if not Config.Locations[shop]["products"][i].requiresLicense then
                     table.insert(ShopItems.items, Config.Locations[shop]["products"][i])
                  end
               end
            end
         else
            ShopItems.items = Config.Locations[shop]["products"]
         end
         ShopItems.slots = 30
         TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
         end)
      end
   end
end
end)