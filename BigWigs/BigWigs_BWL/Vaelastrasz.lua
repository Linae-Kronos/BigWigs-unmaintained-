-- edited by Masil for Kronos II
-- version 1
 
------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Vaelastrasz the Corrupt"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Vaelastrasz",

	adrenaline_trigger = "^(.+) (.+) afflicted by Burning Adrenaline\.",
	start_trigger = "afflicted by Essence of the Red",
	flamebreath_trigger = "Vaelastrasz the Corrupt begins to cast Flame Breath\.",
	yell1 = "^Too late, friends",
	yell2 = "^I beg you, mortals",
	yell3 = "^FLAME! DEATH! DESTRUCTION!",
	start_bar = "Start",
	tankburn_bar = "Tank Burn",
	adrenaline_bar = "Burning: %s",
	breath_bar = "Flame Breath",
	tankburnsoon = "Burning Adrenaline on tank in 5 seconds!",
	adrenaline_message = "%s has Burning Adrenaline!",
	adrenaline_message_you = "You have Burning Adrenaline!",
	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",

	are = "are",

	start_cmd = "start",
	start_name = "Start",
	start_desc = "Starts a bar for estimating the beginning of the fight.",

	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flame Breath",
	flamebreath_desc = "Warns when boss is casting Flame Breath.",

	adrenaline_cmd = "adrenaline",
	adrenaline_name = "Burning Adrenaline",
	adrenaline_desc = "Announces who received Burning Adrenaline and starts a clickable bar for easier selection.",

	whisper_cmd = "whisper",
	whisper_name = "Whisper",
	whisper_desc = "Whispers the players that got Burning Adrenaline, telling them to move away.",

	tankburn_cmd = "tankburn",
	tankburn_name = "Tank Burn",
	tankburn_desc = "Shows a bar for the Burning Adrenaline that will be applied on boss' target.",

	icon_cmd = "icon",
	icon_name = "Raid Icon",
	icon_desc = "Marks the player with Burning Adrenaline for easier localization.\n\n(Requires assistant or higher)",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsVaelastrasz = BigWigs:NewModule(boss)
BigWigsVaelastrasz.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsVaelastrasz.enabletrigger = boss
BigWigsVaelastrasz.toggleoptions = { "start", "flamebreath", "adrenaline", "whisper", "tankburn", "icon", "bosskill" }
BigWigsVaelastrasz.revision = tonumber(string.sub("$Revision: 11206 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsVaelastrasz:OnEnable()
	barstarted = nil
	started = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelAdrenaline", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelBreath", 3)
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelTankBurn", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VaelDead", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsVaelastrasz:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["flamebreath_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "VaelBreath")
	end
end

function BigWigsVaelastrasz:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	local _, _, deathother = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "VaelDead "..UnitName("player"))
	elseif deathother then
		self:TriggerEvent("BigWigs_SendSync", "VaelDead "..deathother)
	end
end

function BigWigsVaelastrasz:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["yell1"]) and self.db.profile.start then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 36, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
		barstarted = true
	elseif string.find(msg, L["yell2"]) and self.db.profile.start and not barstarted then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 26, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
		barstarted = true
	elseif string.find(msg, L["yell3"]) and self.db.profile.start and not barstarted then
		self:TriggerEvent("BigWigs_StartBar", self, L["start_bar"], 10, "Interface\\Icons\\Spell_Holy_PrayerOfHealing", true, "Cyan")
	end
end

function BigWigsVaelastrasz:Event(msg)
	local _, _, name, detect = string.find(msg, L["adrenaline_trigger"])
	if name and detect then
		if detect == L["are"] then
			self:TriggerEvent("BigWigs_SendSync", "VaelAdrenaline "..UnitName("player"))
		else
			self:TriggerEvent("BigWigs_SendSync", "VaelAdrenaline "..name)
		end
		for i = 1, GetNumRaidMembers() do
			if UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == boss and UnitExists("raid"..i.."targettarget") and UnitName("raid"..i.."targettarget") == name then
				self:TriggerEvent("BigWigs_SendSync", "VaelTankBurn")
				break
			end
		end
	end
	if not started and string.find(msg, L["start_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "VaelStart")
	end
end

function BigWigsVaelastrasz:BigWigs_RecvSync(sync, rest, nick)
	if sync == "VaelBreath" and self.db.profile.flamebreath then
		self:TriggerEvent("BigWigs_StartBar", self, L["breath_bar"], 2, "Interface\\Icons\\Spell_Fire_Fire", true, "Red")
	elseif sync == "VaelDead" and rest and self.db.profile.adrenaline then
			self:TriggerEvent("BigWigs_StopBar", self, string.format(L["adrenaline_bar"], rest))
			if self.db.profile.icon then
				self:TriggerEvent("BigWigs_RemoveRaidIcon", rest)
			end
	elseif sync == "VaelAdrenaline" and rest then
		if self.db.profile.adrenaline then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["adrenaline_bar"], rest), 20, "Interface\\Icons\\INV_Gauntlets_03", true, "White")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["adrenaline_bar"], rest), function(name, button, extra) TargetByName(extra, true) end, rest)
			if rest == UnitName("player") then
				self:TriggerEvent("BigWigs_Message", L["adrenaline_message_you"], "Personal", true, "Alarm")
				self:TriggerEvent("BigWigs_Message", string.format(L["adrenaline_message"], rest), "Urgent", nil, "Alert", true)
			else
				self:TriggerEvent("BigWigs_Message", string.format(L["adrenaline_message"], rest), "Urgent")
			end
		end
		if self.db.profile.whisper then
			if rest ~= UnitName("player") then
				self:TriggerEvent("BigWigs_SendTell", rest, L["adrenaline_message_you"])
			end
		end
		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", rest)
		end
	elseif sync == "VaelStart" and not started then
		if self.db.profile.tankburn then
			self:TriggerEvent("BigWigs_StartBar", self, L["tankburn_bar"], 44.9, "Interface\\Icons\\INV_Gauntlets_03", true, "Black")
			self:ScheduleEvent("BigWigs_Message", 39.9, L["tankburnsoon"], "Attention")
		end
		started = true
	elseif sync == "VaelTankBurn" then
		if self.db.profile.tankburn then
			self:TriggerEvent("BigWigs_StartBar", self, L["tankburn_bar"], 44.9, "Interface\\Icons\\INV_Gauntlets_03", true, "Black")
			self:ScheduleEvent("BigWigs_Message", 39.9, L["tankburnsoon"], "Attention")
		end
	end
end