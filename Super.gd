extends Control


enum {
	MENU,
	LOADING,
	GAME,
	PAUSED
}

var state = MENU

# Called when the node enters the scene tree for the first time.
func _ready():
	openMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		openMenu()
		state = PAUSED
	
	if state == MENU:
		if $Backdrop.color.a8 < 255:
			$Backdrop.color.a8 += delta * 175
		if $Backdrop.color.a8 >= 255:
			$Backdrop.color.a8 = 255
			if state == MENU:
				$Game.reset()
	elif state == PAUSED:
		if $Backdrop.color.a8 < 255:
			$Backdrop.color.a8 += delta * 255
		if $Backdrop.color.a8 >= 255:
			$Backdrop.color.a8 = 255
	elif state == LOADING:
		if $Backdrop.color.a8 > 0:
			$Backdrop.color.a8 -= delta * 255
		if $Backdrop.color.a8 <= 0:
			$Backdrop.color.a8 = 0
			state = GAME
			get_tree().paused = false


func openMenu():
	get_tree().paused = true
	$Menu.visible = true


func _on_Game_lose(score : int):
	get_tree().paused = true
	$Explosion.frame = 0
	$Explosion.play("default")
	$Explosion/Sound.play()
	$Menu/LoseScore.text = "You cleared " + str(score) + " notifications"
	openMenu()
	state = MENU


func _on_PlayButton_pressed():
	state = LOADING
	$Menu.visible = false


func _on_Hints_toggled(enabled : bool):
	$Game.hints = enabled


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed




