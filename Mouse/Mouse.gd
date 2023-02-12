extends Area2D

enum {
	INGAME,
	HOVERING,
	SWIPING,
	RECYCLE
}
var state = INGAME
var inNotif = false

var hoveredNotification : Node2D = null
var swipeStartX : int
var swipeOffset : Vector2

signal swiped

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "_on_body_entered")
	connect("area_exited", self, "_on_body_exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()
	
	if state == HOVERING && Input.is_action_just_pressed("left_click"):
		state = SWIPING
		swipeStartX = hoveredNotification.position.x
		swipeOffset = hoveredNotification.position - get_global_mouse_position()
	
	if state == SWIPING && hoveredNotification != null:
		if Input.is_action_pressed("left_click"):
			hoveredNotification.position = get_global_mouse_position() + swipeOffset
			if hoveredNotification.position.x > swipeStartX + 150:
				emit_signal("swiped", hoveredNotification)
				hoveredNotification = null
				state = INGAME
		else:
			state = HOVERING
			get_parent().updateNotifs()
	
	if state == INGAME && !Input.is_action_pressed("left_click"):
		hoveredNotification = null
	
	
	if state == RECYCLE && Input.is_action_just_pressed("left_click"):
		get_tree().get_nodes_in_group("recycle")[0].empty()



func _on_body_entered(body : Area2D):
	if state == SWIPING:
		return
	
	if body.is_in_group("notifications"):
		inNotif = true
		state = HOVERING
		hoveredNotification = body;
	if body.is_in_group("recycle"):
		state = RECYCLE


func _on_body_exited(body : Area2D):
	inNotif = false
	if state != SWIPING:
		state = INGAME


