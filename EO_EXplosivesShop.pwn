/*


																          _____                   _______
																         /\    \                 /::\    \
																        /::\    \               /::::\    \
																       /::::\    \             /::::::\    \
																      /::::::\    \           /::::::::\    \
																     /:::/\:::\    \         /:::/~~\:::\    \
																    /:::/__\:::\    \       /:::/    \:::\    \
																   /::::\   \:::\    \     /:::/    / \:::\    \
																  /::::::\   \:::\    \   /:::/____/   \:::\____\
																 /:::/\:::\   \:::\    \ |:::|    |     |:::|    |
																/:::/__\:::\   \:::\____\|:::|____|     |:::|    |
																\:::\   \:::\   \::/    / \:::\    \   /:::/    /
																 \:::\   \:::\   \/____/   \:::\    \ /:::/    /
																  \:::\   \:::\    \        \:::\    /:::/    /
																   \:::\   \:::\____\        \:::\__/:::/    /
																    \:::\   \::/    /         \::::::::/    /
																     \:::\   \/____/           \::::::/    /
																      \:::\    \                \::::/    /
																       \:::\____\                \::/____/
																        \::/    /                 ~~
																         \/____/



											  ______ ____   ______            _           _                   _____ _
											 |  ____/ __ \ |  ____|          | |         (_)                 / ____| |
											 | |__ | |  | || |__  __  ___ __ | | ___  ___ ___   _____  ___  | (___ | |__   ___  _ __
											 |  __|| |  | ||  __| \ \/ / '_ \| |/ _ \/ __| \ \ / / _ \/ __|  \___ \| '_ \ / _ \| '_ \
											 | |___| |__| || |____ >  <| |_) | | (_) \__ \ |\ V /  __/\__ \  ____) | | | | (_) | |_) |
											 |______\____/ |______/_/\_\ .__/|_|\___/|___/_| \_/ \___||___/ |_____/|_| |_|\___/| .__/
											           ______          | |                                                     | |
											          |______|         |_|                                                     |_|
														                   		EO_Explosives Shop





**CopyRight Claim: Please do not upload this or edit it without my permission, leave all credits,

fireworks
/esp
/saving system
SQLite
**************

=====================================================================================================================================================================
=====================================================================================================================================================================
==========================================================================|[ Configuration Panel ]|=================================================================*/
//Bombs Prices
#define BombP 2500 		// Normal bomb
#define TBombP 5000 	//Settable timed bomb
#define C4P 10000       //C4 remote-controlled
#define CBombP 12000    //Vehicle bomb
#define ABombP 20000    //Atomic Bomb
#define SBombP 9000     //Stiky bomb
#define SuBombP 6000    //Suicidal bomb
#define QBombP 30000    //quantum  bomb
#define MBombP 15000    //Mines
#define EBarrelP 3500   //Explosive barrel
#define ERCCP 15000 //Explosive RC Car
#define ERCHP 20000 //Explosive RC Helicopter
//Timers
#define BrakingTimer 300000 //Timer between using each bomb
#define VehicleBombClearTimer 300000 //Time to clear all vehicle car bombs
/*=====================================================================================================================================================================
====================================================================================================================================================================*/

#define FILTERSCRIPT

#include <a_samp>
#include <sscanf2>
#include <streamer>
#include <iZCMD>

//Colors*********************
#define Blren 0x058E6A
#define Red 0xFF0000
#define Green 0x00FF22
//***************************

#define MAX_EVM 20

new
    Float:gC[3],
	pBomb[MAX_PLAYERS],
	pQBHydraucs[MAX_PLAYERS],
	pQBCore[MAX_PLAYERS],
	pBombTimer[MAX_PLAYERS],
	pABICheck[MAX_PLAYERS],
	pSBCheck[MAX_PLAYERS],
	Float:pBombPos[MAX_PLAYERS][3],
	Float:pABombPos[MAX_PLAYERS][3],
	Float:pQBombPos[MAX_PLAYERS][3],
	pSVBTimer[MAX_PLAYERS],
	pQBombATimer[MAX_PLAYERS],
	Float:pMPos[MAX_PLAYERS][3],
	pMObject[MAX_PLAYERS],
	pAMCheck[MAX_PLAYERS],
	pRCC[MAX_PLAYERS],
	pRCH[MAX_PLAYERS],
	Text3D:pb3DText[MAX_PLAYERS],
	Float:pRCPos[MAX_PLAYERS][3],
	gEVM[MAX_EVM],
	evmid;


//DIALOGS
enum{
    DIALOG_EVMINDEX,
    DIALOG_EVMPSTATS,
    DIALOG_EHELP,
    DIALOG_TBomb
};

enum E_PLAYER_BOMB_DATA{
	bool:BombUse,
	bool:BombEx,
	bool:BombC4,
	bool:AtBomb,
	bool:CarBomb,
	bool:MBombEx,
	bool:AMBomb,
	bool:pSBomb,
	Bomb,
	SuBomb,
	QBomb,
	EBBomb,
	TBomb,
	MBomb,
	CBomb,
	ABomb,
	SBomb,
	C4,
	RCC,
	RCH
};

enum EVM_DATA{
	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:RotX,
	Float:RotY,
	Float:RotZ,
	EVMBlocked,
	Text3D:EVM3DT
};

GetName(playerid){
	new fpname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, fpname, sizeof(fpname));
	return fpname;
}

new EVMData[MAX_EVM][EVM_DATA];


new pbData[MAX_PLAYERS][E_PLAYER_BOMB_DATA];
new vbData[MAX_VEHICLES][E_PLAYER_BOMB_DATA];

//TIMERS
forward BombTimer(playerid);
forward TimingBombTimer(playerid);
forward VehicleCarBombClear(vehicleid);
forward CarBombActivation(vehicleid);
forward atomicbombimpact(playerid);
forward SuVBTimer(playerid);
forward QuantumBombActivation(playerid);

stock ClearBombs(playerid){
    pbData[playerid][Bomb] = 0;
    pbData[playerid][RCC] = 0;
    pbData[playerid][RCH] = 0;
	pbData[playerid][SuBomb] = 0;
	pbData[playerid][QBomb] = 0;
	pbData[playerid][EBBomb] = 0;
	pbData[playerid][TBomb] = 0;
	pbData[playerid][MBomb] = 0;
	pbData[playerid][C4] = 0;
	pbData[playerid][CBomb] = 0;
	pbData[playerid][ABomb] = 0;
	pbData[playerid][SBomb] = 0;
	pbData[playerid][RCC] = 0;
	pbData[playerid][RCH] = 0;
}

new DB:Database;

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	new query[40],str[86],Count=0,DBResult:DATA;
	print("\n--------------------------------------");
	print("        EO_Explosives Shop v1.2         ");
	print("--------------------------------------\n");

	if((Database = db_open("Database.db")) == DB:0){
		printf("[EVM]: Connection to database failed!");
	}
	else{
		db_free_result(db_query(Database, "CREATE TABLE IF NOT EXISTS `EVM`(`ID` INTEGER PRIMARY KEY, `PosX` FLOAT DEFAULT 0.0,`PosY` FLOAT DEFAULT 0.0,`PosZ` FLOAT DEFAULT 0.0,`RotX` FLOAT DEFAULT 0.0,`RotY` FLOAT DEFAULT 0.0,`RotZ` FLOAT DEFAULT 0.0, `Block` INTEGER DEFAULT 0 NOT NULL)"));
		printf("[EVM]: Connection to database was successful");
	}
	printf("\n  ***| Explosives Vending Machines Loading... |***");
	for(new i=1; i<MAX_EVM;i++){
		format(query,sizeof(query), "SELECT * FROM `EVM` WHERE `ID` = %i",i);
		DATA = db_query(Database, query);
		if(db_num_rows(DATA)){
			EVMData[i][PosX] = db_get_field_assoc_float(DATA, "PosX");
			EVMData[i][PosY] = db_get_field_assoc_float(DATA, "PosY");
			EVMData[i][PosZ] = db_get_field_assoc_float(DATA, "PosZ");
			EVMData[i][RotX] = db_get_field_assoc_float(DATA, "RotX");
			EVMData[i][RotY] = db_get_field_assoc_float(DATA, "RotY");
			EVMData[i][RotZ] = db_get_field_assoc_float(DATA, "RotZ");
			EVMData[i][EVMBlocked] = db_get_field_assoc_int(DATA, "Block");
			db_free_result(DATA);
	        gEVM[i] = CreateDynamicObject(18885, EVMData[i][PosX], EVMData[i][PosY], EVMData[i][PosZ], EVMData[i][RotX], EVMData[i][RotY], EVMData[i][RotZ], -1, -1, -1, 110, 100);
	        format(str, sizeof(str), "Explosive Vending Machine\nEVM ID: %i\n{FFFFFF}Press {FFFF00}N {FFFFFF}to interfere", i);
			EVMData[i][EVM3DT] = CreateDynamic3DTextLabel(str, 0xFFFF0088, EVMData[i][PosX], EVMData[i][PosY], EVMData[i][PosZ], 80, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 95);
			Count++;
			printf("EVM ID: %i Loaded successfully",i);
		}
	}
	SetGameModeText("EO_Explosives Shop v1.2");
    printf("  ***| %i EVM(s) Loaded |***\n",Count);

    SetTimer("VehicleCarBombClear",VehicleBombClearTimer,true);
	return 1;
}

#else

#endif
public OnGameModeExit(){
	db_close(Database);
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	ClearBombs(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SendClientMessage(playerid, Green, "[SERVER]: {FFFFFF}EO_Explosives Shop v1.2, see related commands via /evmcmds");
    pbData[playerid][BombEx] = false;
    pbData[playerid][BombC4] = false;
    pbData[playerid][AtBomb] = false;
    pbData[playerid][pSBomb] = false;
    pbData[playerid][MBombEx] = false;
	pbData[playerid][CarBomb] = false;
	pbData[playerid][MBombEx] = false;
	pbData[playerid][AMBomb] = false;
	pbData[playerid][pSBomb] = false;
	pbData[playerid][Bomb] = 0;
	pbData[playerid][SuBomb] = 0;
	pbData[playerid][QBomb] = 0;
	pbData[playerid][EBBomb] = 0;
	pbData[playerid][TBomb] = 0;
	pbData[playerid][MBomb] = 0;
	pbData[playerid][CBomb] = 0;
	pbData[playerid][ABomb] = 0;
	pbData[playerid][SBomb] = 0;
	pbData[playerid][C4] = 0;
	pbData[playerid][RCC] = 0;
	pbData[playerid][RCH] = 0;
    TogglePlayerControllable(playerid, true);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(pbData[playerid][BombEx] == true){
	    SendClientMessage(playerid, Red, "[EO_INFO]: {FFFFFF}The Bomb you planted has been deactivated");
	    DestroyObject(pBomb[playerid]);
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	if(vbData[vehicleid][CarBomb] == true)
		vbData[vehicleid][CarBomb] = false;
	return 1;
}

//explosives stats
CMD:estats(playerid){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    new pname[MAX_PLAYER_NAME], str[1050];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(str, sizeof(str), "{CCCCFF}%s{FFFFFF}\n\nBombs: %i\t\tTiming Bombs: %i\nC4: %i\t\t\tCar Bombs: %i\nAtomic Bombs: %i\tSticky Bombs: %i\nBomb Vests: %i\t\tQuantum Bombs: %i\nMines: %i\t\tExplosive Barrels: %i\nExplosive RC Car: %i\tExplosive Drones: %i",
	pname, pbData[playerid][Bomb],pbData[playerid][TBomb],pbData[playerid][C4],pbData[playerid][CBomb],pbData[playerid][ABomb],pbData[playerid][SBomb],pbData[playerid][SuBomb],pbData[playerid][QBomb],pbData[playerid][MBomb],pbData[playerid][EBBomb],pbData[playerid][RCC],pbData[playerid][RCH]);
    ShowPlayerDialog(playerid, DIALOG_EVMPSTATS, DIALOG_STYLE_MSGBOX, "EO_Explosive Stats", str, "Got it!", "");
	return 1;
}

//Explosives help index
CMD:ehelp(playerid){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    new str[2500];
    strcat(str,"{FFFF00}Bomb: {FFFFFF}A 3 seconds timed bomb with a normal exploding radius, it can be used via /plantbomb\n");
    strcat(str,"{FFFF00}Timing Bomb: {FFFFFF} It's a bomb whose detonation is triggered by a timer which has to be closed in 3 to 60 seconds,\n it can be used via /planttbomb\n");
    strcat(str,"{FFFF00}C4: {FFFFFF}A Remote-controlled bomb, which can be setup somewhere using /plantc4 then detonated via /detonate\n");
    strcat(str,"{FFFF00}Car Bomb: {FFFFFF}A Vehicle related bomb, in order to use it, you be inside of a vehicle, then use /plantvehbomb , after that, you will have to leave the vehicle immediately,\n the bomb will be activated within 3 seconds, and anybody who enters the vehicle by then, will be exploded\n");
    strcat(str,"{FFFF00}Atomic Bomb: {FFFFFF} A bomb that derives its destructive power from the rapid release of nuclear energy, in ordet to use it you have to choose a position, then use /setabpos \nand to activate it, you have to be in a Pony or a Burrito and use /launchab\n");
    strcat(str,"{FFFF00}Sticky Bomb: {FFFFFF} A Sticky Bomb is an explosive charge that when thrown against a player using /attachsbomb sticks until it explodes.\n");
    strcat(str,"{FFFF00}Suicidal bomb vest: {FFFFFF} A Suicidal bomb vest is an armour-like shaped, but instead of protecting you, it activates explosives that will take you and anyone close to you down, to activate it, simply use /mountsvb\n");
    strcat(str,"{FFFF00}Quantum Bomb: {FFFFFF} A Quantum Bomb differs from other bombs with its ability to pull nearby players then teleports them high in the air, next explode them, you can use it via /setqbomb\n");
    strcat(str,"{FFFF00}Mines: {FFFFFF} A mine is an explosive placed underground or underwater that explodes when disturbed, you can use it via /plantmine, then to activate it, use /activatemine\n");
    strcat(str,"{FFFF00}Explosive Barrels: {FFFFFF} An Explosive-loaded steel barrels, that explode upon a physical contact, whether shot or hit, you can place them anywhere using /placeeb\n");
    strcat(str,"{FFFF00}Explosive RC Car: {FFFFFF} A Remote controlled mini-car (basically a moving bomb), it can be used via /activaterccar\n");
    strcat(str,"{FFFF00}Explosive Drone: {FFFFFF} A Remote controlled mini-helicopter (basically a moving bomb), it can be used via /activatedrone\n");
	ShowPlayerDialog(playerid, DIALOG_EHELP, DIALOG_STYLE_MSGBOX, "EO_Explosives Help Section", str, "Got it","");
	return 1;
}

CMD:evmcmds(playerid){
	if(IsPlayerAdmin(playerid)){
		SendClientMessage(playerid, 0xFFFF0088, "|============EO_Explosive Shop Commands===========|");
		SendClientMessage(playerid, 0xFFFFCC90, "| /evmcmds   ||  /evmshop   ||  /estats  ||  /ehelp |");
		SendClientMessage(playerid, 0xFFFFCC90, "|    /givebombs ||  /setbombs  ||  /clearbombs	    |");
		SendClientMessage(playerid, 0xFFFFCC90, "|      /makeevm ||  /editevm   ||  /deleteevm 	    |");
		SendClientMessage(playerid, 0xFFFFCC90, "|     /evmstats ||  /blockevm  ||  /unblockevm    |");
		SendClientMessage(playerid, 0xFFFF0088, "|=================================================|");
	}
	else{
		SendClientMessage(playerid, 0xFFFF0088, "|============EO_Explosive Shop Commands===========|");
		SendClientMessage(playerid, 0xFFFFCC90, "| /evmcmds   ||  /evmshop   ||  /estats  ||  /ehelp |");
		SendClientMessage(playerid, 0xFFFF0088, "|=================================================|");
	}
	
	return 1;
}

/*CMD:evmshop(playerid){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	ShowPlayerDialog(playerid, DIALOG_EVMINDEX, DIALOG_STYLE_LIST, "EO_Explosive Shop",
	"Bomb\n\
	Timing bomb\n\
	C4\n\
	Car bomb\n\
	Atomic bomb\n\
    Sticky bombs\n\
    Suicidal bomb vest\n\
    Quantum bomb\n\
    Mines\n\
    Explosive barrels\n\
	Explosive RC Car\n\
	Explosive Drone"
	,"Select", "Cancel");
	return 1;
}*/
///////////////////////////  ADMIN CMDS  /////////////////////////////////////
CMD:givebombs(playerid,params[]){
	new tid, tname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], bname[10], amount, str[MAX_PLAYER_NAME+60];
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
 		if(sscanf(params, "us[10]i",tid,bname,amount)) return SendClientMessage(playerid, Red, "[USAGE]: /givebombs (playerid) (bomb/tbomb/c4/cbomb/abomb/qbomb/mine/ebarrel/rccar/drone/sbomb/subomb) (amount)");
    	GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerName(tid, tname, sizeof(tname));
		if(IsPlayerConnected(tid)){
			if(!strcmp(bname, "bomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][Bomb] += amount;
			}
			if(!strcmp(bname, "tbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Timing Bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Timing bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][TBomb] += amount;
			}
			if(!strcmp(bname, "c4", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i C4(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i C4(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][C4] += amount;
			}
			if(!strcmp(bname, "cbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Car Bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Car bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][CBomb] += amount;
			}
			if(!strcmp(bname, "abomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Atomic Bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Atomic bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][ABomb] += amount;
			}
			if(!strcmp(bname, "qbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Quantum Bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Quantum bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][QBomb] += amount;
			}
			if(!strcmp(bname, "mine", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Mine(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Mine(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][MBomb] += amount;
			}
			if(!strcmp(bname, "ebarrel", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Explosive Barrel(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Explosive Barrel(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][EBBomb] += amount;
			}
			if(!strcmp(bname, "rccar", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Explosive RC Car(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Explosive RC Car(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][RCC] += amount;
			}
			if(!strcmp(bname, "drone", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Explosive drone(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Explosive drone(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][RCH] += amount;
			}
			if(!strcmp(bname, "sbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Sticky bomb(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Sticky bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][SBomb] += amount;
			}
			if(!strcmp(bname, "subomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s Has given you %i Suicidal Vest(s)",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Suicidal Vest(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][SuBomb] += amount;
			}
		}
		else{
		    SendClientMessage(playerid, 0xFF000088, "[ERROR]: That player isn't connected");
		}
	}
	else{
	    SendClientMessage(playerid,0xFF000088,"[ERROR]: You are not authorized to use that");
	}
	return 1;
}


CMD:setbombs(playerid, params[]){
	new tid, tname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], bname[10], amount, str[MAX_PLAYER_NAME+60];
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(sscanf(params, "us[10]i",tid,bname,amount)) return SendClientMessage(playerid, Red, "[USAGE]: /setbombs (playerid) (bomb/tbomb/c4/cbomb/abomb/qbomb/mine/ebarrel/rccar/drone/sbomb/subomb) (amount)");
    	GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerName(tid, tname, sizeof(tname));
		if(IsPlayerConnected(tid)){
			if(!strcmp(bname, "bomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your bombs to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's bombs to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][Bomb] = amount;
			}
			if(!strcmp(bname, "tbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Timing bombs to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Timing bombs to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][TBomb] = amount;
			}
			if(!strcmp(bname, "c4", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your C4s to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's C4s to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][C4] = amount;
			}
			if(!strcmp(bname, "cbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Car bombs to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Car bombs to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][CBomb] = amount;
			}
			if(!strcmp(bname, "abomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Atomic bombs to %i",tid,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have given %s %i Atomic bomb(s)",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][ABomb] = amount;
			}
			if(!strcmp(bname, "qbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Quantum bombs to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Quantum bombs to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][QBomb] = amount;
			}
			if(!strcmp(bname, "mine", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Mines to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Mines to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][MBomb] = amount;
			}
			if(!strcmp(bname, "ebarrel", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Explosive barrels to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Explosive barrels to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][EBBomb] = amount;
			}
			if(!strcmp(bname, "rccar", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Explosive RC Cars to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Explosive RC Cars to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][RCC] = amount;
			}
			if(!strcmp(bname, "drone", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Explosive Drones to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Explosive Drones to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][RCH] = amount;
			}
			if(!strcmp(bname, "sbomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Sticky bombs to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Sticky bombs to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][SBomb] = amount;
			}
			if(!strcmp(bname, "subomb", true)){
			    if(amount<0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The minimum amount of bombs is 0");
			    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s set your Suicidal Vests to %i",pname,amount);
			    SendClientMessage(tid, Blren, str);
			    format(str, sizeof(str),"[INFO]:{FFFFFF}You have set %s's Suicidal Vests to %i",tid,amount);
			    SendClientMessage(playerid, Blren, str);
			    pbData[tid][SuBomb] = amount;
			}
		}
		else{
		    SendClientMessage(playerid, 0xFF000088, "[ERROR]: That player isn't connected");
		}
	}
	else{
	    SendClientMessage(playerid,0xFF000088,"[ERROR]: You are not authorized to use that");
	}
	return 1;
}


CMD:clearbombs(playerid, params[]){
	new tid, tname[MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], str[MAX_PLAYER_NAME+35];
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(sscanf(params, "us[10]i",tid)) return SendClientMessage(playerid, Red, "[USAGE]: /clearbombs (playerid)");
    	GetPlayerName(playerid, pname, sizeof(pname));
		GetPlayerName(tid, tname, sizeof(tname));
		if(IsPlayerConnected(tid)){
		    ClearBombs(tid);
		    format(str, sizeof(str),"[INFO]:{FFFFFF}Administrator %s has cleared your bombs",pname);
		    SendClientMessage(tid, Blren, str);
		    format(str, sizeof(str),"[INFO]:{FFFFFF}Your bombs have been cleared",tid);
		    SendClientMessage(playerid, Blren, str);
		}
	}
	return 1;
}

CMD:makeevm(playerid,params[]){
	new str1[75],ID,query[200],DBResult:Result;
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
	        if(sscanf(params, "i",ID)) return SendClientMessage(playerid, Red, "[USAGE]: /makeevm (ID)");
	        if(ID >= MAX_EVM || ID <= 0) return SendClientMessage(playerid, Red, "[ERROR]: Invalid ID");
	        format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
	        Result = db_query(Database, query);
	        if(db_num_rows(Result)) return SendClientMessage(playerid, Red, "[ERROR]: That slot is used, clear it using /deleteevm or chose another vailable slot via /evmstats");
            db_free_result(Result);
            evmid = ID;
            GetPlayerPos(playerid, EVMData[ID][PosX], EVMData[ID][PosY], EVMData[ID][PosZ]);
			gEVM[ID] = CreateDynamicObject(18885, EVMData[ID][PosX]+1, EVMData[ID][PosY], EVMData[ID][PosZ], 0.0, 0.0, 0.0, -1, -1, -1, 115, 100);
			EditDynamicObject(playerid, gEVM[ID]);
		    format(str1, sizeof(str1), "[EO_EVM]: {FFFFFF}Explosives Vending Machine successfully created! ID:%i",ID);
			SendClientMessage(playerid, 0xFFFF00, str1);
			printf("Administrator %s Created a new EVM, ID: %i", GetName(playerid), ID);
			EVMData[ID][EVMBlocked] = 0;
			format(query, sizeof(query), "INSERT INTO `EVM`(`PosX`,`PosY`,`PosZ`,`RotX`,`RotY`,`RotZ`,`Block`) VALUES (%f,%f,%f,%f,%f,%f,%d)", EVMData[ID][PosX], EVMData[ID][PosY], EVMData[ID][PosZ], EVMData[ID][RotX], EVMData[ID][RotY], EVMData[ID][RotZ],EVMData[ID][EVMBlocked]);
			db_free_result(db_query(Database, query));
			return 1;
		}
		else{
		    SendClientMessage(playerid, 0xFF0000, "[ERROR]: You can't use this while in a vehicle");
		}
	}
	else{
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	}
	return 1;
}
public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    new str[85],query[500];
    if(response == EDIT_RESPONSE_FINAL)
	{
		format(str, sizeof(str), "Explosive Vending Machine\nEVM ID: %i\n{FFFFFF}Press {FFFF00}N {FFFFFF}to interfere", evmid);
		EVMData[evmid][EVM3DT] = CreateDynamic3DTextLabel(str, 0xFFFF0088, fX, fY, fZ, 80, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 95);
		EVMData[evmid][PosX] = fX;
		EVMData[evmid][PosY] = fY;
		EVMData[evmid][PosZ] = fZ;
		EVMData[evmid][RotX] = fRotX;
		EVMData[evmid][RotY] = fRotY;
		EVMData[evmid][RotZ] = fRotZ;
		
		format(query, sizeof(query), "UPDATE `EVM` SET `PosX` = %f, `PosY` = %f, `PosZ` = %f, `RotX` = %f, `RotY` = %f, `RotZ` = %f WHERE `ID` = %d", EVMData[evmid][PosX],EVMData[evmid][PosY],EVMData[evmid][PosZ],EVMData[evmid][RotX],EVMData[evmid][RotY],EVMData[evmid][RotZ],evmid);
		db_free_result(db_query(Database, query));
	}
	return 1;
}

CMD:deleteevm(playerid, params[]){
    new str1[75],ID,query[200],DBResult:Result;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
	        if(sscanf(params, "i", ID)) return SendClientMessage(playerid, Red, "[USAGE]: /deleteevm (ID)");
	        if(ID >= MAX_EVM || ID <= 0) return SendClientMessage(playerid, Red, "[ERROR]: Invalid ID");
	        format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
	        Result = db_query(Database, query);
	        if(!db_num_rows(Result)) return SendClientMessage(playerid, Red, "[ERROR]: This slot is already clear");
	        db_free_result(Result);
			DestroyDynamicObject(gEVM[ID]);
			DestroyDynamic3DTextLabel(EVMData[ID][EVM3DT]);
			printf("Administrator %s Deleted an EVM, ID: %i", GetName(playerid), ID);
			format(str1, sizeof(str1), "[EO_EVM]: {FFFFFF}Explosives Vending Machine successfully deleted! ID:%i",ID);
			SendClientMessage(playerid, 0xFFFF00, str1);
			format(query, sizeof(query), "DELETE FROM `EVM` WHERE `ID` = %d",ID);
	        Result = db_query(Database, query);
			db_free_result(Result);
			return 1;
		}
		else{
		    SendClientMessage(playerid, 0xFF0000, "[ERROR]: You can't use this while in a vehicle");
		}
	}
	else{
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	}
	return 1;
}

CMD:editevm(playerid, params[]){
    new str1[78],ID,query[200],DBResult:Result;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
	        if(sscanf(params, "i", ID)) return SendClientMessage(playerid, Red, "[USAGE]: /editevm (ID)");
	        if(ID >= MAX_EVM || ID <= 0) return SendClientMessage(playerid, Red, "[ERROR]: Invalid ID");
	        format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
	        Result = db_query(Database, query);
	        if(!db_num_rows(Result)) return SendClientMessage(playerid, Red, "[ERROR]: This slot has no EVM");
	        db_free_result(Result);
	        evmid = ID;
	     	EditDynamicObject(playerid, gEVM[ID]);
	     	DestroyDynamic3DTextLabel(EVMData[ID][EVM3DT]);
		    format(str1, sizeof(str1), "[EO_EVM]: {FFFFFF}Explosives Vending Machine with the ID %i is being edited!",ID);
			SendClientMessage(playerid, 0xFFFF00, str1);
			printf("Administrator %s is editing the EVM with the ID %i", GetName(playerid), ID);
			return 1;
		}
		else{
		    SendClientMessage(playerid, 0xFF0000, "[ERROR]: You can't use this while in a vehicle");
		}
	}
	else{
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	}
	return 1;
}
CMD:evmstats(playerid){
    new str[60],Count=0,string[22],query[40],DBResult:Result,string2[20];
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
	        SendClientMessage(playerid, 0xAF6D37DE, "||=========Explosive Vending Machines States=========||");
	        for(new i=1;i<MAX_EVM;i++){
	        	format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",i);
		        Result = db_query(Database, query);		        
        		if(db_num_rows(Result)){
			 		string = "{E30000}Not Available" ;
			 		if(EVMData[i][EVMBlocked] == 1) string2 = "{E30000}Blocked";
        			else string2 = "{00A700}Not Blocked";
				}
        		else{
				 	string = "{00A700}Available";
				 	string2 = "{E3CC00}N/A";
				 	Count++;
				}
				format(str, sizeof(str), "EVM ID: %i | %s | %s",i,string, string2);
				SendClientMessage(playerid,0xAFA700DE,str);
				db_free_result(Result);
	        }
	        SendClientMessage(playerid, 0xAF6D37DE, "||===================================================||");
	        if(Count == 0) SendClientMessage(playerid,Blren,"[EO_INFO]: {FFFFFF}No Explosives Vending Machines slots available, clear any slot you want using /deleteevm");
			else format(str, sizeof(str), "Available slots found: %i",Count) && SendClientMessage(playerid,0xAFA700DE,str);
		}
	}
	else{
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	}
	return 1;

}
CMD:blockevm(playerid, params[]){
    new str[80],ID,query[55],DBResult:Result;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
			if(sscanf(params, "i", ID)) return SendClientMessage(playerid, Red, "[USAGE]: /blockevm (ID)");
			if(ID<=0 || ID>=MAX_EVM) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Invalid ID");
			format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
		    Result = db_query(Database, query);		     
			if(!db_num_rows(Result)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: No EVM with this ID exist");
			db_free_result(Result);
			if(EVMData[ID][EVMBlocked] == 1) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: This EVM is already blocked");
			EVMData[ID][EVMBlocked] = 1;
			format(str, sizeof(str), "[EO_INFO]: {FFFFFF}You have blocked the Explosive vending machine with ID: %i",ID);
			SendClientMessage(playerid, Blren, str);
			printf("Administrator %s has blocked the EVM with ID: %i",GetName(playerid),ID);
			format(query, sizeof(query), "UPDATE `EVM` SET `Block` = %d WHERE `ID` = %d",EVMData[ID][EVMBlocked],ID);
		    Result = db_query(Database, query);		  
			db_free_result(Result);
		}
		else
	    	SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command while in a vehicle");
	}
	else
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	return 1;
}
CMD:unblockevm(playerid, params[]){
    new str[82],ID,query[55],DBResult:Result;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerAdmin(playerid)){
	    if(!IsPlayerInAnyVehicle(playerid)){
			if(sscanf(params, "i", ID)) return SendClientMessage(playerid, Red, "[USAGE]: /unblockevm (ID)");
			if(ID<=0 ||ID>=MAX_EVM) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Invalid ID");
			format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
		    Result = db_query(Database, query);		     
			if(!db_num_rows(Result)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: No EVM with this ID exist");
			db_free_result(Result);
			if(EVMData[ID][EVMBlocked] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: This EVM is already available to use");
			EVMData[ID][EVMBlocked] = 0;
			format(str, sizeof(str), "[EO_INFO]: {FFFFFF}You have unblocked the Explosive vending machine with ID: %i",ID);
			SendClientMessage(playerid, Blren, str);
			printf("Administrator %s has unblocked the EVM with ID: %i",GetName(playerid),ID);
			format(query, sizeof(query), "UPDATE `EVM` SET `Block` = %d WHERE `ID` = %d",EVMData[ID][EVMBlocked],ID);
		    Result = db_query(Database, query);		  
			db_free_result(Result);
		}
		else
	    	SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command while in a vehicle");
	}
	else
	    SendClientMessage(playerid, 0xFF0000AA, "[ERROR]: You can't use this command");
	return 1;
}
CMD:evmtp(playerid, params[]){
	new string0[43],ID,query[55],DBResult:Result;
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Red, "[ERROR]: You are not authorized to use this!");
	if(sscanf(params, "i", ID)) return SendClientMessage(playerid, Red, "[USAGE]: /evmtp (ID)");
	format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",ID);
    Result = db_query(Database, query);		     
	if(!db_num_rows(Result)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: No EVM with this ID exist");
	db_free_result(Result);
	SetPlayerPos(playerid, EVMData[ID][PosX],EVMData[ID][PosY],EVMData[ID][PosZ]);
	format(string0,sizeof(string0),"[INFO]: You have teleported to EVM ID: %i",ID);
	SendClientMessage(playerid, Blren, string0);
	return 1;
}
//////////////////////////   BOMBS    ////////////////////////////////////////

//Bomb
CMD:plantbomb(playerid, params[]){
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][Bomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	GetPlayerPos(playerid, gC[0], gC[1], gC[2]);
	pBomb[playerid] = CreateObject(1252, gC[0], gC[1], gC[2], 0.0, 0.0,0.0);
	pBombPos[playerid][0] = gC[0];
	pBombPos[playerid][1] = gC[1];
	pBombPos[playerid][2] = gC[2];
	pBombTimer[playerid] = SetTimerEx("BombTimer", 3000, false, "i", playerid);
	pb3DText[playerid] = Create3DTextLabel(GetName(playerid), 0xFF000088, pBombPos[playerid][0], pBombPos[playerid][1] , pBombPos[playerid][2], 30.0, 0, 0);
	pbData[playerid][BombUse] = false;
	pbData[playerid][Bomb]--;
	pbData[playerid][BombEx] = true;
	return 1;
}
//Timming Bomb
CMD:planttbomb(playerid, params[]){
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][TBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a timing bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	ShowPlayerDialog(playerid, DIALOG_TBomb, DIALOG_STYLE_INPUT, "Timing Bomb","Setup the seconds of the bomb to explode", "Setup", "Cancel");
	return 1;
}
//C4
CMD:plantc4(playerid, params[]){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][C4] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a C4");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	GetPlayerPos(playerid, gC[0], gC[1], gC[2]);
	pBomb[playerid] = CreateObject(1252, gC[0], gC[1], gC[2]-1, 0.0, 0.0,0.0);
	pBombPos[playerid][0] = gC[0];
	pBombPos[playerid][1] = gC[1];
	pBombPos[playerid][2] = gC[2];
	pb3DText[playerid] = Create3DTextLabel(GetName(playerid), 0xFF000088, pBombPos[playerid][0], pBombPos[playerid][1] , pBombPos[playerid][2], 30.0, 0, 0);
	pbData[playerid][BombUse] = false;
	pbData[playerid][C4]--;
	SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}You can use {FFFF00}/detonate {FFFFFF}to activate the C4");
	pbData[playerid][BombEx] = true;
	pbData[playerid][BombC4] = true;
	return 1;
}
CMD:detonate(playerid, params[]){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(pbData[playerid][BombC4] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: There is no C4 to blowup");
    SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}You have detonated the C4");
    CreateExplosion(pBombPos[playerid][0],pBombPos[playerid][1], pBombPos[playerid][2], 1, 5);
	pbData[playerid][BombUse] = false;
	SetTimerEx("BombBrakeTimer", BrakingTimer, false, "i", playerid);
	DestroyObject(pBomb[playerid]);
	Delete3DTextLabel(pb3DText[playerid]);
	pbData[playerid][BombC4] = false;
	pbData[playerid][BombEx] = false;
	return 1;
}
//Car bomb
CMD:plantvehbomb(playerid, params[]){
	new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You have to be in a vehicle to use this!");
	if(pbData[playerid][CBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a Car bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	vbData[vehicleid][CarBomb] = true;
	SendClientMessage(playerid, Blren, "[EO_INFO]: You have planted a car bomb in this vehicle");
	SendClientMessage(playerid, Blren, "[EO_INFO]: The car bomb will be activated if anyone attempts to drive it");
	pbData[playerid][BombEx] = true;
	pbData[playerid][BombUse] = false;
	return 1;
}
//Atomic bomb
CMD:setabpos(playerid, params[]){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][ABomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have an Atomic bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	GetPlayerPos(playerid, gC[0], gC[1], gC[2]);
	pABombPos[playerid][0] = gC[0];
	pABombPos[playerid][1] = gC[1];
	pABombPos[playerid][2] = gC[2]+100;
	pbData[playerid][BombUse] = false;
	pbData[playerid][ABomb]--;
	pbData[playerid][BombEx] = true;
	pbData[playerid][AtBomb] = true;
	SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}The atomic bomb impact position has been set!");
	return 1;
}
CMD:launchab(playerid,params[]){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(pbData[playerid][AtBomb] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: There is no posetion set to activate the atomic bomb");
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 413 || GetVehicleModel(GetPlayerVehicleID(playerid)) != 482) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You have to be in a Pony or a Burrito to launch the Atomic Bomb");
   	pBomb[playerid] = CreateObject(3786, pABombPos[playerid][0], pABombPos[playerid][1], pABombPos[playerid][2], 0.0,-90,0.0);
 	MoveObject(pBomb[playerid],pABombPos[playerid][0], pABombPos[playerid][1], pABombPos[playerid][2]-100,30,0.0,-90,0.0);
  	SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}The atomic bomb has been launched");
	pABICheck[playerid] = SetTimer("atomicbombimpact", 100, true);
	return 1;
}
public atomicbombimpact(playerid){
	new Float:ax,Float:ay,Float:az;
	GetObjectPos(pBomb[playerid],ax, ay, az);
	if(ax == pABombPos[playerid][0] && ay == pABombPos[playerid][1] && az == pABombPos[playerid][2]-100){
	    CreateExplosion(pABombPos[playerid][0]+10,pABombPos[playerid][1]+5, pABombPos[playerid][2]-100, 2, 500);
	    CreateExplosion(pABombPos[playerid][0]+3,pABombPos[playerid][1]+2, pABombPos[playerid][2]-100, 3, 200);
	    CreateExplosion(pABombPos[playerid][0]-10,pABombPos[playerid][1], pABombPos[playerid][2]-100, 4, 400);
	    CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1]+8, pABombPos[playerid][2]-100, 1, 300);
        CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1], pABombPos[playerid][2]-100, 2, 20);
        CreateExplosion(pABombPos[playerid][0]+12,pABombPos[playerid][1]+4, pABombPos[playerid][2]-100, 2, 20);
        CreateExplosion(pABombPos[playerid][0]+10,pABombPos[playerid][1]-6, pABombPos[playerid][2]-100, 2, 20);
        CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1], pABombPos[playerid][2]-100, 13, 20);
        CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1]+2, pABombPos[playerid][2]-100, 6, 20);
        
        CreateExplosion(pABombPos[playerid][0]-10,pABombPos[playerid][1]-5, pABombPos[playerid][2]-100, 2, 100);
	    CreateExplosion(pABombPos[playerid][0]-3,pABombPos[playerid][1]-2, pABombPos[playerid][2]-100, 3, 100);
	    CreateExplosion(pABombPos[playerid][0]+10,pABombPos[playerid][1], pABombPos[playerid][2]-100, 4, 100);
	    CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1]-8, pABombPos[playerid][2]-100, 1, 100);
        CreateExplosion(pABombPos[playerid][0]+20,pABombPos[playerid][1], pABombPos[playerid][2]-100, 2, 100);
        CreateExplosion(pABombPos[playerid][0]-12,pABombPos[playerid][1]-4, pABombPos[playerid][2]-100, 2, 100);
        CreateExplosion(pABombPos[playerid][0]-10,pABombPos[playerid][1]+6, pABombPos[playerid][2]-100, 2, 100);
        CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1]-2, pABombPos[playerid][2]-100, 7, 100);
        
        CreateExplosion(pABombPos[playerid][0]-15,pABombPos[playerid][1]-15, pABombPos[playerid][2]-100, 2, 20);
	    CreateExplosion(pABombPos[playerid][0]-13,pABombPos[playerid][1]-20, pABombPos[playerid][2]-100, 3, 20);
	    CreateExplosion(pABombPos[playerid][0]+15,pABombPos[playerid][1], pABombPos[playerid][2]-100, 4, 20);
	    CreateExplosion(pABombPos[playerid][0],pABombPos[playerid][1]-18, pABombPos[playerid][2]-100, 1, 20);
        CreateExplosion(pABombPos[playerid][0]+18,pABombPos[playerid][1], pABombPos[playerid][2]-100, 2, 20);
        CreateExplosion(pABombPos[playerid][0]-22,pABombPos[playerid][1]-24, pABombPos[playerid][2]-100, 2, 20);
        CreateExplosion(pABombPos[playerid][0]-20,pABombPos[playerid][1]+16, pABombPos[playerid][2]-100, 2, 20);
        
        CreateExplosion(pABombPos[playerid][0]+30,pABombPos[playerid][1]+30, pABombPos[playerid][2]-100, 6, 100);
        CreateExplosion(pABombPos[playerid][0]-30,pABombPos[playerid][1]+30, pABombPos[playerid][2]-100, 6, 100);
        CreateExplosion(pABombPos[playerid][0]+30,pABombPos[playerid][1]+0, pABombPos[playerid][2]-100, 6, 100);
        CreateExplosion(pABombPos[playerid][0]-30,pABombPos[playerid][1]+10, pABombPos[playerid][2]-100, 6, 100);
        CreateExplosion(pABombPos[playerid][0]-30,pABombPos[playerid][1]-30, pABombPos[playerid][2]-100, 6, 100);
        CreateExplosion(pABombPos[playerid][0]+20,pABombPos[playerid][1]-30, pABombPos[playerid][2]-100, 6, 100);
        
		DestroyObject(pBomb[playerid]);
		for(new i=0;i<=MAX_PLAYERS;i++){
		    if(!IsPlayerConnected(i)) continue;
		    if(IsPlayerInRangeOfPoint(i,100,pABombPos[playerid][0],pABombPos[playerid][1], pABombPos[playerid][2]-100)){
      			SetPlayerDrunkLevel (playerid, 5000);
		        SetPlayerArmour(i,0);
           		SetPlayerHealth(i,0);
		    }
		}
	}
	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = false;
	pbData[playerid][AtBomb] = false;
}

//Sticky Bomb
CMD:attachsbomb(playerid, params[]){
	new tid, str[53+MAX_PLAYER_NAME], pname[MAX_PLAYER_NAME], tname[MAX_PLAYER_NAME];
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][SBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a Sticky bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	if(sscanf(params, "u", tid)) return SendClientMessage(playerid, Red, "[USAGE]: /attachsbomb (playerid)");
	if(!IsPlayerConnected(tid) || tid == INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: This player is not connected");
	if(tid == playerid) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You can't stick a bomb to yourself");
    if(IsPlayerInAnyVehicle(tid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: That player is in a vehicle");
	GetPlayerName(playerid, pname, sizeof(pname));
	GetPlayerName(tid, tname, sizeof(tname));
	pbData[tid][pSBomb] = true;
	pSBCheck[playerid] = SetTimer("stickybombexp", 3000, false);
	pbData[playerid][BombUse] = false;
	pbData[playerid][SBomb]--;
	pbData[playerid][BombEx] = true;
	format(str, sizeof(str), "[EO_INFO]: {FFFFFF}%s Has thrown a sticky bomb on you",pname);
	SendClientMessage(tid, Blren, str);
	format(str, sizeof(str), "[EO_INFO]: {FFFFFF}You have sticked a sticky bomb to %s",tname);
	SendClientMessage(playerid, Blren, str);
	return 1;
}

forward stickybombexp(playerid);
public stickybombexp(playerid){
	new Float:sx, Float:sy, Float:sz;
	GetPlayerPos(playerid, sx, sy, sz);
	SetPlayerArmour(playerid,0);
	SetPlayerHealth(playerid, 0);
	CreateExplosion(sx, sy, sz, 2, 10);
	pbData[playerid][BombEx] = false;
	pbData[playerid][BombUse] = false;
}

//Suicidal vest
CMD:mountsvb(playerid, params[]){
	
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][SuBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a Suicidal bomb vest");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	SetPlayerAttachedObject(playerid, 1, 19515, 1, 0, 0.0, 0.0, 0, 0, 0, 1, 1, 1, 0xFF00FF00);
	pSVBTimer[playerid] = SetTimer("SuVBTimer", 3000, false);
	pbData[playerid][SuBomb]--;
	pbData[playerid][BombEx] = true;
	pbData[playerid][BombUse] = false;
	return 1;
}
public SuVBTimer(playerid){
    new Float:svbx, Float:svby, Float:svbz;
	GetPlayerPos(playerid, svbx, svby, svbz);
	SetPlayerArmour(playerid, 0);
	SetPlayerHealth(playerid, 0);
	CreateExplosion(svbx,svby, svbz, 2, 20);
	RemovePlayerAttachedObject(playerid, 1);
	pbData[playerid][BombEx] = false;
	pbData[playerid][BombUse] = false;
}
//Quantum bomb
CMD:setqbomb(playerid, params[]){
	new Float:pqx, Float:pqy, Float:pqz;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][QBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a Quantum bomb");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	GetPlayerPos(playerid, pqx, pqy, pqz);
	pQBCore[playerid] = CreateObject(919 ,pqx, pqy, pqz-0.5, 0.0,0.0,0.0,100);
	pQBHydraucs[playerid] = CreateObject(930, pqx+0.8, pqy, pqz-0.5, 0.0,0.0,90.0,100);
	pQBombPos[playerid][0] = pqx;
	pQBombPos[playerid][1] = pqy;
	pQBombPos[playerid][2] = pqz;
	pb3DText[playerid] = Create3DTextLabel(GetName(playerid), 0xFF000088, pQBombPos[playerid][0], pQBombPos[playerid][1] , pQBombPos[playerid][2], 30.0, 0, 0);
	pQBombATimer[playerid] = SetTimer("QuantumBombActivation", 5000, false);
	pbData[playerid][QBomb]--;
	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = true;
	SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}The Quantum bomb has been activated, the effect will start in 3 seconds");
	return 1;
}
public QuantumBombActivation(playerid){

	for(new i=0;i<=MAX_PLAYERS;i++){
	    if(IsPlayerInRangeOfPoint(i,40, pQBombPos[playerid][0], pQBombPos[playerid][1], pQBombPos[playerid][2])){
	        TogglePlayerControllable(i, false);
	        SetPlayerPos(i, pQBombPos[playerid][0], pQBombPos[playerid][1], pQBombPos[playerid][2]);
	        SetPlayerArmour(i, 0);
	        SetPlayerHealth(i, 50);
	        SendClientMessage(i, Blren, "[EO_INFO]: {FFFFFF}You have been pulled to the Quantum explosion core");
	    }
	}
	CreateExplosion(pQBombPos[playerid][0],pQBombPos[playerid][1], pQBombPos[playerid][2], 2, 50);
	DestroyObject(pQBCore[playerid]);
	DestroyObject(pQBHydraucs[playerid]);
	Delete3DTextLabel(pb3DText[playerid]);
	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = false;
	for(new i=0;i<=MAX_PLAYERS;i++){
	    if(IsPlayerInRangeOfPoint(i,40, pQBombPos[playerid][0], pQBombPos[playerid][1], pQBombPos[playerid][2])){
	        TogglePlayerControllable(i, true);
	        SetPlayerPos(i, pQBombPos[playerid][0]-70, pQBombPos[playerid][1]+60, pQBombPos[playerid][2]+350);
	        CreateExplosion(pQBombPos[playerid][0]-70,pQBombPos[playerid][1]+60, pQBombPos[playerid][2]+350, 2, 50);
	    }
	}
}

//Mines
CMD:plantmine(playerid, params[]){
    new Float:pmx, Float:pmy, Float:pmz;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
	if(pbData[playerid][MBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have a Mine");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	GetPlayerPos(playerid, pmx, pmy, pmz);
	pMPos[playerid][0] = pmx;
	pMPos[playerid][1] = pmy;
	pMPos[playerid][2] = pmz;
	pMObject[playerid] = CreateObject(2992,pMPos[playerid][0], pMPos[playerid][1], pMPos[playerid][2]-0.85, 0.0, 0.0, 0.0, 3);
	pb3DText[playerid] = Create3DTextLabel(GetName(playerid), 0xFF000088, pMPos[playerid][0], pMPos[playerid][1] , pMPos[playerid][2], 30.0, 0, 0);
	pAMCheck[playerid] = SetTimer("MineCheck", 50, true);
	pbData[playerid][MBomb]--;
	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = true;
	pbData[playerid][MBombEx] = true;
	pbData[playerid][AMBomb] = false;
	return 1;
}
CMD:activatemine(playerid,params[]){
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
    if(pbData[playerid][MBombEx] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: There is no Mine to activate");
    if(pbData[playerid][AMBomb] == true) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Your Mine bomb is already activated");
    pbData[playerid][AMBomb] = true;
    SendClientMessage(playerid, Blren, "[EO_INFO]: {FFFFFF}You have activated your Mine");
    return 1;
}
forward MineCheck(playerid);
public MineCheck(playerid){
    if(pbData[playerid][BombEx] == true && pbData[playerid][MBombEx] == true)
	{
	    if(pbData[playerid][AMBomb] == true)
		{
			for(new i=0; i<=MAX_PLAYERS; i++)
			{
			    if(IsPlayerInRangeOfPoint(i,2,pMPos[playerid][0],pMPos[playerid][1],pMPos[playerid][2]))
				{
			 		if(!IsPlayerConnected(i)) continue;
					SetPlayerArmour(i, 0);
					SetPlayerArmour(i,10);
					CreateExplosion(pMPos[playerid][0],pMPos[playerid][1], pMPos[playerid][2], 2, 30);
					DestroyObject(pMObject[playerid]);
					Delete3DTextLabel(pb3DText[playerid]);
					pbData[playerid][BombUse] = false;
					pbData[playerid][BombEx] = false;
					pbData[playerid][MBombEx] = false;
					pbData[playerid][AMBomb] = false;
				}
			}
		}
	}
}
//Barrel
CMD:placeeb(playerid, params[]){
	new Float:ebx, Float:eby, Float:ebz;
	if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You cannot use this while in a vehicle");
    if(pbData[playerid][EBBomb] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have any Explosive Barrels left");
	GetPlayerPos(playerid, ebx, eby, ebz);
	CreateObject(1225, ebx+0.5, eby, ebz, 0.0, 0.0, 0.0);
	pbData[playerid][EBBomb]--;
	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = false;
	return 1;
}
//RC CAR
new pRCCTimer[MAX_PLAYERS];
new pRCHTimer[MAX_PLAYERS];
CMD:activaterccar(playerid, params[]){
	new Float:rccx, Float:rccy, Float:rccz,Float:opx,Float:opy,Float:opz;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(pbData[playerid][RCC] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have an Explosive RC Car");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 413) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You have to be in a pony");
	GetPlayerPos(playerid, rccx, rccy, rccz);
	GetPlayerPos(playerid, opx, opy, opz);
	pRCPos[playerid][0] = opx;
	pRCPos[playerid][1] = opy;
	pRCPos[playerid][2] = opz;
	pRCC[playerid] = CreateVehicle(441, rccx+2, rccy-1, rccz-0.5, 0.0, 1,2,10000,0);
 	PutPlayerInVehicle(playerid, pRCC[playerid],0);
 	pRCCTimer[playerid] = SetTimer("RCCEXP",5000,false);
 	pbData[playerid][RCC]--;
 	pbData[playerid][BombUse] = false;
	pbData[playerid][BombEx] = true;
	return 1; 
}
forward RCCEXP(playerid);
public RCCEXP(playerid){
    new Float:rccx, Float:rccy, Float:rccz;
    GetVehiclePos(pRCC[playerid], rccx, rccy, rccz);
    RemovePlayerFromVehicle(playerid);
    SetPlayerPos(playerid, pRCPos[playerid][0],pRCPos[playerid][1],pRCPos[playerid][2]);
    CreateExplosion(rccx,rccy, rccz, 2, 20);
    pbData[playerid][BombEx] = false;
    pbData[playerid][BombUse] = false;
}
//RC Heli
CMD:activatedrone(playerid, params[]){
	new Float:rccx, Float:rccy, Float:rccz,Float:opx,Float:opy,Float:opz;
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You are not connected to the server");
	if(pbData[playerid][RCH] == 0) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You don't have an Explosive Drone");
	if(pbData[playerid][BombUse] == false) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: Wait before using another bomb");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 413) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: You have to be in a pony");
	GetPlayerPos(playerid, rccx, rccy, rccz);
	GetPlayerPos(playerid, opx, opy, opz);
	pRCPos[playerid][0] = opx;
	pRCPos[playerid][1] = opy;
	pRCPos[playerid][2] = opz;
	pRCH[playerid] = CreateVehicle(465, rccx+2, rccy-1, rccz-0.5, 0.0, 1,2,10000,0);
 	PutPlayerInVehicle(playerid, pRCH[playerid],0);
 	pRCHTimer[playerid] = SetTimer("RCCEXP",5000,false);
 	pbData[playerid][RCH]--;
 	pbData[playerid][BombEx] = true;
    pbData[playerid][BombUse] = false;
	return 1; 
}

forward RCHEXP(playerid);
public RCHEXP(playerid){
    new Float:drx, Float:dry, Float:drz;
    GetVehiclePos(pRCH[playerid], drx, dry, drz);
    RemovePlayerFromVehicle(playerid);
    SetPlayerPos(playerid, pRCPos[playerid][0],pRCPos[playerid][1],pRCPos[playerid][2]);
    CreateExplosion(drx,dry,drz, 2, 20);
    pbData[playerid][BombEx] = false;
    pbData[playerid][BombUse] = false;

}
////////////////////////////////  TIMERS   //////////////////////////////////////

//Time to explode
public BombTimer(playerid){
	KillTimer(pBombTimer[playerid]);
	CreateExplosion(pBombPos[playerid][0],pBombPos[playerid][1], pBombPos[playerid][2], 1, 5);
	pbData[playerid][BombUse] = false;
	SetTimerEx("BombBrakeTimer", BrakingTimer, false, "i", playerid);
	DestroyObject(pBomb[playerid]);
	Delete3DTextLabel(pb3DText[playerid]);
	pbData[playerid][BombEx] = false;
}
//Timed bomb exploding timer
public TimingBombTimer(playerid){
	if(pbData[playerid][BombEx] == true){
	    KillTimer(pBombTimer[playerid]);
	    CreateExplosion(pBombPos[playerid][0],pBombPos[playerid][1], pBombPos[playerid][2], 1, 5);
	    pbData[playerid][BombEx] = false;
	    DestroyObject(pBomb[playerid]);
	    Delete3DTextLabel(pb3DText[playerid]);
	}
}
//Car bomb clearing
public VehicleCarBombClear(vehicleid){
	new str[75],Count=0;
	for(new i=0; i<=MAX_VEHICLES;i++){
	    if(vbData[i][CarBomb] == true) return Count++;
	    vbData[i][CarBomb] = false;
	}
	format(str,sizeof(str), "[EO_INFO]: {FFFFFF}All vehicle bombs were cleared, {FFFF00}(total: %i)",Count);
	SendClientMessageToAll(Blren, str);
	return 1;
}
/////////////////////////// Brake Timer    ///////////////////////////////////
forward BombBrakeTimer(playerid);
public BombBrakeTimer(playerid){
    pbData[playerid][BombUse] = true;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new Float:x, Float:y, Float:z;
	if(vbData[vehicleid][CarBomb] == true){
	    GetVehiclePos(vehicleid, x, y, z);
	    SetVehicleHealth(vehicleid, 0);
     	CreateExplosion(x,y, z, 2, 10);
     	pbData[playerid][BombEx] = false;
     	vbData[vehicleid][BombUse] = false;
     	vbData[vehicleid][CarBomb] = false;
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new query[55],DBResult:Result;
	if(newkeys ==  KEY_NO){
	    for(new i=0;i<MAX_EVM;i++){
	    	format(query, sizeof(query), "SELECT * FROM `EVM` WHERE ID = %d",i);
		    Result = db_query(Database, query);	
	        if(IsPlayerInRangeOfPoint(playerid, 2, EVMData[i][PosX],EVMData[i][PosY],EVMData[i][PosZ]) && db_num_rows(Result)){
	            if(EVMData[i][EVMBlocked] == 0){
		            ShowPlayerDialog(playerid, DIALOG_EVMINDEX, DIALOG_STYLE_LIST, "EO_Explosive Shop",
					"Bomb\n\
					Timing bomb\n\
					C4\n\
					Car bomb\n\
					Atomic bomb\n\
				    Sticky bombs\n\
				    Suicidal bomb vest\n\
				    Quantum bomb\n\
				    Mines\n\
				    Explosive barrels\n\
					Explosive RC Car\n\
					Explosive Drone"
					,"Select", "Cancel");
					return 1;
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: This EVM is currently blocked by an administrator and can't be used");
	        }
	        db_free_result(Result);
	    }
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_EVMINDEX){
	    if(!response) return 0;
	    switch(listitem){
	        case 0:{
	            if(GetPlayerMoney(playerid) >= BombP){
	                new string[120];
 					pbData[playerid][Bomb]++;
 					GivePlayerMoney(playerid, -TBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Bomb for $%i, the use instructions via /ehelp",BombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 1:{
	            if(GetPlayerMoney(playerid) >= TBombP){
	                new string[120];
 					pbData[playerid][TBomb]++;
 					GivePlayerMoney(playerid, -TBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Timing Bomb for $%i, the use instructions via /ehelp",TBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			} 
	        case 2:{
	            if(GetPlayerMoney(playerid) >= C4P){
	                new string[120];
 					pbData[playerid][C4]++;
 					GivePlayerMoney(playerid, -C4P);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a C4 for $%i, the use instructions via /ehelp",C4P);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			} 
	        case 3:{
	            if(GetPlayerMoney(playerid) >= CBombP){
	                new string[120];
 					pbData[playerid][CBomb]++;
 					GivePlayerMoney(playerid, -CBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Car Bomb for $%i, the use instructions via /ehelp",CBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			} 
	        case 4:{
	            if(GetPlayerMoney(playerid) >= ABombP){
	                new string[120];
 					pbData[playerid][ABomb]++;
 					GivePlayerMoney(playerid, -ABombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought an Atomic Bomb for $%i, the use instructions via /ehelp",ABombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			} 
	        case 5:{
	            if(GetPlayerMoney(playerid) >= SBombP){
	                new string[120];
 					pbData[playerid][SBomb]++;
 					GivePlayerMoney(playerid, -SBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Sticky Bomb for $%i, the use instructions via /ehelp",SBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 6:{
	            if(GetPlayerMoney(playerid) >= SuBombP){
	                new string[120];
 					pbData[playerid][SuBomb]++;
 					GivePlayerMoney(playerid, -SuBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Suicidal Bomb vest for $%i, the use instructions via /ehelp",SuBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 7:{
	            if(GetPlayerMoney(playerid) >= QBombP){
	                new string[120];
 					pbData[playerid][QBomb]++;
 					GivePlayerMoney(playerid, -QBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Quantum bomb for $%i, the use instructions via /ehelp",QBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 8:{
	            if(GetPlayerMoney(playerid) >= MBombP){
	                new string[120];
 					pbData[playerid][MBomb]++;
 					GivePlayerMoney(playerid, -MBombP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought a Mine for $%i, the use instructions via /ehelp",MBombP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 9:{
	            if(GetPlayerMoney(playerid) >= EBarrelP){
	                new string[120];
 					pbData[playerid][EBBomb]++;
 					GivePlayerMoney(playerid, -EBarrelP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought an explosive barrel for $%i, the use instructions via /ehelp",EBarrelP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	        case 10:{
	            if(GetPlayerMoney(playerid) >= ERCCP){
	                new string[120];
 					pbData[playerid][RCC]++;
 					GivePlayerMoney(playerid, -ERCCP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought an Explosive RC Car for $%i, the use instructions via /ehelp",ERCCP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
			case 11:{
	            if(GetPlayerMoney(playerid) >= ERCHP){
	                new string[120];
 					pbData[playerid][RCH]++;
 					GivePlayerMoney(playerid, -ERCHP);
 					format(string, sizeof(string), "[EO_INFO]: {FFFFFF}You bought an Explosive Drone for $%i, the use instructions via /ehelp",ERCHP);
 					SendClientMessage(playerid, 0xFFFF0088, string);
				}
				else
				    SendClientMessage(playerid, 0xFF000088, "[ERROR]: {FFFFFF}You can't afford this");
			}
	    }
	}
	if(dialogid == DIALOG_TBomb){
	    if(strval(inputtext)>60 || strval(inputtext)<3) return SendClientMessage(playerid, 0xFF000088, "[ERROR]: The seconds value must be closed between 3 and 60");
	    pBombTimer[playerid] = SetTimerEx("TimingBombTimer",strval(inputtext)*1000, false, "i", playerid);
	    GetPlayerPos(playerid, gC[0], gC[1], gC[2]);
		pBombPos[playerid][0] = gC[0];
		pBombPos[playerid][1] = gC[1];
		pBombPos[playerid][2] = gC[2];
		pBomb[playerid] = CreateObject(1252, gC[0], gC[1], gC[2], 0.0, 0.0,0.0);
		pb3DText[playerid] = Create3DTextLabel(GetName(playerid), 0xFF000088, gC[0], gC[1] , gC[2], 30.0, 0, 0);
		pbData[playerid][TBomb]--;
		pbData[playerid][BombUse] = false;
		pbData[playerid][BombEx] = true;
	}
	return 0;
}

//Trials commands
CMD:veh(playerid, params[]){
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	CreateVehicle(411,x+1,y,z,0.0,1,1,100,0);
	return 1;
}
CMD:pony(playerid, params[]){
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x, y, z);
	CreateVehicle(413,x+1,y,z,0.0,1,1,100,0);
	return 1;
}
CMD:kill(playerid, params[]){
	SetPlayerHealth(playerid, 0);
	return 1;
}
CMD:pass(playerid, params[]){
	pbData[playerid][BombUse] = true;
	return 1;
}
CMD:money(playerid, params[]){
	GivePlayerMoney(playerid, 100000);
	return 1;
}
