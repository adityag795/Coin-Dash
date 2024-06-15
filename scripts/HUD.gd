extends CanvasLayer

signal start_game

# The Main scene’s script will call these two functions to update the display 
# whenever there is a changein a value.

func update_score(value):
# updating the Score text whenever a coin is collected
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	$MarginContainer/Time.text = str(value)

func show_message(text):
	$Message.text = text
	$Message.show()
	# Timer to make message label disappear after a brief period
	$Timer.start()

func _on_timer_timeout() -> void:
	$Message.hide()

func _on_start_button_pressed() -> void:
# Button pressed signal
	$StartButton.hide()
	# when clicked, it will hide itself and
	$Message.hide()
	# send a signal to the Main scene tostart the game
	start_game.emit()

func show_game_over():
	show_message("Game Over")
	# 👇 message to be displayed for two seconds and then disappear
	await $Timer.timeout
	# ☝️ pauses the execution of a function until the given node (Timer) emits a given signal (timeout).
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
