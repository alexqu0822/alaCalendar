--[[--
	by ALA
--]]--

local __version = 250401.0;

local _G = _G;
_G.__ala_meta__ = _G.__ala_meta__ or {  };
local __ala_meta__ = _G.__ala_meta__;

-->			versioncheck
	local __coder = __ala_meta__.__coder;
	if __coder ~= nil and __coder.__minor >= __version then
		return;
	elseif __coder == nil then
		__coder = CreateFrame('FRAME');
		__ala_meta__.__coder = __coder;
	else
		if __coder.Halt ~= nil then
			__coder:Halt();
		else
			if __coder.Update then
				__coder:Update({  }, {  }, function() return { "", 0, 0, 0, 0, 0, }; end);
			end
			__coder = CreateFrame('FRAME');
			__ala_meta__.__coder = __coder;
		end
	end
	__coder.__minor = __version;
-->

local After = C_Timer.After;

local ISRETAIL = __ala_meta__.TOC_VERSION >= 90000;
local ISCLASSIC = __ala_meta__.TOC_VERSION < 20000;
local ISBCC = __ala_meta__.TOC_VERSION >= 20000 and __ala_meta__.TOC_VERSION < 30000;
local ISWLK = __ala_meta__.TOC_VERSION >= 30000 and __ala_meta__.TOC_VERSION < 40000;
local ISCATA = __ala_meta__.TOC_VERSION >= 40000 and __ala_meta__.TOC_VERSION < 50000;
local ISMOP = __ala_meta__.TOC_VERSION >= 50000 and __ala_meta__.TOC_VERSION < 90000;

local DEVELOPER = nil;
if ISRETAIL then
	DEVELOPER = {
		--	Mainline
		["Player-962-0509AC92"] = "B",	--	"燃烧之刃.ALEX.WARRIOR",
		["Player-962-04FEC839"] = "B",	--	"燃烧之刃.ALEX.MAGE",
		["Player-962-0509E004"] = "B",	--	"燃烧之刃.ALEX.PALADIN",
		["Player-962-0509E001"] = "B",	--	"燃烧之刃.ALEX.DRUID",
		["Player-962-0509E049"] = "B",	--	"燃烧之刃.ALEX.PRIEST",
		--
		["Player-962-0509ACEF"] = "G",	--	"燃烧之刃.ANDREA.MAGE",
		["Player-962-0508A77F"] = "G",	--	"燃烧之刃.ANDREA.DRUID",
		["Player-962-0508A6CC"] = "G",	--	"燃烧之刃.ANDREA.SHAMAN",
		["Player-962-0508ADA1"] = "G",	--	"燃烧之刃.ANDREA.HUNTER",
		["Player-962-0508AD8B"] = "G",	--	"燃烧之刃.ANDREA.WARRIOR",
		["Player-962-0508ADDC"] = "G",	--	"燃烧之刃.ANDREA.PRIEST",
		["Player-962-0508AD43"] = "G",	--	"燃烧之刃.ANDREA.PALADIN",
		["Player-962-0508AD11"] = "G",	--	"燃烧之刃.ANDREA.ROGUE",
		["Player-962-04FF445B"] = "G",	--	"燃烧之刃.ANDREA.PALADIN-MINUS",
		["Player-962-0509EA70"] = "G",	--	"燃烧之刃.ANDREA.PRIEST-MINUS",
		--
		["Player-962-05469808"] = "B",	--	"金色平原.ALEX.WARRIOR"
		["Player-962-04FEC839"] = "B",	--	"金色平原.ALEX.MAGE"
		--
		["Player-962-0509ACEF"] = "G",	--	"金色平原.ANDREA.MAGE"
		["Player-962-0508A6CC"] = "G",	--	"金色平原.ANDREA.SHAMAN"
		-- ["Player-962-0509ADA1"] = "G",	--	"金色平原.ANDREA.DRUID"
	};
elseif ISCLASSIC then
	DEVELOPER = {
		--	Classic
		["Player-5376-05B22FA4"] = "B",	--	"哈霍兰.ALEX.PALADIN"
	};
else
	DEVELOPER = {
		--	BCC
		["Player-4497-0388473F"] = "B",	--	"碧玉矿洞.ALEX.WARRIOR"
		["Player-4497-039DF9BC"] = "B",	--	"碧玉矿洞.ALEX.PRIEST"
		["Player-4497-038D0E9A"] = "B",	--	"碧玉矿洞.ALEX.PALADIN"
		["Player-4497-054BAC83"] = "B",	--	"碧玉矿洞.ALEX.ROGUE"
		["Player-4497-0507173B"] = "B",	--	"碧玉矿洞.ALEX.DEATHKNIGHT"
		["Player-4497-039DEE62"] = "B",	--	"碧玉矿洞.ALEX.DRUID"
		["Player-4497-0392FA91"] = "B",	--	"碧玉矿洞.ALEX.MAGE"
		["Player-4497-038E14E4"] = "B",	--	"碧玉矿洞.ALEX.SHAMAN"
		["Player-4497-03F0D909"] = "B",	--	"碧玉矿洞.ALEX.HUNTER"
		["Player-4497-040FF31B"] = "B",	--	"碧玉矿洞.ALEX.WARLOCK"
		["Player-4497-04105E08"] = "B",	--	"碧玉矿洞.ALEX.ROGUE.MINOR"
		--
		["Player-4497-03985947"] = "G",	--	"碧玉矿洞.ANDREA.PRIEST"
		["Player-4497-03871A80"] = "G",	--	"碧玉矿洞.ANDREA.SHAMAN"
		["Player-4497-0395C790"] = "G",	--	"碧玉矿洞.ANDREA.HUNTER"
		["Player-4497-04FE92E9"] = "G",	--	"碧玉矿洞.ANDREA.DEATHKNIGHT"
		["Player-4497-03C3B443"] = "G",	--	"碧玉矿洞.ANDREA.MAGE"
		["Player-4497-040C3C57"] = "G",	--	"碧玉矿洞.ANDREA.PALADIN"
		["Player-4497-04102FBE"] = "G",	--	"碧玉矿洞.ANDREA.WARLOCK"
		["Player-4497-0516E2C2"] = "G",	--	"碧玉矿洞.ANDREA.WARRIOR"
		["Player-4497-0410343D"] = "G",	--	"碧玉矿洞.ANDREA.ROGUE"
		["Player-4497-0519E8E8"] = "G",	--	"碧玉矿洞.ANDREA.DRUID"
		["Player-4497-03F6B362"] = "G",	--	"碧玉矿洞.ANDREA.DRUID"
		["Player-4497-04102EFE"] = "G",	--	"碧玉矿洞.ANDREA.WARRIOR.MINOR"
		["Player-4497-03B5A603"] = "G",	--	"碧玉矿洞.ANDREA.MAGE.MINOR"
		--
		["Player-4497-03FC5121"] = "D",	--	"碧玉矿洞.ALA.MAGE.HORDE"
		["Player-4497-03FBAEC1"] = "D",	--	"碧玉矿洞.ALA.MAGE.HORDE.MINOR"
		["Player-4497-03F67EA5"] = "D",	--	"碧玉矿洞.ALA.MAGE.ALLIANCE"
		["Player-4497-040F5394"] = "D",	--	"碧玉矿洞.ALA.WARRIOR"
		["Player-4497-040FF486"] = "D",	--	"碧玉矿洞.ALA.PALADIN"
		["Player-4497-040F5184"] = "D",	--	"碧玉矿洞.ALA.ROGUE"
		--
		["Player-4497-0393B39E"] = "D",	--	"碧玉矿洞.NETEASEUI"
		--
		["Player-4791-00891F9F"] = "B",	--	"碧空之歌.ALEX.WARRIOR"
		["Player-4791-010E9724"] = "B",	--	"碧空之歌.ALEX.MAGE"
		["Player-4791-01680518"] = "B",	--	"碧空之歌.ALEX.WARLOCK"
		["Player-4791-01480730"] = "B",	--	"碧空之歌.ALEX.PALADIN"
		["Player-4791-010EBD53"] = "B",	--	"碧空之歌.ALEX.DRUID"
		["Player-4791-0136A10C"] = "B",	--	"碧空之歌.ALEX.ROGUE"
		["Player-4791-00E26C49"] = "B",	--	"碧空之歌.ALEX.HUNTER"
		["Player-4791-02840797"] = "B",	--	"碧空之歌.ALEX.WARRIOR.MINOR"
		["Player-4791-0088F6CB"] = "B",	--	"碧空之歌.ALEX.PALADIN.MINOR"
		--
		["Player-4791-0088F61D"] = "G",	--	"碧空之歌.ANDREA.PRIEST"
		["Player-4791-00DE4CF1"] = "G",	--	"碧空之歌.ANDREA.HUNTER"
		["Player-4791-010B0B3C"] = "G",	--	"碧空之歌.ANDREA.PALADIN"
		["Player-4791-0136A0D6"] = "G",	--	"碧空之歌.ANDREA.ROGUE"
		["Player-4791-02139522"] = "G",	--	"碧空之歌.ANDREA.MAGE"
		["Player-4791-02139923"] = "G",	--	"碧空之歌.ANDREA.WARLOCK"
	};
end
local TITLELIST = {
	B = --[[IsAddOnLoaded("!!!163UI!!!") and "网易有爱开发者" or ]]"夜空中最亮的星",
	G = --[[IsAddOnLoaded("!!!163UI!!!") and "网易有爱开发者" or ]]"宇宙无敌兔姐姐",
	D = "网易有爱开发者",
};
if ISCLASSIC then
	local FILELIST = {
		--	file, z, x, y, alpha, rotate
		["*"] = { "spells/creature_spellportal_blue.m2", 4, 0, 1, 1, 0.0, },
		[1] = { "spells/creature_spellportal_blue.m2", 4, 0, 1, 1, 0.0, },
		[2] = { "spells/creature_spellportal_purple.m2", 4, 0, 1, 0.75, 0.0, },
		-- [3] = { "spells/corruption_impactdot_med_base.m2", 3, 0, 0.5, 1, 0.0, },
	};
	local FILENUM = #FILELIST;
	local random = random;
	function __coder.GetFile()
		local rnd = random(1, FILENUM);
		return FILELIST[rnd] or FILELIST["*"];
	end
elseif not ISRETAIL then
	local FILELIST = {
		--	file, z, x, y, alpha, rotate
		["*"] = { "spells/creature_spellportal_blue.m2", 4, 0, 1, 1, 0.0, },
		[1] = { "spells/creature_spellportal_blue.m2", 4, 0, 1, 1, 0.0, },
		[2] = { "spells/creature_spellportal_purple.m2", 4, 0, 1, 0.75, 0.0, },
		[3] = { "spells/creature_spellportal_green.m2", 4, 0, 1, 0.75, 0.0, },
		[4] = { "spells/creature_spellportal_white.m2", 4, 0, 1, 1, 0.0, },
		[5] = { "spells/creature_spellportal_yellow.m2", 4, 0, 1, 0.75, 0.0, },
		-- [6] = { "spells/flamecircleeffect_blue.m2", 2.5, 0, 0, 1, 0.0, },
		-- [7] = { "spells/corruption_impactdot_med_base.m2", 3, 0, 0.5, 1, 0.0, },
		-- [1] = { "spells/blackmagic_precast_base.m2", 3, 0, 0.5, 1.0, 0.0, },
		-- [2] = { "spells/sunwell_fire_barrier_ext.m2", 0, 0, 10, 0.5, 1.0, },
		-- [3] = { "spells/archimonde_blue_fire.m2", 0, 0, 0, 0.5, 0.0, },
		-- [4] = { "spells/archimonde_fire.m2", 0, 0, 0, 0.5, 0.0, },
		-- [12] = { "spells/cripple_state_chest.m2", 4, 0, 1.5, 0.75, 0.0, },
		-- [13] = { "spells/cyclone_state.m2", 4, 0, 0, 1, 0.0, },
		-- [13] = { "spells/conjureitemcast.m2", 5, 0, 2.2, 1, 0.0, },
	};
	local FILENUM = #FILELIST;
	local random = random;
	function __coder.GetFile()
		local rnd = random(1, FILENUM);
		return FILELIST[rnd] or FILELIST["*"];
	end
end


local function HashMap()
	local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
	local REALM = GetRealmName();
	local Hash = {  };
	local function InsertInfo(Hash, GUID)
		local locclass, class, locrace, race, sex, name, realm = GetPlayerInfoByGUID(GUID);
		if name ~= nil then
			if realm == "" or realm == nil then
				name = name .. "-" .. REALM;
			else
				name = name .. "-" .. realm;
			end
			Hash[name] = GUID;
			Hash[GUID] = name;
			return true;
		end
		return false;
	end
	local try = 0;
	local Proc;
	local DATA = {
		["Player-962-0508ADDC"] = "\231\129\172\229\176\143\233\155\133\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0509E004"] = "\228\184\128\233\148\164\229\173\144\229\145\188\232\132\184\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-040F5184"] = "\229\176\143\229\129\183\228\184\141\230\152\175\232\180\188\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-03C3B443"] = "\232\138\177\228\191\161\229\185\180\229\141\142\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0392FA91"] = "\229\164\167\231\129\176\231\139\188\229\176\190\229\183\180\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4791-02840797"] = "\232\183\145\228\184\141\229\138\168\228\186\134\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-962-04FEC839"] = "\230\153\154\229\174\137\229\150\181\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0508A77F"] = "\231\129\172\229\133\148\229\133\148\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0509E049"] = "\229\156\163\229\133\137\231\165\158\229\191\189\230\130\160\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0509E001"] = "\228\184\128\231\136\170\229\173\144\229\145\188\232\132\184\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-05469808"] = "\231\129\172\228\185\157\230\186\170\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4791-01680518"] = "\230\186\156\230\186\156\229\147\136\229\163\171\229\165\135\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-5376-05B22FA4"] = "\230\156\155\229\176\189\231\129\175\231\129\171\45\229\147\136\233\156\141\229\133\176",
		["Player-4791-010E9724"] = "\229\133\148\229\133\148\229\174\182\230\136\191\228\184\156\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4497-03985947"] = "\229\176\143\231\153\189\229\133\148\229\176\190\229\183\180\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4791-01480730"] = "\232\182\133\229\142\137\229\174\179\229\147\166\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-02139522"] = "\230\146\146\230\137\139\229\176\177\230\178\161\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-962-0508ADA1"] = "\231\129\172\229\176\143\229\145\134\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-040FF31B"] = "\230\183\177\233\130\131\230\154\151\229\189\177\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4791-02139923"] = "\231\166\187\233\153\140\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-010EBD53"] = "\229\183\180\230\142\140\229\149\170\228\189\160\232\132\184\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-0136A0D6"] = "\229\162\168\233\159\181\228\185\166\233\166\153\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-00DE4CF1"] = "\230\136\191\228\184\156\229\174\182\231\154\132\229\133\148\229\173\144\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-0088F61D"] = "\230\156\186\230\153\186\231\154\132\229\176\143\231\153\189\229\133\148\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-0088F6CB"] = "\233\170\145\228\186\186\229\164\170\230\183\177\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4791-0136A10C"] = "\230\189\156\232\161\140\229\144\131\231\147\156\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4497-03FC5121"] = "\230\140\135\233\151\180\230\156\157\229\164\149\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-038D0E9A"] = "\233\148\164\229\173\144\229\145\188\232\132\184\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0393B39E"] = "\78\101\116\101\97\115\101\117\105\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0507173B"] = "\229\139\135\230\149\162\231\154\132\229\164\167\231\129\176\231\139\188\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-04102EFE"] = "\232\131\161\232\144\157\229\141\156\232\131\150\232\131\150\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-040FF486"] = "\233\170\145\230\176\143\233\133\139\233\149\191\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-040F5394"] = "\230\136\152\230\176\143\233\133\139\233\149\191\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-038E14E4"] = "\230\156\155\229\176\189\231\129\175\231\129\171\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-03FBAEC1"] = "\231\139\188\231\129\176\231\129\176\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-03F67EA5"] = "\229\133\148\231\129\176\231\129\176\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4791-00E26C49"] = "\233\155\133\231\132\182\228\184\128\231\172\145\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4497-03B5A603"] = "\229\164\167\231\147\182\233\133\184\229\165\182\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-962-04FF445B"] = "\230\136\191\228\184\156\229\174\182\231\154\132\229\133\148\229\173\144\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-039DEE62"] = "\229\183\180\230\142\140\229\145\188\232\132\184\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-962-0508A6CC"] = "\231\129\172\229\176\143\229\133\148\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-0519E8E8"] = "\230\181\133\230\181\133\232\135\179\230\158\129",
		["Player-4497-03F6B362"] = "\229\143\152\229\175\140\229\143\152\230\188\130\228\186\174\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0388473F"] = "\231\139\161\231\140\190\231\154\132\229\164\167\231\129\176\231\139\188\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-04102FBE"] = "\232\131\161\232\144\157\229\141\156\231\152\166\231\152\166\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0516E2C2"] = "\228\184\142\229\144\155\228\188\180\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-0410343D"] = "\232\131\161\232\144\157\229\141\156\230\138\177\230\138\177\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-03871A80"] = "\230\156\186\230\153\186\231\154\132\229\176\143\231\153\189\229\133\148\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-962-0509ACEF"] = "\231\129\172\231\173\177\233\155\133\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0509AC92"] = "\231\129\172\228\185\157\230\186\170\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-0395C790"] = "\230\136\191\228\184\156\229\174\182\231\154\132\229\133\148\229\173\144\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-04FE92E9"] = "\229\139\135\230\149\162\231\154\132\229\176\143\231\153\189\229\133\148",
		["Player-4497-040C3C57"] = "\231\139\161\231\140\190\231\154\132\229\176\143\231\153\189\229\133\148\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4497-039DF9BC"] = "\86\111\105\100\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-962-0509EA70"] = "\232\144\140\232\144\140\232\148\172\232\143\156\229\140\133\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0508AD43"] = "\231\129\172\229\164\167\231\153\189\229\133\148\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-962-0508AD11"] = "\231\129\172\232\144\140\229\176\143\232\180\188\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4497-03F0D909"] = "\229\134\178\229\149\138\229\164\167\231\129\176\231\139\188\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-962-0508AD8B"] = "\231\129\172\229\176\143\232\144\140\228\184\182\45\233\135\145\232\137\178\229\185\179\229\142\159",
		["Player-4791-00891F9F"] = "\231\139\161\231\140\190\231\154\132\229\164\167\231\129\176\231\139\188\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4497-04105E08"] = "\231\155\151\230\157\191\232\180\188\45\231\162\167\231\142\137\231\159\191\230\180\158",
		["Player-4791-010B0B3C"] = "\230\136\191\228\184\156\229\174\182\229\176\143\229\133\148\229\173\144\45\231\162\167\231\169\186\228\185\139\230\173\140",
		["Player-4497-054BAC83"] = "\231\171\185\230\158\151\233\155\168\230\183\133\45\231\162\167\231\142\137\231\159\191\230\180\158",	
	};
	function Proc()
		if try > 2 then
			for GUID, _ in next, DEVELOPER do
				if Hash[GUID] == nil then
					local name = DATA[GUID];
					Hash[name] = GUID;
					Hash[GUID] = name;
				end
			end
			for v1, v2 in next, Hash do
				if DEVELOPER[v1] == nil and DEVELOPER[v2] == nil then
					Hash[v1] = nil;
				end
			end
			return;
		end
		After(2, Proc);
		try = try + 1;
		local FullyInserted = true;
		for GUID, _ in next, DEVELOPER do
			FullyInserted = InsertInfo(Hash, GUID) and FullyInserted;
		end
		if FullyInserted then
			try = 999;
		end
	end
	Proc();
	__ala_meta__["__DEV" .. "GUID"] = DEVELOPER;
	__ala_meta__["__DEV" .. "HASH"] = Hash;
	local S = __ala_meta__["__SYNC"];
	if S ~= nil then
		S["REALTIME"] = nil;
		S["ONLOGIN"] = nil;
		S["ONLOGOUT"] = nil;
	end
end

local IsDead = false;

local UnitGUID, UnitIsPlayer = UnitGUID, UnitIsPlayer;
local GameTooltip = GameTooltip;


local function ModelWrap_OnUpdate(_F, elasped)
	local _, unit = GameTooltip:GetUnit();
	if unit == nil or not UnitIsPlayer(unit) then
		__coder.Wrap:Hide();
	else
		local GUID = UnitGUID(unit);
		if DEVELOPER[GUID] == nil then
			__coder.Wrap:Hide();
		end
	end
end
local function ReanchorModelWrap(tip, backdrop)
	__coder.Wrap:ClearAllPoints();
	if backdrop ~= nil and backdrop.insets ~= nil then
		local insets = backdrop.insets;
		__coder.Wrap:SetPoint("BOTTOMLEFT", tip, "BOTTOMLEFT", 0.5 + (insets.left or 0), 0.5 + (insets.bottom or 0));
		__coder.Wrap:SetPoint("TOPRIGHT", tip, "TOPRIGHT", -0.5 - (insets.right or 0), -0.5 - (insets.top or 0));
	else
		__coder.Wrap:SetAllPoints();
	end
end
local function CreateModelWrap(tip)
	local Wrap = CreateFrame('FRAME', nil, tip);
	-- Wrap:SetAllPoints();
	Wrap:SetAlpha(1.0);
	Wrap:Hide();
	Wrap:SetFrameLevel(9999);
	Wrap:SetScript("OnUpdate", ModelWrap_OnUpdate);
	__coder.Wrap = Wrap;
	ReanchorModelWrap(tip, tip.GetBackdrop ~= nil and tip:GetBackdrop() or nil);

	local Model = CreateFrame('PLAYERMODEL', nil, Wrap);
	Model:SetAllPoints();
	Model:SetKeepModelOnHide(true);
	Model:SetPortraitZoom(1.0);
	Model:Show();
	function Wrap:SetModelFile(file)
		local Model = self.Model;
		Model:SetModel(file[1]);
		Model:SetPosition(file[2], file[3], file[4]);
		Model:SetAlpha(file[5]);
		Model:SetFacing(file[6]);
	end
	Wrap.Model = Model;
end

local function CheckTooltip(tip)
	local _, unit = tip:GetUnit();
	if unit ~= nil then
		local GUID = UnitGUID(unit);
		local key = DEVELOPER[GUID];
		if key ~= nil and UnitIsPlayer(unit) and tip:IsVisible() then
			tip:AddLine(TITLELIST[key] or "", 1, 0, 1);
			if not tip.fadeOut then
				tip:Show();
			end
			if __coder.GetFile then
				__coder.Wrap:Show();
				__coder.Wrap:SetModelFile(__coder.GetFile());
			end
		end
	end
end

local function Hook_OnTooltipSetUnit(tip)
	if IsDead then
		return;
	end
	if tip == GameTooltip then
		CheckTooltip(GameTooltip);
	end
end
local HookState = {  };
local function Hook_SetScript(tip, script, method)
	if IsDead then
		return;
	end
	if script == "OnTooltipSetUnit" then
		if HookState[GameTooltip:GetScript("OnTooltipSetUnit")] == nil then
			tip:HookScript("OnTooltipSetUnit", Hook_OnTooltipSetUnit);
		end
	end
end
local function Hook_HookScript(tip, script, method)
	if IsDead then
		return;
	end
	if script == "OnTooltipSetUnit" then
		HookState[GameTooltip:GetScript("OnTooltipSetUnit") or "none"] = true;
	end
end
function __coder.Init()
	if __coder.GetFile then
		CreateModelWrap(GameTooltip);
		if GameTooltip.SetBackdrop ~= nil then
			hooksecurefunc(GameTooltip, "SetBackdrop", ReanchorModelWrap);
		end
	end
	After(1, HashMap);
	if TooltipDataProcessor ~= nil then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, Hook_OnTooltipSetUnit);
	end
	if GameTooltip:HasScript("OnTooltipSetUnit") then
		hooksecurefunc(GameTooltip, "SetScript", Hook_SetScript);
		hooksecurefunc(GameTooltip, "HookScript", Hook_HookScript);
		GameTooltip:HookScript("OnTooltipSetUnit", Hook_OnTooltipSetUnit);
	end
end
if IsLoggedIn() then
	__coder.Init();
else
	__coder:SetScript(
		"OnEvent",
		function(self, event)
			self:UnregisterEvent("LOADING_SCREEN_DISABLED");
			return __coder.Init();
		end
	);
	__coder:RegisterEvent("LOADING_SCREEN_DISABLED");
end

function __coder:Halt()
end
