extends Area2D

signal pickup # declare custom signals that your player will emit when they touch a coin or obstacle
signal hurt   # The touches will be detected by Area2D itself

@export var speed = 350 # make it available in inspector to edit

var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

func _process(delta: float) -> void:
	
	# Get a vector representing the player's input
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# position stores the value of location of the player
	position += velocity * speed * delta
	
	# To avoid player running off screen
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# Choose which animation to play
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	# To toggle direction of animation on x-axis
	if velocity.x != 0: # checks if the player is moving along x-axis
		$AnimatedSprite2D.flip_h = velocity.x < 0 # flip_h ? -ve means left : +ve means right



func start(): # This function resets the player for a new game
	# This will inform the player when the game has started	
	set_process(true) # enables the node to receive instruction every frame
	position = screensize/2
	$AnimatedSprite2D.animation = "idle"

func die():
	# We call this function when the player dies
	$AnimatedSprite2D.animation = "hurt"
	set_process(false) # tells Godot to stop calling the _process() function every frame

func _on_area_entered(area: Area2D) -> void: # called when another area object overlaps with the player
	# When we hit an object, decide what to do
	# print_debug("area entered")
	if area.is_in_group("coins"):
		area.pickup() # function about what the coin does when picked up (playing an animation or sound, for example).
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup() # function about what powerup does when picked up (playing an animation or sound, for example).
		pickup.emit("powerup") 
		# you emit the pickup signal with an additional argument that names the type ofobject. 
	if area.is_in_group("obstacles"): # assign them to the appropriate group so that they can be detected correctly.
		pickup.emit("obstacle")
		hurt.emit()
		die()
