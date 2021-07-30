extends Node

export(PackedScene) var sector_system_scene
export(PackedScene) var system_select_button_scene

onready var system_name_label = $SectorSidePanel/SystemsPanel/SectorNameLabel
onready var system_button_container = $SectorSidePanel/SystemsPanel/ScrollContainer/SystemButtonContainer
onready var selected_system_name_label = $SectorSidePanel/SelectedSystemPanel/SelectedSystemNameLabel
onready var view_system_button = $SectorSidePanel/SelectedSystemPanel/ViewSystemButton
onready var route_from_button = $SectorSidePanel/RoutePanel/FromOptionButton
onready var route_to_button = $SectorSidePanel/RoutePanel/ToOptionButton
onready var plot_result_label = $SectorSidePanel/RoutePanel/PlotResultLabel
onready var camera_focus = $CameraFocus
onready var path_renderer = $PathRenderer

var systems = {}
var selected_system = null

func _ready():
	view_system_button.connect("pressed", self, "_on_ViewSystemButton_pressed")
	route_from_button.connect("item_selected", self, "_on_RouteButtons_changed")
	route_to_button.connect("item_selected", self, "_on_RouteButtons_changed")
	
	populate_sector_map()

func populate_sector_map():
	var sector_data = GameData.sector_data_json
	systems = {}
	
	system_name_label.text = sector_data["sector_name"]
	
	for sector_system in sector_data["systems"]:
		var new_system = sector_system_scene.instance() as SectorSystem
		new_system.load_system_data(sector_system)
		add_child(new_system)
		new_system.translate(new_system.rel_loc)
		systems[new_system.system_name] = new_system
		new_system.connect("system_clicked", self, "_on_SectorSystem_clicked")
		
		var system_select_button = system_select_button_scene.instance()
		system_select_button.set_system_name(new_system.system_name)
		system_select_button.connect("selected", self, "_on_SystemSelectButton_selected")
		system_button_container.add_child(system_select_button)
		
		route_from_button.add_item(new_system.system_name)
		route_to_button.add_item(new_system.system_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		selected_system = null
		selected_system_name_label.text = "No System Selected"
		view_system_button.disabled = true

func _on_SystemSelectButton_selected(system_name):
	focus_on_system(system_name)

func _on_SectorSystem_clicked(system_name):
	focus_on_system(system_name)

func _on_ViewSystemButton_pressed():
	view_system(selected_system.system_name)

func _on_RouteButtons_changed(index):
	var from_selected = route_from_button.get_selected_id()
	var to_selected = route_to_button.get_selected_id()
	if from_selected == -1 or to_selected == -1:
		return
	
	var route_from_selection = route_from_button.get_item_text(from_selected)
	var route_to_selection = route_to_button.get_item_text(to_selected)
	
	var shortest_path = find_path(route_from_selection, route_to_selection)
	draw_path(shortest_path)

func focus_on_system(system_name):
	if not system_name in systems:
		return
	var focus_loc = systems[system_name].rel_loc
	camera_focus.set_focus_position(focus_loc)
	selected_system = systems[system_name]
	selected_system_name_label.text = system_name
	view_system_button.disabled = false

func view_system(system_name):
	pass

func find_path(start_system, end_system):
	var vertices = []
	var dist = {}
	var prev = {}
	
	for system_name in systems:
		dist[system_name] = INF
		prev[system_name] = null
		vertices.append(system_name)
	
	dist[start_system] = 0
	
	while len(vertices) > 0:
		var shortest = vertices[0]
		var shortest_value = dist[shortest]
		for d in vertices:
			if dist[d] < shortest_value:
				shortest = d
				shortest_value = dist[d]
		vertices.erase(shortest)
		
		if shortest == end_system:
			break
		
		for connected_system in systems[shortest].connected:
			var alt_len = shortest_value + 1
			if alt_len < dist[connected_system]:
				dist[connected_system] = alt_len
				prev[connected_system] = shortest
	
	var path = []
	var u = end_system
	if (prev[u] != null) or (u == start_system):
		while u != null:
			path.push_front(u)
			u = prev[u]
	
	return path

func draw_path(path):
	if len(path) <= 1:
		return
	
	path_renderer.clear()
	path_renderer.begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	var step_uv = 1 / len(path) - 1
	var index = 0
	
	for system_name in path:
		path_renderer.set_uv(Vector2(step_uv * index, 0.0))
		index += 1
		path_renderer.add_vertex(systems[system_name].transform.origin)
	path_renderer.end()
