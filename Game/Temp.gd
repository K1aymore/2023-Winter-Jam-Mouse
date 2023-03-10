extends Area2D

var counter = 0
var hints = true

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()


func plusCounter(num):
	counter += num
	updateLabel()


func updateLabel():
	var color = $Label.get("custom_colors/font_color")
	color.h = 0.38 - counter * 0.007
	$Label.set("custom_colors/font_color", color)
	$ProgressBar.get("custom_styles/fg").bg_color = color
	
	$ProgressBar.value = counter + 40
	$ProgressBar/Label.text = str(counter + 40)
	
	if counter > 40 && get_parent().hints:
		$Warning.visible = true
	else:
		$Warning.visible = false
	


func extinguish():
	counter = 0

func _input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed):
		emit_signal("clicked")

