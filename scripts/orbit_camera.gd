extends Spatial

export(float) var move_speed
export(float) var mouse_sens
export(float) var zoom_speed
export(float) var zoom_min
export(float) var zoom_max

onready var child_camera = $OrbitCamera

var dragging = false
var mouse_delta = Vector2()
var camera_distance = 5.0


func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event is InputEventMouseButton:
		dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		mouse_delta = event.relative
	if event.is_action_pressed("zoom_in"):
		camera_distance = clamp(camera_distance - zoom_speed, zoom_min, zoom_max)
	if event.is_action_pressed("zoom_out"):
		camera_distance = clamp(camera_distance + zoom_speed, zoom_min, zoom_max)
	
func _process(delta):
	var move_input = get_movement_input()
	var zoom_input = get_zoom_input()
	
	var forward_proj = project_to_xz_plane(global_transform.basis.z)
	var forward_move = forward_proj * move_input.z
	var side_move = global_transform.basis.x * move_input.x
	
	var move_vector = forward_move + side_move
	
	global_translate(move_vector * move_speed * delta)
	rotate(Vector3.UP, -mouse_delta.x * mouse_sens * delta)
	rotate_object_local(Vector3.RIGHT, -mouse_delta.y * mouse_sens * delta)
	camera_distance = clamp(camera_distance + zoom_input * delta, zoom_min, zoom_max)
	child_camera.transform.origin.z = camera_distance
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

func get_zoom_input():
	var zoom_input = 0.0
	if Input.is_action_pressed("zoom_in"):
		zoom_input -= 1.0
	if Input.is_action_pressed("zoom_out"):
		zoom_input += 1.0
	return zoom_input

func set_focus_position(position):
	transform.origin = position

func project_to_xz_plane(vector):
	var plane = Plane(Vector3.UP, 0.0)
	return plane.project(vector)
