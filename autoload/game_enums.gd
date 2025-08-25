extends Node


enum SCENES {
	Outdated_Index,
	Scene_Intro,
	Scene_Main,
	Scene_WeightLifting,
	Scene_HammerTime,
	Scene_Memory,
	Scene_Outro,
	Scene_Music,
}

enum STEPS {
	Step_JustStarted,
	Step_ObtainedBook,
	Step_ObtainedSeed,
	Step_DroppedSeed,
	Step_ObtainedWeapon,
	Step_DroppedWeapon,
	Step_ObtainedEmerald,
	Step_DroppedEmerald,
	Step_DroppedBook,
	Step_GameStarted,
	Step_BookChecked,
	Step_GameEnded,
	Step_CompletedSeedDrop,
	Step_CompletedWeaponDrop,
	Step_CompletedEmeraldDrop,
}

enum OBJECTS {
	Object_Book,
	Object_Seed,
	Object_Weapon,
	Object_Emerald,
}
