extends Node


var notifications = []
var notifLoad : PackedScene = preload("res://Notification.tscn")

var notifImages = [
	preload("res://Notifications/Dell Pilotes.png"),
	preload("res://Notifications/Test message.png"),
	preload("res://Notifications/Update Available.png"),
]

var lastNotif : int = 0;


var totalScore : int = 0

var hints = true

signal lose

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()


func reset():
	totalScore = 0
	$RecycleBin.counter = 0
	$RecycleBin/Warning.visible = false
	$RecycleBin.updateLabel()
	
	while notifications.size() > 0:
		notifications.pop_back().queue_free()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		_on_Timer_timeout()
	

func updateNotifs():
	for i in range(0, min(5, notifications.size())):
		notifications[i].position = Vector2(1600, 950 - i*210)
		
	for i in range(5, min(10, notifications.size())):
		notifications[i].position = Vector2(975, 950 - (i-5)*210)
		
	for i in range(10, min(15, notifications.size())):
		notifications[i].position = Vector2(300, 950 - (i-10)*210)
	
	if notifications.size() > 14:
		lose()



func _on_Timer_timeout():
	$Timer.wait_time /= 1.01
	
	var newNotif = notifLoad.instance()
	
	var notifNum = 0
	notifNum = randi() % notifImages.size()
	while notifNum == lastNotif:
		notifNum = randi() % notifImages.size()
	
	lastNotif = notifNum
	newNotif.get_node("Sprite").texture = notifImages[notifNum]
	
	add_child(newNotif)
	notifications.push_front(newNotif)
	
	updateNotifs()



func _on_Mouse_swiped(notif):
	var i = notifications.find(notif)
	notifications.remove(i)
	notif.queue_free()
	updateNotifs()
	
	$RecycleBin.plusCounter()
	totalScore += 1
	
	
	if $RecycleBin.counter > 14:
		lose()
	
	if $RecycleBin.counter > 9 && hints:
		$RecycleBin/Warning.visible = true
	else:
		$RecycleBin/Warning.visible = false



func lose():
	emit_signal("lose", totalScore)




