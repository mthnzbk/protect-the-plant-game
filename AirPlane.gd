extends Sprite
class_name AirPlane

export(String, "Left", "Right", "Up", "Down") var direction = "Down"

onready var audio:AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	match direction:
		"Left":
			rotation_degrees = 90
			position.y -= get_viewport_rect().size.y/2
			position.x -= get_viewport_rect().size.y
			position.y += randi()%(int(get_viewport_rect().size.y))
		
		"Right":
			rotation_degrees = 270
			position.y -= get_viewport_rect().size.y/2
			position.x += get_viewport_rect().size.x
			position.y += randi()%(int(get_viewport_rect().size.y))
		
		"Up":
			rotation_degrees = 180
			position.x -= get_viewport_rect().size.x/2
			position.y -= get_viewport_rect().size.y
			position.x += randi()%(int(get_viewport_rect().size.x))
			
		"Down":
			rotation_degrees = 0
			position.x -= get_viewport_rect().size.x/2
			position.x += randi()%(int(get_viewport_rect().size.x))
			position.y += get_viewport_rect().size.y
			
	audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match direction:
		"Left":
			position.x += 5
		
		"Right":
			position.x -= 5
		
		"Up":
			position.y += 2
			
		"Down":
			position.y -= 2


func _on_AudioStreamPlayer2D_finished():
	queue_free()
