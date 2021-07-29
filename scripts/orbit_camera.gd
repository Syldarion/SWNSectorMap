extends Spatial

export(float) var move_speed
export(float) var mouse_sens

onready var child_camera = $OrbitCamera

var dragging = false
var mouse_delta = Vector2()


func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		mouse_delta = event.relative
	
func _process(delta):
	var move_input = get_movement_input()
	
	translate(move_input * move_speed * delta)
	rotate(Vector3.UP, -mouse_delta.x * mouse_sens * delta)
	rotate_object_local(Vector3.RIGHT, -mouse_delta.y * mouse_sens * delta)
	mouse_delta = Vector2()

func get_movement_input():
	var move_input = Vector3()
	
	if Input.is_action_pressed("move_pos_x"):
		move_input.x += 1
	if Input.is_action_pressed("move_neg_x"):
		move_input.x -= 1
	if Input.is_action_pressed("move_pos_y"):
		move_input.y += 1
	if Input.is_action_pressed("move_neg_y"):
		move_input.y -= 1
	if Input.is_action_pressed("move_pos_z"):
		move_input.z += 1
	if Input.is_action_pressed("move_neg_z"):
		move_input.z -= 1
	
	return move_input

func set_focus_position(position):
	transform.origin = position
