class CfgBaseSpawn 
{
	/*
		How long a player must wait before they can spawn at the same flag again
		
		Default: 900 seconds - 15 minutes
	*/
	ExileBaseRespawnTimeLimit = 900;
	/*
		Required Flag Level for Base Spawn 
		
		Default: 1
	*/
	ExileBaseSpawnLevelRequired = 1;
	/*
		"ExileOwnerUID" - Only the owner of the flag can spawn at the flag
		"ExileTerritoryBuildRights" - Everyone on the buildrights can spawn at the flag
		
		Default: "ExileTerritoryBuildRights"
	*/
	ExileBaseSpawnAllowedType = "ExileTerritoryBuildRights";
	/*
		Allow Halo Spawn option for Base Spawn
		1 = On 0 = Off
		
		Default: 1
	*/
	ExileHaloSpawn = 1;
	/*
		Allow Ground Spawn option for Base Spawn 
		1 = On 0 = Off
		
		Default: 1
	*/
	ExileGroundSpawn = 1;
};