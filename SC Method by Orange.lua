--------------[SCRIPT ROTA LUCI x GEIGER x METHODE]--------------

world_farm = "# farm.txt" -- world farm file (world:doorid)
storage_pack = "# pack.txt" -- storage pack file (world:doorid)
storage_seed = "# seed.txt" -- storage seed file (world:doorid)
world_geiger = "# geiger.txt" -- world geiger file (world:doorid)
storage_geiger = "# sgeiger.txt" -- storage geiger file (world:doorid)

storage_vial = "# vial.txt"
world_vend = "# vend.txt"
storage_wls = "# wl.txt"
world_pnb = "# pnb.txt"
world_harvest = "# harvest.txt"
world_magplant = "FREEDL"

--------------------[Delay Setting]-------------------

Delay_execute = 60000 -- ms
Delay_Method = 60 -- minutes

min_reconnect = 15 --second
max_reconnect = 20 --second

usegeiger = false
usemagplant = true

--------------------[Rota Setting]-------------------

id_seed = 4585 -- farm id seed
use_vial = true -- use vial/no
seed_drop = 50 -- seed drop after rotation
gem_limit = 20000

dynamic_delay = true -- delay based on your ping
auto_rest = false -- rest 10 minutes after 1 farm done
harvest_leveling = true -- leveling until bot can break farmables
visit_random = false -- join random world after drop pack/seed

auto_fill = true -- auto fill your farm with seed in the storage
ignore_plant = false

pnb_home = false -- pnb in bot home world
pnb_other = true -- pnb in other world

--------------------[Don't Touch]--------------------

bot = getBot()
bot:getConsole().enabled = true

--------------------[Malady Settings]-------------------- 

bot.auto_malady.auto_vial = use_vial
sleep(10)
if use_vial then
    bot.auto_malady.auto_grumbleteeth = false
    sleep(10)
    bot.auto_malady.auto_chicken_feet = false
    sleep(10)
else
    bot.auto_malady.auto_grumbleteeth = true
    sleep(10)
    bot.auto_malady.auto_chicken_feet = true
    sleep(10)
end

--------------------[Transfer Settings]-------------------- 

bot.auto_transfer.auto_vend = true
sleep(10)
bot.auto_transfer.itemid = 2204
sleep(10)
bot.auto_transfer.buy_price = 1
sleep(10)

--------------------[Rotation Settings]-------------------- 

bot.gem_limit = gem_limit
sleep(10)
bot.rotation.pnb_in_home = pnb_home
sleep(10)
bot.rotation.auto_fill = auto_fill
sleep(10)
bot.rotation.seed_drop_amount = seed_drop
sleep(10)
bot.rotation.dynamic_delay = dynamic_delay
sleep(10)
bot.rotation.auto_rest = auto_rest
sleep(10)
bot.rotation.harvest_until_level = harvest_leveling
sleep(10)
bot.rotation.visit_random_worlds = visit_random
sleep(10)
bot.rotation.custom_position = pnb_other
sleep(10)
bot.rotation.ignore_plant = ignore_plant
sleep(10)
bot.min_reconnect = min_reconnect
bot.max_reconnect = max_reconnect
--------------------[function read]--------------------

function readWorlds(filename)
    worlds = {} -- Tabel untuk menyimpan dunia
    file = io.open(filename, "r")
    if file then
        for line in file:lines() do
            table.insert(worlds, line)
        end
        file:close()
    end
    return worlds
end

world_list_farm = readWorlds(world_farm)
world_list_pack = readWorlds(storage_pack)
world_list_seed = readWorlds(storage_seed)
world_list_geiger = readWorlds(world_geiger)
world_manager = getWorldManager()


if bot.index == 1 then
    for _, str in ipairs(world_list_farm) do
        world_manager:addFarm(str..":"..id_seed)
    end
    for _, str in ipairs(world_list_pack) do
        world_manager:addStorage(str)
    end
    for _, str in ipairs(world_list_seed) do
        world_manager:addStorage(str, StorageType.seed, id_seed)
    end
    for _, str in ipairs(world_list_geiger) do
        bot.auto_geiger.addWorld(str)
    end
    sleep(1131)
    bot.auto_geiger.spread()
	else
    sleep(1131)
    bot.auto_geiger.spread()
end

--------------------[function read]--------------------

function readWorld(filename, index)
    file = io.open(filename, "r")
    for i = 1, index do
        line = file:read("*l")
        if line == nil then
            file:close()
            return nil
        end
    end
    file:close()
    return line
end

for i = 1, bot.index do
    world_name_vial = readWorld(storage_vial, i)
    world_name_pnb = readWorld(world_pnb, i)
    world_name_vend = readWorld(world_vend, i)
    world_name_harvest = readWorld(world_harvest, i)

    if world_name_vial then
        bot.auto_malady.storage = readWorld(storage_vial, bot.index)
    end
    sleep(10)
    if world_name_pnb then
        bot.rotation.pnb_world = readWorld(world_pnb, bot.index)
    end
    sleep(10)
    if world_name_vend then
        bot.auto_transfer.input = readWorld(world_vend, bot.index)
    end
    sleep(10)
    if world_name_harvest then
        bot.auto_harvest:add(readWorld(world_harvest, bot.index) .. ":4585")
    end
    sleep(10)
end
--------------------[function mainScript1]--------------------

function mainScript1()
    local function status()
        local state = bot.status
        local status_Naming = { -- Credit: hitoari
            [BotStatus.offline] = "Offline",
            [BotStatus.online] = "Online",
            [BotStatus.account_banned] = "Banned",
            [BotStatus.location_banned] = "Location Banned",
            [BotStatus.server_overload] = "Login Failed",
            [BotStatus.too_many_login] = "Login Failed",
            [BotStatus.maintenance] = "Maintenance",
            [BotStatus.version_update] = "Version Update",
            [BotStatus.server_busy] = "Server Busy",
            [BotStatus.error_connecting] = "Error Connecting",
            [BotStatus.logon_fail] = "Login Failed",
            [BotStatus.http_block] = "HTTP Blocked",
            [BotStatus.wrong_password] = "Wrong Password",
            [BotStatus.advanced_account_protection] = "Advanced Account Protection",
            [BotStatus.bad_name_length] = "Bad Name Length",
            [BotStatus.invalid_account] = "Invalid Account",
            [BotStatus.guest_limit] = "Guest Limit",
            [BotStatus.changing_subserver] = "Changing Subserver",
            [BotStatus.captcha_requested] = "Captcha",
            [BotStatus.mod_entered] = "Mod Entered",
            [BotStatus.high_load] = "High Load"
        }
        return status_Naming[state] or status_Naming[BotStatus.offline]
    end

    local function reconnect()
        if status() ~= "Online" then
            while status() ~= "Online" do
                if not bot.auto_reconnect then
                    bot.auto_reconnect = true
                end
                sleep(8000)
            end
        end
    end

    local function warps(world, doorid, x, y)
        if doorid == nil or doorid == false then
            doorid = ""
        end
        ::back::
        if world ~= "" then
            if doorid == "" then
                while not bot:isInWorld(world:upper()) do
                    reconnect()
                    bot:warp(world)
                    sleep(5000)
                    local start = os.time()
                    while true do
                        if (bot:isInWorld(world:upper())) or ((os.time() - start) > 25) then
                            break
                        end
                        sleep(1000)
                    end
                end
            else
                while not bot:isInWorld(world:upper()) or getTile(bot.x, bot.y).fg == 6 do
                    reconnect()
                    bot:warp(world, doorid)
                    sleep(5000)
                    local start = os.time()
                    while true do
                        if (bot:isInWorld(world:upper()) and getTile(bot.x, bot.y).fg ~= 6) or ((os.time() - start) > 25) then
                            break
                        end
                        sleep(1000)
                    end
                end
            end
        end
        if x and y then
            while not bot:isInTile(x, y) do
                bot:findPath(x, y)
                sleep(300)
                if status() ~= "Online" then
                    reconnect()
                    goto back
                end
            end
        end
    end

    local function randomNama(panjang)
        local word = ""
        local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for i = 1, panjang do
            local randomIndex = math.random(#characters)
            word = word .. string.sub(characters, randomIndex, randomIndex)
        end
        return word
    end

    local function achivement(netid)
        bot:wrenchPlayer(netid)
        sleep(1000)
        bot:sendPacket(2, "action|dialog_return\ndialog_name|popup\nnetID|"..netid.."|\nbuttonClicked|open_personlize_profile")
        sleep(1000)
        bot:sendPacket(2, "action|dialog_return\ndialog_name|personalize_profile\nbuttonClicked|save\n\ncheckbox_show_achievements|1\ncheckbox_show_total_ach_count|1\ncheckbox_show_account_age|1")
        sleep(1000)
    end

    local function notebook(netid)
        bot:wrenchPlayer(netid)
        sleep(1000)
        bot:sendPacket(2, [[action|dialog_return
dialog_name|popup
netID|]] .. netid .. [[|
buttonClicked|notebook_edit]])
        sleep(1000)
        for i = 0, 4 do
            bot:sendPacket(2, [[action|dialog_return
dialog_name|paginated_personal_notebook_view
pageNum|]] .. i .. [[|
buttonClicked|editPnPage]])
            sleep(1000)
            bot:sendPacket(2, [[action|dialog_return
dialog_name|paginated_personal_notebook_edit
pageNum|]] .. i .. [[|
buttonClicked|save

personal_note|budiganteng yang ke ]] .. i + 1)
            sleep(1000)
        end
    end

    if not bot:isInWorld() then
        warps(randomNama(7))
    end

    for _, plr in pairs(getPlayers()) do
        if plr.name:find(bot.name) then
            bot.custom_status = "Set Achievement [0]"
            achivement(plr.netid)
            bot.custom_status = "Write Notebook [0]"
            notebook(plr.netid)
        end
    end

    local extendBp, buyclothes = false, false
    if bot:getInventory().slotcount == 16 then
        gemsNeed = 150
        extendBp, buyclothes = true, true
    elseif #bot:getInventory():getItems() + 3 <= bot:getInventory().slotcount then 
        gemsNeed = 50
        buyclothes = true
    end

    addEvent(Event.game_message, function(message)
        if message:find('available|1') then
            found = true
            unlistenEvents()
        elseif message:find('available|0') then
            found = false
            unlistenEvents()
        end
    end)

    local function findWorld()
        found = false
        local world = ""
        while true do
            reconnect()
            world = randomNama(math.random(10, 14))
            bot:sendPacket(3, 'action|validate_world\nname|' .. world)
            listenEvents(5)
            if found then
                break
            end
        end
        return world
    end

    if bot:getInventory():getItemCount(2) < 5 then
        bot.custom_status = "Farm Dirt [0]"
        local world = findWorld()
        bot.auto_collect = true
        warps(world)
        for _, tile in pairs(getTiles()) do
            if bot:getInventory():getItemCount(2) >= 5 then
                if bot:getInventory():getItemCount(3) > 0 then
                    bot:trash(3, bot:getInventory():getItemCount(3))
                    sleep(1500)
                end
                break
            end
            if tile.fg == 2 or tile.fg == 4 or tile.fg == 8 or tile.fg == 10 and getBot():getWorld().name:lower() ~= "exit" then
                if #getBot():getPath(tile.x, tile.y - 1) then
                    warps(world, "", tile.x, tile.y - 1)
                    while getTile(tile.x, tile.y).bg ~= 0 and getTile(tile.x, tile.y).fg ~= 8 and getTile(tile.x, tile.y) ~= 3760 do
                        getBot():hit(tile.x, tile.y)
                        sleep(math.random(200, 300))
                    end
                    while getTile(tile.x, tile.y + 1).bg ~= 0 and getTile(tile.x, tile.y + 1).fg ~= 8 and getTile(tile.x, tile.y + 1) ~= 3760 do
                        getBot():hit(tile.x, tile.y + 1)
                        sleep(math.random(200, 300))
                    end
                end
            end
        end
    end
	
    while bot.gem_count < 50 do
        bot.custom_status = "Harvest Gems [0]"
        bot.auto_harvest.enabled = true
        bot.auto_collect = true
    end
    bot.auto_harvest.enabled = false
    bot.auto_collect = false
    bot.custom_status = "Buy Clothes [0]"
    bot:buy("clothes")
    sleep(3500)
	
    for _, item in pairs(bot:getInventory():getItems()) do
        local id = item.id
        if getInfo(id).clothing_type > 0 then
            bot:wear(id)
            sleep(492)
        end
    end

    if extendBp then
        while bot.gem_count < 100 do
            bot.custom_status = "Harvest Gems [0]"
            bot.auto_harvest.enabled = true
            bot.auto_collect = true
        end
        bot.auto_harvest.enabled = false
        bot.auto_collect = false
        bot.custom_status = "Buy Backpack [0]"
        bot:buy("upgrade_backpack")
    end
end

--------------------[function mainScript2]--------------------

function mainScript2()
    local function takeitem()
        for i = 1, bot.index do
            world_name_wl = readWorld(storage_wls, i)
            if world_name_wl then
                storage_wl = readWorld(storage_wls, bot.index)
                while not bot:isInWorld(storage_wl) do
                    bot:warp(storage_wl)
                    sleep(2937)
                end
                if bot:isInWorld(storage_wl) then
                    for _, object in pairs(bot:getWorld():getObjects()) do
                        if object.id == 242 then
                            bot:findPath(math.floor((object.x + 10) / 32), math.floor((object.y + 10) / 32))
                            sleep(1131)
                            bot.auto_collect = true
                            sleep(1131)
                            bot.auto_collect = false
                        end
                    end
                    while bot:getInventory():getItemCount(242) > 1 do
                        bot.custom_status = "Drop WL [0]"
                        bot:sendPacket(2, "action|drop\n|itemID|242") 
                        sleep(1920)
                        bot:sendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|242|\ncount|" .. bot:getInventory():getItemCount(242) - 1) 
                        sleep(5138)
                    end
                    bot:leaveWorld()
					break
                end
            end
        end
    end
    local function buyitem()
        bot.auto_transfer.enabled = true
    end
    while bot:getInventory():getItemCount(242) == 0 do
        bot.custom_status = "Take WL [0]"
        takeitem()
        sleep(1000)
    end
    while bot:getInventory():getItemCount(2204) == 0 do
        bot.custom_status = "Buy Geiger [0]"
        buyitem()
        sleep(1000)
	end
    bot:wear(2204)
    bot.auto_transfer.enabled = false
end

--------------------[function mainScript3]--------------------

function mainScript3() 
    local function randomNama(panjang)
        ::back::
        local word = ""
        local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for i = 1, panjang do
            local randomIndex = math.random(#characters)
            word = word .. string.sub(characters, randomIndex, randomIndex)
        end
        return word
    end
	
    local teks_note = { 
        "soil world ke", 
        "kevin ganteng nomor", 
        "linda hebat banget ke", 
        "geiger yang ke", 
        "lisa juara menggambar ke", 
        "gems nya ada", 
        "aku mengunjungi indonesia negara", 
        "Beli rice yang ke", 
        "Ambil egg yang ke", 
        "Ambil arroz di block", 
		"Wilayah Seed Farm Berikut",
		"Farm Urutan Ke", 
		"Area Harvest Spot ke", 
		"sektor room block ke"
    }

    local function notebook2(netid)
        bot:wrenchPlayer(netid)
        sleep(1920)
    
        bot:sendPacket(2, [[action|dialog_return
dialog_name|popup
netID|]] .. netid .. [[| 
buttonClicked|notebook_edit]])
        sleep(1920)

        for i = 0, 4 do
            local teks_acak = teks_note[math.random(1, #teks_note)]
        
            bot:sendPacket(2, [[action|dialog_return
dialog_name|paginated_personal_notebook_view
pageNum|]] .. i .. [[|
buttonClicked|editPnPage]])
            sleep(1920)

            bot:sendPacket(2, [[action|dialog_return
dialog_name|paginated_personal_notebook_edit
pageNum|]] .. i .. [[|
buttonClicked|save

personal_note|]] .. teks_acak .. " " .. (i + 1))
            sleep(1920)
        end
    end

    local geiger_list = {1492, 1498, 1500, 2206, 2242, 2244, 2246, 2248, 2250, 2804, 2806, 3196, 3204, 3306, 3792, 4426, 4646, 4648, 4650, 4652, 4654, 4676, 4678, 4680, 4682, 6416, 8270, 8272, 8274, 9242, 10084, 10086, 10172, 10556, 10698, 11186, 11298, 12502, 12628, 13930}

    local function check_geiger_item()
        bot.custom_status = "Check Item [2]"
        for i = 1, #geiger_list do
            if bot:getInventory():getItemCount(geiger_list[i]) > 0 then
                return true
            end
        end
        return false
    end

    local function drops()
        bot.custom_status = "Drop Item [2]"
        for i = 1, bot.index do
            world_list_storage = readWorld(storage_geiger, i)
            if world_list_storage then
                storage_geigers = readWorld(storage_geiger, bot.index)
                while not bot:isInWorld(storage_geigers) do
                    bot:warp(storage_geigers)
                    sleep(2937)
                end
                if bot:isInWorld(storage_geigers) then
                    for i = 1, #geiger_list do
                        local itemIDs = geiger_list[i]
                        while bot:getInventory():getItemCount(itemIDs) > 0 do
                            bot:sendPacket(2, "action|drop\n|itemID|" .. itemIDs) 
                            sleep(1920)
                            bot:sendPacket(2, "action|dialog_return\ndialog_name|drop_item\nitemID|" .. itemIDs .. "|\ncount|" .. bot:getInventory():getItemCount(itemIDs))
                            sleep(2138)
                        end
                    end
                end
            end
        end
    end
    
    local function magplant()
        bot.custom_status = "Magplant [1]"
        while not bot:isInWorld(world_magplant) do
            bot:warp(world_magplant)
            sleep(5000)
        end
        for i, tile in pairs(getBot():getWorld():getTiles()) do
            if tile.fg == 5638 then
                bot.auto_farm.mag_x = tile.x
                sleep(10)
                bot.auto_farm.mag_y = tile.y
                sleep(10)
                break
            end
        end
        bot.auto_farm.auto_remote = true
        sleep(10)
        bot.auto_farm.auto_break = false
        sleep(10)
        bot.auto_farm.auto_place = false
        sleep(10)
        bot.auto_farm.enabled = true
        while bot:getInventory():getItemCount(5640) == 0 do
            sleep(2000)
		end
        bot.auto_farm.enabled = false
        sleep(3000)
        bot:leaveWorld()
    end
	
    local function writenote()
        bot.custom_status = "Notebook [1]"
        bot.rotation.enabled = false
        sleep(100)
        bot.auto_geiger.enabled = false
        sleep(100)
        while not bot:isInWorld() do
            bot:warp(randomNama(10))
            sleep(5000)
        end
        for _, plr in pairs(getPlayers()) do
            if plr.name:find(getLocal().name) then
                notebook2(plr.netid)
                sleep(500)
            end
        end
	end
	
    local function findgeiger()
        while bot:getInventory():getItemCount(2204) == 1 do
            bot.custom_status = "Geiger [1]"
            bot.auto_geiger.enabled = true
            sleep(2000)
        end
        bot.auto_geiger.enabled = false
        while check_geiger_item() do
            drops()
            sleep(100)
        end
        if not bot:getInventory():getItem(2286).isActive then
            bot:wear(2286)
            sleep(100)
        end
	end
	
    local trashList = {370, 138}
    local function Trash()
        for a, trash in ipairs(trashList) do
            trash_count = bot:getInventory():findItem(trash)
            if bot:getInventory():findItem(trash) > 0 then
                bot:sendPacket(2,"action|trash\n|itemID|"..trash) 
                bot:sendPacket(2,"action|dialog_return\ndialog_name|trash_item\nitemID|"..trash.."|\ncount|"..trash_count)
                sleep(1131)
            end
        end
    end

    Trash()
    sleep(1131)
    while bot.level < 12 do
        bot.custom_status = "Leveling [0]"
        bot.ignore_gems = true
        bot.rotation.enabled = true
        sleep(100)
    end
    bot.ignore_gems = false
    bot.auto_malady.enabled = true
    sleep(1131)
	
    while true do
        if bot:getInventory():getItemCount(2204) == 1 then
            if not bot:getInventory():getItem(2204).isActive then
                bot:wear(2204)
                sleep(500)
            end
            bot.rotation.break_x = math.random(2, 97)
            sleep(100)
            bot.rotation.break_y = math.random(1, 16)
            sleep(100)
            bot.rotation.enabled = true
            sleep(60000 * Delay_Method)
            writenote()
            if usemagplant then
			     magplant()
            end
            if usegeiger then
			     findgeiger()
            end
            bot.rotation.enabled = true
        end
        sleep(2000)
    end
end

function threadStatus()
    bot = getBot()
    function Rotastatus()
        if bot:getInventory():getItemCount(2204) == 1 then
            Rotatype = 1
        else
            Rotatype = 2
		end
        local customStatus = {
            [0] = "Scan World ["..Rotatype.."]",
            [1] = "Harvest Tree ["..Rotatype.."]",
            [2] = "Break Block ["..Rotatype.."]",
            [3] = "Plant Seed ["..Rotatype.."]",
            [4] = "Drop Seed ["..Rotatype.."]",
            [5] = "Drop Pack ["..Rotatype.."]",
            [6] = "Fill Seed ["..Rotatype.."]",
            [7] = "Harvest Root ["..Rotatype.."]",
            [11] = "Clear Object ["..Rotatype.."]",
            [12] = "Leveling ["..Rotatype.."]"
        }
        bot.custom_status = customStatus[bot.rotation.status] or "Unknown"
    end
    while true do
        if bot.rotation.enabled then
            Rotastatus()
        end
	    sleep(5000)
    end
end

-------------------------------- [Main Executor] --------------------------------

bot.custom_status = "Waiting [1]"
sleep(getBot().index * Delay_execute)

if bot:getInventory().slotcount == 16 then
    mainScript1()
    sleep(500)
end

if bot:getInventory():getItemCount(2204) == 0 then
    if bot:getInventory():getItemCount(2286) == 0 then
        mainScript2()
    end
end

runThread(threadStatus)
mainScript3()