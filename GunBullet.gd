extends Area2D
class_name GunBullet


var speed:int = 2000
export(Vector2) var normalized

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += normalized * speed * delta


func _on_Timer_timeout():
	queue_free()


func _on_GunBullet_body_entered(body):
	print(body)
	if body.has_method("is_enemy"):
		body.health -= 20
	queue_free()

