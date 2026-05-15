extends Node2D

var bullet_scene: PackedScene = preload("res://bullets/bullet.tscn")

func _ready() -> void:
	pulse_sign_lights()

func pulse_sign_lights():
	var sign_lights = $Lights/Signs.get_children()
	for sl in sign_lights:
		var sign_light_tween = create_tween()
		sign_light_tween.set_loops()
		sign_light_tween.tween_property(sl, "energy", 1.0, 2)
		sign_light_tween.tween_property(sl, "energy", 0.6, 2)

func _on_player_shot(pos: Vector2, dir: Vector2) -> void:
	var bullet := bullet_scene.instantiate()
	bullet.setup(pos, dir)
	$Bullets.add_child(bullet)
