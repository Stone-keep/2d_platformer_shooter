extends Node2D

var bullet_scene: PackedScene = preload("res://bullets/bullet.tscn")

func _on_player_shot(pos: Vector2, dir: Vector2) -> void:
	var bullet := bullet_scene.instantiate()
	bullet.setup(pos, dir)
	$Bullets.add_child(bullet)
