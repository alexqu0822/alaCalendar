--[[--
	by ALA
--]]--

if U1CoreAPI.GetClientMajor() > 4 then
	return;
end

local _G = _G;
local GetNumSavedInstances, GetSavedInstanceInfo, GetSavedInstanceEncounterInfo = GetNumSavedInstances, GetSavedInstanceInfo, GetSavedInstanceEncounterInfo;
local GameTooltip = GameTooltip;
local SecondsToTime = SecondsToTime;
local RESETS_IN = RESETS_IN;
local BOSS_DEAD = BOSS_DEAD;
local BOSS_ALIVE = BOSS_ALIVE;

--[[
local InstanceList = {  };

-- RaidInfoInstance10:ClearAllPoints();
-- RaidInfoInstance10:SetPoint("TOPLEFT", RaidInfoInstance9, "BOTTOMLEFT", 0, 5);
local relTo = nil;
for i = 1, 100 do
	local name = "RaidInfoInstance" .. i;
	local Instance = _G[name];
	if Instance == nil then
		Instance = CreateFrame('FRAME', name, RaidInfoScrollChildFrame, "RaidInfoInstanceTemplate");
		Instance:SetPoint("TOPLEFT", relTo, "BOTTOMLEFT", 0, 5);
	end
	InstanceList[i] = Instance;
	relTo = Instance;
	local Name = _G[name .. "Name"];
	if Name ~= nil then
		Name:ClearAllPoints();
		Name:SetPoint("TOPLEFT", 5, 0);
	end
	local Reset = _G[name .. "Reset"];
	if Reset ~= nil then
		Reset:ClearAllPoints();
		Reset:SetPoint("TOPRIGHT", -10, 0);
	end
end
MAX_RAID_INFOS = 100;

for i = 1, MAX_RAID_INFOS do
	local Instance = InstanceList[i];
	Instance:EnableMouse(true);
	Instance.__ID = i;
	Instance.__HL = Instance:CreateTexture(nil, "OVERLAY");
	Instance.__HL:SetAllPoints();
	Instance.__HL:SetColorTexture(1.0, 0.75, 0.5, 0.25);
	Instance.__HL:SetBlendMode("ADD");
	Instance.__HL:Hide();
	Instance:SetScript("OnEnter", function(self)
		self.__HL:Show();
		if self.__ID <= GetNumSavedInstances() then
			local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(self.__ID);
			if name ~= nil then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
				GameTooltip:AddDoubleLine(name, id, 1.0, 1.0, 1.0, 0.35, 0.35, 0.35);
				if locked then
					GameTooltip:AddLine(RESETS_IN .. " " .. SecondsToTime(reset), 0.5, 0.5, 0.5);
					GameTooltip:AddLine(" ");
					-- var[1] = id;
					-- var[2] = t;
					-- var[3] = numEncounters;
					-- var[4] = encounterProgress;
					for encounterIndex = 1, numEncounters do
						local bossName, fileDataID, isKilled, unknown4 = GetSavedInstanceEncounterInfo(self.__ID, encounterIndex);
						-- var[4 + encounterIndex * 2 - 1] = bossName;
						-- var[4 + encounterIndex * 2] = isKilled;
						if isKilled then
							GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, 0.875, 0.875, 0.875, 1.0, 0.0, 0.0);
						else
							GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, 0.875, 0.875, 0.875, 0.0, 1.0, 0.0);
						end
					end
				end
				GameTooltip:Show();
			end
		end
	end);
	Instance:SetScript("OnLeave", function(self)
		self.__HL:Hide();
		GameTooltip:Hide();
	end);
end
--]]

local hooked = {  };
local function HookButton(Button)
	if hooked[Button] == nil then
		hooked[Button] = true;
		Button:SetScript("OnEnter", function(self)
			if self.raidIndex <= GetNumSavedInstances() then
				local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(self.raidIndex);
				if name ~= nil then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
					GameTooltip:AddDoubleLine(name, id, 1.0, 1.0, 1.0, 0.35, 0.35, 0.35);
					if locked then
						GameTooltip:AddLine(RESETS_IN .. " " .. SecondsToTime(reset), 0.5, 0.5, 0.5);
						GameTooltip:AddLine(" ");
						-- var[1] = id;
						-- var[2] = t;
						-- var[3] = numEncounters;
						-- var[4] = encounterProgress;
						for encounterIndex = 1, numEncounters do
							local bossName, fileDataID, isKilled, unknown4 = GetSavedInstanceEncounterInfo(self.raidIndex, encounterIndex);
							-- var[4 + encounterIndex * 2 - 1] = bossName;
							-- var[4 + encounterIndex * 2] = isKilled;
							if isKilled then
								GameTooltip:AddDoubleLine(bossName, BOSS_DEAD, 0.875, 0.875, 0.875, 1.0, 0.0, 0.0);
							else
								GameTooltip:AddDoubleLine(bossName, BOSS_ALIVE, 0.875, 0.875, 0.875, 0.0, 1.0, 0.0);
							end
						end
					end
					GameTooltip:Show();
				end
			end
		end);
		Button:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end);
	end
end
RaidInfoFrame.ScrollBox:RegisterCallback(_G.ScrollBoxListViewMixin.Event.OnAcquiredFrame, function(owner, line, index)
	HookButton(line);
end);
