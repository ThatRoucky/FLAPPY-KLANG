extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
var flying : bool = false
var falling : bool = false
const START_POS = Vector2(100, 400)

#called when the node enters the scene for the fist time 
func _ready():
	reset()
	
#reset the starting game values 
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

#called to fluidify the movement in game
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y*0.05))
			$AnimatedSprite2D.play()
		else: #falling
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
func flap():
	velocity.y = FLAP_SPEED
			
			
