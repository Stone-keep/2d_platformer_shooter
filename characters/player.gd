extends CharacterBody2D

const SPEED := 200.0
const FRICTION := SPEED / 0.1
const JUMP_STRENGTH := 400.0
const GRAVITY_FACTOR := 1.0
var direction: float
var can_shoot := true

signal player_shot(pos: Vector2, dir: Vector2)


func _physics_process(delta: float) -> void:
	get_input(delta)
	handle_gravity(delta)
	move_and_slide()

func get_input(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if Input.is_action_just_pressed("jump"):
		velocity.y = -JUMP_STRENGTH
	if Input.is_action_just_pressed("shoot") and can_shoot:
		try_shoot()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_FACTOR

func shoot():
	player_shot.emit(position, get_local_mouse_position().normalized())
	can_shoot = false
	$ReloadTimer.start()

func try_shoot() -> void:
	if not can_shoot:
		return
	shoot()

func _on_reload_timer_timeout() -> void:
	can_shoot = true
