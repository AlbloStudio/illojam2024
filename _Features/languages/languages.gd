extends Node

@export var next_scene: PackedScene
@onready var _en_button := $GridContainer/EN_MARGIN/EN as TextureButton
@onready var _es_button := $GridContainer/ES_MARGIN/ES as TextureButton


func _on_en_pressed():
	TranslationServer.set_locale("en")
	go_to_main()


func _on_es_pressed():
	TranslationServer.set_locale("es")
	go_to_main()


func go_to_main():
	get_tree().get_root().add_child(next_scene.instantiate())
	queue_free()


func _on_es_mouse_entered():
	_es_button.self_modulate = Color(1, 1, 1, 1)


func _on_es_mouse_exited():
	_es_button.self_modulate = Color(1, 1, 1, 0.5)


func _on_en_mouse_entered():
	_en_button.self_modulate = Color(1, 1, 1, 1)


func _on_en_mouse_exited():
	_en_button.self_modulate = Color(1, 1, 1, 0.5)
