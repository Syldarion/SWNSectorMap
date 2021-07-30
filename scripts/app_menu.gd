extends Node

onready var sector_data_url_input = $CenterContainer/VBoxContainer/SectorDataURLInput
onready var status_label = $CenterContainer/VBoxContainer/StatusLabel


func _ready():
	SectorDataDownloader.connect("download_succeeded", self, "_on_Downloader_success")
	SectorDataDownloader.connect("download_failed", self, "_on_Downloader_fail")

func _on_LoadSectorButton_pressed():
	status_label.text = "Loading data file..."
	SectorDataDownloader.request_json_file(sector_data_url_input.text)

func _on_Downloader_success(json):
	var file = File.new()
	file.open("user://sector_data.json", File.READ)
	var file_json = JSON.parse(file.get_as_text())
	file.close()
	GameData.parse_sector_data(file_json.result)
	get_tree().change_scene("res://scenes/SectorMap.tscn")

func _on_Downloader_fail():
	sector_data_url_input.text = ""
	status_label.text = "Failed to download data file."


func _on_PasteButton_pressed():
	sector_data_url_input.text = OS.clipboard
