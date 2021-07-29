extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal body_clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ColiisionArea_input_event(camera, event, click_position, click_normal, shape_idx):
	emit_signal("body_clicked")
