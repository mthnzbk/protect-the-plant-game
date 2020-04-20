extends KinematicBody2D
class_name EnemyII

export(int) var health = 100

onready var health_bar:TextureProgress = $HealthProgress

var path:PoolVector2Array
var speed:int = 100
var corpse

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.stream.loop = false
	health_bar.max_value = health
	health_bar.value = health
	corpse = load("res://Sprites/Enemy/enemy-death-2.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar.value = health
	if !health <= 0:
		move(speed * delta)


func move(distance:float) -> void:
	var start_point := position
	for i in range(path.size()):
		var distance_to_next := start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			$Sprite.rotation = start_point.angle_to_point(path[0])
			break
#		elif distance < 0.0:
#			position = path[0]
#			set_process(false)
#			break
			
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func is_enemy() -> bool:
	return true


func _on_HealthProgress_value_changed(value):
	value = value as int
	if value <= 0:
		$CollisionShape2D.disabled = true
		$Sprite.texture = corpse
		$Sprite.scale = Vector2(.5, .5)
		$AudioStreamPlayer2D.playing = true
		yield($AudioStreamPlayer2D, "finished")
		yield(get_tree().create_timer(3), "timeout")
		queue_free()
