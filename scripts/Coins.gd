extends Area2D

var screensize = Vector2.ZERO

func pickup():
# CollisionShape2D’s disabled property needs to be set to true. If we don't, the "area_entered" signal 
# can get triggered a second time, registereing as a second pick up.
	$CollisionShape2D.set_deferred("disabled", true)
	# In the above line of code,☝️is used to wait for the current frame to finish and only then it will disable
	# collisionShape2D.
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	# "set_parallel()" says that any following tweens should happen at the same time, instead of one after 
	# another. "set_trans()" sets the transition function to the “quadratic” curve.
	tw.tween_property(self, "scale", scale * 3, 0.3)
	# [the object to affect (self), the property to change, the ending value, and theduration (in seconds)]
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished
# Safely removes the node fromthe tree and deletes it from memory, along with all its children. 
	queue_free()

func _ready() -> void:
	$Timer.start(randf_range(3, 8))

func _on_timer_timeout() -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play()
# 👇so that coins don't get spawned over cactus
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
