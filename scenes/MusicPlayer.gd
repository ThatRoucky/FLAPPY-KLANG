extends AudioStreamPlayer

func _ready():
	# Charge le fichier audio au démarrage
	stream = load("res://assets/audio/Flappy Klang.mp3")
	if stream is AudioStream:
		stream.loop = true	
	play()
