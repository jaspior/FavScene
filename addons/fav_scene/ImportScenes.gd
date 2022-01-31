tool
extends Control

var FavScenes = []

func _ready():
	$FileDialog.add_filter("*.tscn ; Scenes")
