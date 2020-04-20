extends Area2D
class_name Bazooka


var speed:int = 750
export(Vector2) var normalized

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = normalized.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position += normalized * speed * delta


func _on_Timer_timeout():
	queue_free()



func _on_Bazooka_body_entered(body):
	if body.has_method("is_enemy"):
		body.health -= 50
	queue_free()
