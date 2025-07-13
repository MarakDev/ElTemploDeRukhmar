extends Node2D

@export var canvas: CanvasLayer
@export var player: Node2D
@export var camera: Node2D
@export var colisionLava: TileMapLayer
@export var colisionParedSecreta: TileMapLayer
@export var corrupcionSpawn: TileMapLayer
@export var oscuridad : CanvasModulate
@export var screamerImage : Sprite2D

@onready var cueva_musica : AudioStreamPlayer2D = $Musica
@onready var musica2 : AudioStreamPlayer2D = $Musica2
@onready var ambiente_musica : AudioStreamPlayer2D = $Cueva
@onready var lava_musica : AudioStreamPlayer2D = $Lava
@onready var screamer : AudioStreamPlayer2D = $Screamer


var sala_x = 1
var sala_y = 1

var sala_actual = 1

var salas_lava = [5, 7, 15, 16, 21, 22, 23, 24, 28, 29, 31, 32, 33, 34, 35, 36, 39, 43, 44, 48, 50, 51, 56, 58, 59]
#todas las salas de lava tambien lo son de oscuridad
var salas_oscuridad = [4, 20, 26, 30, 37, 38, 40, 45, 46, 47, 52, 53, 55, 57, 60, 61, 62, 63, 64]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.position.x = 0
	camera.position.y = 0
	
	corrupcionSpawn.enabled = false
	corrupcionSpawn.visible = false
	colisionParedSecreta.enabled = true
	colisionParedSecreta.visible = true
	
	cueva_musica.play()
	ambiente_musica.play()
	
	await get_tree().create_timer(1.5).timeout
	
	canvas.queue_text("Vaya...")
	canvas.queue_text("Eso ha sido una buena caida...")
	canvas.queue_text("Maldicion, queria encontrar el templo de Rukhmar, Pero no asi!")
	canvas.queue_text("Ahora estoy perdida...")
	canvas.queue_text("Un segundo!")
	canvas.queue_text("Aun tengo la brujula maldita, la cual me guiara hacia mi mayor deseo.")
	canvas.queue_text("Vamos brujula, llevame a la salida.")
	canvas.queue_text("Pulsa Z para encontrar la salida *")
	
	await get_tree().create_timer(2).timeout
	player_block = false
	


var player_block = true
var salaLavaSound = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	
	position.x = player.position.x
	position.y = player.position.y
	
	if player_block:
			player.position.x = 113
			player.position.y = -1226
	
	actualiza_camara()
	actualizar_sala_actual()
	actualiza_salas_especiales()
	
	if sala_actual in salas_lava:
		if salaLavaSound:
			lava_musica.play()
			salaLavaSound = false # Cambiamos a False para indicar que la música ya está sonando
	
	if sala_actual not in salas_lava:
		if not salaLavaSound:
			lava_musica.stop()
			salaLavaSound = true
	
	#si el jugador obtiene botas desactiva la colision lava
	if(player.tiene_botas) && colisionLava != null:
		colisionLava.enabled = false
	
	if(player.tiene_brujula2):
		corrupcionSpawn.enabled = true
		corrupcionSpawn.visible = true
		colisionParedSecreta.enabled = false
		colisionParedSecreta.visible = false
		
	
	if(player.tiene_antorcha) && oneTimeText:
		oneTimeText = false
		await get_tree().create_timer(1).timeout
		canvas.queue_text("Pulsa X para encender la antorcha *")
	
	
	if sala_actual == 9 && oneTimeText2:
		oneTimeText2 = false
		await get_tree().create_timer(2).timeout
		canvas.queue_text("Parece el mural de un insecto...")
		canvas.queue_text("Pero tiene una forma humanoide.")
		canvas.queue_text("Ademas porta en su mano derecha una hoz.")
		canvas.queue_text("Y en su mano izquierda una pesa.")
		canvas.queue_text("Se unen con una cadena...")
		canvas.queue_text("Claro!")
		canvas.queue_text("Seguramente este ser lo utilizaria como arma para defenderse.")
		canvas.queue_text("Mmm...")
		canvas.queue_text("Un momento.")
		canvas.queue_text("Que es eso debajo del mural.")
		canvas.queue_text("Hay una inscripcion!")
		canvas.queue_text("L  I  H  N    B  I  A  N.")
		canvas.queue_text("Parece el nombre de la criatura.")
		canvas.queue_text("Fascinante...")
	
	if sala_actual == 54 && oneTimeText3:
		oneTimeText3 = false
		await get_tree().create_timer(2).timeout
		canvas.queue_text("La salida al fin!")
		canvas.queue_text("Este sitio es de verdad un laberinto.")
		canvas.queue_text("Nos veremos Rukhmar, volvere dentro de poco.")
		canvas.queue_text("Cuando mis desarrolladores puedan utilizar Unity.")
		canvas.queue_text("Y no les escuezan los ojos por no dormir.")
		canvas.queue_text("Ah y a vosotros, gracias por jugar :D.")
		
	if sala_actual == 41 && oneTimeText4:
		oneTimeText4 = false
		await get_tree().create_timer(2).timeout
		canvas.queue_text("Que almacenarian en tantas vasijas...")
	
	if sala_actual == 57 && oneTimeText5:
		oneTimeText5 = false
		await get_tree().create_timer(2).timeout
		screamer.play()
		screamerImage.visible = true
		await get_tree().create_timer(1).timeout
		screamer.stop()
		screamerImage.visible = false
		
	if sala_actual == 64 && oneTimeText4:
		oneTimeText4 = false
		await get_tree().create_timer(1).timeout
		canvas.queue_text("Que ese objeto...")
		canvas.queue_text("Otra brujula...")
	
	print_debug("sala: ")
	print_debug(sala_actual)
	
var oneTimeText = true
var oneTimeText2 = true
var oneTimeText3 = true
var oneTimeText4 = true
var oneTimeText5 = true
var oneTimeText6 = true

func actualiza_camara():
	
	#camera move 224
	if player.position.x >= (224 * sala_x):
		camera.position.x += 224
		sala_x += 1
	
	if player.position.x <= (224 * (sala_x-1)) && sala_x != 1:
		camera.position.x -= 224
		sala_x -= 1
		
	if player.position.y <= (-224 * (sala_y - 1)):
		camera.position.y -= 224
		sala_y += 1
	
	if player.position.y >= (-224 * (sala_y - 2)) && sala_y != 1:
		camera.position.y += 224
		sala_y -= 1
		
	#if player.position.y >= (-224 * sala_y):
		#camera.position.y -= 224
		#sala_y += 1
	#
	#if player.position.y <= (-224 * (sala_y - 1)) && sala_y != 1:
		#camera.position.y += 224
		#sala_y -= 1
	
	


func actualizar_sala_actual():
	sala_actual = sala_x + (8 * (sala_y - 1)) - 48
	
func actualiza_salas_especiales():
	
	#esta dentro de una sala oscura
	for salasOscuras in salas_oscuridad:
		if sala_actual == salasOscuras:
			player.first_time_oscuridad = true
			oscuridad.color = Color("000000")
			texto_antorcha()
			return
	
	for salasLava in salas_lava:
		if sala_actual == salasLava:
			player.first_time_lava = true
			texto_lava()
			oscuridad.color = Color("938f78")
			return
	
	if sala_actual == -5 && oneTimeMusic:
		oneTimeMusic = false
		oneTimeMusic2 = true
		oscuridad.color = Color("70613e")
		cueva_musica.stop()
		musica2.play()
		
	if sala_actual == 3 && oneTimeMusic2:
		oneTimeMusic = true
		oneTimeMusic2 = false
		#oscuridad.color = Color("70613e")
		cueva_musica.play()
		musica2.stop()
	
	#oscuridad normal
	if sala_actual > 0:
		oscuridad.color = Color("70613e")
	elif sala_actual < 0:
		oscuridad.color = Color("240922")
	#lava_musica.stop()

var oneTimeMusic = true
var oneTimeMusic2 = false

var noMoreTextOscuridad = false
func texto_antorcha():
	if player.first_time_oscuridad && !noMoreTextOscuridad:
		noMoreTextOscuridad = true

		await get_tree().create_timer(0.75).timeout
		
		canvas.queue_text("Esta muy oscuro...")
		canvas.queue_text("Deberia buscar una antorcha, si no me sera imposible avanzar.")
		canvas.queue_text("La brujula se ha actualizado *")
		canvas.queue_text("Pulsa X para encontrar una antorcha *")
		
var noMoreTextlava = false
func texto_lava():
	if player.first_time_lava && !noMoreTextlava:
		noMoreTextlava = true

		await get_tree().create_timer(0.75).timeout
		
		canvas.queue_text("Vaya, parece que tambien hay magma...")
		canvas.queue_text("En las ruinas de Rukhmar se dice que hay unas botas que son capaces de soportar las altas temperaturas.")
		canvas.queue_text("Espero encontrarlas.")
		canvas.queue_text("La brujula se ha actualizado *")
		canvas.queue_text("Pulsa C para encontrar las botas de Rukhmar *")
		
	
func _on_timer_timeout():
	Tiempo.tiempoTotal += 1
