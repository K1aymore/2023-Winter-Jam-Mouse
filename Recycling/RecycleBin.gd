extends Node2D

var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()


func plusCounter():
	counter += 1
	updateLabel()


func updateLabel():
	$Panel.color.h = 0.4 - counter * 0.03  # for 15 max
	$Panel/Label.text = str(counter)
	


func empty():
	counter = 0;
	updateLabel()

