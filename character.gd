extends KinematicBody2D

func _ready():
	pass

# DECLARAÇÃO DE VARIAVEIS DO PROTAGONISTA 
const LEAPSAMOUNT = 2
const POWER = preload("res://power.tscn")
var movement = Vector2()
var gravity = 950
var velocity = 300
var leap = LEAPSAMOUNT
var jump_time = 0
var lifeCharacter = 50

func _physics_process(delta):
	# GRAVIDADE APLICADA AO PROTAGONISTA
	if movement.y > gravity:
		movement.y = gravity
	
	# MOVIMENTAÇÃO DO PROTAGONISTA
	if Input.is_action_pressed("ui_left"):
		movement.x = -velocity
		get_node("AnimatedSprite").play("running")
		get_node("AnimatedSprite").set_flip_h(true)
		if Input.is_action_pressed("ui_up"):
			if jump_time < 1:
				movement.y = -520
				jump_time = jump_time + 1
			
	elif Input.is_action_pressed("ui_right"):
		movement.x = velocity
		get_node("AnimatedSprite").play("running")
		get_node("AnimatedSprite").set_flip_h(false)
		if Input.is_action_pressed("ui_up"):
			if jump_time < 1:
				movement.y = -520
				jump_time = jump_time + 1

				
	# AÇÃO DE PULO
	elif Input.is_action_pressed("ui_up"):
		if jump_time < 1:
			movement.y = -520
			jump_time = jump_time + 1
			
	# QUANDO PARADO
	elif movement.y < 500:
		get_node("AnimatedSprite").play("jumping")
		
	else:
		movement.x = 0
		jump_time = 0
		get_node("AnimatedSprite").play("idling")
		
	
	movement.y += gravity * delta
	
	
	# ATIRAR SHURIKEN
	if Input.is_action_just_pressed("space"):
		var power = POWER.instance()
		get_parent().add_child(power)
		power.position = $Position2D.global_position
		
		if $Position2D.position.x > 0:
			power.set_direction(1)
		else:
			power.set_direction(-1)
			
	if Input.is_action_just_pressed("ui_left"):
		if $Position2D.position.x > 0:
			$Position2D.position.x *= -1
	if Input.is_action_just_pressed("ui_right"):
		if $Position2D.position.x < 0:
			$Position2D.position.x *= -1
				
	move_and_slide(movement, Vector2(0,-1))

#DANO INIMIGOS
func damage():
	
	get_node("../zombieM").attack()
	get_node("../zombieF").attack()
	
	if get_node("../zombieF/DieAreaZombie") or get_node("../zombieF/CollisionDieZombie"):
		
		if lifeCharacter > 0:
			lifeCharacter -= 5
			print("Vida F")
			print(lifeCharacter)
		else: 
			get_tree().change_scene("res://game_over.tscn")
			
	elif get_node("../zombieM/DieAreaZombie") or get_node("../zombieM/CollisionDieZombie"):

		if lifeCharacter > 0:
			lifeCharacter -= 5
			print("Vida M")
			print(lifeCharacter)
		else: 
			get_tree().change_scene("res://game_over.tscn")
			
	else:
		
		if lifeCharacter > 0:
			lifeCharacter -= 5
			print("Vida L")
			print(lifeCharacter)
		else: 
			get_tree().change_scene("res://game_over.tscn")
	
# MOVIMENTAÇÃO DO TRAMPOLIM / CAIXA
func _on_trampoline_body_entered(body):
	movement.y = -750

# CARREGAMENTO DE PROXIMA FASE / LEVEL
func _on_portalLevel2_body_entered(body):
	get_tree().change_scene("res://level2.tscn")

func _on_portalLevel3_body_entered(body):
	get_tree().change_scene("res://level3.tscn")

func _on_portalEnd_body_entered(body):
	get_tree().change_scene("res://the_end.tscn")
