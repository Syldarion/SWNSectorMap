extends Node

export(PackedScene) var sector_system_scene


func _ready():
	populate_sector_map()

func populate_sector_map():
	var sector_data = GameData.sector_data_json
	
	for sector_system in sector_data["systems"]:
		var new_system = sector_system_scene.instance() as SectorSystem
		new_system.load_system_data(sector_system)
		add_child(new_system)
		new_system.translate(new_system.rel_loc)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
