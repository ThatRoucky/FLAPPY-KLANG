#FLAPPY KLANG 0.1
#ZACHARIE LE ZIGOUIGOUI
#31.10.2025

extends Node2D

@export var pipe_scene : PackedScene




const BASE_PIPE_RANGE = 200

var SCROLL_SPEED = 1.8
var PIPE_DELAY = 20
var PIPE_RANGE = 20

var game_running : bool
var game_over : bool
var scroll 
var score : int
var high_score : int
var screen_size : Vector2i
var ground_height : int
var pipes : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$MainMenu.show()
	new_game()
	# Load saved high score if exists
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)
		high_score = file.get_32()
		file.close()
	else:
		high_score = 0
	$HighScore.text = "HIGH SCORE : " + str(high_score)
	
#reset variables and the Bird's variable
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE : " + str(score)
	$HighScore.text = "HIGH SCORE : " + str(high_score)
	$MainMenu.hide()
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	#generate first pipes
	generate_pipes()
	$Bird.reset()

#get the input events 
func _input(event):
	if not game_over:
		# Détecter l’action rebinding “flap”
		if Input.is_action_just_pressed("flap"):
			if not game_running:
				start_game()
			if game_running and $Bird.flying:
				$Bird.flap()
				check_top()

#Start the game
func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	#pipe timer takes over
	$PipeTimer.start()

#called every frame
func _physics_process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		#reset scroll 
		if scroll >= screen_size.x:
			scroll = 0

		
		#move pipes
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout():
	generate_pipes()

func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2.0 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.score.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score+=1
	$ScoreLabel.text = "SCORE : " + str(score)
	if score > high_score:
		high_score = score
		$HighScore.text = "HIGH SCORE : " + str(high_score)
		save_high_score()


func  check_top():
	if $Bird.position.y <0:
		$Bird.falling = true
		stop_game()

func stop_game():
	$PipeTimer.stop()
	#Show high score
	if score > high_score:
		high_score = score
	#show the menu 
	$GameOver.show()
	$Bird.flying =false
	game_running = false
	game_over = true
	

func bird_hit():
	$Bird.falling = true
	stop_game()

#On ground = dies
func _on_ground_hit():
	$Bird.falling = false
	stop_game()


func _on_game_over_restart():
	new_game()

func save_high_score():
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	file.store_32(high_score)
	file.close()
