extends Node2D

onready var base_spark = load("res://scenes/player_spark.tscn")
onready var base_robo = load("res://scenes/player_robo.tscn")

func _ready():
	
	# cria o player
	var p1 = base_spark.instance()
	p1.walk_speed = 100
	p1.run_speed = 250
	p1.controlled = false
	p1.facing = Vector2(0,1) # começa virado pra baixo "down"
	p1.person = "spark"
	p1.global_position = $position1.global_position
	$YSort.call_deferred("add_child", p1)
	
	
	# cria um segundo personagem
	var p2 = base_robo.instance()
	p2.walk_speed = 150
	p2.run_speed = 400
	p2.controlled = true
	p2.facing = Vector2(1,0) # começa virado pra baixo "down"
	p2.person = "robo"
	p2.global_position = $position2.global_position
	$YSort.call_deferred("add_child", p2)
