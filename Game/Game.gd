extends Control


var notifications = []
var notifLoad : PackedScene = load("res://Game/Notification.tscn")

var notifImages = []
var notifImagesDiscord = []

var lastNotif : int = 0;

var randomer : RandomNumberGenerator = RandomNumberGenerator.new()
var timerBaseTime

var totalScore : int = 0

var grabbedNotif = null
var grabbedStartX : int
var grabbedOffset : Vector2

var wait = 0

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
	
	randomer.randomize()
	reset()


func reset():
	totalScore = 0
	timerBaseTime = 0.5
	$Timer.wait_time = timerBaseTime
	$RecycleBin.counter = 0
	$RecycleBin.updateLabel()
	$Discord.counter = 0
	$Discord.updateLabel()
	$Temp.counter = 0
	$Temp.updateLabel()
	
	while notifications.size() > 0:
		notifications.pop_back().queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		_on_Timer_timeout()
	
	$Temp.plusCounter(delta * (1 + (totalScore/140.0)))
	if $Temp.counter > 60:
		lose()
	#$Extinguisher/ColorRect.visible = $Mouse.holdingExtinguisher
	
	if !Input.is_action_pressed("left_click"):
		grabbedNotif = null
	
	
	updateNotifs(delta)
	
	if $MouseExtinguisher.visible:
		$MouseExtinguisher.position = get_global_mouse_position()
		$Extinguisher/ColorRect.visible = true
	else:
		$Extinguisher/ColorRect.visible = false
	
	if grabbedNotif != null:
		grabbedNotif.position = get_global_mouse_position() + grabbedOffset
		if grabbedNotif.position.x > grabbedStartX + 100:
			notifSwiped()


func updateNotifs(delta):
	for i in range(0, min(5, notifications.size())):
		var notif : Area2D = notifications[i]
		var newPosition = Vector2(1600, 900 - i*205)
		notif.position = notif.position.move_toward(newPosition, delta * 3000)
		
	for i in range(5, min(10, notifications.size())):
		notifications[i].position = Vector2(975, 900 - (i-5)*205)
		
	for i in range(10, min(15, notifications.size())):
		notifications[i].position = Vector2(300, 900 - (i-10)*205)
	
	if notifications.size() > 14:
		lose()



func _on_Timer_timeout():
	if timerBaseTime > 0.11:
		timerBaseTime /= 1.0013  # 0.x% faster each time
	else:
		timerBaseTime = 0.11
	
	$Timer.wait_time = timerBaseTime + randomer.randfn(0, 0.1)
	
	addNotif()


func addNotif():
	var newNotif = notifLoad.instance()
	
	var notifNum = 0
	notifNum = randi() % notifImages.size()
	while notifNum == lastNotif:
		notifNum = randi() % notifImages.size()
	
	lastNotif = notifNum
	newNotif.get_node("Sprite").texture = notifImages[notifNum]
	
	if notifImagesDiscord[notifNum] == true:
		newNotif.add_to_group("Discord")
	
	
	newNotif.position = Vector2(1600, 1080)
	newNotif.connect("clicked", self, "notifClicked")
	
	add_child(newNotif)
	notifications.push_front(newNotif)


func notifClicked(notif):
	grabbedNotif = notif
	grabbedStartX = grabbedNotif.position.x
	grabbedOffset = grabbedNotif.position - get_global_mouse_position()
	$MouseExtinguisher.visible = false


func notifSwiped():
	var i = notifications.find(grabbedNotif)
	
	if grabbedNotif.is_in_group("Discord"):
		$Discord.plusCounter()
	else:
		$RecycleBin.plusCounter()
	totalScore += 1
	
	notifications.remove(i)
	grabbedNotif.queue_free()
	grabbedNotif = null
	
	if $RecycleBin.counter > 14:
		lose()
	if $Discord.counter > 14:
		lose()



func lose():
	emit_signal("lose", totalScore)





func _on_Extinguisher_clicked():
	$MouseExtinguisher.visible = true


func _on_Temp_clicked():
	if $MouseExtinguisher.visible:
		$Temp.extinguish()
		$MouseExtinguisher.visible = false
