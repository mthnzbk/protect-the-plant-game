extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($Label, "modulate", Color(1,1,1,1), Color(1,1,1,0), 8,Tween.TRANS_QUINT,Tween.EASE_IN)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tween_tween_all_completed():
	
	get_tree().change_scene("res://Game.tscn")
