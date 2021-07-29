extends Button

signal selected

var system_name


func _ready():
	connect("pressed", self, "_on_Button_pressed")

func set_system_name(sys_name):
	text = sys_name
	system_name = sys_name

func _on_Button_pressed():
	emit_signal("selected", system_name)
