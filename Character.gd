extends KinematicBody2D
class_name Character

var direction:Vector2 = Vector2.ZERO
var speed:int = 500

onready var gun_texture:Texture = load("res://Sprites/Characters/Ch-hold-gun.png")
onready var gun2_texture:Texture = load("res://Sprites/Characters/Ch-hold-gun2.png")
onready var plant_texture:Texture = load("res://Sprites/Characters/Ch-idle.png")

onready var timer:Timer = $Timer
onready var shoot_timer:Timer = $ShootTimer
var bazooka_timer:Timer

var foot_d:bool = true
var bazooka:AudioStreamOGGVorbis
var gun:AudioStreamOGGVorbis

var ulti_max = 100
var ulti = 0
var health_max = 100
var health = 100

signal health_change(value)
signal ulti_change(value)

var is_bazooka:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bazooka_timer = Timer.new()
	add_child(bazooka_timer)
	bazooka_timer.one_shot = true
	bazooka_timer.wait_time = 60
	bazooka_timer.start()
	bazooka_timer.connect("timeout", self, "_is_Bazooka")
	bazooka = load("res://Sounds/bazooka.ogg")
	bazooka.loop = false
	gun = load("res://Sounds/gun2.ogg")
	gun.loop = false
	timer.connect("timeout", self, "_add_foot")
	shoot_timer.connect("timeout", self, "_shoot")
	
	


func _process(delta) -> void:
	look_at(get_global_mouse_position())
	self.move(delta)
	
	if health <= 0:
		get_node("/root/Game").emit_signal("game_over")
	
	ulti += delta
	health += delta
	if ulti >= ulti_max:
		ulti = ulti_max
		
	else:
		emit_signal("ulti_change", ulti)
		
	if health >= health_max:
		health = health_max
	
	else:
		emit_signal("health_change", health)


func move(delta:float) -> void:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		direction.y = -1
		
	if Input.is_action_pressed("Down"):
		direction.y = 1
		
	if Input.is_action_pressed("Left"):
		direction.x = -1
		
	if Input.is_action_pressed("Right"):
		direction.x = 1

	if Input.is_action_just_pressed("Fire"):
		self._shoot()
		if $Gun2Sprite.visible:
			shoot_timer.start(.78)
		else:
			shoot_timer.start(0.2)
		$AnimatedSprite.show()
		$AnimatedSprite.playing = true
		$GunSprite/Particles2D.emitting = true
		print("1")
	
	elif Input.is_action_just_released("Fire"):
#		self._shoot()
		shoot_timer.stop()
		$AnimatedSprite.hide()
		$AnimatedSprite.playing = false
		$GunSprite/Particles2D.emitting = false
		print("2")
		
	if Input.is_action_just_pressed("Change") and is_bazooka:
		$Gun2Sprite.visible = !$Gun2Sprite.visible
		$GunSprite.visible = !$GunSprite.visible
		
		if $Gun2Sprite.visible:
			$AudioStreamPlayer2D.stream = bazooka
			
		else:
			$AudioStreamPlayer2D.stream = gun
		
#
#	if Input.is_action_pressed("Ulti"):
#		direction = Vector2.UP

	if direction != Vector2.ZERO:
		if timer.is_stopped():
			timer.start(.15)
			$FootAudio.playing = true
			print("foot")
	
	else:
		$FootAudio.playing = false
		timer.stop()
	
	var mov = direction.normalized() * speed
	self.move_and_slide(mov)
		


func _add_foot() -> void:
	var footp := load("res://Sprites/ayakizi-up.png")
	var foot := preload("res://Foot.tscn").instance()
	foot.position = position
	foot.rotate(direction.angle())
	if foot_d:
		foot.get_node("Sprite").texture = footp
		foot.get_node("Sprite").flip_h = true
#		foot.position.x += 10
	else:
		foot.get_node("Sprite").texture = footp
#		foot.position.x -= 10
	foot_d = !foot_d
	get_node("/root/Game/Navigation2D/TileMap").add_child(foot)

func _shoot() -> void:
	if $Gun2Sprite.visible:
		var bazooka = preload("res://Bazooka.tscn").instance()
		bazooka.global_position = $BulletSpawn.global_position
		bazooka.normalized = global_position.direction_to(get_global_mouse_position() as Vector2)
		get_node("/root/Game").call_deferred("add_child", bazooka)
		
	else:
		var bullet = preload("res://GunBullet.tscn").instance()
		bullet.global_position = $BulletSpawn.global_position
		bullet.normalized = global_position.direction_to(get_global_mouse_position() as Vector2)
		get_node("/root/Game").call_deferred("add_child", bullet)
	$AudioStreamPlayer2D.play()

func _is_Bazooka() -> void:
	is_bazooka = true
	var label := get_parent().get_node("HUD/Right/Label")
	label.show()
	var tw := Tween.new()
	add_child(tw)
	tw.interpolate_property(label, "modulate", Color(1,1,1,1), Color(1,1,1,0), 6, Tween.TRANS_QUINT, Tween.EASE_IN)
	tw.start()
	yield(tw, "tween_all_completed")
	label.hide()
	tw.queue_free()
	#mesaj
