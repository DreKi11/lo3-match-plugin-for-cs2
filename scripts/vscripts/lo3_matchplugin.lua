--[[
******************************************************[ lo3 matchplugin CS2 ]********************************************************
	Original plugin created by: execut1ve
	Version: 1.0
	Github: https://github.com/execut1ve/
	Twitter: https://twitter.com/execut1ve
	Steam: https://steamcommunity.com/id/execut1ve/

	Improved by: DreKill
	Version: 1.0
	Github: https://github.com/DreKi11/
	Steam: https://steamcommunity.com/profiles/76561197965623687

	*<News>
	  Added PrintWaitingPracc (Print message during the pracc period) [.restart .forceend(back to warmup)]
	  Added PrintWaitingPug (Print message during the match period) [.pause .unpause .restart(restart score) .forceend]
	* PrintWaitingforPlayers *(default print message during the warmup period) [.lo3 .pracc .scramble .help]
	- Added timers WARPUG_TIME, WARPRACC_TIME
	* Use timer WARMUP_TIME *(default timer and config)
	- Added .pracc, .restart <Convars:GetCommandClient()>
	- Replace <fr> traduction																								- V
	*<Past>
	_____________________________________________________________________________________________________________________________
	
	USABILITY:
	- Ce plugin est un simple lo3 5vs5 competitive pour votre serveur
	- Warmup time par défaut, switch pour lo3 ou pracc configuration
	- 3 Phases (Warmup time/Match time/Pracc time)
************************************************************************************************************************************
--]]

require "libs.timers"
chatPrefix = "{darkgreen} [LO3] "
 
-- Les valeurs ci-dessous sont à réglées dans les timers à partir de la ligne <'91,114,136'>
-- Affiche des messages à intervalle régulier pendant les phases de || warmup || lo3 || pracc ||
-- -------------------------------------------------------------------
WARMUP_TIME = true
warmupDelay = 0 -- warmupDelay 45 par default pour les messages pendant le warmup (à ne pas régler ici)
WARPUG_TIME = false
warpugDelay = 0 -- warpugDelay 90 par default pour les messages pendant le lo3 (à ne pas régler ici)
WARPRACC_TIME = false
warpraccDelay = 0 -- warpraccDelay 60 par default pour les messages pendant le pracc (à ne pas régler ici)
scrambleDelay = 0
scrambleTime = 0
-- -------------------------------------------------------------------

function HC_ReplaceColorCodes_pug(text)
	text = string.gsub(text, "{white}", "\x01")
	text = string.gsub(text, "{darkred}", "\x02")
	text = string.gsub(text, "{purple}", "\x03")
	text = string.gsub(text, "{darkgreen}", "\x04")
	text = string.gsub(text, "{lightgreen}", "\x05")
	text = string.gsub(text, "{green}", "\x06")
	text = string.gsub(text, "{red}", "\x07")
	text = string.gsub(text, "{lightgray}", "\x08")
	text = string.gsub(text, "{yellow}", "\x09")
	text = string.gsub(text, "{orange}", "\x10")
	text = string.gsub(text, "{darkgray}", "\x0A")
	text = string.gsub(text, "{blue}", "\x0B")
	text = string.gsub(text, "{darkblue}", "\x0C")
	text = string.gsub(text, "{gray}", "\x0D")
	text = string.gsub(text, "{darkpurple}", "\x0E")
	text = string.gsub(text, "{lightred}", "\x0F")
	return text
end

function HC_PrintChatAll_pug(text)		
	ScriptPrintMessageChatAll(" " .. HC_ReplaceColorCodes_pug(chatPrefix .. text))
end

function PrintHelp()
    HC_PrintChatAll_pug("{white}------------------------------------------------")
    HC_PrintChatAll_pug("{white}【Échauffement】")
    HC_PrintChatAll_pug("{darkgreen}.lo3{white} : Commence le match。")
    HC_PrintChatAll_pug("{darkgreen}.pracc{white} : Commence le pracc。")
    HC_PrintChatAll_pug("{darkgreen}.scramble{white} : Mélange les équipes 3 fois。")
    HC_PrintChatAll_pug("{white}【Pendant la partie】")
    HC_PrintChatAll_pug("{red}.pause{white} : Demande une pause au prochain freezetime。")
    HC_PrintChatAll_pug("{red}.unpause{white} : Annule la pause demandée。")
    HC_PrintChatAll_pug("{red}.restart{white} : Restart le match、 les scores reviennent à 0。")
    HC_PrintChatAll_pug("{red}.forceend{white} : Force la fin du match/pracc。")
    HC_PrintChatAll_pug("{white}------------------------------------------------")
end

-- Timer pendant le warmup pour afficher toutes les x secondes les commandes
function PrintWaitingforPlayers(event)
    Timers:CreateTimer("warmup_timer", {
        callback = function()
            if (WARMUP_TIME == true) then
                if warmupDelay == 45 then
                    SendToServerConsole("bot_kick")
                    HC_PrintChatAll_pug("{white} Warmup en cours...。")
                    HC_PrintChatAll_pug("{white} à la console tape {darkgreen}.lo3{white} Commence le match。")
                    HC_PrintChatAll_pug("{white} à la console tape {darkgreen}.pracc{white} Commence le pracc。")
                    HC_PrintChatAll_pug("{white} à la console tape {darkgreen}.cut{white} Commence le cut round。")
					HC_PrintChatAll_pug("{white} à la console tape {darkgreen}.scramble{white} Mélange les équipes 3 fois。")
                    HC_PrintChatAll_pug("{white} à la console tape {orange}.help{white} Obtenir de l'aide。")
                    warmupDelay = 0
                else
                    warmupDelay = warmupDelay + 1
                end
            end
            return 1
        end,
    })
end

-- Timer pendant le pug pour afficher toutes les x secondes les commandes
function PrintWaitingPug(event)
    Timers:CreateTimer("warpug_timer", {
        callback = function()
            if (WARPUG_TIME == true) then
                if warpugDelay == 90 then
                    SendToServerConsole("bot_kick")
                    HC_PrintChatAll_pug("{white} Match en cours...。")
                    HC_PrintChatAll_pug("{white} à la console tape {red}.pause{white} Demande une pause au prochain freezetime。")
                    HC_PrintChatAll_pug("{white} à la console tape {red}.unpause{white} Annule la pause demandée。")
					HC_PrintChatAll_pug("{white} à la console tape {red}.restart{white} Restart le match、 les scores reviennent à 0。")
					HC_PrintChatAll_pug("{white} à la console tape {red}.forceend{white} Force la fin du match。")
                    warpugDelay = 0
                else
                    warpugDelay = warpugDelay + 1
                end
            end
            return 1
        end,
    })
end

-- Timer pendant le pracc pour afficher toutes les x secondes les commandes
function PrintWaitingPracc(event)
    Timers:CreateTimer("warpracc_timer", {
        callback = function()
            if (WARPRACC_TIME == true) then
                if warpraccDelay == 60 then
                    HC_PrintChatAll_pug("{white} Pracc en cours...。")
					HC_PrintChatAll_pug("{white} à la console tape {red}.restart{white} Restart le pracc、 les scores reviennent à 0。")
					HC_PrintChatAll_pug("{white} à la console tape {red}.forceend{white} Relance le warmup。")
                    warpraccDelay = 0
                else
                    warpraccDelay = warpraccDelay + 1
                end
            end
            return 1
        end,
    })
end

-- Phase de warmup (par défaut)
function StartWarmup()
    SendToServerConsole("mp_unpause_match")
    SendToServerConsole("bot_kick")
    SendToServerConsole("bot_quota 0")
    SendToServerConsole("bot_quota_mode fill")
	SendToServerConsole("mp_buytime 9999")
	SendToServerConsole("mp_startmoney 800")
	SendToServerConsole("mp_maxmoney 6000")
	SendToServerConsole("mp_roundtime 0")
	SendToServerConsole("sv_allow_votes 0")
	SendToServerConsole("mp_endmatch_votenextleveltime 0")
	SendToServerConsole("mp_endmatch_votenextmap 0")
	SendToServerConsole("mp_endmatch_votenextmap_keepcurrent 0")
    SendToServerConsole("sv_cheats 1")
    SendToServerConsole("mp_respawn_on_death_t 0")
    SendToServerConsole("mp_respawn_on_death_ct 0")
    SendToServerConsole("mp_autokick 0")
    SendToServerConsole("sv_grenade_trajectory_prac_pipreview 0")
    SendToServerConsole("sv_grenade_trajectory_prac_trailtime 0")
    SendToServerConsole("sv_showimpacts 0")
    SendToServerConsole("sv_showimpacts_time 0")
    SendToServerConsole("sv_infinite_ammo 2")
    SendToServerConsole("mp_buy_anywhere 1")
    SendToServerConsole("mp_warmuptime 234124235")
    SendToServerConsole("mp_warmuptime_all_players_connected 234124235")
    SendToServerConsole("mp_warmup_pausetimer 1")
	SendToServerConsole("mp_warmup_start")
	SendToServerConsole("nextmap_print_enabled 1")
    WARMUP_TIME = true
	WARPUG_TIME = false
	WARPRACC_TIME = false
end

-- Phase de match
function StartPug()
    SendToServerConsole("bot_kick")
    SendToServerConsole("bot_quota 0")
    SendToServerConsole("bot_quota_mode fill")
	SendToServerConsole("mp_buytime 20")
	SendToServerConsole("mp_startmoney 800")
	SendToServerConsole("mp_maxmoney 16000")
	SendToServerConsole("mp_roundtime 1.92")
	SendToServerConsole("sv_allow_votes 1")
	SendToServerConsole("mp_endmatch_votenextleveltime 2")
	SendToServerConsole("mp_endmatch_votenextmap 1")
	SendToServerConsole("mp_endmatch_votenextmap_keepcurrent 1")
    SendToServerConsole("mp_warmup_start")
    SendToServerConsole("sv_grenade_trajectory_prac_pipreview 0")
    SendToServerConsole("sv_grenade_trajectory_prac_trailtime 0")
    SendToServerConsole("sv_showimpacts 0")
    SendToServerConsole("sv_showimpacts_time 0")
    SendToServerConsole("sv_infinite_ammo 0")
    SendToServerConsole("mp_buy_anywhere 0")
    SendToServerConsole("sv_cheats 0")
    SendToServerConsole("mp_respawn_on_death_t 0")
    SendToServerConsole("mp_respawn_on_death_ct 0")
    SendToServerConsole("mp_autokick 0")
    SendToServerConsole("mp_warmuptime 10")
    SendToServerConsole("mp_warmuptime_all_players_connected 10")
    SendToServerConsole("mp_warmup_pausetimer 0")
	SendToServerConsole("nextmap_print_enabled 1")
    HC_PrintChatAll_pug("{white} Le match commencera dans 10 secondes。")
    HC_PrintChatAll_pug("{white} Le match commencera dans 10 secondes。")
    HC_PrintChatAll_pug("{white} Le match commencera dans 10 secondes。")
    WARMUP_TIME = false
	WARPUG_TIME = true
	WARPRACC_TIME = false
end

-- Phase de pracc
function StartPracc()
    SendToServerConsole("bot_quota 10")
    SendToServerConsole("bot_quota_mode fill")
	SendToServerConsole("mp_buytime 9999")
	SendToServerConsole("mp_startmoney 800")
	SendToServerConsole("mp_maxmoney 12000")
	SendToServerConsole("mp_roundtime 60")
	SendToServerConsole("sv_allow_votes 1")
	SendToServerConsole("mp_endmatch_votenextleveltime 2")
	SendToServerConsole("mp_endmatch_votenextmap 1")
	SendToServerConsole("mp_endmatch_votenextmap_keepcurrent 1")
    SendToServerConsole("mp_warmup_start")
    SendToServerConsole("sv_grenade_trajectory_prac_pipreview 1")
    SendToServerConsole("sv_grenade_trajectory_prac_trailtime 5")
    SendToServerConsole("sv_showimpacts 1")
    SendToServerConsole("sv_showimpacts_time 1")
    SendToServerConsole("sv_infinite_ammo 2")
    SendToServerConsole("mp_buy_anywhere 1")
    SendToServerConsole("sv_cheats 1")
    SendToServerConsole("mp_respawn_on_death_t 0")
    SendToServerConsole("mp_respawn_on_death_ct 0")
    SendToServerConsole("mp_autokick 0")
    SendToServerConsole("mp_warmuptime 10")
    SendToServerConsole("mp_warmuptime_all_players_connected 10")
    SendToServerConsole("mp_warmup_pausetimer 0")
	SendToServerConsole("nextmap_print_enabled 1")
    HC_PrintChatAll_pug("{white} Le pracc commence。")
    HC_PrintChatAll_pug("{white} Le pracc commence。")
    HC_PrintChatAll_pug("{white} Le pracc commence。")
    WARMUP_TIME = false
	WARPUG_TIME = false
	WARPRACC_TIME = true
end

function ScrambleTeams()
    scrambleTime = 2
    HC_PrintChatAll_pug("{white} Les membres de l'équipe seront mélangés 3 fois de plus。")
    SendToServerConsole("mp_scrambleteams")
    Timers:CreateTimer("scramble_timer", {
        callback = function()
            if scrambleDelay == 1 then
                HC_PrintChatAll_pug("{white} Les membres de l'équipe sont partis "..scrambleTime.." sera mélangé deux fois。")
                SendToServerConsole("mp_scrambleteams")
                scrambleTime = scrambleTime - 1
                scrambleDelay = 0
            else
                scrambleDelay = scrambleDelay + 1
            end
            if scrambleTime == 0 then
                Timers:RemoveTimer(scramble_timer)
            end
            return 1
        end,
    })
end

--[[
Déclaration des commandes possible pour les utilisateurs selon la configuration
.lo3
.pracc
.help
.pause
.unpause
.restart
.scramble
.forceend
--]]

Convars:RegisterCommand(".lo3", function() 
	local user = Convars:GetCommandClient()
	
	if (WARMUP_TIME == true) then
		StartPug()
	end
end, nil, 0)

Convars:RegisterCommand(".pracc", function() 
	local user = Convars:GetCommandClient()
	
	if (WARMUP_TIME == true) then
		StartPracc()
	end
end, nil, 0)

Convars:RegisterCommand(".help", function() 
	local user = Convars:GetCommandClient()
	PrintHelp()
end, nil, 0)

Convars:RegisterCommand(".pause", function()
	local user = Convars:GetCommandClient()
    SendToServerConsole("mp_pause_match")
    HC_PrintChatAll_pug("{white} Qqun demande une pause au prochain freezetime。")
end, nil, 0)

Convars:RegisterCommand(".unpause", function()
	local user = Convars:GetCommandClient()
    SendToServerConsole("mp_unpause_match")
    HC_PrintChatAll_pug("{white} La pause demandée vient d'être annulée/stoppée。")
end, nil, 0)

Convars:RegisterCommand(".restart", function()
	local user = Convars:GetCommandClient()
    if (WARMUP_TIME == false) then
	    SendToServerConsole("mp_restartgame 3")
        HC_PrintChatAll_pug("{white} Restart du match/pracc、 les scores reviennent donc à 0。")
    end
end, nil, 0)

Convars:RegisterCommand(".scramble", function()
	local user = Convars:GetCommandClient()
	if (WARMUP_TIME == true) then
        HC_PrintChatAll_pug("{white} Mélange des équipes。")
        ScrambleTeams()
    end
end, nil, 0)

Convars:RegisterCommand(".forceend", function()
	local user = Convars:GetCommandClient()
    if (WARMUP_TIME == false) then
        HC_PrintChatAll_pug("{white} Le match/pracc a été annulé。")
        StartWarmup()
    end
end, nil, 0)

function OnPlayerSpawned(event)
	PrintWaitingforPlayers(event)
end

function RoundStart(event)
	PrintWaitingPug(event)
end

function RoundEnd(event)
	PrintWaitingPracc(event)
end

-- Par défaut, on start le warmup
StartWarmup()

-- Pendant le warmup
ListenToGameEvent("player_spawn", OnPlayerSpawned, nil)

-- Pendant le lo3
ListenToGameEvent("round_start", RoundStart, nil)

-- Pendant le pracc
ListenToGameEvent("round_end", RoundEnd, nil)

-- Permet de voir si le plugin est bien chargé
print("[LO3] Plugin loaded!")
