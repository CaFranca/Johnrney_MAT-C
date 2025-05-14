extends Node

@onready var player = $AudioStreamPlayer


		
func slide_bar(value) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	AudioServer.set_bus_mute(1,value<0.01)
