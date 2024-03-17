class_name GameUI extends Control

@export var despierta_shake := Vector2(1.0, 1.0)
@export var despierta_base_time := 0.1

var initial_despierta_label_position: Vector2

@onready var despierta := $Despierta as PanelContainer
@onready var despierta_label := $Despierta/CenterContainer as CenterContainer
@onready var progress_bar := $Progress as TextureProgressBar
@onready var video := $Video as VideoStreamPlayer
@onready var mierda := $Mierda as Panel


func _process(_delta: float) -> void:
	var randx = randf_range(-despierta_shake.x, despierta_shake.x)
	var randy = randf_range(-despierta_shake.y, despierta_shake.y)

	despierta_label.global_position = Vector2(randx, randy)


func set_total_progress(amount: float) -> void:
	progress_bar.max_value = amount


func add_progress(amount: float) -> void:
	progress_bar.value += amount

	if progress_bar.value >= progress_bar.max_value:
		SignalBus.despierta.emit()


func set_progress(amount: float) -> void:
	progress_bar.value = amount


func awake() -> void:
	despierta.visible = true
	create_tween().tween_callback(_hide_awake).set_delay(despierta_base_time * progress_bar.value)


func _hide_awake() -> void:
	despierta.visible = false


func show_mierda() -> void:
	mierda.visible = true


func hide_mierda() -> void:
	mierda.visible = false


func hide_ui() -> void:
	progress_bar.visible = false


func start_video() -> void:
	video.play()
