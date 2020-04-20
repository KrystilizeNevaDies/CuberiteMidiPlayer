



--[[
Instructions

Convert your midi into a midi text document using http://flashmusicgames.com/midi/mid2txt.php



Replace the midi Test Document at the bottom of this file.





]]










function Initialize(Plugin)
	PLUGIN = Plugin;
	
    
    
    
    -- Here is where you set the tempo
    -- It may not be accurate, but it is an approximation
    
    
    Tempo = 200
    
    
    
    
    
    
    
	Plugin:SetName("Music");
	Plugin:SetVersion(1);
	
	local cPluginManager = cRoot:Get():GetPluginManager();
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoin);
    cPluginManager:AddHook(cPluginManager.HOOK_PLUGINS_LOADED, OnPluginsLoad);
    cPluginManager:AddHook(cPluginManager.HOOK_SERVER_PING, OnPing);


	Table = {}

	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion())
	return true;
end




function OnPing(ClientHandle, ServerDescription, OnlinePlayers, MaxPlayers, Favicon)
    local newDescription = ClientHandle:GetClientBrand()
     
    return false, newDescription, OnlinePlayers, MaxPlayers, Favicon
end




function OnPlayerJoin(Player)
    local World = Player:GetWorld()
    World:ScheduleTask(10, function (Player)
        local TotalTime = math.sqrt(#Table) * 60
        local Delta = 0
        for K, T in pairs(Table) do
            -- local Delta = (T[1]/Table[#Table][1]) * TotalTime
            local Delta = T[1] / (Tempo)
            
            World:ScheduleTask(math.floor(Delta), function ()
                cRoot:Get():ForEachPlayer(function (Player)
                    Player:GetWorld():BroadcastSoundEffect("block.note.harp", Player:GetPosition(), T[4], T[3])
                end)
            end)
        end
    end)
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
        end
    end
    for k, v in spairs(Table, function(t,a,b) return tonumber(t[a][1]) < tonumber(t[b][1]) end) do
        table.insert(ReturnValue, k, v)
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





                    -- Beginning of file
    MidiFile = [=[
MFile 0 1 1024
MTrk
0 TimeSig 3/4 24 8
0 Tempo 413793
0 Tempo 413793
0 KeySig 254 major
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=16 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=15 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=14 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=13 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=12 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=11 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=10 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=9 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=8 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=7 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=6 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=5 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=4 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=3 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=2 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 PrCh ch=1 p=0
0 Par ch=1 c=7 v=120
3 Par ch=1 c=101 v=0
3 Par ch=1 c=100 v=0
3 Par ch=1 c=101 v=0
3 Par ch=1 c=100 v=0
4 Par ch=1 c=6 v=12
4 Par ch=1 c=6 v=12
5 Par ch=1 c=38 v=0
5 Par ch=1 c=38 v=0
10 On ch=1 n=46 v=53
11 Tempo 413793
435 Off ch=1 n=46 v=0
1050 On ch=1 n=53 v=50
1451 Off ch=1 n=53 v=0
1536 Tempo 413793
1792 Tempo 416666
2048 Tempo 416666
2066 On ch=1 n=53 v=52
2304 Tempo 419580
2457 Off ch=1 n=53 v=0
2560 Tempo 419580
2816 Tempo 422535
3072 Tempo 413793
3076 On ch=1 n=50 v=54
3507 Off ch=1 n=50 v=0
4122 On ch=1 n=53 v=50
4523 Off ch=1 n=53 v=0
4608 Tempo 413793
4864 Tempo 416666
5120 Tempo 416666
5138 On ch=1 n=53 v=52
5376 Tempo 419580
5529 Off ch=1 n=53 v=0
5632 Tempo 419580
5888 Tempo 422535
6144 Tempo 413793
6148 On ch=1 n=46 v=53
6579 Off ch=1 n=46 v=0
7194 On ch=1 n=53 v=50
7595 Off ch=1 n=53 v=0
7680 Tempo 413793
7936 Tempo 416666
8192 Tempo 416666
8210 On ch=1 n=53 v=52
8448 Tempo 419580
8601 Off ch=1 n=53 v=0
8704 Tempo 419580
8960 Tempo 422535
9216 Tempo 413793
9220 On ch=1 n=50 v=54
9651 Off ch=1 n=50 v=0
10266 On ch=1 n=53 v=50
10667 Off ch=1 n=53 v=0
10752 Tempo 413793
11008 Tempo 416666
11264 Tempo 416666
11282 On ch=1 n=53 v=52
11520 Tempo 419580
11673 Off ch=1 n=53 v=0
11776 Tempo 419580
12032 Tempo 422535
12288 Tempo 413793
12292 On ch=1 n=58 v=49
12292 On ch=1 n=46 v=53
12723 Off ch=1 n=46 v=0
13338 On ch=1 n=53 v=50
13739 Off ch=1 n=53 v=0
13824 Tempo 413793
14080 Tempo 416666
14336 Tempo 416666
14354 On ch=1 n=53 v=52
14592 Tempo 419580
14745 Off ch=1 n=53 v=0
14848 Tempo 419580
15104 Tempo 422535
15360 Tempo 413793
15364 On ch=1 n=57 v=49
15364 On ch=1 n=50 v=54
15481 Off ch=1 n=58 v=0
15795 Off ch=1 n=50 v=0
16410 On ch=1 n=53 v=50
16811 Off ch=1 n=53 v=0
16896 Tempo 413793
17152 Tempo 416666
17408 Tempo 416666
17426 On ch=1 n=53 v=52
17664 Tempo 419580
17817 Off ch=1 n=53 v=0
17920 Tempo 419580
18176 Tempo 422535
18432 Tempo 413793
18436 On ch=1 n=58 v=49
18436 On ch=1 n=46 v=53
18553 Off ch=1 n=57 v=0
18867 Off ch=1 n=46 v=0
19482 On ch=1 n=53 v=50
19883 Off ch=1 n=53 v=0
19968 Tempo 413793
20224 Tempo 416666
20480 Tempo 416666
20498 On ch=1 n=55 v=49
20498 On ch=1 n=53 v=52
20578 Off ch=1 n=58 v=0
20736 Tempo 419580
20889 Off ch=1 n=53 v=0
20992 Tempo 419580
21248 Tempo 422535
21504 Tempo 413793
21508 On ch=1 n=57 v=49
21508 On ch=1 n=50 v=54
21543 Off ch=1 n=55 v=0
21939 Off ch=1 n=50 v=0
22554 On ch=1 n=58 v=49
22554 On ch=1 n=53 v=50
22593 Off ch=1 n=57 v=0
22955 Off ch=1 n=53 v=0
23040 Tempo 413793
23296 Tempo 416666
23552 Tempo 416666
23570 On ch=1 n=55 v=44
23570 On ch=1 n=53 v=52
23609 Off ch=1 n=58 v=0
23808 Tempo 419580
23961 Off ch=1 n=53 v=0
24064 Tempo 419580
24320 Tempo 422535
24575 Off ch=1 n=55 v=0
24576 Tempo 413793
24580 On ch=1 n=57 v=49
24580 On ch=1 n=48 v=53
25011 Off ch=1 n=48 v=0
25626 On ch=1 n=53 v=50
26027 Off ch=1 n=53 v=0
26112 Tempo 413793
26368 Tempo 416666
26624 Tempo 416666
26642 On ch=1 n=60 v=49
26642 On ch=1 n=53 v=52
26722 Off ch=1 n=57 v=0
26880 Tempo 419580
27033 Off ch=1 n=53 v=0
27136 Tempo 419580
27392 Tempo 422535
27648 Tempo 413793
27652 On ch=1 n=62 v=49
27652 On ch=1 n=51 v=54
27687 Off ch=1 n=60 v=0
28083 Off ch=1 n=51 v=0
28698 On ch=1 n=53 v=50
29099 Off ch=1 n=53 v=0
29184 Tempo 413793
29440 Tempo 416666
29696 Tempo 416666
29714 On ch=1 n=59 v=49
29714 On ch=1 n=53 v=52
29794 Off ch=1 n=62 v=0
29952 Tempo 419580
30105 Off ch=1 n=53 v=0
30208 Tempo 419580
30464 Tempo 422535
30720 Tempo 413793
30724 On ch=1 n=60 v=49
30724 On ch=1 n=48 v=53
30759 Off ch=1 n=59 v=0
31155 Off ch=1 n=48 v=0
31770 On ch=1 n=53 v=50
32171 Off ch=1 n=53 v=0
32256 Tempo 413793
32512 Tempo 416666
32768 Tempo 419580
32786 On ch=1 n=53 v=52
33024 Tempo 422535
33177 Off ch=1 n=53 v=0
33280 Tempo 425531
33536 Tempo 428571
33796 On ch=1 n=51 v=54
34048 Tempo 413793
34227 Off ch=1 n=51 v=0
34842 On ch=1 n=53 v=50
35243 Off ch=1 n=53 v=0
35858 On ch=1 n=53 v=52
36249 Off ch=1 n=53 v=0
36863 Off ch=1 n=60 v=0
36868 On ch=1 n=65 v=49
36868 On ch=1 n=53 v=49
37299 Off ch=1 n=53 v=0
37914 On ch=1 n=60 v=50
38315 Off ch=1 n=60 v=0
38400 Tempo 413793
38656 Tempo 416666
38912 Tempo 416666
38930 On ch=1 n=60 v=53
39168 Tempo 419580
39321 Off ch=1 n=60 v=0
39424 Tempo 419580
39680 Tempo 422535
39936 Tempo 413793
39940 On ch=1 n=64 v=57
39940 On ch=1 n=55 v=56
40057 Off ch=1 n=65 v=0
40371 Off ch=1 n=55 v=0
40986 On ch=1 n=60 v=59
41387 Off ch=1 n=60 v=0
42002 On ch=1 n=60 v=62
42393 Off ch=1 n=60 v=0
43012 On ch=1 n=63 v=66
43012 On ch=1 n=56 v=65
43129 Off ch=1 n=64 v=0
43443 Off ch=1 n=56 v=0
44058 On ch=1 n=60 v=68
44459 Off ch=1 n=60 v=0
45074 On ch=1 n=60 v=72
45074 On ch=1 n=60 v=71
45154 Off ch=1 n=63 v=0
45465 Off ch=1 n=60 v=0
46084 On ch=1 n=63 v=75
46084 On ch=1 n=57 v=79
46119 Off ch=1 n=60 v=0
46515 Off ch=1 n=57 v=0
47130 On ch=1 n=62 v=75
47130 On ch=1 n=60 v=75
47169 Off ch=1 n=63 v=0
47531 Off ch=1 n=60 v=0
48146 On ch=1 n=60 v=70
48146 On ch=1 n=60 v=77
48185 Off ch=1 n=62 v=0
48537 Off ch=1 n=60 v=0
49151 Off ch=1 n=60 v=0
49156 On ch=1 n=67 v=75
49156 On ch=1 n=46 v=75
49587 Off ch=1 n=46 v=0
50202 On ch=1 n=53 v=73
50603 Off ch=1 n=53 v=0
50688 Tempo 413793
50944 Tempo 416666
51200 Tempo 419580
51218 On ch=1 n=65 v=71
51218 On ch=1 n=53 v=71
51298 Off ch=1 n=67 v=0
51456 Tempo 422535
51609 Off ch=1 n=53 v=0
51712 Tempo 425531
51968 Tempo 428571
52228 On ch=1 n=63 v=69
52228 On ch=1 n=50 v=69
52263 Off ch=1 n=65 v=0
52480 Tempo 413793
52659 Off ch=1 n=50 v=0
53274 On ch=1 n=53 v=67
53675 Off ch=1 n=53 v=0
54290 On ch=1 n=62 v=60
54290 On ch=1 n=53 v=65
54370 Off ch=1 n=63 v=0
54681 Off ch=1 n=53 v=0
55295 Off ch=1 n=62 v=0
55300 On ch=1 n=62 v=62
55300 On ch=1 n=45 v=62
55731 Off ch=1 n=45 v=0
56346 On ch=1 n=60 v=60
56346 On ch=1 n=53 v=60
56385 Off ch=1 n=62 v=0
56747 Off ch=1 n=53 v=0
56832 Tempo 413793
57088 Tempo 416666
57344 Tempo 419580
57362 On ch=1 n=59 v=58
57362 On ch=1 n=53 v=58
57401 Off ch=1 n=60 v=0
57600 Tempo 422535
57753 Off ch=1 n=53 v=0
57856 Tempo 425531
58112 Tempo 428571
58372 On ch=1 n=60 v=56
58372 On ch=1 n=48 v=56
58407 Off ch=1 n=59 v=0
58624 Tempo 413793
58803 Off ch=1 n=48 v=0
59418 On ch=1 n=55 v=54
59457 Off ch=1 n=60 v=0
60434 On ch=1 n=57 v=47
60473 Off ch=1 n=55 v=0
61439 Off ch=1 n=57 v=0
61444 On ch=1 n=58 v=49
61444 On ch=1 n=46 v=53
61875 Off ch=1 n=46 v=0
62490 On ch=1 n=53 v=50
62891 Off ch=1 n=53 v=0
62976 Tempo 413793
63232 Tempo 416666
63488 Tempo 416666
63506 On ch=1 n=53 v=52
63744 Tempo 419580
63897 Off ch=1 n=53 v=0
64000 Tempo 419580
64256 Tempo 422535
64512 Tempo 413793
64516 On ch=1 n=57 v=49
64516 On ch=1 n=50 v=54
64633 Off ch=1 n=58 v=0
64947 Off ch=1 n=50 v=0
65562 On ch=1 n=53 v=50
65963 Off ch=1 n=53 v=0
66048 Tempo 413793
66304 Tempo 416666
66560 Tempo 416666
66578 On ch=1 n=53 v=52
66816 Tempo 419580
66969 Off ch=1 n=53 v=0
67072 Tempo 419580
67328 Tempo 422535
67584 Tempo 413793
67588 On ch=1 n=58 v=49
67588 On ch=1 n=46 v=53
67705 Off ch=1 n=57 v=0
68019 Off ch=1 n=46 v=0
68634 On ch=1 n=53 v=50
69035 Off ch=1 n=53 v=0
69120 Tempo 413793
69376 Tempo 416666
69632 Tempo 419580
69650 On ch=1 n=55 v=49
69650 On ch=1 n=53 v=52
69730 Off ch=1 n=58 v=0
69888 Tempo 422535
70041 Off ch=1 n=53 v=0
70144 Tempo 425531
70400 Tempo 428571
70660 On ch=1 n=57 v=49
70660 On ch=1 n=50 v=54
70695 Off ch=1 n=55 v=0
70912 Tempo 413793
71091 Off ch=1 n=50 v=0
71706 On ch=1 n=58 v=49
71706 On ch=1 n=53 v=50
71745 Off ch=1 n=57 v=0
72107 Off ch=1 n=53 v=0
72722 On ch=1 n=55 v=44
72722 On ch=1 n=53 v=52
72761 Off ch=1 n=58 v=0
73113 Off ch=1 n=53 v=0
73727 Off ch=1 n=55 v=0
73732 On ch=1 n=57 v=49
73732 On ch=1 n=45 v=53
74163 Off ch=1 n=45 v=0
74778 On ch=1 n=53 v=50
75179 Off ch=1 n=53 v=0
75794 On ch=1 n=60 v=49
75794 On ch=1 n=53 v=52
75874 Off ch=1 n=57 v=0
76185 Off ch=1 n=53 v=0
76767 Off ch=1 n=60 v=0
76804 On ch=1 n=60 v=49
76804 On ch=1 n=44 v=53
77235 Off ch=1 n=44 v=0
77850 On ch=1 n=53 v=50
78251 Off ch=1 n=53 v=0
78866 On ch=1 n=59 v=49
78866 On ch=1 n=53 v=52
78946 Off ch=1 n=60 v=0
79257 Off ch=1 n=53 v=0
79876 On ch=1 n=60 v=49
79876 On ch=1 n=45 v=53
79911 Off ch=1 n=59 v=0
80307 Off ch=1 n=45 v=0
80922 On ch=1 n=53 v=50
81323 Off ch=1 n=53 v=0
81408 Tempo 413793
81664 Tempo 416666
81920 Tempo 416666
81938 On ch=1 n=53 v=52
82176 Tempo 419580
82329 Off ch=1 n=53 v=0
82432 Tempo 419580
82688 Tempo 422535
82944 Tempo 413793
82948 On ch=1 n=48 v=53
83379 Off ch=1 n=48 v=0
83994 On ch=1 n=53 v=50
84395 Off ch=1 n=53 v=0
84480 Tempo 413793
84736 Tempo 416666
84992 Tempo 419580
85010 On ch=1 n=53 v=52
85248 Tempo 422535
85401 Off ch=1 n=53 v=0
85504 Tempo 425531
85760 Tempo 428571
86015 Off ch=1 n=60 v=0
86020 On ch=1 n=62 v=49
86020 On ch=1 n=48 v=49
86272 Tempo 413793
86451 Off ch=1 n=48 v=0
87066 On ch=1 n=54 v=52
87467 Off ch=1 n=54 v=0
88082 On ch=1 n=54 v=55
88473 Off ch=1 n=54 v=0
89092 On ch=1 n=63 v=58
89092 On ch=1 n=48 v=57
89209 Off ch=1 n=62 v=0
89523 Off ch=1 n=48 v=0
90138 On ch=1 n=55 v=62
90539 Off ch=1 n=55 v=0
91154 On ch=1 n=64 v=65
91154 On ch=1 n=55 v=65
91234 Off ch=1 n=63 v=0
91545 Off ch=1 n=55 v=0
92164 On ch=1 n=67 v=68
92164 On ch=1 n=48 v=67
92199 Off ch=1 n=64 v=0
92595 Off ch=1 n=48 v=0
93210 On ch=1 n=57 v=71
93611 Off ch=1 n=57 v=0
94226 On ch=1 n=57 v=75
94617 Off ch=1 n=57 v=0
95236 On ch=1 n=65 v=78
95236 On ch=1 n=53 v=78
95353 Off ch=1 n=67 v=0
95667 Off ch=1 n=53 v=0
96282 On ch=1 n=57 v=81
96683 Off ch=1 n=57 v=0
97298 On ch=1 n=69 v=84
97298 On ch=1 n=57 v=84
97378 Off ch=1 n=65 v=0
97689 Off ch=1 n=57 v=0
98308 On ch=1 n=70 v=88
98308 On ch=1 n=48 v=92
98343 Off ch=1 n=69 v=0
98739 Off ch=1 n=48 v=0
99354 On ch=1 n=58 v=89
99755 Off ch=1 n=58 v=0
100370 On ch=1 n=58 v=91
100761 Off ch=1 n=58 v=0
101380 On ch=1 n=69 v=88
101380 On ch=1 n=52 v=93
101497 Off ch=1 n=70 v=0
101811 Off ch=1 n=52 v=0
102426 On ch=1 n=58 v=89
102827 Off ch=1 n=58 v=0
103442 On ch=1 n=67 v=88
103442 On ch=1 n=58 v=91
103522 Off ch=1 n=69 v=0
103833 Off ch=1 n=58 v=0
104452 On ch=1 n=65 v=83
104452 On ch=1 n=53 v=88
104487 Off ch=1 n=67 v=0
104883 Off ch=1 n=53 v=0
105498 On ch=1 n=57 v=82
105899 Off ch=1 n=57 v=0
106514 On ch=1 n=60 v=75
106905 Off ch=1 n=60 v=0
107519 Off ch=1 n=65 v=0
107524 On ch=1 n=53 v=69
107955 Off ch=1 n=53 v=0
110596 On ch=1 n=70 v=54
110596 On ch=1 n=46 v=53
111027 Off ch=1 n=70 v=0
111027 Off ch=1 n=46 v=0
113665 Meta TrkEnd
TrkEnd
    ]=] -- END OF FILE DO NOT GO PASS HERE
    
    
    
    
    Table = ParseMidi(MidiFile)
    cRoot:Get():ForEachPlayer(function (Player)
        OnPlayerJoin(Player)
    end)
end