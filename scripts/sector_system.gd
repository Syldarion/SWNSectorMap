class_name SectorSystem
extends Spatial

onready var system_mesh = $SystemMesh

var system_name
var system_data # this is loaded from the main GameData json
var rel_loc
var color


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_system_data(data):
	system_data = data
	system_name = data["system_name"]
	rel_loc = Vector3(data["rel_loc"][0], data["rel_loc"][1], data["rel_loc"][2])
	color = data["color"]

func _on_ColiisionArea_input_event(camera, event, click_position, click_normal, shape_idx):
	pass # Replace with function body.
