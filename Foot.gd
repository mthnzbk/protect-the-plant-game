extends Node2D


onready var tw:Tween = $Tween
onready var sp:Sprite = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	tw.interpolate_property(sp, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tw.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Tween_tween_all_completed():
	queue_free()
