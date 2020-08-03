//////// include ////////
#include <sourcemod>
#include <sdktools>
#include <hgr>
#include <cstrike>
#include <multicolors>

//////// define ////////
#define DEBUG
#define PLUGIN_AUTHOR "ByDexter"
#define PLUGIN_VERSION "1.0"

//////// pragma ////////
#pragma semicolon 1
#pragma newdecls required

//////// Handle ////////
Handle hgrt_enable;

//////// ConVar ////////
ConVar hgrt_prefix;

//////// char ////////
char hgrt_text[64];

//////// bool ////////
bool hgrt_aktifmi;

//////// Myinfo ////////
public Plugin myinfo = 
{
	name = "Jail HGRT",
	author = PLUGIN_AUTHOR,
	description = "Jailbreak modunda HGR T takımını engelleme/aktifleştirme",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

//////// PluginStart ////////
public void OnPluginStart()
{
	LoadTranslations("hgrtannounce.phrases.txt");
	RegAdminCmd("sm_hgrt", HGRSTATUS, ADMFLAG_GENERIC, "HGR Enable/Disable");
	hgrt_prefix = CreateConVar("sm_hgr_prefix", "ByDexter", "Chat Başında geçicek reklam");
	hgrt_enable = CreateConVar("sm_hgr_enable", "1", "Eklenti Açıp Kapatma");
}

//////// MapStart ////////
public void OnMapStart()
{
	hgrt_aktifmi = false;
}

//////// Configs ////////
public void OnConfigsExecuted()
{
	hgrt_prefix.GetString(hgrt_text, sizeof(hgrt_text));
}

//////// SetCvar ////////
void SetCvar(char cvarName[64], int value)
{
	Handle IntCvar = FindConVar(cvarName);
	if (IntCvar)
	{
		int flags = GetConVarFlags(IntCvar);
		flags &= ~FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
		SetConVarInt(IntCvar, value, false, false);
		flags |= FCVAR_NOTIFY;
		SetConVarFlags(IntCvar, flags);
	}
}

//////// Hook ////////
public Action HGR_OnClientHook(int client)
{
	if (!GetConVarInt(hgrt_enable) && GetClientTeam(client) == CS_TEAM_T)
		return Plugin_Handled;

	return Plugin_Continue;
}

//////// Grab ////////
public Action HGR_OnClientGrab(int client)
{
	if (!GetConVarInt(hgrt_enable) && GetClientTeam(client) == CS_TEAM_T)
		return Plugin_Handled;

	return Plugin_Continue;
}

//////// Rope ////////
public Action HGR_OnClientRope(int client)
{
	if (!GetConVarInt(hgrt_enable) && GetClientTeam(client) == CS_TEAM_T)
		return Plugin_Handled;

	return Plugin_Continue;
}

//////// HGRTSTATUS ////////
public Action HGRSTATUS(int client, int args)
{
	if (hgrt_aktifmi)
	{
		CPrintToChatAll("{darkred}[%s] %t", hgrt_text, "Hgrdisablean", client);
		SetCvar("sm_hgr_enable", 0);
		hgrt_aktifmi = false;
	}
	else
	{
		CPrintToChatAll("{darkred}[%s] %t", hgrt_text, "Hgrenablean", client);
		SetCvar("sm_hgr_enable", 1);
		hgrt_aktifmi = true;
	}
	return Plugin_Continue;
}