extends Node2D

onready var player = load("res://player.tscn")

func _ready():
	
	# cria o player
	var p = player.instance()
	p.walk_speed = 100
	p.run_speed = 250
	p.facing = Vector2(0,1) # começa virado pra baixo "down"
	p.person = "spark"
	p.global_position = $position.global_position
	add_child(p)
