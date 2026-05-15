extends CharacterBody2D


const SPEED = 50.0
var health := 3
var direction := Vector2.ZERO
var is_exploding := false

func _physics_process(_delta: float) -> void:
	if is_exploding:
		return
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return
	direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()
	
func explode() -> void:
	if is_exploding:
		return
	is_exploding = true
	velocity = Vector2.ZERO
	$CollisionBody.set_deferred("disabled", "true")
	$CollisionLeftRotor.set_deferred("disabled", "true")
	$CollisionRightRotor.set_deferred("disabled", "true")
	$Sprite2D.hide()
	$Explosion.show()
	$ExplosionLight.show()
	$AnimationPlayer.play("explosion")
	await $AnimationPlayer.animation_finished
	queue_free()

func explosion_aoe_damage() -> void:
	var overlapping = $ExplosionRange.get_overlapping_bodies()
	for body in overlapping:
		if body == self:
			continue
		elif body.is_in_group("player"):
			body.take_damage()
		elif body.is_in_group("enemies"):
			body.explode()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not area.is_in_group("bullets"):
		return
	health -= 1
	if not is_exploding:
		area.queue_free()
	if health <= 0:
		explode()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		explode()
