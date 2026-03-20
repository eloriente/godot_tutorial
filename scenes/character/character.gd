extends CharacterBody2D
# Character signals
signal character_dead

# Character variables
@export var animation: AnimatedSprite2D
@export var area_2d: Area2D
@export var material_red_character: ShaderMaterial

var _velocity: float = 100.0
var _velocity_jump: float = -300.0
var _dead: bool

func _ready():
	add_to_group("characters")
	area_2d.body_entered.connect(_on_area_2d_body_entered)

# Character functions
func _physics_process(delta: float) -> void:
	if _dead:
		return
	
	# Character gravity
	velocity += get_gravity() * delta
	
	# Character jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _velocity_jump
	
	# Character movement
	if Input.is_action_pressed("right"):
		velocity.x = _velocity
		animation.flip_h = true
	elif Input.is_action_pressed("left"):
		velocity.x = -_velocity
		animation.flip_h = false
	else:
		velocity.x = 0
	move_and_slide()
	
	# Character animation
	if !is_on_floor():
		animation.play("jump")
	elif velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")


func _on_area_2d_body_entered(_body: Node) -> void:
	animation.material = material_red_character
	_dead = true
	animation.stop()
	await get_tree().create_timer(0.5).timeout #manera rapida de crear un timer
	character_dead.emit()
