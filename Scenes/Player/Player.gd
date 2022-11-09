extends KinematicBody2D

var snap = Vector2.DOWN
const UP_DIRECTION = Vector2.UP

export var Speed = 600.0
export (float, 0, 1) var AccSpeed = 0.05
export (float, 0, 1) var DeccSpeed = 0.1


var canJump = false
var jump_count = 0
export var jump_max = 2
export var Jump_strength = 1500.0

export (float, 0, 1) var coyoteTime = 0.1
onready var CTimer = get_node("CoyoteTimer")


export var gravity = 4500.0
var velocity = Vector2.ZERO

func _ready():
	CTimer.wait_time = coyoteTime


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity,snap,UP_DIRECTION,true)

func _process(_delta):
	Locomotion()

func Locomotion():
	var Horizontal_direction = ( Input.get_action_strength("right") - Input.get_action_strength("left"))
	
	if Horizontal_direction != 0:
		velocity.x = lerp(velocity.x, Horizontal_direction * Speed, AccSpeed)
	elif Horizontal_direction == 0 and !is_on_floor():
		velocity.x = lerp(velocity.x, 0, DeccSpeed/2)
	else:
		velocity.x = lerp(velocity.x, 0, DeccSpeed)
	
#	velocity.x = Horizontal_direction * speed
	
	var _is_falling = velocity.y > 0.0 and not is_on_floor()
	var _is_idle = is_on_floor() and is_zero_approx(velocity.x)
	var _is_running = is_on_floor() and not is_zero_approx(velocity.x)
	var just_landed = is_on_floor() and snap == Vector2.ZERO
	
	if is_on_floor():
		jump_count = 0
		canJump = true
	elif just_landed:
		snap = Vector2.DOWN
	
	if !is_on_floor() and jump_count < jump_max:
		canJump = true
		CTimer.start()
	
	if canJump:
		if jump_count < jump_max:
			if Input.is_action_just_pressed("jump"):
				velocity.y = -Jump_strength
				snap = Vector2.ZERO
				jump_count += 1

func _on_CoyoteTimer_timeout():
	canJump = false
