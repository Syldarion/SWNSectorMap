extends Node

export(PackedScene) var sector_system_scene
export(PackedScene) var system_select_button_scene

onready var system_name_label = $SystemsPanel/SectorNameLabel
onready var system_button_container = $SystemsPanel/ScrollContainer/SystemButtonContainer
onready var selected_system_name_label = $SelectedSystemPanel/SelectedSystemNameLabel
onready var view_system_button = $SelectedSystemPanel/ViewSystemButton
onready var camera_focus = $CameraFocus

var systems = {}
var selected_system = null

func _ready():
	view_system_button.connect("pressed", self, "_on_ViewSystemButton_pressed")
	
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
