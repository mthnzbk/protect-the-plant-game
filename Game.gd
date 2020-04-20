extends Node2D



onready var character:KinematicBody2D = $Character
onready var camera:Camera2D = $Character/Camera2D
onready var gece_gunduz:CanvasModulate = $GeceGunduz
onready var tw:Tween = $Tween
onready var ptimer:Timer = $PlaneTimer
onready var spawn_timer:Timer = $SpawnTimer
onready var navigation:Navigation2D = $Navigation2D
onready var plant_progress:TextureProgress = $HUD/Middle/VBoxContainer/PlantProgress

var gunduz:bool = true
var enemy1
var enemy2

signal game_over

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	connect("game_over", self, "_on_Game_Over")
	
	spawn_timer.connect("timeout", self, "_on_Spawn_Enemy")
	spawn_timer.start(2)
	
	ptimer.connect("timeout", self, "_on_AirPlane_Go")
	ptimer.start(45)
	
	tw.interpolate_property(gece_gunduz, "color", Color(1, 1, 1), Color(0, 0, 0.5), 60, Tween.TRANS_QUINT, Tween.EASE_IN)
	tw.start()
	enemy1 = load("res://Enemy.tscn")
	enemy2 = load("res://EnemyII.tscn")
	
	plant_progress.max_value = $Plant.health
	plant_progress.value = $Plant.health
	$Plant.connect("plant_health", self, "_on_Plant_Progress")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
#	self.mouseMoveToCamera2D()

	pass



func _on_Tween_tween_completed(object, key):
	gunduz = !gunduz
	if gunduz:
		for light in $Lights.get_children():
			light.enabled = false
		tw.interpolate_property(gece_gunduz, "color", Color(1, 1, 1), Color(0, 0, 0.5), 60, Tween.TRANS_QUINT, Tween.EASE_IN)
	else:
		for light in $Lights.get_children():
			light.enabled = true
		tw.interpolate_property(gece_gunduz, "color", Color(0, 0, 0.5), Color(1, 1, 1), 60, Tween.TRANS_QUINT, Tween.EASE_IN)
	
	tw.start()

func _on_AirPlane_Go() -> void:
	var d := ["Left", "Right", "Up", "Down"]
	var plane := preload("res://AirPlane.tscn").instance()
	plane.direction = d[randi()%len(d)]
	plane.position = $Character.position
	call_deferred("add_child", plane)


func _on_Game_Over() -> void:
	get_tree().change_scene("res://GameOver.tscn")

func _on_Spawn_Enemy() -> void:
	var index = randi()%$SpawnPoints.get_child_count()
	var enemies := [enemy1.instance(), enemy2.instance()]
	var enemy = enemies[randi()%len(enemies)]
	enemy.position = $SpawnPoints.get_child(index).position
	enemy.path = navigation.get_simple_path(enemy.global_position, $Plant.global_position)
	
	get_node("/root/Game/Enemies").call_deferred("add_child", enemy)
	
func _on_Plant_Progress(value:float):
	plant_progress.value = value as int
