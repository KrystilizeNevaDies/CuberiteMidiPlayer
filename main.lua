



--[[
Instructions

Convert your midi into a midi text document using http://flashmusicgames.com/midi/mid2txt.php



Replace the midi Test Document at the bottom of this file.
]]










function Initialize(Plugin)
	PLUGIN = Plugin;
	
    
    
    
    -- Here is where you set the tempo
    -- It may not be accurate, but it is an approximation
    
    -- Tempo = 20
    
    
    
    
    
    
    
	Plugin:SetName("Music");
	Plugin:SetVersion(1);
	
	local cPluginManager = cRoot:Get():GetPluginManager();
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoin);
    cPluginManager:AddHook(cPluginManager.HOOK_PLUGINS_LOADED, OnPluginsLoad);
    cPluginManager:AddHook(cPluginManager.HOOK_SERVER_PING, OnPing);
    
    cPluginManager.BindCommand("/play", "", PlayCommand, " ~ Plays a song");


	MusicTable = {}

	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion())
	return true;
end




function OnPing(ClientHandle, ServerDescription, OnlinePlayers, MaxPlayers, Favicon)
    local newDescription = ClientHandle:GetClientBrand()
     
    return false, newDescription, OnlinePlayers, MaxPlayers, Favicon
end




function OnPlayerJoin(Player)
    local World = Player:GetWorld() 
end


function PlayMusic(Table, Player, Key)

    local TotalTime = math.sqrt(#Table[Key]) * 60
    local Alpha, Delta, Tempo = 0, 0, 0
    local World = Player:GetWorld()
    for K = 1, #Table[Key] do
        local T = Table[Key][K]
        local Alpha = T[1] / (Tempo / Delta * 0.01)
        if #T == 4 then
            World:ScheduleTask(math.floor(Alpha), function ()
                Player:GetWorld():BroadcastSoundEffect("block.note.harp", Player:GetPosition(), T[4], T[3])
            end)
        elseif #T == 2 then
            Tempo = T[2]
        elseif #T == 1 then
            Delta = T[1]
        end
    end
end

function ParseMidi(File)
    local ReturnValue = {}
    local Table = {}
    local Temp = {}
    local AveragePitch = 0
    for Line in File:gmatch("([^\n]*)\n?") do
        if string.match(Line, "On") then
            local Words = {}
            Line = Line:gsub("n=", "")
            for Word in Line:gmatch("%w+") do
                Line = Line:gsub(" ", "")
                table.insert(Words, Word)
            end
            AveragePitch = AveragePitch + Words[5]
            table.insert(Temp, "")
        end
    end
    AveragePitch = AveragePitch / #Temp
    for Line in File:gmatch("([^\n]*)\n?") do
        if string.match(Line, "MFile") then
            Line = Line:gsub("MFile ", "")
            local Words = {}
            for Word in Line:gmatch("%w+") do
                Line = Line:gsub(" ", "")
                Words[1] = Word
            end
            table.insert(Table, Words)
        end
        if string.match(Line, "On") then
            local Words = {}
            Line = Line:gsub("On ", "")
            Line = Line:gsub("ch=", "")
            Line = Line:gsub("n=", "")
            Line = Line:gsub("v=", "")
            for Word in Line:gmatch("%w+") do
                Line = Line:gsub(" ", "")
                table.insert(Words, Word)
            end
            
            local Volume = Words[4] * (1/127)
            
            local Uses = Words[3] - math.floor(AveragePitch)
            
            while (Uses + 12) > AveragePitch do
                Uses = Uses - 12
            end
            while (Uses - 12) > AveragePitch do
                Uses = Uses + 12
            end
            
            
            local Pitch = math.pow(2, (Uses/12))
            
            Words[4] = Volume
            Words[3] = Pitch
            table.insert(Table, Words)
        elseif string.match(Line, "Tempo") then
            Line = Line:gsub("Tempo ", "")
            local Words = {}
            for Word in Line:gmatch("%w+") do
                Line = Line:gsub(" ", "")
                table.insert(Words, Word)
            end
            table.insert(Table, Words)
        end
    end
    for Key = 1, #Table do
        
        table.insert(ReturnValue, Key, Table[Key])
    end
    return ReturnValue
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function OnPluginsLoad()
    
    
    LoadMidis()
    
    
    cRoot:Get():ForEachPlayer(function (Player)
        OnPlayerJoin(Player)
    end)
    
    
end


function LoadMidis()
    local Directory = PLUGIN:GetLocalFolder() .. cFile:GetPathSeparator() .. "Midis" .. cFile:GetPathSeparator()
    local Contents = cFile:GetFolderContents(Directory)
    for _, File in pairs(Contents) do
        local Table = {}
        for str in string.gmatch(File, "([^.]+)") do
            table.insert(Table, str)
        end
        if #Table > 1 then
            if (string.sub(File, #File -3, #File) == ".txt") then
                print("Processing: " .. Directory .. File)
                local Value = ParseMidi(cFile:ReadWholeFile(Directory .. File))
                local Key = string.sub(File, 1, #File -4)
                MusicTable[Key] = Value
			end
        end
    end
end



function PlayCommand(Split, Player)
    local Query = false
    for Key,_ in pairs(MusicTable) do
        if Key == Split[2] then
            Query = true
        end
    end
    if Query then
        PlayMusic(MusicTable, Player, Split[2])
        return true
    else
        return false
    end
end

