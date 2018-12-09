extends Node

var current_scene = null
var Menu = preload("res://MainMenu.tscn")
var Main = preload("res://Scenes/World.tscn")  

var basic_tile_size = 32
var ts = 32
var map_size = OS.window_size/ts
var offset = Vector2(16, 16)

func _ready():
	randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)

func _deferred_goto_scene(scene):
	current_scene.free()
	current_scene = scene.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)