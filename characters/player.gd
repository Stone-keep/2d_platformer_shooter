extends CharacterBody2D

const SPEED := 100.0
const FRICTION := SPEED / 0.1
const JUMP_STRENGTH := 350.0
const GRAVITY_FACTOR := 1.0
var direction: float
var can_shoot := true
var health := 3

var gun_directions = {
	Vector2i(1, 0):   0,
	Vector2i(1, 1):   1,
	Vector2i(0, 1):   2,
	Vector2i(-1, 1):  3,
	Vector2i(-1, 0):  4,
	Vector2i(-1, -1): 5,
	Vector2i(0, -1):  6,
	Vector2i(1, -1):  7
}

signal player_shot(pos: Vector2, dir: Vector2)


func _physics_process(delta: float) -> void:
	get_input()
	handle_gravity(delta)
	handle_movement(delta)
	handle_torso_animation()
	handle_crosshair_position()
	move_and_slide()

func get_input() -> void:
	direction = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_STRENGTH
	if Input.is_action_just_pressed("shoot") and can_shoot:
		try_shoot()

func handle_movement(delta: float) -> void:
	if is_on_floor():
		if direction:
			velocity.x = direction * SPEED
			$LegsSprite.flip_h = direction < 0
			$AnimationPlayer.current_animation = "run"
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			$AnimationPlayer.current_animation = "idle"
	else:
		if direction:
			velocity.x = direction * SPEED
			$LegsSprite.flip_h = direction < 0

		$AnimationPlayer.current_animation = "jump"

func handle_torso_animation() -> void:
	var mouse_position = get_local_mouse_position().normalized()
	var rounded_position = Vector2i(round(mouse_position.x), round(mouse_position.y))
	$TorsoSprite.frame = gun_directions[rounded_position]

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_FACTOR

func shoot():
	player_shot.emit(position, get_local_mouse_position().normalized())
	can_shoot = false
	var crosshair_tween = get_tree().create_tween()
	crosshair_tween.tween_property($Crosshair, "scale", Vector2(0.1, 0.1), 0.2)
	crosshair_tween.tween_property($Crosshair, "scale", Vector2(0.5, 0.5), 0.2)
	$ReloadTimer.start()

func try_shoot() -> void:
	if not can_shoot:
		return
	shoot()

func handle_crosshair_position() -> void:
	var mouse_position = get_local_mouse_position().normalized()
	$Crosshair.position = mouse_position * 50

func take_damage():
	health -= 1
	if health <= 0:
		print("dead")

func _on_reload_timer_timeout() -> void:
	can_shoot = true
