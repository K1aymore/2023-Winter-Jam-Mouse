extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		emit_signal("clicked")
