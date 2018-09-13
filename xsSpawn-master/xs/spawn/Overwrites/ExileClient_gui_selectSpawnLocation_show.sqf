/**
 * ExileClient_gui_selectSpawnLocation_show
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_display","_spawnButton","_spawnButton2","_tipText","_tipTextList","_listBox","_listItemIndex","_numberOfSpawnPoints","_randNum","_randData","_randomSpawnIndex"];

ExileBaseRespawnTimeLimit = getNumber(missionConfigFile >> "CfgBaseSpawn" >> "ExileBaseRespawnTimeLimit");
ExileBaseSpawnLevelRequired = getNumber(missionConfigFile >> "CfgBaseSpawn" >> "ExileBaseSpawnLevelRequired");
ExileBaseSpawnBuildRights = getNumber(missionConfigFile >> "CfgBaseSpawn" >> "ExileBaseSpawnBuildRights");
ExileBaseSpawnHalo = getNumber(missionConfigFile >> "CfgBaseSpawn" >> "ExileBaseSpawnHalo");
ExileBaseSpawnGround = getNumber(missionConfigFile >> "CfgBaseSpawn" >> "ExileBaseSpawnGround");

if(isNil "spawnRegistry") then 
{
	spawnRegistry = [];
};

fn_checkRespawnDelay = {
	_markerName = _this select 0;
	if(isNil "_markerName") exitWith {true;};
	
	_counter = 0;
	{
		_baseName = _x select 0;
		_time = _x select 1;
		
		if(isNil "_baseName") exitWith {true;};
		if(isNil "_time") exitWith {true;};
		
		if(_baseName isEqualTo _markerName) then 
		{
			if(_time > time-ExileBaseRespawnTimeLimit) then
			{
				_counter = _counter + 1;
			};
		};
	} forEach spawnRegistry;
	
	if(_counter >= 1) exitWith
	{
		false;
	};
	true;
};

disableSerialization;
ExileClientSpawnLocationSelectionDone = false;
ExileClientSelectedSpawnLocationMarkerName = "";
createDialog "xstremeGroundorHaloDialog";
_display = uiNamespace getVariable ["xstremeGroundorHaloDialog",displayNull];
_display displayAddEventHandler ["KeyDown", "_this call ExileClient_gui_loadingScreen_event_onKeyDown"];
_spawnButton = _display displayCtrl 1600;
_spawnButton2 = _display displayCtrl 1601;
_spawnButton ctrlEnable false;
_spawnButton2 ctrlEnable false;
_tipText = _display displayCtrl 1204;
_listBox = _display displayCtrl 1500;
lbClear _listBox;
{
	if (getMarkerType _x == "ExileSpawnZone") then
	{
		_listItemIndex = _listBox lbAdd (markerText _x);
		_listBox lbSetData [_listItemIndex, _x];
	};
}
forEach allMapMarkers;

defaultLBsize = lbSize _listBox;
_playerUID = getPlayerUID player;
playerFlags = [];
{
	_flag = _x;
	_owner = _flag getVariable ["ExileOwnerUID", ""];
	_buildRights = _x getVariable["ExileTerritoryBuildRights",[]];
	_territoryLevelConfig =_x getVariable ["ExileTerritoryLevel", 0];
	if (_playerUID isEqualTo _owner || (ExileBaseSpawnBuildRights isEqualTo 1)&&(_playerUID in _buildRights)) then
	{	
		if(_territoryLevelConfig >= ExileBaseSpawnLevelRequired)then
		{
			_baseName = _flag getVariable ["ExileTerritoryName", ""];
			if(!([_baseName] call fn_checkRespawnDelay)) exitWith {};
			_listItemIndex = _listBox lbAdd (_flag getVariable ["ExileTerritoryName", ""]);
			_listBox lbSetData [_listItemIndex, str(count playerFlags)];
			_listBox lbSetColor [_listItemIndex, [0,0.68,1,1]];
			playerFlags pushBack _flag;
		};
	};
} forEach (allMissionObjects "Exile_Construction_Flag_Static");

fnc_selectionChange = {
	disableSerialization;
	_ctrl = _this select 0;
	_curSel = lbCurSel _ctrl;
	if(_curSel < defaultLBsize)then
	{
		_this call ExileClient_gui_selectSpawnLocation_event_onListBoxSelectionChanged;
	}
	else
	{
		_data = _ctrl lbData _curSel;
		_num = parseNumber _data;
		_flag = playerFlags select _num;
		markerName = format['FLAG_%1',_playerUID];
		deleteMarker markerName;
		createMarker [markerName,getPosATL _flag];
		ExileClientSelectedSpawnLocationMarkerName = markerName;
		_display = uiNamespace getVariable ["xstremeGroundorHaloDialog",displayNull];
		_spawnButton = _display displayCtrl 1600;
    		_spawnButton ctrlEnable true;
		_mapControl = _display displayCtrl 1300;
		_mapControl ctrlMapAnimAdd [1, 0.1, getMarkerPos ExileClientSelectedSpawnLocationMarkerName]; 
		ctrlMapAnimCommit _mapControl;
		_spawnButton = _display displayCtrl 1600;
		_spawnButton2 = _display displayCtrl 1601;
		if(ExileBaseSpawnHalo isEqualTo 1)then
		{
			_spawnButton ctrlEnable true;
		}else{
			_spawnButton ctrlEnable false;
		};
		if(ExileBaseSpawnGround isEqualTo 1)then
		{
			_spawnButton2 ctrlEnable true;
		}else{
			_spawnButton2 ctrlEnable false;
		};
	};
};
_listBox ctrlRemoveAllEventHandlers "LBSelChanged";
_listBox ctrlAddEventHandler ["LBSelChanged", "_this call fnc_selectionChange;"];

_tipTextList = selectRandom 
[
	"Connect to the xstreme gaming discord at discord.xstremegaming.com",
	"Server news, comp claims and more join the communnity www.xstremegaming.com",
	"This is a game of loss, its a wild world out there, good luck!",
	"Enjoy the server... Please consider donating to help keep us alive",
	"Any vehicle left inside the black safezone circle will be deleted at restart",
	"Press 'M' key for Map in game to view Server Rules and Building Limits",
	"Do not leave vehicles on exile base parts, at restart they will likely explode",
	"Press the 'U' key when your loaded in to show your FPS on the Status bar"
];
_tipText ctrlSetStructuredText parseText format["<t size ='1.8 / (getResolution select 5)' valign='middle' align='right'>[ %1 ]</t>",_tipTextList];

true
