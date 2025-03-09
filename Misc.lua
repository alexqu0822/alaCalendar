--[[--
	by ALA @ 163UI
--]]--
----------------------------------------------------------------------------------------------------
local _G = _G;
local GetNumSavedInstances, GetSavedInstanceInfo, GetSavedInstanceEncounterInfo = GetNumSavedInstances, GetSavedInstanceInfo, GetSavedInstanceEncounterInfo;
local GameTooltip = GameTooltip;

local buttons = {  };

RaidInfoInstance10:ClearAllPoints();
RaidInfoInstance10:SetPoint("TOPLEFT", RaidInfoInstance9, "BOTTOMLEFT", 0, 5);
local p = nil;
for i = 1, 100 do
	local name = "RaidInfoInstance" .. i;
	local b = _G[name];
	if b == nil then
		b = CreateFrame('FRAME', name, RaidInfoScrollChildFrame, "RaidInfoInstanceTemplate");
		b:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 0, 5);
	end
	buttons[i] = b;
	p = b;
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
	local b = buttons[i];
	b:EnableMouse(true);
	b.__ID = i;
	b.__HL = b:CreateTexture(nil, "OVERLAY");
	b.__HL:SetAllPoints();
	b.__HL:SetColorTexture(1.0, 0.75, 0.5, 0.25);
	b.__HL:SetBlendMode("ADD");
	b.__HL:Hide();
	b:SetScript("OnEnter", function(self)
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
	b:SetScript("OnLeave", function(self)
		self.__HL:Hide();
		GameTooltip:Hide();
	end);
end
