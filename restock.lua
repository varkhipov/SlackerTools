local Restock = CreateFrame('Frame', 'RestockFrame')

function Restock:GetRestockItems()
    return {
        ['Coarse Thread'] = 2,
        ['Mild Spices'] = 10,
    }
end

function Restock:GetVendorItems(restockItems)
    local items = {}
    for vendorItemIndex = 1, GetMerchantNumItems() do
        local name=select(1, GetMerchantItemInfo(vendorItemIndex))

        if (restockItems[name]) then
            -- [Item Name] = VendorItemIndex
            items[name] = vendorItemIndex
        end
    end
    return items
end

function Restock:GetPlayerItems(restockItems)
    local items = {}
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            local id = GetContainerItemID(bag, slot)

            if (link and id and type(link) == "string") then
                local name = select(1, GetItemInfo(link))
                local count = select(2, GetContainerItemInfo(bag, slot))

                if (restockItems[name]) then
                    -- there could be same items in separate stacks
                    local current = items[name] or 0
                    -- [Item Name] = HowManyPlayerAlreadyHas
                    items[name] = current + count
                end
            end
        end
    end
    return items
end

function Restock:OnEvent(event)
    local itemsToRestock = Restock:GetRestockItems()
    local vendorItems = Restock:GetVendorItems(itemsToRestock)

    if (next(vendorItems) == nil) then
        return
    end

    local playerItems = Restock:GetPlayerItems(itemsToRestock)

    for itemName, desiredCount in pairs(itemsToRestock) do
        local vendorItemIndex = vendorItems[itemName]

        if (vendorItemIndex) then
            local countToBuy = 0
            local countPlayerHas = playerItems[itemName]

            if (countPlayerHas) then
                countToBuy = desiredCount - countPlayerHas
            else
                countToBuy = desiredCount
            end

            if (countToBuy > 0) then
                print('Restocking: ' .. countToBuy .. ' x [' .. itemName .. ']')
                BuyMerchantItem(vendorItemIndex, countToBuy)
            end
        end
    end
end

--Restock:RegisterEvent("PLAYER_ENTERING_WORLD")
Restock:RegisterEvent('MERCHANT_SHOW')
Restock:SetScript('OnEvent', Restock.OnEvent)
