class_name OverworldManager
extends Node

# variables which need to be stored when overworld scene is unloaded
var Camera_CurrentY = null;

func _ready():
	print("OverworldManager loaded");

func loadStuff(CurrentWorld):
	# overworld scene is asking for data
	if(Camera_CurrentY != null):
		CurrentWorld.Camera_CurrentY = Camera_CurrentY;

func saveStuff(CurrentWorld):
	# overworld scene is being unloaded & giving data
	Camera_CurrentY = CurrentWorld.Camera_CurrentY;
