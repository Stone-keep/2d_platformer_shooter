extends Node2D

var bullet_scene: PackedScene = preload("res://bullets/bullet.tscn")

func _ready() -> void:
	pulse_sign_lights()

func _physics_process(_delta: float) -> void:
	enter_door()

func pulse_sign_lights():
	var sign_lights = $Lights/Signs.get_children()
	for sl in sign_lights:
		var sign_light_tween = create_tween()
		sign_light_tween.set_loops()
		sign_light_tween.tween_property(sl, "energy", 1.0, 1)
		sign_light_tween.tween_property(sl, "energy", 0.5, 1)

func check_overlap(area, character):
	var overlapping = area.get_overlapping_bodies()
	return character in overlapping

func enter_door():
	if Input.is_action_just_pressed("enter"):
		var player = $Characters/Player
		if check_overlap($Areas/UpperDoor, player):
			player.global_position = $Areas/MiddleDoor.global_position
		elif check_overlap($Areas/MiddleDoor, player):
			player.global_position = $Areas/UpperDoor.global_position
		elif check_overlap($Areas/LowerDoor, player):
			print("game won")


func _on_player_shot(pos: Vector2, dir: Vector2) -> void:
	var bullet := bullet_scene.instantiate()
	bullet.setup(pos, dir)
	$Bullets.add_child(bullet)