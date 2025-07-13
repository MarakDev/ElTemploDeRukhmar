extends CharacterBody2D

@export var rayo_salida: CPUParticles2D
@export var rayo_antorcha: CPUParticles2D
@export var rayo_botas: CPUParticles2D
@export var rayo_brujula2: CPUParticles2D

@export var luzbrujula: PointLight2D

@export var target_salida: Node2D
@export var target_antorcha: Node2D
@export var target_botas: Node2D
@export var target_brujula2: Node2D

#sonido
@onready var pasos : AudioStreamPlayer2D = $Pasos
@onready var equipado : AudioStreamPlayer2D = $Equipado
@onready var laser_brujula : AudioStreamPlayer2D = $Laser
@onready var antorcha_sonido : AudioStreamPlayer2D = $AntorchaSonido

var tiene_antorcha = false
var tiene_botas = false
var tiene_brujula2 = false

var currentSpeed = SPEED
const SPEED = 50
const SPEED_COMPASS = SPEED / 5

var current_dir = "none"
var compassActive = false
var current_compass = null
var current_target = null

var activate_antorcha = false

var first_time_lava = false
var first_time_oscuridad = false

func _ready():
	rayo_salida.emitting = false
	rayo_antorcha.emitting = false
	rayo_botas.emitting = false
	
	$AnimatedSprite2D.play("front_idle")

func _process(delta):
	
	use_compass()
	direccion_particulas(current_target, current_compass)
	actualiza_spritesheet()
	
	if (velocity.x != 0 || velocity.y != 0) && pasitos:
		pasos.play()
		pasitos = false
		await get_tree().create_timer(1.9).timeout
		pasos.stop()
		pasitos = true


var pasitos = true
func _physics_process(delta):
	player_movement(delta)
	

func player_movement(delta):
	
	#var dir_x = Input.get_axis("left", "right")
	#var dir_y = Input.get_axis("up", "down")
	
	if Input.is_action_pressed("right"):
		play_anim(1)
		current_dir = "right"
		velocity.x = currentSpeed
		velocity.y = 0

	elif Input.is_action_pressed("left"):
		play_anim(1)
		current_dir = "left"
		velocity.x = -currentSpeed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		play_anim(1)
		current_dir = "up"
		velocity.x = 0
		velocity.y = currentSpeed
	elif Input.is_action_pressed("up"):
		play_anim(1)
		current_dir = "down"
		velocity.x = 0
		velocity.y = -currentSpeed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
		
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")
		
	if dir == "up":
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")
		
	if dir == "down":
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

func use_compass():
	#comprueba si cada rayo se puede activar
	if !compassActive && Input.is_action_just_pressed("activate compass salida"):
		currentSpeed = SPEED_COMPASS
		
		laser_brujula.play()
		equipado.play()
		luzbrujula.enabled = true
		
		#si tiene antorcha y no botas va al compass torch
		if activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass_torch.tres")
		#si tiene botas y no antorcha va al compass botas
		if !activate_antorcha && tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass_botas.tres")
		#no tiene nada
		if !activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass.tres")
		#si tiene todo
		if activate_antorcha && tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/full.tres")
			
		if tiene_brujula2:
			current_target = target_brujula2
			current_compass = rayo_brujula2
		else:
			current_target = target_salida
			current_compass = rayo_salida
		
		current_compass.emitting = true
		await get_tree().create_timer(0.1).timeout
		compassActive = true
		
		#caso antorcha
	elif !compassActive && Input.is_action_just_pressed("activate compass antorcha") && !tiene_antorcha && first_time_oscuridad:
		currentSpeed = SPEED_COMPASS
		
		luzbrujula.enabled = true
		laser_brujula.play()
		equipado.play()
		
		#si tiene botas y no antorcha va al compass botas
		if tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass_botas.tres")
		#no tiene nada
		if !activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass.tres")
		
		current_compass = rayo_antorcha
		current_target = target_antorcha
		
		current_compass.emitting = true
		await get_tree().create_timer(0.1).timeout
		compassActive = true
		
		#caso botas
	elif !compassActive && Input.is_action_just_pressed("activate compass botas") && !tiene_botas && first_time_lava:
		currentSpeed = SPEED_COMPASS
		
		luzbrujula.enabled = true
		laser_brujula.play()
		equipado.play()
		
		#si tiene antorcha y no botas va al compass torch
		if activate_antorcha:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass_torch.tres")
		#no tiene nada
		if !activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/compass.tres")
		
		current_compass = rayo_botas
		current_target = target_botas
		
		current_compass.emitting = true
		await get_tree().create_timer(0.1).timeout
		compassActive = true
	
	#desactivacion de rayos
	if compassActive && (Input.is_action_just_pressed("activate compass salida") or Input.is_action_just_pressed("activate compass antorcha") or Input.is_action_just_pressed("activate compass botas")):
		currentSpeed = SPEED
		current_compass.emitting = false
		
		laser_brujula.stop()
		luzbrujula.enabled = false
		
		#no tiene nada, vuelve al idle
		if !activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/idle.tres")
		
		#si solo tiene antorcha, vuelve a torch
		if activate_antorcha && !tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/torch.tres")
		
		#si solo tiene botas, vuelve a botas
		if !activate_antorcha && tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas.tres")
		
		#si tiene antorcha y botas, vuelve a botas_torch
		if activate_antorcha && tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas_torch.tres")
			
		await get_tree().create_timer(0.1).timeout
		compassActive = false
		

func direccion_particulas(target, actual_rayo):
	if target != null and actual_rayo:
		var direction = (target.global_position - actual_rayo.global_position).normalized()
		
		var newGravityToRotate =  Vector2(325 * direction.x, 325 * direction.y)
		
		actual_rayo.gravity = newGravityToRotate

func consigue_antorcha():
	tiene_antorcha = true
	currentSpeed = SPEED
	if current_compass != null:
		current_compass.emitting = false
	compassActive = false
	


func consigue_botas():
	tiene_botas = true
	currentSpeed = SPEED
	if current_compass != null:
		current_compass.emitting = false
	compassActive = false
	if activate_antorcha:
		$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas_torch.tres")
	else:
		$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas.tres")

func actualiza_spritesheet():
	#cuando activa la antorcha
	if Input.is_action_just_pressed("activate compass antorcha") && !activate_antorcha && tiene_antorcha:
		if tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas_torch.tres")
		else:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/torch.tres")
		
		antorcha_sonido.play()
		
		$PointLight2D.enabled = true
		await get_tree().create_timer(0.1).timeout
		activate_antorcha = true
	
	#cuando vuelve a darle a la antorcha se vuelve a idle
	if Input.is_action_just_pressed("activate compass antorcha") && activate_antorcha && tiene_antorcha:
		#si tiene botas cambia al spritesheet de idle con botas
		if tiene_botas:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/botas.tres")
		else:
			$AnimatedSprite2D.sprite_frames = load("res://Art/SpriteSheets/idle.tres")
		
		antorcha_sonido.stop()
		
		$PointLight2D.enabled = false
		await get_tree().create_timer(0.1).timeout
		activate_antorcha = false
