extends KinematicBody2D

class_name KinematicBodyBase2D

# // Variáveis com opção para exportar para serem customizadas
export(int) var walk_speed: int = 300
export(int) var run_speed: int = 300
export var person: String = "spark"
export var facing: Vector2 = Vector2(0,1)
export(bool) var controlled: bool = false

# // Variáveis básicas
var speed: int = 0
var died: bool = false
var state: String = "idle"
var dir: Vector2 = Vector2.ZERO
var oldTexture = null
export(Array) var directions: Array = ["right", "downright", "down", "downleft", "left", "upleft", "up", "upright"]
var pathTexture: String = "res://assets/persons/[PERSON]/[STATE]/[FACING].png"

# // Cache
var loaded: Dictionary = {}

func _ready() -> void:
	add_to_group("characters")
	speed = walk_speed
	_preCache()

func _physics_process(_delta) -> void:
	if died: return
	# regras de movimentação, animação e troca de textura do player
	_move()
	# implementa o movimento no KinematicBody2D
	dir = move_and_slide(dir.normalized() * speed)

func _move() -> void:
	# ////////
	# inicia sem movimentação
	dir = Vector2.ZERO
	# inicia o estado do player como parado
	state = "idle"
	
	var LEFT:bool = Input.is_action_pressed("ui_left")
	var RIGHT:bool = Input.is_action_pressed("ui_right")
	var UP:bool = Input.is_action_pressed("ui_up")
	var DOWN:bool = Input.is_action_pressed("ui_down")
	
	if !controlled:
		LEFT = false
		RIGHT = false
		UP = false
		DOWN = false
	
	var vX:int = (int(RIGHT)-int(LEFT))
	var vY:int = (int(DOWN)-int(UP))
	
	# //////// MOVIMENTA O PLAYER
	dir.x = vX
	dir.y = vY
	
	# //////// ESTADOS DO JOGADOR
	# se a movimentação do player for diferente de Vector.ZERO
	# Estado - walk
	if dir != Vector2(0,0):
		state = "walk"
		speed = walk_speed

	# aqui você pode implementar outros estados para o jogador
	# - correndo por exemplo
	# você pode verificar se shift está selecionado por exemplo
	# e multiplicar o speed por uma velocidade
	if Input.is_action_pressed("ui_run"):
		if dir != Vector2(0,0):
			state = "run"
			speed = run_speed

	
	# //////// OBTÉM DIREÇÃO
	# aqui verifica para qual direção o player está indo
	if LEFT || RIGHT || UP || DOWN:
		facing = dir
	
	# pega pela direção que o player está virado, qual é o angulo
	var animation = direction2str(facing)
	
	# //////// TEXTURA
	# apenas da um replace na string do path, colocando as informações corretas
	var newTexture = _getTexture(animation, state)
	
	# aqui apenas é uma verificação para não ficar dando play repetidamente no AnimationPLayer
	if $anim.assigned_animation != state:
		$anim.play(state)
	
	# algo parecido fazemos aqui, para não ficar alterando a textura muitas vezes
	# apenas trocamos quando o jogador muda de direção ou estado
	if oldTexture != newTexture:
		oldTexture = newTexture
		
		# com cache
		var key = str(state, "_", animation)
		$imagem.texture = _imageCache(newTexture, key)
		
		# sem cache
		#$imagem.texture = load(newTexture)

func direction2str(direction) -> String:
	var angle = direction.angle()
	if angle < 0:
		angle += 2 * PI
	var index = round(angle / PI * 4)
	return directions[index]
	
	# OBS: PI é um radiano 3,141516..., equivale à 180º

func _imageCache(_newTexture, _key) -> Texture:
	var tex = null
	# Se não tem no cache, então carrega e coloca
	if not loaded.has(_key):
		tex = load(_newTexture)
		loaded[_key] = tex
	else:
		tex = loaded[_key]
	
	return tex

func _preCache() -> void:
	for anim_state in $anim.get_animation_list():
		for animation in directions:
			var newTexture = _getTexture(animation, anim_state)
			var key = str(anim_state, "_", animation)
			var _tmp = _imageCache(newTexture, key)

func _getTexture(_animation, _state) -> String:
	# //////// TEXTURA
	# apenas da um replace na string do path, colocando as informações corretas
	var newTexture = pathTexture
	# coloca a informação da direção up,down,left,right,etc...
	newTexture = newTexture.replace("[FACING]", _animation)
	# coloca a informação de qual personagem é
	newTexture = newTexture.replace("[PERSON]", person)
	# coloca a informação do estado do jogador
	newTexture = newTexture.replace("[STATE]", _state)
	return newTexture
	
	
func die():
	if died: return
	died = true
	state = "die"
	
	# pega pela direção que o player está virado, qual é o angulo
	var _animation = direction2str(facing)
	var newTexture = _getTexture(_animation, state)
	
	# com cache
	var key = str(state, "_", _animation)
	$imagem.texture = _imageCache(newTexture, key)
	$anim.play(state)
