extends Node2D

@export var coin_scene : PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready() -> void:
# automatically calls _ready() on every node when it’s added
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide() # so you won’t see the player before the game starts.
	# new_game(), was put here only for testing
	
func new_game():
# setting the variables to their starting values
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show() # A pre-defined function to show/hide
	$GameTimer.start() # to start counting down the remaining timein the game
	spawn_coins()
	spawn_cactus()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func spawn_cactus():
	for i in level:
		var c = cactus_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func spawn_coins():
# create multiple instances of the Coin object and add them as children of Main
	for i in level + 4:
		var c = coin_scene.instantiate()
		# Whenever you instantiate a new node, it must be added to the scene tree using add_child()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		$LevelSound.play()

func _process(delta: float) -> void:
# runs every frame to check if all the coins have veen collected
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		spawn_cactus()
		_on_powerup_timer_timeout()

func _on_game_timer_timeout() -> void:
	time_left = time_left - 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt() -> void:
	game_over()

func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
		"obstacle":
			$EndSound.play()

func game_over():
	playing = false
	$GameTimer.stop()
	# ☝️halts the game and also uses call_group() to remove all 
	# remaining coins by calling queue_free() on each of them.
	get_tree().call_group("coins", "powerups", "obstacles", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	
func _on_hud_start_game() -> void:
	new_game()

func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
