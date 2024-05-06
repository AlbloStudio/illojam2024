class_name Spawney extends Sprite3D

@onready var animation_player := $AnimationPlayer as AnimationPlayer


func _ready():
	animation_player.animation_finished.connect(func(_anim_name): queue_free())
