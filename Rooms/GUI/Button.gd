tool
extends Control

var selected = false

signal pressed()

func _ready():
	init()

func init():
	get_node("ColorRect").rect_size = rect_size
	get_node("Label").rect_size = get_node("ColorRect").rect_size
	get_node("Label").set_text(get_name())

func _on_ColorRect_gui_input(ev):
	if (ev is InputEventMouseButton or ev is InputEventScreenTouch) and ev.is_pressed():
		emit_signal("pressed")

func _on_ColorRect_mouse_entered():
	select()

func _on_ColorRect_mouse_exited():
	unselect()

func select():
	selected = true
	get_node("ColorRect").modulate = Color("#2daabf")

func unselect():
	selected = false
	get_node("ColorRect").modulate = Color("#01282e")
