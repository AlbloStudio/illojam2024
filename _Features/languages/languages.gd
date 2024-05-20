extends Node

@export var next_scene: PackedScene

var help_text_en = """
LMB 🖱️ move
RMB 🖱️ execute action
MMB 🖱️ see all points
ESC ⌨️ menu
  Q ⌨️ skip dialogue
"""

var help_text_es = """
Izq 🖱️ moverte
Der 🖱️ realizar acción
Mid 🖱️ mostrar puntos
ESC ⌨️ menú
  Q ⌨️ saltar diálogos
"""

@onready var help_label := %HelpText as RichTextLabel
@onready var en_button := %EN_MARGIN/EN as TextureButton
@onready var es_button := %ES_MARGIN/ES as TextureButton


func _ready():
	set_text(help_text_en)


func _on_en_pressed():
	TranslationServer.set_locale("en")
	go_to_main()


func _on_es_pressed():
	TranslationServer.set_locale("es")
	go_to_main()


func go_to_main():
	get_tree().get_root().add_child(next_scene.instantiate())
	queue_free()


func set_text(text: String) -> void:
	help_label.text = text


func _on_es_mouse_entered():
	set_text(help_text_es)
	es_button.self_modulate = Color(1, 1, 1, 1)


func _on_es_mouse_exited():
	es_button.self_modulate = Color(1, 1, 1, 0.5)


func _on_en_mouse_entered():
	set_text(help_text_en)
	en_button.self_modulate = Color(1, 1, 1, 1)


func _on_en_mouse_exited():
	en_button.self_modulate = Color(1, 1, 1, 0.5)
