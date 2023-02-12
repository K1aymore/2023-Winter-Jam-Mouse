extends Node


var notifications = []
var notifLoad : PackedScene = preload("res://Game/Notification.tscn")

var notifImages = []
var notifImagesDiscord = []

var lastNotif : int = 0;


var totalScore : int = 0

var hints = true

signal lose

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = "res://Notifications"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	var count : int = 0
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") && !file_name.ends_with(".import"):
			notifImages.append(load(path + "/" + file_name))
			notifImagesDiscord.append(file_name.begins_with("Discord"))
	dir.list_dir_end()
	
	
	reset()


func reset():
	totalScore = 0
	$Timer.wait_time = 0.6
	$RecycleBin.counter = 0
	$RecycleBin.updateLabel()
	$Discord.counter = 0
	$Discord.updateLabel()
	
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
	$Timer.wait_time /= 1.003  # 0.3% faster each time
	
	var newNotif = notifLoad.instance()
	
	var notifNum = 0
	notifNum = randi() % notifImages.size()
	while notifNum == lastNotif:
		notifNum = randi() % notifImages.size()
	
	lastNotif = notifNum
	newNotif.get_node("Sprite").texture = notifImages[notifNum]
	
	if notifImagesDiscord[notifNum] == true:
		newNotif.add_to_group("Discord")
	
	add_child(newNotif)
	notifications.push_front(newNotif)
	
	updateNotifs()



func _on_Mouse_swiped(notif):
	var i = notifications.find(notif)
	
	if notif.is_in_group("Discord"):
		$Discord.plusCounter()
	else:
		$RecycleBin.plusCounter()
	totalScore += 1
	
	notifications.remove(i)
	notif.queue_free()
	updateNotifs()
	
	
	if $RecycleBin.counter > 14:
		lose()
	if $Discord.counter > 14:
		lose()



func lose():
	emit_signal("lose", totalScore)




