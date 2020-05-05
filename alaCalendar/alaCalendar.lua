--[[--
	by ALA @ 163UI
	复用代码请在显著位置标注来源【ALA@网易有爱】
	Please Keep WOW Addon open-source & Reduce barriers for others.
	请勿加密、乱码、删除空格tab换行符、设置加载依赖
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;
_G.__ala_meta__ = _G.__ala_meta__ or {  };
__ala_meta__.cal = NS;
local _G = _G;

do
	local _G = _G;
	if NS.__fenv == nil then
		NS.__fenv = setmetatable({  },
				{
					__index = _G,
					__newindex = function(t, key, value)
						rawset(t, key, value);
						print("aca assign global", key, value);
						return value;
					end,
				}
			);
	end
	setfenv(1, NS.__fenv);
end

local LOCALE = GetLocale();
local curPhase = 4;
----------------------------------------------------------------------------------------------------upvalue
	----------------------------------------------------------------------------------------------------LUA
	local math, table, string, bit = math, table, string, bit;
	local type = type;
	local assert, collectgarbage, date, difftime, error, getfenv, getmetatable, loadstring, next, newproxy, pcall, select, setfenv, setmetatable, time, type, unpack, xpcall, rawequal, rawget, rawset =
			assert, collectgarbage, date, difftime, error, getfenv, getmetatable, loadstring, next, newproxy, pcall, select, setfenv, setmetatable, time, type, unpack, xpcall, rawequal, rawget, rawset;
	local abs, acos, asin, atan, atan2, ceil, cos, deg, exp, floor, fmod, frexp,ldexp, log, log10, max, min, mod, rad, random, sin, sqrt, tan, fastrandom =
			abs, acos, asin, atan, atan2, ceil, cos, deg, exp, floor, fmod or math.fmod, frexp,ldexp, log, log10, max, min, mod, rad, random, sin, sqrt, tan, fastrandom;
	local format, gmatch, gsub, strbyte, strchar, strfind, strlen, strlower, strmatch, strrep, strrev, strsub, strupper, tonumber, tostring =
			format, gmatch, gsub, strbyte, strchar, strfind, strlen, strlower, strmatch, strrep, strrev, strsub, strupper, tonumber, tostring;
	local strcmputf8i, strlenutf8, strtrim, strsplit, strjoin, strconcat, tostringall = strcmputf8i, strlenutf8, strtrim, strsplit, strjoin, strconcat, tostringall;
	local ipairs, pairs, sort, tContains, tinsert, tremove, wipe = ipairs, pairs, sort, tContains, tinsert, tremove, wipe;
	-- local gcinfo, foreach, foreachi, getn = gcinfo, foreach, foreachi, getn;	-- Deprecated
	----------------------------------------------------------------------------------------------------GAME
	local print = print;
	local GetServerTime = GetServerTime;
	local CreateFrame = CreateFrame;
	local IsAltKeyDown = IsAltKeyDown;
	local IsControlKeyDown = IsControlKeyDown;
	local IsShiftKeyDown = IsShiftKeyDown;
	--------------------------------------------------
	local RAID_CLASS_COLORS = RAID_CLASS_COLORS;
	local _ = nil;
	local function _log_(...)
		print(date('\124cff00ff00%H:%M:%S\124r'), ...);
	end
	local function _error_(header, child, ...)
		print(date('\124cffff0000%H:%M:%S\124r'), header, child, ...);
		if alaCalendarSV then
			local err = alaCalendarSV.err;
			if not err then
				err = {  };
				alaCalendarSV.err = err;
			end
			err[header] = err[header] or {  };
			err[header][child] = (err[header][child] or 0) + 1;
		end
	end
	local function _noop_()
	end
	--------------------------------------------------
	local NUM_ROW = 6;
	local NUM_COL = 7;
	local ui_style = {
		texture_white = "Interface\\Buttons\\WHITE8X8",
		texture_unk = "Interface\\Icons\\inv_misc_questionmark",
		texture_highlight = "Interface\\Buttons\\UI-Common-MouseHilight",
		texture_triangle = "interface\\transmogrify\\transmog-tooltip-arrow",
		texture_collapsed = "interface\\buttons\\ui-plusbutton-up",
		texture_expanded = "interface\\buttons\\ui-minusbutton-up",
		texture_triangle_normal_color = { 0.5, 0.5, 0.5, 1.0, },
		texture_triangle_pushed_color = { 0.25, 0.25, 0.25, 1.0, },

		frameTitle_YSize = 48,
		frameBackdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false,
			tileSize = 16,
			edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0, }
		},
		frameBackdropColor = { 0.15, 0.15, 0.15, 0.9, },
		frameBackdropBorderColor = { 0.0, 0.0, 0.0, 1.0, },

		cal_XToBorder = 4,
		cal_YToBorder = 4,
		calBackdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false,
			tileSize = 16,
			edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0, }
		},
		calBackdropColor = { 0.5, 0.5, 0.5, 0.25, },
		calBackdropBorderColor = { 0.0, 0.0, 0.0, 1.0, },

		weekTitle_YSize = 30,
		weekTitle_BG = "Interface\\Calendar\\CalendarBackground",
		weekTitle_BG_Coord = { 0.0, 0.3515625, 0.72265625, 0.81640625, },

		cell_YToWeekTitle = 4,
		cell_XSize = 90,
		cell_YSize = 90,
		cell_XInt = 0,
		cell_YInt = 0,
		cell_BG = "Interface\\Calendar\\CalendarBackground",
		cell_BG_Coord = { 0.0, 0.3515625, 0.0, 0.3515625, },
		cell_this_month_maskColor = { 0.25, 0.25, 0.25, 0.5, },
		cell_today_mask_color = { 1.0, 0.5, 0.0, 1.0, },
		cell_Highlight = "interface\\buttons\\checkbuttonhilight",
		cell_HighlightCoord = { 0.05, 0.95, 0.05, 0.95, },

		--
		board_XSize = 360,
		board_YSize = 600,

		button_height = 20,
		buttonBackdrop = {
			-- bgFile = "Interface\\Buttons\\WHITE8X8",
			-- edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = false,
			tileSize = 16,
			edgeSize = 1,
			insets = { left = 1, right = 1, top = 1, bottom = 1 }
		},
		buttonBackdropColor = { 1.0, 1.0, 1.0, 1.0, },
		buttonBackdropBorderColor = { 1.0, 1.0, 1.0, 1.0, },
		buttonHighlightColor = { 0.5, 0.5, 0.0, 0.25, },
		buttonGlowColor = { 0.0, 0.25, 0.0, 0.15, },

		frameFont = SystemFont_Shadow_Med1:GetFont(),--=="Fonts\ARKai_T.ttf"
		frameFontSize = min(select(2, SystemFont_Shadow_Med1:GetFont()) + 1, 15),
		frameFontOutline = "NORMAL",
		weekTitleFontSize = min(select(2, SystemFont_Shadow_Med1:GetFont()) + 5, 18),
		cellTitleFontSize = min(select(2, SystemFont_Shadow_Med1:GetFont()) + 5, 18),
		bigFontSize = 32,
		smallFontSize = select(2, SystemFont_Shadow_Med1:GetFont()),
		
		today_color = { 0.5, 0.75, 1.0, 0.9, },
		ad_color = { 0.25, 0.5, 0.75, 1.0, },

	};
	ui_style.cal_XSize = ui_style.cell_XSize * (NUM_COL) + ui_style.cell_XInt * (NUM_COL - 1);
	ui_style.cal_YSize = ui_style.weekTitle_YSize + ui_style.cell_YToWeekTitle + ui_style.cell_YSize * (NUM_ROW) + ui_style.cell_YInt * (NUM_ROW - 1);
	ui_style.frame_XSize = ui_style.cal_XToBorder * 2 + ui_style.cal_XSize;
	ui_style.frame_YSize = ui_style.frameTitle_YSize + ui_style.cal_YToBorder * 2 + ui_style.cal_YSize;
	ui_style.festival_Size = min(ui_style.cell_XSize, ui_style.cell_YSize) * 0.45;
	ui_style.cell_inst_Size = min(ui_style.cell_XSize * 0.25, ui_style.cell_YSize * 0.25);
	--
	_G.ala_cal_ui_style = ui_style;
	--
	local BIG_NUMBER = 4294967295;
	--[[
		-- "Interface\\Buttons\\WHITE8X8",
		-- "Interface\\Tooltips\\UI-Tooltip-Background",
		-- "Interface\\ChatFrame\\ChatFrameBackground"
		alaCalendarSV = {
			var = {
				[GUID] = {
					[instance] = bool,
					realm_id = number,
					realm_name = string,
				},
			},
			set = {
				first_col_day = bool,
				[instance] = bool,
			},
			_version = number,
		}
	]]
----------------------------------------------------------------------------------------------------
local L = {  };
do
	L.REGION = {
		[1] = "US",
		[2] = "Korea-대한민국",
		[3] = "Europe",
		[4] = "Taiwan, China-中國台灣",
		[5] = "China-中国大陆",
	};
	if LOCALE == "zhCN" then
		L.CALENDAR = "日历";
		L.BOARD = "进度";
		L.WEEKTITLE = {
			[1] = "星期一";
			[2] = "星期二";
			[3] = "星期三";
			[4] = "星期四";
			[5] = "星期五";
			[6] = "星期六";
			[0] = "星期日";
		};
		L.YEAR_FORMAT = "%d";
		L.MONTH_FORMAT = "年%s";
		L.MONTH = {
			"1月",
			"2月",
			"3月",
			"4月",
			"5月",
			"6月",
			"7月",
			"8月",
			"9月",
			"10月",
			"11月",
			"12月",
		};
		L.FORMAT_DATE_TODAY = "%Y年%m月%d日 %lw";
		L.FORMAT_CLOCK = "%H:%M:%S";
		L.INSTANCE_RESET = " \124cffff9f00重置\124r";
		L.FESTIVAL_START = " \124cff00ff00开始\124r";
		L.FESTIVAL_END = " \124cffff0000结束\124r";
		L.INSTANCE_LOCKED_DOWN = "锁定：";
		L.SLASH_NOTE = {
			region = "地区设置为：%s",
			first_col_day = "首列已被设置为：%s",
			show_DBIcon = "小地图按钮",
			scale = "缩放",
			alpha = "透明度",
			show_unlocked = "显示无进度的角色",
		};
		L.TooltipLines = {
			"\124cff00ff00左键点击\124r打开/关闭日历",
			"\124cff00ff00右键点击\124r打开/关闭副本进度",
		};
		L.DBIcon_Text = "日历";
		L.CLOSE = "关闭";
		L.RESET = "返回今天";
		L.CALL_BOARD = "副本进度";
		L.CALL_CALENDAR = "日历";
		L.AD_TEXT = "ALA @ 网易有爱\nwowui.w.163.com";
		L["COLORED_FORMATTED_TIME_LEN"] = {
			"\124cff%.2x%.2x00%d天%02d时%02d分%02d秒\124r",
			"\124cff%.2x%.2x00%d时%02d分%02d秒\124r",
			"\124cff%.2x%.2x00%d分%02d秒\124r",
			"\124cff%.2x%.2x00%d秒\124r",
		};
		L["FORMATTED_TIME_LEN"] = {
			"%d天%02d时%02d分%02d秒",
			"%d时%02d分%02d秒",
			"%d分%02d秒",
			"%d秒",
		};
		L["FORMATTED_TIME"] = "%Y年%m月%d日\n%H:%M:%S";
		L["COOLDOWN_EXPIRED"] = "\124cff00ff00冷却结束\124r";
	elseif LOCALE == "zhTW" then
		L.CALENDAR = "日曆";
		L.BOARD = "進度";
		L.WEEKTITLE = {
			[1] = "星期一";
			[2] = "星期二";
			[3] = "星期三";
			[4] = "星期四";
			[5] = "星期五";
			[6] = "星期六";
			[0] = "星期日";
		};
		L.YEAR_FORMAT = "%d";
		L.MONTH_FORMAT = "年%s";
		L.MONTH = {
			"1月",
			"2月",
			"3月",
			"4月",
			"5月",
			"6月",
			"7月",
			"8月",
			"9月",
			"10月",
			"11月",
			"12月",
		};
		L.FORMAT_DATE_TODAY = "%Y年%m月%d日 %lw";
		L.FORMAT_CLOCK = "%H:%M:%S";
		L.INSTANCE_RESET = " \124cffff9f00重置\124r";
		L.FESTIVAL_START = " \124cff00ff00開始\124r";
		L.FESTIVAL_END = " \124cffff0000結束\124r";
		L.INSTANCE_LOCKED_DOWN = "鎖定：";
		L.SLASH_NOTE = {
			region = "地區設置爲：%s",
			first_col_day = "首列已被設置爲：%s",
			show_DBIcon = "小地圖按鈕",
			scale = "縮放",
			alpha = "透明度",
			show_unlocked = "顯示無進度鎖定的角色",
		};
		L.TooltipLines = {
			"\124cff00ff00左鍵點擊\124r打開/關閉日曆",
			"\124cff00ff00右鍵點擊\124r打開/關閉副本進度",
		};
		L.DBIcon_Text = "日曆";
		L.CLOSE = "關閉";
		L.RESET = "返回今天";
		L.CALL_BOARD = "副本進度";
		L.CALL_CALENDAR = "日曆";
		L.AD_TEXT = "ALA @ 網易有愛\nwowui.w.163.com";
		L["COLORED_FORMATTED_TIME_LEN"] = {
			"\124cff%.2x%.2x00%d天%02d时%02d分%02d秒\124r",
			"\124cff%.2x%.2x00%d时%02d分%02d秒\124r",
			"\124cff%.2x%.2x00%d分%02d秒\124r",
			"\124cff%.2x%.2x00%d秒\124r",
		};
		L["FORMATTED_TIME_LEN"] = {
			"%d天%02d时%02d分%02d秒",
			"%d时%02d分%02d秒",
			"%d分%02d秒",
			"%d秒",
		};
		L["FORMATTED_TIME"] = "%Y年%m月%d日\n%H:%M:%S";
		L["COOLDOWN_EXPIRED"] = "\124cff00ff00冷卻結束\124r";
	elseif LOCALE == "koKR" then
		L.CALENDAR = "달력";
		L.BOARD = "인스턴스";
		L.WEEKTITLE = {
			[1] = "월";
			[2] = "화";
			[3] = "수";
			[4] = "목";
			[5] = "금";
			[6] = "토";
			[0] = "일";
		};
		L.YEAR_FORMAT = "%d";
		L.MONTH_FORMAT = "년%s";
		L.MONTH = {
			" 1월",
			" 2월",
			" 3월",
			" 4월",
			" 5월",
			" 6월",
			" 7월",
			" 8월",
			" 9월",
			" 10월",
			" 11월",
			" 12월",
		};
		L.FORMAT_DATE_TODAY = "%Y년 %m월 %d일 %lw요일";
		L.FORMAT_CLOCK = "%H:%M:%S";
		L.INSTANCE_RESET = " \124cffff9f00초기화\124r";
		L.FESTIVAL_START = " \124cff00ff00시작\124r";
		L.FESTIVAL_END = " \124cffff0000종료\124r";
		L.INSTANCE_LOCKED_DOWN = "잠김: ";
		L.SLASH_NOTE = {
			region = "지역 변경: %s",
			first_col_day = "첫번째 열의 요일 변경: %s",
			show_DBIcon = "미니맵 버튼",
			scale = "Scale",
			alpha = "Alpha",
			show_unlocked = "잠긴 인스턴스 문자 표시"
		};
		L.TooltipLines = {
			"\124cff00ff00좌클릭\124r 달력 토글",
			"\124cff00ff00우클릭\124r 잠긴 인스턴스 토글",
		};
		L.DBIcon_Text = "달력";
		L.CLOSE = "닫기";
		L.RESET = "오늘로 돌아가기";
		L.CALL_BOARD = "인던 잠김";
		L.CALL_CALENDAR = "달력";
		L.AD_TEXT = "ALA @ 163UI";
		L["COLORED_FORMATTED_TIME_LEN"] = {
			"\124cff%.2x%.2x00%d일 %02d시간 %02d분 %02d초\124r",
			"\124cff%.2x%.2x00%d시간 %02d분 %02d초\124r",
			"\124cff%.2x%.2x00%d분 %02d초\124r",
			"\124cff%.2x%.2x00%d초\124r",
		};
		L["FORMATTED_TIME_LEN"] = {
			"%d일 %02d시간 %02d분 %02d초",
			"%d시 %02d분 %02d초",
			"%d분 %02d초",
			"%d초",
		};
		L["FORMATTED_TIME"] = "%Y년%m월%d일\n%H:%M:%S";
		L["COOLDOWN_EXPIRED"] = "\124cff00ff00유효함\124r";
	else
		L.CALENDAR = "Calendar";
		L.BOARD = "Instance";
		L.WEEKTITLE = {
			[1] = "Mon.";
			[2] = "Tues.";
			[3] = "Wed.";
			[4] = "Thur.";
			[5] = "Fri.";
			[6] = "Sat.";
			[0] = "Sun.";
		};
		L.YEAR_FORMAT = "%d";
		L.MONTH_FORMAT = "%s ";
		L.MONTH = {
			"Jan.",
			"Feb.",
			"Mar.",
			"Apr.",
			"May.",
			"Jun.",
			"Jul.",
			"Aug.",
			"Sep.",
			"Oct.",
			"Nov.",
			"Dec.",
		};
		L.FORMAT_DATE_TODAY = "%b %d, %y %lw";
		L.FORMAT_CLOCK = "%H:%M:%S";
		L.INSTANCE_RESET = " \124cffff9f00reset\124r";
		L.FESTIVAL_START = " \124cff00ff00starts\124r";
		L.FESTIVAL_END = " \124cffff0000ends\124r";
		L.INSTANCE_LOCKED_DOWN = "Locked down: ";
		L.SLASH_NOTE = {
			region = "Set region to: %s",
			first_col_day = "Fist row is set to: %s",
			show_DBIcon = "Minimap button",
			scale = "Scale",
			alpha = "Alpha",
			show_unlocked = "Show characters without locked instance"
		};
		L.TooltipLines = {
			"\124cff00ff00Left click\124r to toggle calendar",
			"\124cff00ff00Right click\124r to toggle board displaying instance locked down",
		};
		L.DBIcon_Text = "Calendar";
		L.CLOSE = "Close";
		L.RESET = "Back to today";
		L.CALL_BOARD = "Instance locked down";
		L.CALL_CALENDAR = "Calendar";
		L.AD_TEXT = "ALA @ 163UI";
		L["COLORED_FORMATTED_TIME_LEN"] = {
			"\124cff%.2x%.2x00%dd %02dh %02dm %02ds\124r",
			"\124cff%.2x%.2x00%dh %02dm %02ds\124r",
			"\124cff%.2x%.2x00%dm %02ds\124r",
			"\124cff%.2x%.2x00%ds\124r",
		};
		L["FORMATTED_TIME_LEN"] = {
			"%dd %02dh %02dm %02ds",
			"%dh %02dm %02ds",
			"%dm %02dsr",
			"%ds",
		};
		L["FORMATTED_TIME"] = "%Y-%m-%d\n%H:%M:%S";
		L["COOLDOWN_EXPIRED"] = "\124cff00ff00Available\124r";
	end
	if LOCALE == "zhCN" then
		L.INSTANCE = {
			ONY = "奥妮克希亚的巢穴",
			MC = "熔火之心",
			BWL = "黑翼之巢",
			ZG = "祖尔格拉布",
			RAQ = "安其拉废墟",
			TAQ = "安其拉",
			NAXX = "纳克萨玛斯",
			DarkMoon = "暗月马戏团",
			["DarkMoon: Elwynn"] = "暗月马戏团 \124cff00afff艾尔文森林\124r",
			["DarkMoon: Mulgore"] = "暗月马戏团 \124cffff3f00莫高雷\124r",
			["Fishing Extravaganza"] = "荆棘谷钓鱼大赛",
			["Warsong Gulch"] = "战歌峡谷节日",
			["Arathi Basin"] = "阿拉希盆地节日",
			["Alterac Valley"] = "奥特兰克山谷节日",
			ala = "ala",
		};
	elseif LOCALE == "zhTW" then
		L.INSTANCE = {
			ONY = "奥妮克希亚的巢穴",
			MC = "熔火之心",
			BWL = "黑翼之巢",
			ZG = "祖尔格拉布",
			RAQ = "安其拉废墟",
			TAQ = "安其拉",
			NAXX = "纳克萨玛斯",
			DarkMoon = "暗月马戏团",
			["DarkMoon: Elwynn"] = "暗月马戏团 \124cff00afff艾尔文森林\124r",
			["DarkMoon: Mulgore"] = "暗月马戏团 \124cffff3f00莫高雷\124r",
			["Fishing Extravaganza"] = "荆棘谷钓鱼大赛",
			["Warsong Gulch"] = "战歌峡谷节日",
			["Arathi Basin"] = "阿拉希盆地节日",
			["Alterac Valley"] = "奥特兰克山谷节日",
			ala = "ala",
		};
	elseif LOCALE == "deDE" then
		L.INSTANCE = {
			ONY = "Onyxias Hort",
			MC = "Geschmolzener Kern",
			BWL = "Pechschwingenhort",
			ZG = "Zul'Gurub",
			RAQ = "Ruinen von Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	elseif LOCALE == "enUS" then
		L.INSTANCE = {
			ONY = "Onyxia's Lair",
			MC = "Molten Core",
			BWL = "Blackwing Lair",
			ZG = "Zul'Gurub",
			RAQ = "Ruins of Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	elseif LOCALE == "esES" or LOCALE == "esMX" then
		L.INSTANCE = {
			ONY = "Guarida de Onyxia",
			MC = "Núcleo de Magma",
			BWL = "Guarida Alanegra",
			ZG = "Zul'Gurub",
			RAQ = "Ruinas de Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	elseif LOCALE == "frFR" then
		L.INSTANCE = {
			ONY = "Repaire d'Onyxia",
			MC = "Cœur du Magma",
			BWL = "Repaire de l'Aile noire",
			ZG = "Zul'Gurub",
			RAQ = "Ruines d'Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	-- elseif LOCALE == "itIT" then
	elseif LOCALE == "ptBR" then
		L.INSTANCE = {
			ONY = "Covil da Onyxia",
			MC = "Núcleo Derretido",
			BWL = "Covil Asa Negra",
			ZG = "Zul'Gurub",
			RAQ = "Ruínas de Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	elseif LOCALE == "ruRU" then
		L.INSTANCE = {
			ONY = "Логово Ониксии",
			MC = "Огненные Недра",
			BWL = "Логово Крыла Тьмы",
			ZG = "Зул'Гуруб",
			RAQ = "Руины Ан'Киража",
			TAQ = "Ан'Кираж",
			NAXX = "Наксрамас",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	elseif LOCALE == "koKR" then
		L.INSTANCE = {
			ONY = "오닉시아의 둥지",
			MC = "화산 심장부",
			BWL = "검은날개 둥지",
			ZG = "줄구룹",
			RAQ = "안퀴라즈 폐허",
			TAQ = "안퀴라즈",
			NAXX = "낙스라마스",
			DarkMoon = "다크문",
			["DarkMoon: Elwynn"] = "다크문 \124cff00afff엘윈숲\124r",
			["DarkMoon: Mulgore"] = "다크문 \124cffff3f00멀고어\124r",
			["Fishing Extravaganza"] = "가시덤불 골짜기 낚시대회",
			["Warsong Gulch"] = "전쟁노래 협곡 사절단",
			["Arathi Basin"] = "아라시 분지 사절단",
			["Alterac Valley"] = "알터렉 계곡 사절단",
			ala = "ala",
		};
	else
		L.INSTANCE = {
			ONY = "Onyxia's Lair",
			MC = "Molten Core",
			BWL = "Blackwing Lair",
			ZG = "Zul'Gurub",
			RAQ = "Ruins of Ahn'Qiraj",
			TAQ = "Ahn'Qiraj",
			NAXX = "Naxxramas",
			DarkMoon = "DarkMoon",
			["DarkMoon: Elwynn"] = "DarkMoon \124cff00afffElwynn\124r",
			["DarkMoon: Mulgore"] = "DarkMoon \124cffff3f00Mulgore\124r",
			["Fishing Extravaganza"] = "Fishing Extravaganza",
			["Warsong Gulch"] = "Warsong Gulch Holidays",
			["Arathi Basin"] = "Arathi Basin Holidays",
			["Alterac Valley"] = "Alterac Valley Holidays",
			ala = "ala",
		};
	end
end
local ARTWORK_PATH = "Interface\\AddOns\\alaCalendar\\ARTWORK\\";
---------------------------------------------------------------------------------------------------
local AVAR, VAR, SET = nil, nil, nil;
local gui = {  };

local PLAYER_REALM_ID = tonumber(GetRealmID());
local PLAYER_REALM_NAME = GetRealmName();
local PLAYER_GUID = UnitGUID('player');

local function info_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if self.info_lines then
		for _, v in pairs(self.info_lines) do
			GameTooltip:AddLine(v);
		end
	end
	GameTooltip:Show();
end
local function info_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide();
	end
end
local function IsEastAsiaFormat()
	return LOCALE == "zhCN" or LOCALE == "zhTW" or LOCALE == "koKR";
end

local _EventHandler = CreateFrame("FRAME");
do	--	EventHandler
	local function OnEvent(self, event, ...)
		return NS[event](...);
	end
	function _EventHandler:FireEvent(event, ...)
		local func = NS[event];
		if func then
			return func(...);
		end
	end
	function _EventHandler:RegEvent(event)
		NS[event] = NS[event] or _noop_;
		self:RegisterEvent(event);
		self:SetScript("OnEvent", OnEvent);
	end
	function _EventHandler:UnregEvent(event)
		self:UnregisterEvent(event);
	end
end

do	--	util
	local data_valid_time = 86400;
	function NS.seconds_to_colored_formatted_time_len(sec)
		local p = max(0.0, 1.0 - sec / data_valid_time);
		local r = 0.0;
		local g = 0.0;
		if p > 0.5 then
			r = (1.0 - p) * 255.0;
			g = 255.0;
		else
			r = 255.0;
			g = p * 255;
		end
		--
		local d = floor(sec / 86400);
		sec = sec % 86400;
		local h = floor(sec / 3600);
		sec = sec % 3600;
		local m = floor(sec / 60);
		sec = sec % 60;
		if d > 0 then
			return format(L["COLORED_FORMATTED_TIME_LEN"][1], r, g, d, h, m, sec);
		elseif h > 0 then
			return format(L["COLORED_FORMATTED_TIME_LEN"][2], r, g, h, m, sec);
		elseif m > 0 then
			return format(L["COLORED_FORMATTED_TIME_LEN"][3], r, g, m, sec);
		else
			return format(L["COLORED_FORMATTED_TIME_LEN"][4], r, g, sec);
		end
	end
	function NS.seconds_to_formatted_time(sec)
		if sec and type(sec) == 'number' then
			return date(L["FORMATTED_TIME"], sec);
		end
	end
	function NS.seconds_to_formatted_time_len(sec)
		local d = floor(sec / 86400);
		sec = sec % 86400;
		local h = floor(sec / 3600);
		sec = sec % 3600;
		local m = floor(sec / 60);
		sec = sec % 60;
		if d > 0 then
			return format(L["FORMATTED_TIME_LEN"][1], d, h, m, sec);
		elseif h > 0 then
			return format(L["FORMATTED_TIME_LEN"][2], h, m, sec);
		elseif m > 0 then
			return format(L["FORMATTED_TIME_LEN"][3], m, sec);
		else
			return format(L["FORMATTED_TIME_LEN"][4], sec);
		end
	end
end

do	--	MAIN
	local to_date = {  };
	do	--	to_date
		local const_epoch = { 1970, 1, 1, 0, 0, 0, 4, 0, };
		do
			const_epoch[8] = const_epoch[8] - const_epoch[6] - const_epoch[5] * 60 - const_epoch[4] * 3600;
			const_epoch[4] = 0;
			const_epoch[5] = 0;
			const_epoch[6] = 0;
			if const_epoch[2] ~= 1 or const_epoch[3] ~= 1 then
				local ofs_days = to_date.get_year_day_index(const_epoch[1], const_epoch[2], const_epoch[3]) - 1;
				const_epoch[2] = 1;
				const_epoch[3] = 1;
				const_epoch[7] = (const_epoch[7] - ofs_days) % NUM_COL;
				const_epoch[8] = const_epoch[8] - ofs_days * 86400;
			end
		end
		local month_days = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, };
		function to_date.time()
			return GetServerTime();
		end
		function to_date.date(_format, _time)
			_time = _time or to_date.time();
			return date(_format, _time);
		end
		function to_date.built_in_date(_format, _time)
			_time = _time or to_date.time();
			local Y, m, d, W, R = to_date.get_localized_ofs_date_val(_time);
			local H = floor(R / 3600);
			local M = floor((R % 3600) / 60);
			local S = R % 60;
			_format = gsub(_format, "%%[Yy]", Y);
			_format = gsub(_format, "%%m", format("%02d", m));
			_format = gsub(_format, "%%[Bb]", L.MONTH[m]);
			_format = gsub(_format, "%%d", format("%02d", d));
			_format = gsub(_format, "%%H", format("%02d", H));
			_format = gsub(_format, "%%M", format("%02d", M));
			_format = gsub(_format, "%%S", format("%02d", S));
			_format = gsub(_format, "%%w", W);
			_format = gsub(_format, "%%lw", L.WEEKTITLE[W]);
			_format = gsub(_format, "%%%%", "%%");
			return _format;
		end
		function to_date.get_user_time_zone()
			local utc = date("!*t");
			local loc = date("*t");
			--	year, month, day, hour, min, sec, wday, yday, isdst
			local sec = ((loc.year == utc.year) and (loc.yday - utc.yday) * 86400 or ((loc.year > utc.year) and 86400 or -86400)) +
						(loc.hour - utc.hour) * 3600 + (loc.min - utc.min) * 60 + (loc.sec - utc.sec);
			if sec == 0 then
				return 0;
			elseif sec > 0 then
				return floor((sec + 1800) / 3600);
			else
				return ceil((sec - 1800) / 3600);
			end
		end
		function to_date.get_month_days(Y, M)
			if M == 2 then
				--	mod4 = 0 and mod100 ~= 0
				--	mod400 == 0 and mod3200 ~= 0
				--	mod172800 == 0
				--[[if Y % 172800 == 0 then
					return 29;
				elseif Y % 3200 == 0 then
					return 28;
				else--]]if Y % 400 == 0 then
					return 29;
				elseif Y % 100 == 0 then
					return 28;
				elseif Y % 4 == 0 then
					return 29;
				else
					return 28;
				end
			else
				return month_days[M];
			end
		end
		function to_date.get_year_days(Y)
				--	mod4 = 0 and mod100 ~= 0
				--	mod400 == 0 and mod3200 ~= 0
				--	mod172800 == 0
				--[[if Y % 172800 == 0 then
					return 366;
				elseif Y % 3200 == 0 then
					return 365;
				else--]]if Y % 400 == 0 then
					return 366;
				elseif Y % 100 == 0 then
					return 365;
				elseif Y % 4 == 0 then
					return 366;
				else
					return 365;
				end
		end
		function to_date.get_year_remaining_days(Y, M, D)
			local days = to_date.get_month_days(Y, M) - D + 1;
			for month = M + 1, 12 do
				days = days + to_date.get_month_days(Y, month);
			end
			return days;
		end
		function to_date.get_year_day_index(Y, M, D)
			local days = 0;
			for month = 1, M - 1 do
				days = days + to_date.get_month_days(Y, month);
			end
			days = days + D;
			return days;
		end
		function to_date.localized_ofs(val)
			return val - to_date.timeZone * 3600;
		end
		function to_date.get_localized_ofs_date_val(val)		--	localized_ofs time modified by timeZone offset [time - timeZone * 3600]
			-- val = to_date.localized_ofs(val);
			local Y, M, D, h, m, s, w, ofs = unpack(const_epoch);
			ofs = to_date.localized_ofs(ofs);
			--	M, D are always 1	h, m, s are always 0
			w = (w + floor((val - ofs) / 86400)) % NUM_COL;
			while true do
				local yhs = to_date.get_year_days(Y) * 86400;
				if ofs + yhs < val then
					Y = Y + 1;
					ofs = ofs + yhs;
				elseif ofs + yhs == val then
					Y = Y + 1;
					return Y, 1, 1, w, 0;
				else
					while true do
						local mhs = to_date.get_month_days(Y, M) * 86400;
						if ofs + mhs < val then
							M = M + 1;
							ofs = ofs + mhs;
						elseif ofs + mhs == val then
							M = M + 1;
							return Y, M, 1, w, 0;
						else
							local diff = val - ofs;
							return Y, M, 1 + floor(diff / 86400), w, diff % 86400;
						end
					end
				end
			end
		end
		function to_date.get_localized_start_of_day(val)
			val = val or to_date.time();
			return val - (val + to_date.timeZone * 3600) % 86400;
		end
		--	fixed_cycle		1_first_seen,	2_cycle,		3_nil,			4_nil,		5_dur,	6_tex_start,	7_curtain,	8_tex_end,	9_tex_start_coord,	10_curtain_coord,	11_tex_end_coord
		--	month_week_day	1_first_seen,	2_cycle_month,	3_check_day,	4_latency,	5_dur,	6_tex_start,	7_curtain,	8_tex_end,	9_tex_start_coord,	10_curtain_coord,	11_tex_end_coord
		--	using UTC-0
		to_date.milestone = {
			--	P1	MC, ONY			--	Global Time	--	UTC-8	2019-08-27 7:00
			["MC"] = {
				phase = 1,
				type = "fixed_cycle",
				1566860400,
				7 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-moltencore",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			["ONY"] = {
				phase = 1,
				type = "fixed_cycle",
				1567206000,		--	modified	1566860400
				5 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-onyxiaencounter",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			--	DM									--	UTC-8	2019-10-16-Wed
			--	P2	No more RAID					--	UTC-8	2019-11-15-Fri
			--	BG	Warsong Gulch & Alterac Valley	--	UTC-8	2019-12-12-Thu
			--	P3	BWL								--	Global Time	--	UTC-8	2020-2-13-Thu-7:00	PST	2020-2-12-15:00	EST	2020-2-12:18:00
			["BWL"] = {
				phase = 3,
				type = "fixed_cycle",
				1581980400,		--	modified	1581548400
				7 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-blackwinglair",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			--	BG	Arathi Basin		--	UTC-8	2020-3-12-Thu
			--	P4	ZG, SILITHUS		--	Global Time	--	UTC-8	2020-4-16-Thu-7:00	PDT	2020-4-16-15:00
			["ZG"] = {
				phase = 4,
				type = "fixed_cycle",
				1587164400,		--	modified	1586991600
				3 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-zulgurub",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			--	P5
			["TAQ"] = {
				phase = 5,
				type = "fixed_cycle",
				1566860400,
				7 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-aqtemple",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			["RAQ"] = {
				phase = 5,
				type = "fixed_cycle",
				1566774000,
				5 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-aqruins",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			--	P6
			["NAXX"] = {
				phase = 6,
				type = "fixed_cycle",
				1566860400,
				7 * 86400,
				nil,
				nil,
				0,
				ARTWORK_PATH .. "Milestone\\lfgicon-naxxramas",
				nil,
				nil,
				nil,
				nil,
				nil,
				instance = true,
			},
			--
			--	Festival
			--	P3	DarkMoon			--	UTC-8	2020-2-7
			["DarkMoon: Mulgore"] = {
				phase = 3,
				type = "month_week_day",
				1581033600 + 4 * 3600,
				2,
				5,
				3 * 86400 + 4 * 3600,
				7 * 86400 - 1 - 4 * 3600,
				"interface\\calendar\\holidays\\calendar_darkmoonfairemulgorestart",
				"interface\\calendar\\holidays\\calendar_darkmoonfairemulgoreongoing",
				"interface\\calendar\\holidays\\calendar_darkmoonfairemulgoreend",
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				festival = true,
				local_time = true,
			},
			["DarkMoon: Elwynn"] = {
				phase = 3,
				type = "month_week_day",
				1583452800 + 4 * 3600,
				2,
				5,
				3 * 86400 + 4 * 3600,
				7 * 86400 - 1 - 4 * 3600,
				"interface\\calendar\\holidays\\calendar_darkmoonfaireelwynnstart",
				"interface\\calendar\\holidays\\calendar_darkmoonfaireelwynnongoing",
				"interface\\calendar\\holidays\\calendar_darkmoonfaireelwynnend",
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				festival = true,
				local_time = true,
			},
			--	P4	Fishing Extravaganza
			["Fishing Extravaganza"] = {
				phase = 4,
				type = "fixed_cycle",
				1587304800,
				7 * 86400,
				nil,
				nil,
				7200 - 1,
				"interface\\calendar\\holidays\\calendar_fishingextravaganza",
				nil,
				nil,
				{ 0.0, 91 / 128, 0.0, 91 / 128, },
				nil,
				nil,
				festival = true,
				local_time = true,
				texture_channel2 = true,
			},
			--	Server Time	--	03-13	04-10	05-08	Warsong Gulch
			["Warsong Gulch"] = {
				phase = 3,
				type = "fixed_cycle",
				1584057600,
				28 * 86400,
				nil,
				nil,
				4 * 86400 - 1,
				"interface\\glues\\loadingscreens\\loadscreenwarsonggulch",		-- "interface\\lfgframe\\lfgicon-battleground",
				"interface\\calendar\\holidays\\calendar_weekendmistsofpandariaongoing",
				nil,
				nil,
				{ 0.0, 91 / 128, 91 / 128, 0.0, },
				nil,
				festival = true,
				local_time = true,
				curtain_channel2 = true,
			},
			--	Server Time	--	03-20	04-17	05-15	Arathi Basin
			["Arathi Basin"] = {
				phase = 3,
				type = "fixed_cycle",
				1584662400,
				28 * 86400,
				nil,
				nil,
				4 * 86400 - 1,
				"interface\\glues\\loadingscreens\\loadscreenarathibasin",		-- "interface\\calendar\\holidays\\calendar_volunteerguardday",
				"interface\\calendar\\holidays\\calendar_weekendpvpskirmishongoing",
				nil,
				nil,
				{ 0.0, 91 / 128, 91 / 128, 0.0, },
				nil,
				festival = true,
				local_time = true,
				curtain_channel2 = true,
			},
			--	Server Time	--	03-27	04-24	05-22	None
			--	Server Time	--	04-03	05-01	05-29	Alterac Valley
			["Alterac Valley"] = {
				phase = 3,
				type = "fixed_cycle",
				1585872000,
				28 * 86400,
				nil,
				nil,
				4 * 86400 - 1,
				"interface\\glues\\loadingscreens\\loadscreenpvpbattleground",	-- "interface\\lfgframe\\lfgicon-battleground",
				"interface\\calendar\\holidays\\calendar_weekendwrathofthelichkingongoing",
				nil,
				nil,
				{ 0.0, 91 / 128, 91 / 128, 0.0, },
				nil,
				festival = true,
				local_time = true,
				curtain_channel2 = true,
			},
			["ala"] = {
				phase = 0,
				type = "fixed_cycle",
				1566835200,
				7 * 86400,
				nil,
				nil,
				86400,
				"interface\\lfgframe\\lfgicon-moltencore",
				nil,
				nil,
				instance = true,
			},
		};
		to_date.milestone_list = {
			"NAXX",
			"TAQ",
			"BWL",
			"MC",
			-- "ala",
			"RAQ",
			"ZG",
			"ONY",
			"Warsong Gulch",
			"Arathi Basin",
			"Alterac Valley",
			"DarkMoon: Mulgore",
			"DarkMoon: Elwynn",
			"Fishing Extravaganza",
		};
		function NS.set_time_zone()
			to_date.timeZone = SET.use_realm_time_zone and to_date.realmTimeZone or to_date.userTimeZone;
		end
		function NS.init_time_zone()
			local userTimeZone = to_date.get_user_time_zone();
			to_date.userTimeZone = userTimeZone;
			NS.apply_region[SET.region]();
			NS.set_time_zone();
		end
		NS.apply_region = {
			[1] = function(region)	--	1 = US and Brazil and Oceania		UTC-8
				to_date.milestone["MC"][1] = 18135 * 86400 + 17 * 3600;		--
				to_date.milestone["ONY"][1] = 18141 * 86400 + 17 * 3600;	--
				to_date.milestone["BWL"][1] = 18310 * 86400 + 17 * 3600;	--
				to_date.milestone["ZG"][1] = 18368 * 86400 + 17 * 3600;		--
				to_date.milestone["TAQ"][1] = 18135 * 86400 + 17 * 3600;	--
				to_date.milestone["RAQ"][1] = 18138 * 86400 + 17 * 3600;	--~
				to_date.milestone["NAXX"][1] = 18135 * 86400 + 17 * 3600;	--
				to_date.milestone["DarkMoon: Mulgore"][1] = 18298 * 86400 + 9 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][2] = 2;
				to_date.milestone["DarkMoon: Mulgore"][3] = 5;
				to_date.milestone["DarkMoon: Mulgore"][4] = 3 * 86400 + 9 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][5] = 7 * 86400 - 9 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][1] = 18327 * 86400 + 9 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][2] = 2;
				to_date.milestone["DarkMoon: Elwynn"][3] = 5;
				to_date.milestone["DarkMoon: Elwynn"][4] = 3 * 86400 + 9 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][5] = 7 * 86400 - 9 * 3600;
				to_date.milestone["Fishing Extravaganza"][1] = 1587254400 + 14 * 3600;
				to_date.milestone["Warsong Gulch"][1] = 1584057600;
				to_date.milestone["Arathi Basin"][1] = 1584662400;
				to_date.milestone["Alterac Valley"][1] = 1585872000;
				for _, val in pairs(to_date.milestone) do
					if val.local_time then
						val[1] = val[1] - (-8) * 3600;
					end
				end
				to_date.realmTimeZone = -8;
			end,
			[2] = function(region)	--	2 = Korea
				to_date.milestone["MC"][1] = 1567040400;		--
				to_date.milestone["ONY"][1] = 1566954000;		--
				to_date.milestone["BWL"][1] = 1581555600;		--
				to_date.milestone["ZG"][1] = 1586826000;		--
				to_date.milestone["TAQ"][1] = 1567040400;		--
				to_date.milestone["RAQ"][1] = 1567213200;		--~
				to_date.milestone["NAXX"][1] = 1567040400;		--
				to_date.milestone["DarkMoon: Mulgore"][1] = 18298 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][2] = 2;
				to_date.milestone["DarkMoon: Mulgore"][3] = 5;
				to_date.milestone["DarkMoon: Mulgore"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][1] = 18327 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][2] = 2;
				to_date.milestone["DarkMoon: Elwynn"][3] = 5;
				to_date.milestone["DarkMoon: Elwynn"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["Fishing Extravaganza"][1] = 1587304800;
				to_date.milestone["Warsong Gulch"][1] = 1584057600;
				to_date.milestone["Arathi Basin"][1] = 1584662400;
				to_date.milestone["Alterac Valley"][1] = 1585872000;
				for _, val in pairs(to_date.milestone) do
					if val.local_time then
						val[1] = val[1] - (9) * 3600;
					end
				end
				to_date.realmTimeZone = 9;
			end,
			[3] = function(region)	--	3 = Europe			UTC+1
				to_date.milestone["MC"][1] = 18136 * 86400 + 8 * 3600;		--
				to_date.milestone["ONY"][1] = 18140 * 86400 + 8 * 3600;		--
				to_date.milestone["BWL"][1] = 18304 * 86400 + 8 * 3600;		--
				to_date.milestone["ZG"][1] = 18368 * 86400 + 8 * 3600;		--
				to_date.milestone["TAQ"][1] = 18136 * 86400 + 8 * 3600;		--
				to_date.milestone["RAQ"][1] = 18368 * 86400 + 8 * 3600;		--~
				to_date.milestone["NAXX"][1] = 18136 * 86400 + 8 * 3600;	--
				to_date.milestone["DarkMoon: Mulgore"][1] = 18298 * 86400 + 6 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][2] = 2;
				to_date.milestone["DarkMoon: Mulgore"][3] = 5;
				to_date.milestone["DarkMoon: Mulgore"][4] = 3 * 86400 + 6 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][5] = 7 * 86400 - 6 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][1] = 18327 * 86400 + 6 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][2] = 2;
				to_date.milestone["DarkMoon: Elwynn"][3] = 5;
				to_date.milestone["DarkMoon: Elwynn"][4] = 3 * 86400 + 6 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][5] = 7 * 86400 - 6 * 3600;
				to_date.milestone["Fishing Extravaganza"][1] = 1587254400 + 14 * 3600;
				to_date.milestone["Warsong Gulch"][1] = 1584057600;
				to_date.milestone["Arathi Basin"][1] = 1584662400;
				to_date.milestone["Alterac Valley"][1] = 1585872000;
				for _, val in pairs(to_date.milestone) do
					if val.local_time then
						val[1] = val[1] - (1) * 3600;
					end
				end
				to_date.realmTimeZone = 1;
			end,
			[4] = function(region)	--	4 = Taiwan
				to_date.milestone["MC"][1] = 1567040400;
				to_date.milestone["ONY"][1] = 1566954000;
				to_date.milestone["BWL"][1] = 1581555600;
				to_date.milestone["ZG"][1] = 1586826000;
				to_date.milestone["TAQ"][1] = 1567040400;
				to_date.milestone["RAQ"][1] = 1567213200;
				to_date.milestone["NAXX"][1] = 1567040400;
				to_date.milestone["DarkMoon: Mulgore"][1] = 18298 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][2] = 2;
				to_date.milestone["DarkMoon: Mulgore"][3] = 6;
				to_date.milestone["DarkMoon: Mulgore"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][1] = 18327 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][2] = 2;
				to_date.milestone["DarkMoon: Elwynn"][3] = 6;
				to_date.milestone["DarkMoon: Elwynn"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["Fishing Extravaganza"][1] = 1587304800;
				to_date.milestone["Warsong Gulch"][1] = 1584057600;
				to_date.milestone["Arathi Basin"][1] = 1584662400;
				to_date.milestone["Alterac Valley"][1] = 1585872000;
				for _, val in pairs(to_date.milestone) do
					if val.local_time then
						val[1] = val[1] - (8) * 3600;
					end
				end
				to_date.realmTimeZone = 8;
			end,
			[5] = function(region)	--	5 = China
				to_date.milestone["MC"][1] = 1566860400;		--
				to_date.milestone["ONY"][1] = 1567206000;		--	modified	1566860400
				to_date.milestone["BWL"][1] = 1581980400;		--	modified	1581548400
				to_date.milestone["ZG"][1] = 1587164400;		--	modified	1586991600
				to_date.milestone["TAQ"][1] = 1566860400;		--
				to_date.milestone["RAQ"][1] = 1567206000;		--~
				to_date.milestone["NAXX"][1] = 1566860400;		--
				to_date.milestone["DarkMoon: Mulgore"][1] = 18298 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][2] = 2;
				to_date.milestone["DarkMoon: Mulgore"][3] = 5;
				to_date.milestone["DarkMoon: Mulgore"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Mulgore"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][1] = 18327 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][2] = 2;
				to_date.milestone["DarkMoon: Elwynn"][3] = 5;
				to_date.milestone["DarkMoon: Elwynn"][4] = 3 * 86400 + 4 * 3600;
				to_date.milestone["DarkMoon: Elwynn"][5] = 7 * 86400 - 4 * 3600;
				to_date.milestone["Fishing Extravaganza"][1] = 1587304800;
				to_date.milestone["Warsong Gulch"][1] = 1584057600;
				to_date.milestone["Arathi Basin"][1] = 1584662400;
				to_date.milestone["Alterac Valley"][1] = 1585872000;
				for _, val in pairs(to_date.milestone) do
					if val.local_time then
						val[1] = val[1] - (8) * 3600;
					end
				end
				to_date.realmTimeZone = 8;
			end,
		};
	end
	NS.to_date = to_date;

	local extern_list = {  };
	do	--	external
			--	head = 'string' or 'number' or table{ tex, coord, title, color, }, function(inst)return tex, coord, title, color
			--	text = 'string' or 'number' or table{ tex, coord, title, color_title, cool, color_cool, }, function(inst)tex, coord, title, color_title, cool, color_cool
		function NS.ext_Reset()
			wipe(extern_list);
		end
		function NS.ext_RegHeader(head, text)
			if extern_list[head] == nil then
				extern_list[head] = { text = text, };
				return;
			else
				return false;
			end
		end
		function NS.ext_AddLine(head, key, val)
			local list = extern_list[head];
			if list then
				list[key] = val;
				return true;
			else
				return false;
			end
		end
		function NS.ext_UpdateBoard()
			local board = gui["BOARD"];
			if board and board:IsShown() then
				board:update_list();
				board:update_func();
			end
		end
	end

	do	--	func
		local function cal_and_val(Y1, M1, D1, W1)
			while M1 <= 0 do
				M1 = M1 + 12;
				Y1 = Y1 - 1;
			end
			while M1 > 12 do
				M1 = M1 - 12;
				Y1 = Y1 + 1;
			end
			local N1 = to_date.get_month_days(Y1, M1);
			local W1S = (W1 - D1 + 1) % NUM_COL;
			local W1E = (W1 - D1 + N1) % NUM_COL;
			local PS1 = (W1S - SET.first_col_day) % NUM_COL + 1;
			local PE1 = (W1E - SET.first_col_day) % NUM_COL + 1;	--	((SET.first_col_day - 1) % NUM_COL - W1E) % NUM_COL;
			local L1 = (PS1 - 1 + N1 + NUM_COL - PE1) / NUM_COL;
			return Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1;
		end
		function NS.proc_update_calendar(frame)
			--	local
				local var = frame.var;
				local now = to_date.time();
				local Y, M, D, W, R = to_date.get_localized_ofs_date_val(now);							--	TODAY
				local Y1, M1, D1, W1, N1, W1S, W1E, PS1, PE1, L1 = Y, M, 1, (W + 1 - D) % NUM_COL;		--	BASE DATE OF PROCESSING
				local NOW1 = now - R - (D - 1) * 86400;
				local Y0, M0, D0, N0, NOW0;																--	DATE of cell{ col = 1, row = 1 }
			--	proc var
				local month_ofs = var.month_ofs;
				local line_ofs = var.line_ofs;
				if month_ofs ~= 0 then
					local M1days = 0;
					if month_ofs > 0 then
						for ofs = 0, month_ofs - 1 do
							M1days = M1days + to_date.get_month_days(Y1, M1);
							M1 = M1 + 1;
							if M1 > 12 then
								Y1 = Y1 + 1;
								M1 = 1;
							end
						end
					else
						for ofs = 0, month_ofs + 1, -1 do
							M1 = M1 - 1;
							if M1 <= 0 then
								Y1 = Y1 - 1;
								M1 = 12;
							end
							M1days = M1days - to_date.get_month_days(Y1, M1);
						end
					end
					W1 = (W1 + M1days) % NUM_COL;
					NOW1 = NOW1 + M1days * 86400;
				end
				Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1 = cal_and_val(Y1, M1, D1, W1);
				-- _log_("1#B", Y1 .. '-' .. M1 .. '-' .. D1 .. '#' .. W1, month_ofs, line_ofs, N1, "S" .. W1S, "E" .. W1E);
				--
				if line_ofs < 0 then
					while true do
						local tm1 = M1 - 1;
						local ty1 = Y1;
						if tm1 <= 0 then
							tm1 = 12;
							ty1 = ty1 - 1;
						end
						local tM1days = to_date.get_month_days(ty1, tm1);
						local tW1 = (W1 - tM1days) % NUM_COL;
						local tY1, tM1, tD1, tN1, tW1S, tW1E, tPS1, tPE1, tL1 = cal_and_val(ty1, tm1, D1, tW1);
						if -line_ofs >= tL1 then
							month_ofs = month_ofs - 1;
							line_ofs = line_ofs + tL1;
							if PS1 ~= 1 then
								line_ofs = line_ofs - 1;
							end
							W1 = tW1;
							Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1 = tY1, tM1, tD1, tN1, tW1S, tW1E, tPS1, tPE1, tL1;
							NOW1 = NOW1 - tM1days * 86400;
						else
							local days0 = - line_ofs * NUM_COL + PS1 - 1;
							if days0 > NUM_COL * NUM_ROW * 0.5 then
								month_ofs = month_ofs - 1;
								line_ofs = line_ofs + tL1; 
								if PS1 ~= 1 then
									line_ofs = line_ofs - 1;
								end
								W1 = tW1;
								Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1 = tY1, tM1, tD1, tN1, tW1S, tW1E, tPS1, tPE1, tL1;
								NOW1 = NOW1 - tM1days * 86400;
							else
								break;
							end
						end
					end
				elseif line_ofs > 0 then
					while true do
						if line_ofs >= L1 then
							local M1days = to_date.get_month_days(Y1, M1);
							month_ofs = month_ofs + 1;
							line_ofs = line_ofs - L1;
							W1 = (W1 + M1days) % NUM_COL;
							Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1 = cal_and_val(Y1, M1 + 1, D1, W1);
							NOW1 = NOW1 + M1days * 86400;
							if PS1 ~= 1 then
								line_ofs = line_ofs + 1;
							end
						else
							local days0 = (L1 - 1 - line_ofs) * NUM_COL + PE1;
							if days0 < NUM_COL * NUM_ROW * 0.5 then
								local M1days = to_date.get_month_days(Y1, M1);
								month_ofs = month_ofs + 1;
								line_ofs = line_ofs - L1;
								W1 = (W1 + M1days) % NUM_COL;
								Y1, M1, D1, N1, W1S, W1E, PS1, PE1, L1 = cal_and_val(Y1, M1 + 1, D1, W1);
								NOW1 = NOW1 + M1days * 86400;
								if PS1 ~= 1 then
									line_ofs = line_ofs + 1;
								end
							else
								break;
							end
						end
					end
				end
				-- _log_("2#B", Y1 .. '-' .. M1 .. '-' .. D1 .. '#' .. W1, month_ofs, line_ofs, N1, "S" .. W1S, "E" .. W1E);
				if line_ofs > 0 then
					Y0, M0, N0 = Y1, M1, N1;
					D0 = (line_ofs - 1) * NUM_COL + NUM_COL - PS1 + 1 + 1;
					NOW0 = NOW1 + (D0 - D1) * 86400;
				elseif line_ofs < 0 then
					M0 = M1 - 1;
					if M0 <= 0 then
						Y0 = Y1 - 1;
						M0 = 12;
					else
						Y0 = Y1;
					end
					N0 = to_date.get_month_days(Y0, M0);
					D0 = N0 + 1 - (- line_ofs) * NUM_COL - PS1 + D1;
					NOW0 = NOW1 - (N0 - D0 + D1) * 86400;
				else
					if PS1 == 1 then
						Y0, M0, D0, N0, NOW0 = Y1, M1, D1, N1, NOW1;
					else
						M0 = M1 - 1;
						if M0 <= 0 then
							Y0 = Y1 - 1;
							M0 = 12;
						else
							Y0 = Y1;
						end
						N0 = to_date.get_month_days(Y0, M0);
						D0 = N0 + 1 - PS1 + D1;
						NOW0 = NOW1 - (N0 - D0 + D1) * 86400;
					end
				end
				var.month_ofs = month_ofs;
				var.line_ofs = line_ofs;
				var.first_cell_time = { Y0, M0, D0, N0, NOW0, };
				var.center_cell_time = { Y1, M1, D1, N1, NOW1, };
			--	gui
				if IsEastAsiaFormat() then
					frame:SetDateLeftText(format(L.YEAR_FORMAT, Y1));
					frame:SetDateRightText(format(L.MONTH_FORMAT, L.MONTH[M1]));
				else
					frame:SetDateRightText(format(L.YEAR_FORMAT, Y1));
					frame:SetDateLeftText(format(L.MONTH_FORMAT, L.MONTH[M1]));
				end
				local cells = frame.cells;
				local ofs = 0;
				--
				for col = 1, NUM_ROW do
					local rc = cells[col];
					for row = 1, NUM_COL do
						local cell = rc[row];
						cell:SetTitle(M0 .. "-" .. D0);
						if M0 == M1 then
							cell:Bright();
						else
							cell:Dark();
						end
						if Y0 == Y and M0 == M and D0 == D then
							cell:Today();
						else
							cell:NotToday();
						end
						cell.now = NOW0;
						cell:HideFestival1Tex();
						cell:HideFestival2Tex();
						cell:HideCurtain1Tex();
						cell:HideCurtain2Tex();
						local info = nil;
						cell:ResetInstance();
						local state = cell.state;
						wipe(state);
						for _, inst in ipairs(to_date.milestone_list) do
							if SET.inst_hash[inst] then
								local val = to_date.milestone[inst];
								if val and val.phase <= curPhase then
									local start_of_day_first_seen = to_date.get_localized_start_of_day(val[1]);
									if NOW0 >= start_of_day_first_seen then
										if val.type == "fixed_cycle" then
											local diff = (NOW0 - start_of_day_first_seen) % val[2];
											local end_time_ofs = val[5] + val[1] - start_of_day_first_seen;
											if diff <= max(end_time_ofs, 86400 - 1) then			--	in the range of dur, at least one day
												if diff < 86400 then						--	the first day
													if val.festival then
														if val.texture_channel2 then
															cell:SetFestival2Tex(val[6]);
															if val[9] then
																cell:SetFestival2TexCoord(unpack(val[9]));
															end
														else
															cell:SetFestival1Tex(val[6]);
															if val[9] then
																cell:SetFestival1TexCoord(unpack(val[9]));
															end
														end
													end
													if end_time_ofs < 86400 then
														state[inst] = 2;
													else
														state[inst] = 1;
													end
												else
													local last_day_remaining = end_time_ofs % 86400;
													if last_day_remaining == 0 then
														last_day_remaining = 86400;
													end
													if diff + 86400 > end_time_ofs - last_day_remaining then
														state[inst] = -1;
													else
														state[inst] = 0;
													end
												end
												if val[7] then
													if val.curtain_channel2 then
														cell:SetCurtain2Tex(val[7]);
														if val[10] then
															cell:SetCurtain2TexCoord(unpack(val[10]));
														end
													else
														cell:SetCurtain1Tex(val[7]);
														if val[10] then
															cell:SetCurtain1TexCoord(unpack(val[10]));
														end
													end
												end
												if val.instance then
													if SET.instance_icon then
														cell:AddInstance(val[6], val[9]);
													end
													if SET.instance_text then
														info = info and (info .. "\n" .. inst) or inst;
													end
												end
											end
										elseif val.type == "month_week_day" then
											local fit = false;
											if val[2] and val[2] > 1 then
												local y, m = to_date.get_localized_ofs_date_val(val[1]);
												local n_month = (Y0 - y) * 12 + (M0 - m);
												fit = n_month % val[2] == 0;
											else
												fit = true;
											end
											if fit then
												local day_check = (val[3] - ((row + SET.first_col_day - 1) % NUM_COL - D0 + 1) % NUM_COL + 1) % NUM_COL;
												day_check = day_check == 0 and 7 or day_check;
												local diff = (D0 - day_check) * 86400;-- + (to_date.timeZone - to_date.realmTimeZone) * 3600;
												local start_ofs = val[4] + (to_date.timeZone - to_date.realmTimeZone) * 3600;
												if (diff + 86400 - 1) >= start_ofs and diff < (start_ofs + val[5]) then
													if diff < (floor(start_ofs / 86400) * 86400 + 86400) then		--	the first day
														if val.festival then
															if val.texture_channel2 then
																cell:SetFestival2Tex(val[6]);
																if val[9] then
																	cell:SetFestival2TexCoord(unpack(val[9]));
																end
															else
																cell:SetFestival1Tex(val[6]);
																if val[9] then
																	cell:SetFestival1TexCoord(unpack(val[9]));
																end
															end
														end
														if (start_ofs + val[5]) < (diff + 86400) then
															state[inst] = 2;
														else
															state[inst] = 1;
														end
													else
														if diff < (start_ofs + val[5] - 86400) then
															if val[7] then
																if val.curtain_channel2 then
																	cell:SetCurtain2Tex(val[7]);
																	if val[10] then
																		cell:SetCurtain2TexCoord(unpack(val[10]));
																	end
																else
																	cell:SetCurtain1Tex(val[7]);
																	if val[10] then
																		cell:SetCurtain1TexCoord(unpack(val[10]));
																	end
																end
															end
															state[inst] = 0;
														else
															if val[7] then
																if val.texture_channel2 then
																	cell:SetFestival2Tex(val[8]);
																	if val[11] then
																		cell:SetFestival2TexCoord(unpack(val[11]));
																	end
																else
																	cell:SetFestival1Tex(val[8]);
																	if val[11] then
																		cell:SetFestival1TexCoord(unpack(val[11]));
																	end
																end
															end
															state[inst] = -1;
														end
													end
													if val.instance then
														if SET.instance_icon then
															cell:AddInstance(val[6], val[9]);
														end
														if SET.instance_text then
															info = info and (info .. "\n" .. inst) or inst;
														end
													end
												end
											end
										end
									end
								end
							end
						end
						cell:RefreshInstance();
						if SET.instance_text then
							cell:SetInfo(info);
						else
							cell:SetInfo(nil);
						end
						D0 = D0 + 1;
						NOW0 = NOW0 + 86400;
						if D0 > N0 then
							M0 = M0 + 1;
							if M0 > 12 then
								Y0 = Y0 + 1;
								M0 = 1;
							end
							D0 = 1;
							N0 = to_date.get_month_days(Y0, M0);
						end
					end
				end
		end
		--
		local function clean_up()
			local now = to_date.time()
			local earliest = BIG_NUMBER;
			for GUID, VAR in pairs(AVAR) do
				for _, inst in pairs(SET.inst_list) do
					local var = VAR[inst];
					if var[2] then
						if var[2] <= now then
							wipe(var);
						else
							earliest = min(earliest, var[2]);
						end
					end
				end
			end
			return earliest;
		end
		local instance_name_hash = {  };
		local timer_update = nil;
		function NS.proc_locked_down_instance()
			for _, inst in pairs(SET.inst_list) do
				wipe(VAR[inst]);
			end
			local earliest = BIG_NUMBER;
			local now = to_date.time()
			for instanceIndex = 1, GetNumSavedInstances() do
				local name, id, reset, difficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(instanceIndex);
				if locked and isRaid then
					local inst = instance_name_hash[name];
					if inst then
						local t = now + reset;
						local var = VAR[inst];
						var[1] = id;
						var[2] = t;
						var[3] = numEncounters;
						var[4] = encounterProgress;
						earliest = min(earliest, t);
						for encounterIndex = 1, numEncounters do
							local bossName, fileDataID, isKilled, unknown4 = GetSavedInstanceEncounterInfo(instanceIndex, encounterIndex);
							var[4 + encounterIndex * 2 - 1] = bossName;
							var[4 + encounterIndex * 2] = isKilled;
						end
					else
					end
				end
			end
			if timer_update ~= nil then
				timer_update:Cancel();
			end
			timer_update = C_Timer.NewTimer(min(earliest - now + 1, 3600, clean_up() - now), NS.proc_locked_down_instance);
			--
			--
			local board = gui["BOARD"];
			if board then
				board:update_list();
				board:update_func();
			end
		end
		function NS.init_instance()
			for _, inst in pairs(SET.inst_list) do
				if VAR[inst] == nil then
					VAR[inst] = {  };
				end
				local name = L.INSTANCE[inst];
				if name then
					instance_name_hash[name] = inst;
				end
			end
			C_Timer.After(1.0, NS.proc_locked_down_instance);
		end
		function NS.PLAYER_LOGOUT(...)
			VAR.PLAYER_LEVEL = UnitLevel('player');
			NS.proc_locked_down_instance();
		end
		function NS.ENCOUNTER_END()
			_EventHandler:run_on_next_tick(NS.proc_locked_down_instance);
		end
		function NS.BOSS_KILL()
			_EventHandler:run_on_next_tick(NS.proc_locked_down_instance);
		end
		function NS.UPDATE_INSTANCE_INFO()
			_EventHandler:run_on_next_tick(NS.proc_locked_down_instance);
		end
		function NS.PLAYER_LEVEL_UP(level)
			VAR.PLAYER_LEVEL = level;
		end
	end

	do	--	ui
		--
			local function region_select(_, val)
				SET.region = val;
				NS.apply_region[val]();
				NS.set_time_zone();
				NS.ui_update_calendar();
				NS.ui_attribute_all("region", val);
			end
			local list_drop_meta = {
				handler = region_select,
				elements = {  },
			};
			for region = 1, 5 do
				local drop = {
					text = L.REGION[region],
					para = { region, },
				};
				tinsert(list_drop_meta.elements, drop);
			end
			local function cell_OnEnter(self)
				local now = self.now;
				if now then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
					GameTooltip:AddLine(to_date.built_in_date(L.FORMAT_DATE_TODAY, now), 1.0, 1.0, 1.0);
					local state = self.state;
					for _, inst in pairs(to_date.milestone_list) do
						local s = state[inst];
						if s then
							local val = to_date.milestone[inst];
							if val.instance then
								GameTooltip:AddDoubleLine(L.INSTANCE[inst] .. L.INSTANCE_RESET, to_date.built_in_date(L.FORMAT_CLOCK, (val[1] % 86400)), 1.0, 1.0, 1.0);
							elseif val.festival then
								if s == 2 then
									GameTooltip:AddDoubleLine(L.INSTANCE[inst], to_date.built_in_date(L.FORMAT_CLOCK, val[1] % 86400) .. " - " ..  to_date.built_in_date(L.FORMAT_CLOCK, val[1] % 86400 + val[5]), 1.0, 1.0, 1.0);
								elseif s == 1 then
									GameTooltip:AddDoubleLine(L.INSTANCE[inst] .. L.FESTIVAL_START, to_date.built_in_date(L.FORMAT_CLOCK, (val[1] % 86400)), 1.0, 1.0, 1.0);
								elseif s == -1 then
									GameTooltip:AddDoubleLine(L.INSTANCE[inst] .. L.FESTIVAL_END, to_date.built_in_date(L.FORMAT_CLOCK, ((val[1] + val[5]) % 86400)), 1.0, 1.0, 1.0);
								else
									GameTooltip:AddLine(L.INSTANCE[inst], 1.0, 1.0, 1.0);
								end
							end
						end
					end
					GameTooltip:Show();
				else
					info_OnLeave(self);
				end
			end
			local function cal_OnMouseWheel(self, delta)
				local frame = self:GetParent();
				frame.var.line_ofs = frame.var.line_ofs - delta;
				NS.proc_update_calendar(frame);
			end
			local function cell_OnMouseWheel(self, delta)
				cal_OnMouseWheel(self:GetParent(), delta)
			end
			local function createCell(parent)
				local cell = CreateFrame("BUTTON", nil, parent);
				cell:SetSize(ui_style.cell_XSize, ui_style.cell_YSize);
				cell:SetHighlightTexture(ui_style.cell_Highlight);
				cell:GetHighlightTexture():SetTexCoord(unpack(ui_style.cell_HighlightCoord));
				cell:GetHighlightTexture():SetAlpha(0.5);
				cell:EnableMouse(true);
				cell:RegisterForDrag("LeftButton");
				cell:SetScript("OnDragStart", function(self)
					self.frame:StartMoving();
				end);
				cell:SetScript("OnDragStop", function(self)
					self.frame:StopMovingOrSizing();
				end);
				cell:SetScript("OnEnter", cell_OnEnter);
				cell:SetScript("OnLeave", info_OnLeave);
				-- cell:SetScript("OnMouseWheel", cell_OnMouseWheel);
				cell:Show();
				cell.frame = parent:GetParent();
				cell.state = {  };

				local bg = cell:CreateTexture(nil, "BACKGROUND");
				bg:SetDrawLayer("BACKGROUND", 0);
				bg:SetPoint("CENTER");
				bg:SetAllPoints(true);
				bg:SetTexture(ui_style.cell_BG);
				bg:SetTexCoord(unpack(ui_style.cell_BG_Coord));

				do	--	festival
					local festival = cell:CreateTexture(nil, "BORDER");
					festival:SetDrawLayer("BORDER", 1);
					festival:SetPoint("TOPLEFT");
					-- festival:SetSize(ui_style.festival_Size, ui_style.festival_Size);
					festival:SetAllPoints(true);
					festival:Hide();
					function cell:SetFestival1Tex(...)
						festival:SetTexture(...);
						festival:Show();
					end
					function cell:SetFestival1TexCoord(...)
						festival:SetTexCoord(...);
					end
					function cell:HideFestival1Tex()
						festival:Hide();
					end

					local curtain = cell:CreateTexture(nil, "ARTWORK");
					curtain:SetDrawLayer("ARTWORK", 1);
					curtain:SetPoint("CENTER");
					curtain:SetAllPoints(true);
					-- curtain:SetBlendMode("ADD");
					curtain:Hide();
					function cell:SetCurtain1Tex(...)
						curtain:SetTexture(...);
						curtain:Show();
					end
					function cell:SetCurtain1TexCoord(...)
						curtain:SetTexCoord(...);
					end
					function cell:HideCurtain1Tex()
						curtain:Hide();
					end
				end

				do	--	festival2
					local festival2 = cell:CreateTexture(nil, "BORDER");
					festival2:SetDrawLayer("BORDER", 2);
					festival2:SetPoint("BOTTOMLEFT");
					-- festival2:SetSize(ui_style.festival_Size, ui_style.festival_Size);
					festival2:SetAllPoints(true);
					festival2:Hide();
					function cell:SetFestival2Tex(...)
						festival2:SetTexture(...);
						festival2:Show();
					end
					function cell:SetFestival2TexCoord(...)
						festival2:SetTexCoord(...);
					end
					function cell:HideFestival2Tex()
						festival2:Hide();
					end

					local curtain2 = cell:CreateTexture(nil, "ARTWORK");
					curtain2:SetDrawLayer("ARTWORK", 2);
					curtain2:SetPoint("CENTER");
					curtain2:SetAllPoints(true);
					-- curtain2:SetBlendMode("ADD");
					curtain2:Hide();
					function cell:SetCurtain2Tex(...)
						curtain2:SetTexture(...);
						curtain2:Show();
					end
					function cell:SetCurtain2TexCoord(x1, x2, y1, y2)
						curtain2:SetTexCoord(x1, x2, y1, y2);
					end
					function cell:HideCurtain2Tex()
						curtain2:Hide();
					end
				end

				local title = cell:CreateFontString(nil, "ARTWORK");
				title:SetDrawLayer("ARTWORK", 7);
				title:SetFont(ui_style.frameFont, ui_style.cellTitleFontSize, "OUTLINE");
				title:SetPoint("TOPLEFT", 4, -2);
				function cell:SetTitle(...)
					title:SetText(...);
				end

				local info = cell:CreateFontString(nil, "ARTWORK");
				info:SetDrawLayer("ARTWORK", 7);
				info:SetJustifyH("LEFT");
				info:SetFont(ui_style.frameFont, ui_style.smallFontSize, "OUTLINE");
				info:SetPoint("BOTTOMLEFT", 4, 4);
				function cell:SetInfo(...)
					info:SetText(...);
				end

				local this_month_mask = cell:CreateTexture(nil, "OVERLAY");
				this_month_mask:SetDrawLayer("OVERLAY", 7);
				this_month_mask:SetPoint("CENTER");
				this_month_mask:SetAllPoints(true);
				this_month_mask:SetColorTexture(unpack(ui_style.cell_this_month_maskColor));
				this_month_mask:Hide();
				function cell:Bright()
					this_month_mask:Hide();
				end
				function cell:Dark()
					this_month_mask:Show();
				end

				local today_mask = cell:CreateTexture(nil, "OVERLAY");
				today_mask:SetDrawLayer("OVERLAY", 7);
				today_mask:SetPoint("CENTER");
				today_mask:SetAllPoints(true);
				today_mask:SetTexture(ui_style.cell_Highlight);
				today_mask:SetTexCoord(unpack(ui_style.cell_HighlightCoord));
				today_mask:SetBlendMode("ADD");
				today_mask:SetVertexColor(unpack(ui_style.cell_today_mask_color));
				today_mask:Hide();
				function cell:Today()
					today_mask:Show();
				end
				function cell:NotToday()
					today_mask:Hide();
				end

				local instances = {  };
				local instances_mask = {  };
				local last_instance = 0;
				function cell:ResetInstance()
					last_instance = 0;
				end
				function cell:AddInstance(tex, coord)
					last_instance = last_instance + 1;
					local inst = instances[last_instance];
					if inst == nil then
						-- inst = CreateFrame("BUTTON", nil, cell);
						inst = cell:CreateTexture(nil, "ARTWORK");
						inst:SetDrawLayer("ARTWORK", 0);
						inst:SetSize(ui_style.cell_inst_Size, ui_style.cell_inst_Size);
						inst:SetAlpha(0.75);
						inst:SetVertexColor(1.0, 1.0, 1.0, 0.75);
						inst:Show();
						instances[last_instance] = inst;
						local inst_mask = cell:CreateTexture(nil, "ARTWORK");
						inst_mask:SetDrawLayer("ARTWORK", 1);
						inst_mask:SetSize(ui_style.cell_inst_Size, ui_style.cell_inst_Size);
						inst_mask:SetTexture("interface\\buttons\\ui-quickslot-depress");
						inst_mask:SetTexCoord(4 / 64, 60 / 64, 4 / 64, 60 / 64);
						inst_mask:SetBlendMode("MOD");
						inst_mask:Show();
						inst_mask:SetPoint("CENTER", inst);
						instances_mask[last_instance] = inst_mask;
						-- inst:SetNormalTexture(135913);
						-- -- inst:GetNormalTexture():SetVertexColor(1.0, 1.0, 1.0, 0.75);
						-- inst:SetHighlightTexture("interface\\buttons\\ui-quickslot-depress");
						-- inst:GetHighlightTexture():SetTexCoord(2 / 64, 62 / 64, 2 / 64, 62 / 64);
						-- inst:GetHighlightTexture():SetBlendMode("MOD");
						-- inst:LockHighlight();
						if last_instance == 1 then
							inst:SetPoint("BOTTOMLEFT", 6, 6);
						elseif last_instance % 3 == 1 then
							inst:SetPoint("BOTTOM", instances[last_instance - 3], "TOP", 0, 0);
						else
							inst:SetPoint("LEFT", instances[last_instance - 1], "RIGHT", 0, 0);
						end
					else
						inst:Show();
						instances_mask[last_instance]:Show();
					end
					-- inst:SetNormalTexture(tex);
					inst:SetTexture(tex);
					if coord then
						-- inst:GetNormalTexture():SetTexCoord(unpack(coord));
						inst:SetTexCoord(unpack(coord));
					end
				end
				function cell:RefreshInstance()
					for index = last_instance + 1, #instances do
						instances[index]:Hide();
						instances_mask[index]:Hide();
					end
				end

				return cell;
			end
			local function createWeekTitle(parent)
				local bg = parent:CreateTexture(nil, "ARTWORK");
				bg:SetSize(ui_style.cell_XSize, ui_style.weekTitle_YSize);
				bg:SetTexture(ui_style.weekTitle_BG);
				bg:SetTexCoord(unpack(ui_style.weekTitle_BG_Coord));
				bg:Show();
				local str = parent:CreateFontString(nil, "OVERLAY");
				str:SetFont(ui_style.frameFont, ui_style.weekTitleFontSize);
				str:SetPoint("CENTER", bg);
				str:Show();
				local wt = { bg, str, };
				function wt:SetText(...)
					self[2]:SetText(...);
				end
				function wt:SetTexture(...)
					self[1]:SetTexture(...);
				end
				function wt:Show()
					self[1]:Show();
					self[2]:Show();
				end
				function wt:Hide()
					self[1]:Hide();
					self[2]:Hide();
				end
				function wt:SetVertexColor(...)
					self[1]:SetVertexColor(...);
					self[2]:SetVertexColor(...);
				end
				function wt:SetTextColor(...)
					self[2]:SetVertexColor(...);
				end
				function wt:ClearAllPoints()
					self[1]:ClearAllPoints();
				end
				function wt:SetPoint(...)
					self[1]:SetPoint(...);
				end
				return wt;
			end
		--
		function NS.ui_refreshWeekTitle(frame)
			local weekTitles = frame.weekTitles;
			for col = 1, NUM_COL do
				local wt = weekTitles[col];
				local day = (col + SET.first_col_day - 1) % NUM_COL;
				wt:SetText(L.WEEKTITLE[day]);
			end
		end
		function NS.ui_CreateCalendar()
			local frame = CreateFrame("FRAME", "ALA_CALENDAR", UIParent);
			tinsert(UISpecialFrames, "ALA_CALENDAR");
			frame:SetBackdrop(ui_style.frameBackdrop);
			frame:SetBackdropColor(unpack(ui_style.frameBackdropColor));
			frame:SetBackdropBorderColor(unpack(ui_style.frameBackdropBorderColor));
			frame:SetSize(ui_style.frame_XSize, ui_style.frame_YSize);
			frame:SetFrameStrata("HIGH");
			frame:SetPoint("CENTER", 0, 0);
			frame:SetScale(SET.scale);
			frame:SetAlpha(SET.alpha);
			frame:EnableMouse(true);
			frame:SetMovable(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", function(self)
				self:StartMoving();
			end);
			frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing();
			end);
			frame:Hide();
			frame.var = {
				month_ofs = 0,
				line_ofs = 0,
			};
			local StartMoving = frame.StartMoving;
			function frame.StartMoving(self)
				self:ClearAllPoints();
				local cal = gui["BOARD"];
				cal:ClearAllPoints();
				cal:SetPoint("TOPLEFT", self, "TOPRIGHT", 1, 0);
				StartMoving(self);
			end

			local close = CreateFrame("BUTTON", nil, frame);
			close:SetSize(20, 20);
			close:SetNormalTexture("interface\\common\\indicator-red");
			close:GetNormalTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:SetPushedTexture("interface\\common\\indicator-red");
			close:GetPushedTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			close:SetHighlightTexture("interface\\common\\indicator-red");
			close:GetHighlightTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:GetHighlightTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
			close:SetScript("OnClick", function()
				frame:Hide();
			end);
			close:SetScript("OnEnter", info_OnEnter);
			close:SetScript("OnLeave", info_OnLeave);
			close.info_lines = { L.CLOSE, };
			frame.close = close;

			local region = CreateFrame("BUTTON", nil, frame);
			region:SetHeight(20);
			region:SetPoint("TOP", frame, "TOPRIGHT", -150, -2);
			local region_str = region:CreateFontString(nil, "OVERLAY");
			region_str:SetFont(ui_style.frameFont, ui_style.smallFontSize, ui_style.frameFontOutline);
			region_str:SetPoint("CENTER");
			region_str:SetText(L.REGION[SET.region]);
			region.str = region_str;
			region:SetWidth(region_str:GetWidth() + 8);
			region:SetScript("OnClick", function(self)
				ALADROP(self, "BOTTOMLEFT", list_drop_meta);
			end);
			frame.region = region;

			local ad = frame:CreateFontString(nil, "OVERLAY");
			ad:SetFont(ui_style.frameFont, ui_style.smallFontSize, ui_style.frameFontOutline);
			ad:SetVertexColor(unpack(ui_style.ad_color));
			ad:SetPoint("TOP", frame, "TOPRIGHT", -150, -20);
			ad:SetText(L.AD_TEXT);
			frame.ad = ad;

			do	--	title
				local title = frame:CreateFontString(nil, "ARTWORK");
				title:SetFont(ui_style.frameFont, ui_style.frameFontSize, ui_style.frameFontOutline);
				title:SetPoint("TOP", 0, -1);
				title:SetText(L["CALENDAR_TITLE"]);
				frame.title = title;

				function frame:SetTitleText(...)
					title:SetText(...);
				end
			end

			do	--	date & clock
				local clock = frame:CreateFontString(nil, "OVERLAY");
				clock:SetFont(ui_style.frameFont, ui_style.bigFontSize);
				clock:SetPoint("TOP", frame, "TOPLEFT", (ui_style.frame_XSize / 2 - 4 - 48 - 12 - 24) / 2, -2);
				clock:Show();
				frame.clock = clock;

				local today = frame:CreateFontString(nil, "OVERLAY");
				today:SetFont(ui_style.frameFont, ui_style.smallFontSize);
				today:SetPoint("TOP", clock, "BOTTOM", 0, -2);
				today:SetVertexColor(unpack(ui_style.today_color));
				today:Show();
				frame.today = today;

				function frame:SetClockText(...)
					clock:SetText(...);
				end
				function frame:SetWhatDayText(...)
					today:SetText(...);
				end
				C_Timer.NewTicker(0.1, function()
					if frame:IsShown() then
						today:SetText(to_date.built_in_date(L.FORMAT_DATE_TODAY));
						clock:SetText(to_date.built_in_date(L.FORMAT_CLOCK));
					end
				end);

				local reset =  CreateFrame("BUTTON", nil, frame);
				-- reset:SetSize(20, 20);
				reset:SetPoint("TOPLEFT", today, "TOPLEFT", 0, 0);
				reset:SetPoint("BOTTOMRIGHT", today, "BOTTOMRIGHT", 0, 0);
				reset:SetScript("OnClick", function()
					frame.var.line_ofs = 0;
					frame.var.month_ofs = 0;
					frame.update_func();
				end);
				reset:SetScript("OnEnter", function()
					today:SetVertexColor(1.0, 1.0, 1.0, 1.0);
				end);
				reset:SetScript("OnLeave", function()
					today:SetVertexColor(unpack(ui_style.today_color));
				end);
				reset:SetFontString(today);
				reset:SetPushedTextOffset(0, -1);
				frame.reset = reset;
			end

			do	--	year & month explorer
				local drop_table_year = {
					handler = function(_, frame, val)
						local var = frame.var;
						var.month_ofs = var.month_ofs + val * 12;
						frame.update_func();
					end,
					elements = {  },
				};
				for index = 1, 10 do
					drop_table_year.elements[index] = { para = { frame, index - 5, }, };
				end
				local drop_table_month = {
					handler = function(_, frame, val)
						local var = frame.var;
						var.month_ofs = var.month_ofs - var.center_cell_time[2] + val;
						var.line_ofs = 0;
						frame.update_func();
					end,
					elements = {  },
				};
				for index = 1, 12 do
					drop_table_month.elements[index] = { para = { frame, index, }, text = L.MONTH[index], };
				end

				local date_title_L = CreateFrame("BUTTON", nil, frame);
				date_title_L:SetSize(48, 24);
				date_title_L:SetPoint("TOPRIGHT", frame, "TOP", 0, -16);
				date_title_L:SetScript("OnClick", function(self)
					if IsEastAsiaFormat() then
						local Y1 = frame.var.center_cell_time[1];
						local elements = drop_table_year.elements;
						for index = 1, 10 do
							local Y = Y1 + index - 5;
							elements[index].text = tostring(Y);
						end
						ALADROP(self, "BOTTOM", drop_table_year);
					else
						ALADROP(self, "BOTTOM", drop_table_month);
					end
				end);
				date_title_L:SetScript("OnMouseWheel", function(self, delta)
					if IsEastAsiaFormat() then
						local var = frame.var;
						var.month_ofs = var.month_ofs + delta * 12;
						var.line_ofs = 0;
						frame.update_func();
					else
						local var = frame.var;
						var.month_ofs = var.month_ofs + delta;
						var.line_ofs = 0;
						frame.update_func();
					end
				end);
				local date_title_L_str = date_title_L:CreateFontString(nil, "ARTWORK");
				date_title_L_str:SetFont(ui_style.frameFont, ui_style.frameFontSize, ui_style.frameFontOutline);
				date_title_L_str:SetPoint("RIGHT");
				frame.date_title_L = date_title_L;

				local date_title_R = CreateFrame("BUTTON", nil, frame);
				date_title_R:SetSize(48, 24);
				date_title_R:SetPoint("TOPLEFT", frame, "TOP", 0, -16);
				date_title_R:SetScript("OnClick", function(self)
					if IsEastAsiaFormat() then
						ALADROP(self, "BOTTOM", drop_table_month);
					else
						local Y1 = frame.var.center_cell_time[1];
						local elements = drop_table_year.elements;
						for index = 1, 10 do
							local Y = Y1 + index - 5;
							elements[index].text = tostring(Y);
						end
						ALADROP(self, "BOTTOM", drop_table_year);
					end
				end);
				date_title_R:SetScript("OnMouseWheel", function(self, delta)
					if IsEastAsiaFormat() then
						local var = frame.var;
						var.month_ofs = var.month_ofs + delta;
						var.line_ofs = 0;
						frame.update_func();
					else
						local var = frame.var;
						var.month_ofs = var.month_ofs + delta * 12;
						var.line_ofs = 0;
						frame.update_func();
					end
				end);
				local date_title_R_str = date_title_R:CreateFontString(nil, "ARTWORK");
				date_title_R_str:SetFont(ui_style.frameFont, ui_style.frameFontSize, ui_style.frameFontOutline);
				date_title_R_str:SetPoint("LEFT");
				frame.date_title_R = date_title_R;

				local prev = CreateFrame("BUTTON", nil, frame);
				prev:SetSize(16, 16);
				prev:SetNormalTexture(ui_style.texture_triangle);
				prev:GetNormalTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
				prev:GetNormalTexture():SetVertexColor(unpack(ui_style.texture_triangle_normal_color));
				prev:GetNormalTexture():SetBlendMode("ADD");
				prev:SetPushedTexture(ui_style.texture_triangle);
				prev:GetPushedTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
				prev:GetPushedTexture():SetVertexColor(unpack(ui_style.texture_triangle_pushed_color));
				prev:GetPushedTexture():SetBlendMode("ADD");
				prev:SetHighlightTexture(ui_style.texture_triangle);
				prev:GetHighlightTexture():SetAlpha(0.25);
				prev:GetHighlightTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
				prev:SetPoint("RIGHT", date_title_L, "LEFT", -6, 0);
				prev:SetScript("OnClick", function()
					local var = frame.var;
					if var.line_ofs <= 0 then
						var.month_ofs = var.month_ofs - 1;
					end
					var.line_ofs = 0;
					frame.update_func();
				end);
				frame.prev = prev;

				local next = CreateFrame("BUTTON", nil, frame);
				next:SetSize(16, 16);
				next:SetNormalTexture(ui_style.texture_triangle);
				next:GetNormalTexture():SetVertexColor(unpack(ui_style.texture_triangle_normal_color));
				next:GetNormalTexture():SetBlendMode("ADD");
				next:SetPushedTexture(ui_style.texture_triangle);
				next:GetPushedTexture():SetVertexColor(unpack(ui_style.texture_triangle_pushed_color));
				next:GetPushedTexture():SetBlendMode("ADD");
				next:SetHighlightTexture(ui_style.texture_triangle);
				next:GetHighlightTexture():SetAlpha(0.25);
				next:SetPoint("LEFT", date_title_R, "RIGHT", 6, 0);
				next:SetScript("OnClick", function()
					local var = frame.var;
					if var.line_ofs >= 0 then
						var.month_ofs = var.month_ofs + 1;
					end
					var.line_ofs = 0;
					frame.update_func();
				end);
				frame.next = next;

				function frame:SetDateLeftText(...)
					date_title_L_str:SetText(...);
				end
				function frame:SetDateLeftColor(...)
					date_title_L_str:SetVertexColor(...);
				end
				function frame:SetDateRightText(...)
					date_title_R_str:SetText(...);
				end
				function frame:SetDateRightColor(...)
					date_title_R_str:SetVertexColor(...);
				end
			end

			do	--	calendar
				local cal = CreateFrame("FRAME", nil, frame);
				cal:SetBackdrop(ui_style.calBackdrop);
				cal:SetBackdropColor(unpack(ui_style.calBackdropColor));
				cal:SetBackdropBorderColor(unpack(ui_style.calBackdropBorderColor));
				cal:SetSize(ui_style.cal_XSize, ui_style.cal_YSize);
				cal:SetPoint("TOPLEFT", frame, "TOPLEFT", ui_style.cal_XToBorder, - (ui_style.frameTitle_YSize + ui_style.cal_YToBorder));
				cal:EnableMouse(true);
				cal:SetScript("OnShow", frame.update_func);
				cal:SetScript("OnMouseWheel", cal_OnMouseWheel);
				cal:Show();
				frame.cal = cal;

				local weekTitles = {  };
				frame.weekTitles = weekTitles;
				for col = 1, NUM_COL do
					local wt = createWeekTitle(cal);
					wt:SetPoint("TOPLEFT", cal, "TOPLEFT", (ui_style.cell_XSize + ui_style.cell_XInt) * (col - 1), 0);
					weekTitles[col] = wt;
				end
				NS.ui_refreshWeekTitle(frame);

				local cells = {  };
				frame.cells = cells;
				for row = 1, NUM_ROW do
					local rc = {  };
					cells[row] = rc;
					for col = 1, NUM_COL do
						local cell = createCell(cal);
						cell:SetPoint("TOPLEFT", cal, "TOPLEFT",
										(ui_style.cell_XSize + ui_style.cell_XInt) * (col - 1),
										- (ui_style.weekTitle_YSize + ui_style.cell_YToWeekTitle + (ui_style.cell_YSize + ui_style.cell_YInt) * (row - 1))
						);
						cell.row = row;
						cell.col = col;
						cell.index = (row - 1) * NUM_COL + col;
						rc[col] = cell;
					end
				end
			end

			function frame.update_func()
				NS.proc_update_calendar(frame);
			end
			frame:SetScript("OnShow", function()
				frame.update_func();
				gui["BOARD"].call_calendar:Texture(true);
			end);
			frame:SetScript("OnHide", function(self)
				self.var.month_ofs = 0;
				self.var.line_ofs = 0;
				gui["BOARD"].call_calendar:Texture(false);
			end);

			local call_board = CreateFrame("BUTTON", nil, frame);
			call_board:SetSize(20, 20);
			call_board:SetNormalTexture(ui_style.texture_triangle);
			call_board:GetNormalTexture():SetVertexColor(unpack(ui_style.texture_triangle_normal_color));
			call_board:GetNormalTexture():SetBlendMode("ADD");
			call_board:SetPushedTexture(ui_style.texture_triangle);
			call_board:GetPushedTexture():SetVertexColor(unpack(ui_style.texture_triangle_pushed_color));
			call_board:GetPushedTexture():SetBlendMode("ADD");
			call_board:SetHighlightTexture(ui_style.texture_triangle);
			call_board:GetHighlightTexture():SetAlpha(0.25);
			call_board:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -32);
			function call_board:Texture(bool)
				if bool then
					self:GetNormalTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
					self:GetPushedTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
					self:GetHighlightTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
				else
					self:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
					self:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
					self:GetHighlightTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
				end
			end
			call_board:Texture(false);
			call_board:SetScript("OnClick", function(self)
				NS.ui_toggleGUI("BOARD");
			end);
			call_board:SetScript("OnEnter", info_OnEnter);
			call_board:SetScript("OnLeave", info_OnLeave);
			call_board.info_lines = { L.CALL_BOARD, };
			local call_board_str = call_board:CreateFontString(nil, "ARTWORK");
			call_board_str:SetFont(ui_style.frameFont, ui_style.smallFontSize, "OUTLINE");
			call_board_str:SetText(L["BOARD"]);
			call_board_str:SetPoint("RIGHT", call_board, "LEFT", -2, 0);
			call_board.str = call_board_str;
			call_board:SetHitRectInsets(-call_board_str:GetWidth(), 0, 0, 0);
			frame.call_board = call_board;

			return frame;
		end
		--
			local function board_button_OnClick(self, button)
				local frame = self.frame;
				local display_list = frame.display_list;
				local data_index = self:GetDataIndex();
				local head, val, inst = display_list[data_index * 3 - 2], display_list[data_index * 3 - 1], display_list[data_index * 3];
				if head == 'header' or head == 'extern_head' then
					local collapsed = SET.collapsed;
					collapsed[inst] = not collapsed[inst];
					frame.update_func();
				end
			end
			local function board_button_OnEnter(self)
				local frame = self.frame;
				local display_list = frame.display_list;
				local data_index = self:GetDataIndex();
				local head, val, inst = display_list[data_index * 3 - 2], display_list[data_index * 3 - 1], display_list[data_index * 3];
				if head == 'GUID' then
					local VAR = AVAR[val];
					if VAR then
						GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
						GameTooltip:AddLine(L.INSTANCE[inst], 1.0, 1.0, 1.0);
						local var = VAR[inst];
						for index = 1, (#var - 4) / 2 do
							local bossName, isKilled = var[3 + index * 2], var[4 + index * 2];
							if isKilled then
								GameTooltip:AddLine(bossName, 1.0, 0.0, 0.0);
							else
								GameTooltip:AddLine(bossName, 0.0, 1.0, 0.0);
							end
						end
						GameTooltip:Show();
					else
						GameTooltip:Hide();
					end
				else
					GameTooltip:Hide();
				end
			end
			local function funcToCreateButton(parent, index, buttonHeight)
				local button = CreateFrame("BUTTON", nil, parent);
				button:SetHeight(buttonHeight);
				button:SetBackdrop(ui_style.buttonBackdrop);
				button:SetBackdropColor(unpack(ui_style.buttonBackdropColor));
				button:SetBackdropBorderColor(unpack(ui_style.buttonBackdropBorderColor));
				button:SetHighlightTexture(ui_style.texture_white);
				button:GetHighlightTexture():SetVertexColor(unpack(ui_style.buttonHighlightColor));
				button:EnableMouse(true);

				local glow = button:CreateTexture(nil, "OVERLAY");
				glow:SetTexture(ui_style.texture_white);
				glow:SetVertexColor(unpack(ui_style.buttonGlowColor));
				glow:SetBlendMode("ADD");
				glow:SetAllPoints(true);
				button.glow = glow;

				local collapse = button:CreateTexture(nil, "BORDER");
				collapse:SetTexture(ui_style.texture_collapsed);
				collapse:SetSize(buttonHeight - 4, buttonHeight - 4);
				collapse:SetPoint("LEFT", 8, 0);
				button.collapse = collapse;

				local icon = button:CreateTexture(nil, "BORDER");
				icon:SetTexture(ui_style.texture_unk);
				icon:SetSize(buttonHeight - 4, buttonHeight - 4);
				icon:SetPoint("LEFT", collapse, "RIGHT", 4, 0);
				button.icon = icon;

				local title = button:CreateFontString(nil, "OVERLAY");
				title:SetFont(ui_style.frameFont, ui_style.frameFontSize, ui_style.frameFontOutline);
				title:SetPoint("LEFT", icon, "RIGHT", 4, 0);
				-- title:SetWidth(160);
				title:SetMaxLines(1);
				title:SetJustifyH("LEFT");
				button.title = title;

				local cool = button:CreateFontString(nil, "OVERLAY");
				cool:SetFont(ui_style.frameFont, ui_style.frameFontSize, ui_style.frameFontOutline);
				cool:SetPoint("RIGHT", button, "RIGHT", -4, 0);
				-- cool:SetWidth(160);
				cool:SetMaxLines(1);
				cool:SetJustifyH("LEFT");
				cool:SetVertexColor(1.0, 0.25, 0.25, 1.0);
				button.cool = cool;

				button:SetScript("OnClick", board_button_OnClick);
				button:SetScript("OnEnter", board_button_OnEnter);

				local frame = parent:GetParent():GetParent();
				button.frame = frame;
				button.list = frame.list;

				return button;
			end
			local function funcToSetButton(button, data_index)
				local frame = button.frame;
				local display_list = frame.display_list;
				local head, key, inst = display_list[data_index * 3 - 2], display_list[data_index * 3 - 1], display_list[data_index * 3];
				if head and key and inst then
					local collapsed = SET.collapsed;
					if head == 'header' then
						button.glow:Show();
						if collapsed[inst] then
							button.collapse:SetTexture(ui_style.texture_collapsed);
						else
							button.collapse:SetTexture(ui_style.texture_expanded);
						end
						button.collapse:Show();
						local val = to_date.milestone[inst];
						if val then
							button.icon:SetTexture(val[6]);
							if val[7] then
								button.icon:SetTexCoord(unpack(val[7]));
							else
								button.icon:SetTexCoord(0.0, 1.0, 0.0, 1.0);
							end
							button.icon:Show();
							button.cool:SetText(NS.seconds_to_formatted_time_len(val[2] - (to_date.time() - val[1]) % val[2]));
						else
							button.icon:Hide();
							button.cool:SetText(nil);
						end
						button.title:SetText(L.INSTANCE[inst]);
						button.title:SetVertexColor(1.0, 1.0, 1.0, 1.0);
					elseif head == 'GUID' then
						button.glow:Hide();
						button.collapse:Hide();
						button.icon:Hide();
						local var = AVAR[key][inst];
						local lClass, class, lRace, race, sex, name = GetPlayerInfoByGUID(key);
						if name and class then
							local classColorTable = RAID_CLASS_COLORS[strupper(class)];
							button.title:SetText(name);
							button.title:SetVertexColor(classColorTable.r, classColorTable.g, classColorTable.b, 1.0);
						else
							button.title:SetText(key);
							button.title:SetVertexColor(1.0, 1.0, 1.0, 1.0);
							C_Timer.After(0.5, function() funcToSetButton(button, data_index); end);
						end
						if var and var[1] then
							button.cool:SetText(var[4] .. "/" .. var[3] .. '  \124cffffffffid: ' .. var[1]);
						else
							button.cool:SetText(L["COOLDOWN_EXPIRED"]);
						end
					elseif head == 'extern_head' then
						button.glow:Show();
						if collapsed[inst] then
							button.collapse:SetTexture(ui_style.texture_collapsed);
						else
							button.collapse:SetTexture(ui_style.texture_expanded);
						end
						button.collapse:Show();
						local text = extern_list[inst].text;
						local tex, coord, title, color_title;
						if type(text) == 'function' then
							tex, coord, title, color_title = text(inst);
						elseif type(inst) == 'function' then
							tex, coord, title, color_title = inst(text);
						elseif type(text) == 'table' then
							tex, coord, title, color_title = unpack(text);
						elseif type(inst) == 'table' then
							tex, coord, title, color_title = unpack(inst);
						else
							title = text;
						end
						if tex then
							button.icon:SetTexture(tex);
							if coord then
								button.icon:SetTexCoord(coord[1] or coord.r, coord[2] or coord.g, coord[3] or coord.b, coord[4] or 1.0);
							else
								button.icon:SetTexCoord(0.0, 1.0, 0.0, 1.0);
							end
							button.icon:Show();
						else
							button.icon:Hide();
						end
						if title then
							button.title:SetText(title);
							if color_title then
								button.title:SetVertexColor(color_title[1] or color_title.r, color_title[2] or color_title.g, color_title[3] or color_title.b, color_title[4] or 1.0);
							else
								button.title:SetVertexColor(1.0, 1.0, 1.0, 1.0);
							end
						else
							button.title:SetText(nil);
						end
						button.cool:SetText(nil);
					elseif head == 'extern_key' then
						button.glow:Hide();
						button.collapse:Hide();
						local val = extern_list[inst][key];
						local tex, coord, title, color_title, cool, color_cool;
						if type(val) == 'function' then
							tex, coord, title, color_title, cool, color_cool = val(inst, key);
						elseif type(key) == 'function' then
							tex, coord, title, color_title = val(inst, key);
						elseif type(val) == 'table' then
							tex, coord, title, color_title, cool, color_cool = unpack(val);
						elseif type(key) == 'table' then
							tex, coord, title, color_title, cool, color_cool = unpack(key);
						else
							title = key;
							cool = val;
						end
						if tex then
							button.icon:SetTexture(tex);
							if coord then
								button.icon:SetTexCoord(coord[1] or coord.r, coord[2] or coord.g, coord[3] or coord.b, coord[4] or 1.0);
							else
								button.icon:SetTexCoord(0.0, 1.0, 0.0, 1.0);
							end
							button.icon:Show();
						else
							button.icon:Hide();
						end
						if title then
							button.title:SetText(title);
							if color_title then
								button.title:SetVertexColor(color_title[1] or color_title.r, color_title[2] or color_title.g, color_title[3] or color_title.b, color_title[4] or 1.0);
							else
								button.title:SetVertexColor(1.0, 1.0, 1.0, 1.0);
							end
						else
							button.title:SetText(nil);
						end
						if cool then
							button.cool:SetText(cool);
							if color_cool then
								button.cool:SetVertexColor(color_cool[1] or color_cool.r, color_cool[2] or color_cool.g, color_cool[3] or color_cool.b, color_cool[4] or 1.0);
							else
								button.cool:SetVertexColor(1.0, 1.0, 1.0, 1.0);
							end
						else
							button.cool:SetText(nil);
						end
					end
					button:Show();
				else
					button:Hide();
				end
			end
		--
		function NS.ui_CreateBoard()
			local frame = CreateFrame("FRAME", "ALA_CALENDAR_BOARD", UIParent);
			tinsert(UISpecialFrames, "ALA_CALENDAR_BOARD");
			frame:SetBackdrop(ui_style.frameBackdrop);
			frame:SetBackdropColor(unpack(ui_style.frameBackdropColor));
			frame:SetBackdropBorderColor(unpack(ui_style.frameBackdropBorderColor));
			frame:SetSize(ui_style.board_XSize, ui_style.board_YSize);
			frame:SetFrameStrata("HIGH");
			frame:SetPoint("TOPLEFT", gui["CALENDAR"], "TOPRIGHT", 1, 0);
			frame:SetScale(SET.scale);
			frame:SetAlpha(SET.alpha);
			frame:EnableMouse(true);
			frame:SetMovable(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", function(self)
				self:StartMoving();
			end);
			frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing();
			end);
			frame:Hide();
			frame.list = {  };
			frame.display_list = {  };
			local StartMoving = frame.StartMoving;
			function frame.StartMoving(self)
				self:ClearAllPoints();
				local cal = gui["CALENDAR"];
				cal:ClearAllPoints();
				cal:SetPoint("TOPRIGHT", self, "TOPLEFT", -1, 0);
				StartMoving(self);
			end

			local close = CreateFrame("BUTTON", nil, frame);
			close:SetSize(20, 20);
			close:SetNormalTexture("interface\\common\\indicator-red");
			close:GetNormalTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:SetPushedTexture("interface\\common\\indicator-red");
			close:GetPushedTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:GetPushedTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			close:SetHighlightTexture("interface\\common\\indicator-red");
			close:GetHighlightTexture():SetTexCoord(4 / 32, 28 / 32, 4 / 32, 28 / 32);
			close:GetHighlightTexture():SetVertexColor(0.5, 0.5, 0.5, 0.5);
			close:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2);
			close:SetScript("OnClick", function()
				frame:Hide();
			end);
			close:SetScript("OnEnter", info_OnEnter);
			close:SetScript("OnLeave", info_OnLeave);
			close.info_lines = { L.CLOSE, };
			frame.close = close;

			local scroll = ALASCR(frame, nil, nil, ui_style.button_height, funcToCreateButton, funcToSetButton);
			scroll:SetPoint("BOTTOMLEFT", 4, 4);
			scroll:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, - (ui_style.frameTitle_YSize + ui_style.cal_YToBorder));
			-- scroll:SetPoint("TOPRIGHT", - 4, - 4);
			frame.scroll = scroll;

			function frame.update_list()
				local list = frame.list;
				wipe(list);
				for _, inst in pairs(SET.inst_list) do
					local add_head = true;
					for GUID, VAR in pairs(AVAR) do
						local var = VAR[inst];
						local ms = to_date.milestone[inst];
						if ms and ms.phase <= curPhase then
							if (var and var[1]) or (SET.show_unlocked and VAR.PLAYER_LEVEL and VAR.PLAYER_LEVEL >= 60) then
								if add_head then
									tinsert(list, 'header');
									tinsert(list, inst);
									add_head = false;
								end
								tinsert(list, 'GUID');
								tinsert(list, GUID);
							end
						end
					end
				end
				for head, ext in pairs(extern_list) do
					local add_head = true;
					for key, val in pairs(ext) do
						if key ~= 'text' then
							if add_head then
								tinsert(list, 'extern_head');
								tinsert(list, head);
								add_head = false;
							end
							tinsert(list, 'extern_key');
							tinsert(list, key);
						end
					end
				end
			end
			function frame.update_func()
				local collapsed = SET.collapsed;
				local list = frame.list;
				local display_list = frame.display_list;
				wipe(display_list);
				do
					local index = 1;
					local inst = nil;
					while true do
						if list[index] == nil then
							break;
						elseif list[index] == 'header' then
							inst = list[index + 1];
							tinsert(display_list, 'header');
							tinsert(display_list, inst);
							tinsert(display_list, inst);
						elseif list[index] == 'extern_head' then
							inst = list[index + 1];
							tinsert(display_list, 'extern_head');
							tinsert(display_list, inst);
							tinsert(display_list, inst);
						else
							if not collapsed[inst] then
								tinsert(display_list, list[index]);
								tinsert(display_list, list[index + 1]);
								tinsert(display_list, inst);
							end
						end
						index = index + 2;
					end
				end
				scroll:SetNumValue(#display_list / 2);
				scroll.Update();
			end
			frame:SetScript("OnShow", function()
				frame.update_func();
				gui["CALENDAR"].call_board:Texture(true);
			end);
			frame:SetScript("OnHide", function(self)
				gui["CALENDAR"].call_board:Texture(false);
			end);

			local call_calendar = CreateFrame("BUTTON", nil, frame);
			call_calendar:SetSize(20, 20);
			call_calendar:SetNormalTexture(ui_style.texture_triangle);
			call_calendar:GetNormalTexture():SetVertexColor(unpack(ui_style.texture_triangle_normal_color));
			call_calendar:GetNormalTexture():SetBlendMode("ADD");
			call_calendar:SetPushedTexture(ui_style.texture_triangle);
			call_calendar:GetPushedTexture():SetVertexColor(unpack(ui_style.texture_triangle_pushed_color));
			call_calendar:GetPushedTexture():SetBlendMode("ADD");
			call_calendar:SetHighlightTexture(ui_style.texture_triangle);
			call_calendar:GetHighlightTexture():SetAlpha(0.25);
			call_calendar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -32);
			function call_calendar:Texture(bool)
				if bool then
					self:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
					self:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
					self:GetHighlightTexture():SetTexCoord(0.0, 1.0, 0.0, 1.0);
				else
					self:GetNormalTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
					self:GetPushedTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
					self:GetHighlightTexture():SetTexCoord(1.0, 0.0, 0.0, 1.0);
				end
			end
			call_calendar:Texture(false);
			call_calendar:SetScript("OnClick", function(self)
				NS.ui_toggleGUI("CALENDAR");
			end);
			call_calendar:SetScript("OnEnter", info_OnEnter);
			call_calendar:SetScript("OnLeave", info_OnLeave);
			call_calendar.info_lines = { L.CALL_CALENDAR, };
			local call_calendar_str = call_calendar:CreateFontString(nil, "ARTWORK");
			call_calendar_str:SetFont(ui_style.frameFont, ui_style.smallFontSize, "OUTLINE");
			call_calendar_str:SetText(L["CALENDAR"]);
			call_calendar_str:SetPoint("LEFT", call_calendar, "RIGHT", -2, 0);
			call_calendar.str = call_calendar_str;
			call_calendar:SetHitRectInsets(0, -call_calendar_str:GetWidth(), 0, 0);
			frame.call_calendar = call_calendar;

			return frame;
		end
	end

	function NS.init_regEvent()
		_EventHandler:RegEvent("PLAYER_LOGOUT");
		_EventHandler:RegEvent("PLAYER_LEVEL_UP");
		_EventHandler:RegEvent("ENCOUNTER_END");
		_EventHandler:RegEvent("BOSS_KILL");
		_EventHandler:RegEvent("UPDATE_INSTANCE_INFO");
	end
	local function icon_OnClick(self, button)
		if button == "RightButton" then
			if gui["BOARD"]:IsShown() then
				gui["BOARD"]:Hide();
				gui["CALENDAR"].call_board:Texture(false);
			else
				gui["BOARD"]:Show();
				gui["CALENDAR"].call_board:Texture(true);
			end
		else
			if gui["CALENDAR"]:IsShown() then
				gui["CALENDAR"]:Hide();
				gui["BOARD"].call_calendar:Texture(false);
			else
				gui["CALENDAR"]:Show();
				gui["BOARD"].call_calendar:Texture(true);
			end
		end
	end
	function NS.init_createGUI()
		--	GUI
			local calendar = NS.ui_CreateCalendar();
			gui["CALENDAR"] = calendar;
			local board = NS.ui_CreateBoard();
			gui["BOARD"] = board;
			--
			if GameTimeFrame then
				GameTimeFrame:SetScript("OnMouseUp", icon_OnClick);
				if GameTimeFrame_UpdateTooltip then
					hooksecurefunc("GameTimeFrame_UpdateTooltip", function()
						GameTooltip:AddLine(" ");
						for _, text in pairs(L.TooltipLines) do
							GameTooltip:AddLine(text);
						end
						GameTooltip:Show();
					end);
				end
				if SET.show_indicator then
					local TEXTURE = "interface\\minimap\\supertrackerarrow";
					local NUM_TEX = 8;
					local SPEED = 16;
					local w, h = GameTimeFrame:GetHeight() * 4, GameTimeFrame:GetHeight();
					local step = ceil(w / NUM_TEX);
					w = step * NUM_TEX;
					local indicator = CreateFrame("FRAME", nil, GameTimeFrame);
					indicator:SetSize(w, h);
					indicator:SetPoint("RIGHT", GameTimeFrame, "LEFT", 0, 0);
					indicator:EnableMouse(false);
					local textures = {  };
					for index = 1, NUM_TEX do
						local texture = indicator:CreateTexture(nil, "OVERLAY");
						texture:SetSize(h / 2, h);
						texture:SetTexture(TEXTURE);
						texture:SetTexCoord(6 / 32, 26 / 32, 26 / 32, 26 / 32, 6 / 32, 6 / 32, 26 / 32, 6 / 32);
						texture:SetBlendMode("ADD");
						textures[index] = texture;
					end
					local timer = 0;
					indicator:SetScript("OnUpdate", function(self, elasped)
						timer = timer + elasped;
						for index = 1, NUM_TEX do
							local texture = textures[index];
							texture:ClearAllPoints();
							local temp = (SPEED * timer) % step;
							texture:SetPoint("RIGHT", indicator, "RIGHT", -(step * (index - 1) - abs(temp - step * 0.5) * 2), 0);
						end
					end);
					--
					calendar:HookScript("OnShow", function()
						indicator:Hide();
						SET.show_indicator = false;
					end);
					board:HookScript("OnShow", function()
						indicator:Hide();
						SET.show_indicator = false;
					end);
				end
			end
		--	External Lib
			if LibStub then
				--	DBICON
					local LDI = LibStub("LibDBIcon-1.0", true);
					if LDI then
						LDI:Register("alaCalendar",
							{
								icon = ARTWORK_PATH .. "ICON",	--	"interface\\minimap\\tracking\\reagents"
								OnClick = icon_OnClick,
								text = L.DBIcon_Text,
								OnTooltipShow = function(tt)
										tt:AddLine("alaCalendar");
										tt:AddLine(" ");
										for _, text in pairs(L.TooltipLines) do
											tt:AddLine(text);
										end
									end
							},
							{
								minimapPos = SET.minimapPos,
							}
						);
						if SET.show_DBIcon then
							LDI:Show("alaCalendar");
						else
							LDI:Hide("alaCalendar");
						end
						local mb = LDI:GetMinimapButton("alaCalendar");
						mb:RegisterEvent("PLAYER_LOGOUT");
						mb:HookScript("OnEvent", function(self)
							SET.minimapPos = self.minimapPos or self.db.minimapPos;
						end);
						mb:HookScript("OnDragStop", function(self)
							SET.minimapPos = self.minimapPos or self.db.minimapPos;
						end);
					end
				--	LDB
					local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
					if LDB then
						local obj = LDB:NewDataObject("alacal", {
							type = "launcher",
							icon = ARTWORK_PATH .. "ICON";
							OnClick = icon_OnClick,
							OnTooltipShow = function(tt)
								tt:AddLine("alaCalendar");
								tt:AddLine(" ");
								for _, text in pairs(L.TooltipLines) do
									tt:AddLine(text);
								end
								tt:Show();
							end,
						});
					end
			end	
		--
	end
	--
	function NS.ui_toggleGUI(key)
		local frame = gui[key];
		if frame then
			if frame:IsShown() then
				frame:Hide();
				return false;
			else
				frame:Show();
				return true;
			end
		end
	end
	function NS.ui_update_calendar()
		NS.ui_refreshWeekTitle(gui["CALENDAR"]);
		gui["CALENDAR"]:update_func();
	end
	function NS.ui_update_board()
		gui["BOARD"]:update_list();
		gui["BOARD"]:update_func();
	end
	function NS.ui_refresh_calendar()
		NS.ui_refreshWeekTitle(gui["CALENDAR"]);
	end
	function NS.ui_attribute_all(att, val)
		if att == "region" then
			local region = gui["CALENDAR"].region;
			region.str:SetText(L.REGION[SET.region]);
			region:SetWidth(region.str:GetWidth() + 8);
		elseif att == "scale" then
			gui["CALENDAR"]:SetScale(SET.scale);
			gui["BOARD"]:SetScale(SET.scale);
		elseif att == "alpha" then
			gui["CALENDAR"]:SetAlpha(SET.alpha);
			gui["BOARD"]:SetAlpha(SET.alpha);
		end
	end
end

do	--	INITIALIZE
	--	1 = US and Brazil and Oceania, 2 = Korea, 3 = Europe, 4 = Taiwan, 5 = China
	local temp = {
		enUS = 1,
		koKR = 2,
		zhTW = 3,
		zhCN = 5,
	};
	local default_set = {
		region = temp[LOCALE] or 4,
		use_realm_time_zone = false,
		first_col_day = IsEastAsiaFormat() and 1 or 0;
		instance_icon = true,
		instance_text = false,
		show_indicator = true,
		show_DBIcon = true,
		scale = 1.0,
		alpha = 1.0,
		show_unlocked = false,
	};
	local instances_list = {
		"NAXX",
		"TAQ",
		"RAQ",
		"BWL",
		"ZG",
		"MC",
		"ONY",
		-- "ala",
	};
	local instances_hash = {
		["NAXX"] = true,
		["TAQ"] = true,
		["RAQ"] = true,
		["BWL"] = true,
		["ZG"] = true,
		["MC"] = true,
		["ONY"] = true,
		["Warsong Gulch"] = true,
		["Arathi Basin"] = true,
		["Alterac Valley"] = true,
		["DarkMoon: Mulgore"] = true,
		["DarkMoon: Elwynn"] = true,
		["Fishing Extravaganza"] = true,
	};
	local function MODIFY_SAVED_VARIABLE()
		if alaCalendarSV then
			if alaCalendarSV._version == nil then
				alaCalendarSV._version = 200425.0;
			end
			if alaCalendarSV._version < 200426.0 then
				alaCalendarSV.set.collapsed = {  };
			end
			if alaCalendarSV._version < 200504.0 then
				for GUID, VAR in pairs(alaCalendarSV.var) do
					VAR['ZG'] = VAR['ZG'] or VAR['ZUG'];
					VAR['ZUG'] = nil;
					VAR['ONY'] = VAR['ONY'] or VAR['ONYX'];
					VAR['ONYX'] = nil;
					for _, inst in pairs(instances_list) do
						if VAR[inst] == nil then
							VAR[inst] = {  };
						end
					end
				end
				alaCalendarSV.set.inst_list = Mixin({  }, instances_list);
				alaCalendarSV.set.inst_hash = Mixin({  }, instances_hash);
				alaCalendarSV.set.char_list = nil;
			end
		else
			_G.alaCalendarSV = {
				set = {
					inst_list = Mixin({  }, instances_list),
					inst_hash = Mixin({  }, instances_hash);
					collapsed = {  },
				},
				var = {  },
			};
		end
		alaCalendarSV._version = 200504.0;
		AVAR = alaCalendarSV.var;
		VAR = AVAR[PLAYER_GUID];
		if VAR == nil then
			VAR = { realm_id = PLAYER_REALM_ID, realm_name = PLAYER_REALM_NAME, };
			AVAR[PLAYER_GUID] = VAR;
		end
		SET = setmetatable(alaCalendarSV.set, {
			__index = function(t, key)
				return default_set[key];
			end,
		});
		VAR.PLAYER_LEVEL = UnitLevel('player');
	end
	local function init()
		--	NS.db_init();
		MODIFY_SAVED_VARIABLE();
		NS.init_time_zone();
		NS.init_regEvent();
		NS.init_createGUI();
		NS.init_instance();
		for GUID, _ in pairs(AVAR) do
			GetPlayerInfoByGUID(GUID);
		end
	end
	function NS.PLAYER_ENTERING_WORLD()
		_EventHandler:UnregEvent("PLAYER_ENTERING_WORLD");
		init();
	end
	_EventHandler:RegEvent("PLAYER_ENTERING_WORLD");
end

do	--	SLASH
	--	pattern, key, note, func(key, val)
	local SEPARATOR = "[ %`%~%!%@%#%$%%%^%&%*%(%)%-%_%=%+%[%{%]%}%\\%|%;%:%\'%\"%,%<%.%>%/%?]*";
	local set_cmd_list = {
		{	--	region
			'num',
			"^region" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"region",
			function(key, val)
				return format(L.SLASH_NOTE["region"], L.REGION[val]);
			end,
			function(key, val)
				NS.apply_region[val]();
				NS.ui_update_calendar();
				NS.ui_attribute_all("region", val);
			end,
			function(val)
				if val >= 1 and val <= 5 then
					return val;
				end
			end,
		},
		{	--	use_realm_time_zone
			'bool',
			"^use" .. SEPARATOR .. "realm" .. SEPARATOR .. "time" .. SEPARATOR .. "zone" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"use_realm_time_zone",
			L.SLASH_NOTE["use_realm_time_zone"],
			function(key, val)
				NS.set_time_zone();
				NS.ui_update_calendar();
			end,
		},
		{	--	first_col_day
			'num',
			"^first" .. SEPARATOR .. "col" .. SEPARATOR .. "day" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"first_col_day",
			function(key, val)
				return format(L.SLASH_NOTE["first_col_day"], L.WEEKTITLE[val]);
			end,
			function(key, val)
				NS.ui_update_calendar();
			end,
			function(val)
				return val % NUM_COL;
			end,
		},
		{	--	instance_icon
			'bool',
			"^instance" .. SEPARATOR .. "icon" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"instance_icon",
			L.SLASH_NOTE["instance_icon"],
			function(key, val)
				NS.ui_update_calendar();
			end,
		},
		{	--	instance_text
			'bool',
			"^instance" .. SEPARATOR .. "text" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"instance_text",
			L.SLASH_NOTE["instance_text"],
			function(key, val)
				NS.ui_update_calendar();
			end,
		},
		{	--	dbicon
			'bool',
			"^show" .. SEPARATOR .. "db" .. SEPARATOR .. "icon" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"show_DBIcon",
			L.SLASH_NOTE["show_DBIcon"],
			function(key, val)
				if val then
					LibStub("LibDBIcon-1.0", true):Show("alaCalendar");
				else
					LibStub("LibDBIcon-1.0", true):Hide("alaCalendar");
				end
			end,
		},
		{	--	scale
			'num',
			"^scale" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"scale",
			L.SLASH_NOTE["scale"],
			function(key, val)
				NS.ui_attribute_all("scale", val);
			end,
			function(val)
				return max(min(10.0, val), 0.1);
			end,
		},
		{	--	alpha
			'num',
			"^alpha" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"alpha",
			L.SLASH_NOTE["alpha"],
			function(key, val)
				NS.ui_attribute_all("alpha", val);
			end,
			function(val)
				return max(min(1.0, val), 0.0);
			end,
		},
		{	--	show_unlocked
			'bool',
			"^show" .. SEPARATOR .. "unlocked" .. SEPARATOR .. "(.*)" .. SEPARATOR .. "$",
			"show_unlocked",
			L.SLASH_NOTE["show_unlocked"],
			function(key, val)
				NS.ui_update_board();
			end,
		},
	};
	_G.SLASH_ALACALENDAR1 = "/alacalendar";
	_G.SLASH_ALACALENDAR2 = "/alacal";
	_G.SLASH_ALACALENDAR3 = "/acal";
	local SET_PATTERN = "^" .. SEPARATOR .. "set" .. SEPARATOR .. "(.+)" .. SEPARATOR .. "$";
	SlashCmdList["ALACALENDAR"] = function(msg)
		msg = strlower(msg);
		--	set
		local _, _, pattern = strfind(msg, SET_PATTERN);
		if pattern then
			for _, v in pairs(set_cmd_list) do
				local _, _, pattern2 = strfind(pattern, v[2]);
				if pattern2 then
					if v[1] == 'bool' then
						if pattern2 == "true" or pattern2 == "ture" or pattern2 == "treu" or pattern2 == "1" or pattern2 == "on" or pattern2 == "enable" then
							SET[v[3]] = true;
							print(v[4] or v[3], "\124cff00ff00ON\124r");
							if v[5] then
								v[5](v[3], true);
							end
						elseif pattern2 == "false" or pattern2 == "flase" or pattern2 == "fales" or pattern2 == "0" or pattern2 == "off" or pattern2 == "disable" then
							SET[v[3]] = false;
							print(v[4] or v[3], "\124cffff0000OFF\124r");
							if v[5] then
								v[5](v[3], false);
							end
						else
							print(L["INVALID_COMMANDS"]);
						end
					elseif v[1] == 'num' then
						local val = tonumber(pattern2);
						if val then
							if v[6] then
								val = v[6](val);
							end
							if val then
								SET[v[3]] = val;
								if v[4] then
									if type(v[4]) == 'function' then
										print(v[4](key, val));
									else
										print(v[4], val);
									end
								else
									print(v[3], val);
								end
								if v[5] then
									v[5](v[3], val);
								end
							else
								print("\124cffff0000Invalid parameter: ", pattern2);
							end
						end
					end
					return;
				end
			end
			return;
		end
		--	default
		if strfind(msg, "[A-Za-z0-9]+" ) then
			print("Invalid command: [[", msg, "]] Use: ");
			print("  /acal setregion 1/2/3/4/5");
			print("  /acal setfirstcolday 0/1/2/3/4/5/6");
			print("  /acal setinstanceicon on/off");
			print("  /acal setinstancetext on/off");
			print("  /acal setshowdbicon 0/1");
			print("  /acal setscale 0.1~10.0");
			print("  /acal setalpha 0.0~1.0");
		else
			NS.ui_toggleGUI("CALENDAR");
		end
	end
end

do	--	run_on_next_tick	--	execute two ticks later
	local min_ticker_duration = 0.1;
	if false then	--	a universal method, unnecessary here
		local DELAY = 5;
		local delay_run_funcs = {  };
		for index = 1, DELAY do
			delay_run_funcs[index] = {  };
		end
		local timer = 0.0;
		local function delay_run_handler(self, elasped)
			timer = timer + elasped;
			if timer >= min_ticker_duration * DELAY then
				timer = 0.0;
				local funcs = delay_run_funcs[1];
				while true do
					local func = tremove(funcs, 1);
					if func then
						func();
					else
						break;
					end
				end
				for index = 2, DELAY do
					if #delay_run_funcs[index] > 0 then
						tinsert(delay_run_funcs, tremove(delay_run_funcs));
						return;
					end
				end
				_EventHandler:SetScript("OnUpdate", nil);
			end
		end
		function _EventHandler:delay_run(func, delay)
			delay = delay and max(min(delay, DELAY), 1) or 1;
			local dIndex = DELAY - delay + 1;
			for index = 1, DELAY do
				if index ~= dIndex then
					local funcs = delay_run_funcs[index];
					for i = 1, #funcs do
						if func == funcs[i] then
							tremove(funcs, i);
							break;
						end
					end
				end
			end
			local funcs = delay_run_funcs[dIndex];
			for index = 1, #funcs do
				if func == funcs[index] then
					return;
				end
			end
			tinsert(funcs, func);
			_EventHandler:SetScript("OnUpdate", delay_run_handler);
		end
		function _EventHandler:frame_delay_update(frame, delay)
			_EventHandler:delay_run(frame.update_func, delay);
		end
	end
	--
	local run_on_next_tick_func_1 = {  };
	local run_on_next_tick_func_2 = {  };
	local timer = 0.0;
	local function run_on_next_tick_handler(self, elasped)
		timer = timer + elasped;
		if timer >= min_ticker_duration * 2 then
			timer = 0.0;
			while true do
				local func = tremove(run_on_next_tick_func_1, 1);
				if func then
					func();
				else
					break;
				end
			end
			if #run_on_next_tick_func_1 + #run_on_next_tick_func_2 == 0 then
				_EventHandler:SetScript("OnUpdate", nil);
			else
				run_on_next_tick_func_1, run_on_next_tick_func_2 = run_on_next_tick_func_2, run_on_next_tick_func_1;
			end
		end
	end
	function _EventHandler:run_on_next_tick(func)
		for index = 1, #run_on_next_tick_func_1 do
			if func == run_on_next_tick_func_1[index] then
				tremove(run_on_next_tick_func_1, index);
				break;
			end
		end
		for index = 1, #run_on_next_tick_func_2 do
			if func == run_on_next_tick_func_2[index] then
				return;
			end
		end
		tinsert(run_on_next_tick_func_2, func);
		_EventHandler:SetScript("OnUpdate", run_on_next_tick_handler);
	end
	function _EventHandler:frame_update_on_next_tick(frame)
		_EventHandler:run_on_next_tick(frame.update_func);
	end
end

do	--	EXTERN
end

do	--	DEV
	if false then
		local t = time();
		-- function NS.to_date.time()
		-- 	return 1587918600 + time() - t;
		-- end
		function NS.to_date.get_user_time_zone()
			return 1;
		end
		NS.to_date.date = NS.to_date.built_in_date;
	end
end
