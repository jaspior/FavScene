extends KinematicBody2D

var speed = 300
var gravity = 30
var motion = Vector2.ZERO
var push = 1000

enum{on_ground, on_air}
var move_status = on_air

func move():
	motion.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))*speed
	


	if motion.x == 0:
		$AnimatedSprite.play("Idle")
	elif motion.x < 1:
		$AnimatedSprite.play("Walk")		
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("Walk")		
		$AnimatedSprite.flip_h = true
	
	
	
	
func apply_gravity():
	if is_on_floor():
		move_status = on_ground
	
	if  is_on_floor() and motion.y > 0:
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += gravity

func jump():
	if Input.is_action_just_pressed("ui_up") and move_status == on_ground:
		move_status = on_air
		motion.y -= 500


func _physics_process(delta):
	apply_gravity()
	
	
	move()
	jump()
	move_and_slide(motion,Vector2.UP,false, 4, PI/4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("movable"):
			collision.collider.apply_central_impulse(-collision.normal * push)
