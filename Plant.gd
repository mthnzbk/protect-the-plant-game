extends Area2D


var health:float = 1000
var is_area:bool = false
var enemy_count = 0

signal plant_health(health)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemy_count:
		health -= delta * enemy_count
		emit_signal("plant_health", health)
		if health <= 0:
			get_node("/root/Game").emit_signal("game_over")
			set_process(false)


func _on_Plant_body_entered(body):
	print("bitkiye girildi")
	if body.has_method("is_enemy"):
		enemy_count += 1
#	get_node("/root/Game").emit_signal("game_over")


func _on_Plant_body_exited(body):
	print("bitkiye girilmedi")
	if body.has_method("is_enemy"):
		enemy_count -= 1
