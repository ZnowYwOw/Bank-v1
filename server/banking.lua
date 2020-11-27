--[[
────────────────────────────────────────────────
─███████╗███╗───██╗ ██████╗ ██╗────██╗██╗───██╗─  
─╚══███╔╝████╗──██║██╔═══██╗██║────██║╚██╗─██╔╝─  
───███╔╝─██╔██╗─██║██║───██║██║─█╗─██║─╚████╔╝──   
──███╔╝──██║╚██╗██║██║───██║██║███╗██║──╚██╔╝───    
─███████╗██║─╚████║╚██████╔╝╚███╔███╔╝───██║────     
─╚══════╝╚═╝──╚═══╝─╚═════╝──╚══╝╚══╝────╚═╝────     
────────────────────────────────────────────────
]]-- 

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_bank")

RegisterServerEvent("banking:getBankAmount")
AddEventHandler("banking:getBankAmount", function()
    local source = source
    local user_id = vRP.getUserId({source})
    local money = vRP.getBankMoney({user_id})
    local name = GetCharacterFirstName(source)
    TriggerClientEvent("banking:money", source, money, name)
end)

function GetCharacterFirstName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, name FROM vrp_user_identities WHERE user_id = @user_id', {
		['@user_id'] =  vRP.getUserId({source})
	})

	if result[1] and result[1].firstname and result[1].name then
		return ('%s %s'):format(result[1].firstname, result[1].name)
	end
end

RegisterServerEvent("banking:deposit")
AddEventHandler("banking:deposit", function(depositAmount, depositDate)
    local _depositAmount = tonumber(depositAmount)
    local source = source
    local user_id = vRP.getUserId({source})
    if _depositAmount == nil or _depositAmount <= 0 or _depositAmount > vRP.getMoney({user_id}) then
        TriggerClientEvent("banking:send:alert", -1, "error", "Invalid deposit")
    else
        vRP.tryDeposit({user_id,math.floor(math.abs(_depositAmount))})
        TriggerClientEvent("banking:send:alert", -1, "success", "Deposit was successful")
        MySQL.Async.execute("INSERT INTO transactions (`user_id`, `type`, `amount`, `date`) VALUES (@user_id, @type, @amount, @date);", 
        {
            user_id = user_id,
            type = "Deposit",
            amount = _depositAmount,
            date = depositDate

        }, function()
    end)
    end
end)


RegisterServerEvent("banking:withdraw")
AddEventHandler("banking:withdraw", function(withdrawAmount, withdrawDate)
    local _withdrawAmount = tonumber(withdrawAmount)
    local source = source
    local user_id = vRP.getUserId({source})
    base = vRP.getBankMoney({user_id})
    if _withdrawAmount == nil or _withdrawAmount <= 0 or _withdrawAmount > base then
        TriggerClientEvent("banking:send:alert", -1, "error", "Invalid withdraw")
    else
        vRP.tryWithdraw({user_id,math.floor(math.abs(_withdrawAmount))})
        TriggerClientEvent("banking:send:alert", -1, "success", "Withdraw was successful")
        MySQL.Async.execute("INSERT INTO transactions (`user_id`, `type`, `amount`, `date`) VALUES (@user_id, @type, @amount, @date);", 
            {
                user_id = user_id,
                type = "Withdraw",
                amount = _withdrawAmount,
                date = withdrawDate
            
            }, function()
        end)
    end
end)

RegisterServerEvent("banking:transfer")
AddEventHandler("banking:transfer", function(transferAmount, transferDate, transferName)
    local source = source
    local user_id = vRP.getUserId({source})
    local target = vRP.getUserId({transferName})
    if (target == nil or target == -1) then
        TriggerClientEvent("banking:send:alert", source, "error", "The ID is invalid")
    else
        balance = vRP.getBankMoney({user_id})
        tbalance = vRP.getBankMoney({target})

        if tonumber(source) == tonumber(transferName) then
            TriggerClientEvent("banking:send:alert", source, "error", "You cannot transfer money to yourself.")
        else
            if balance <= 0 or balance < tonumber(transferAmount) or tonumber(transferAmount) <= 0 then
                TriggerClientEvent("banking:send:alert", source, "error", "You dont have enough money in the bank.")
            else
                vRP.tryWithdraw({user_id,math.floor(math.abs(transferAmoun))})
                vRP.giveBankMoney({target,tonumber(transferAmount)})
                MySQL.Async.execute("INSERT INTO transactions (`user_id`, `type`, `amount`, `date`) VALUES (@user_id, @type, @amount, @date);", 
                    {
                        user_id = user_id,
                        type = "Transfer to " .. targetName .. "",
                        amount = transferAmount,
                        date = transferDate
            
                    }, function()
                end)
            end
        end
    end
end)

ZnowYVRP7.RegisterServerCallback('banking:get:transactions', function(source, cb)
    local source = source
    local user_id = vRP.getUserId({source})
    MySQL.Async.fetchAll("SELECT * FROM transactions WHERE user_id = @user_id ORDER BY user_id DESC" , 
        {
            ['@user_id'] = user_id
        }, function(transactions)
        cb(transactions)
    end)
end)

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function bankBalance(source)
    return vRP.getBankMoney({vRP.getUserId({source})})
end