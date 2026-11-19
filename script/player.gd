extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var radar: Area2D = $radar
var modele_lanceur = preload("res://scene/modele_lanceur.tscn")


var feu = preload("res://sort/element/feu.tres")
var vent = preload("res://sort/element/vent.tres")
var eau = preload("res://sort/element/eau.tres")
var terre = preload("res://sort/element/terre.tres")
var foudre = preload("res://sort/element/foudre.tres")

var projectile = preload("res://sort/type/projectile.tscn")
var laser = preload("res://sort/type/laser.tscn")
var aura = preload("res://sort/type/aura.tscn")
var meteor = preload("res://sort/type/meteor.tscn")

var xp:int = 0
var piece:int = 940
signal xp_piece(valeur_xp: int, valeur_piece: int)
const SPEED = 150

func _ready() -> void:
	# Forcer les collisions du Joueur (Layer 1, Mask Vide)
	collision_layer = 1
	collision_layer = 16
	collision_mask = 0
	# Forcer les collisions du Radar (Layer Vide, Mask 2)
	radar.collision_layer = 0
	radar.collision_mask = 2
	
	equiper_nouveau_sort(projectile, eau, "projectile", 1, 900.0,1)



func _physics_process(delta: float) -> void:

	# Deplacement
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()
	# Animation
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true



func equiper_nouveau_sort(la_scene, element, categorie, temps_recharge, portee, level):
	# On vérifie la limite stricte de 5 armes
	if $Arsenal.get_child_count() < 5:
		
		# 1. On fabrique un nouveau lanceur
		var nouveau_lanceur = modele_lanceur.instantiate()
		
		# 2. On le remplit avec les infos de la boutique
		nouveau_lanceur.scene_sort = la_scene
		nouveau_lanceur.element_sort = element
		nouveau_lanceur.type = categorie
		nouveau_lanceur.portee = portee
		nouveau_lanceur.niveau_sort = level
		
		# 3. On l'attache a l'arsenal
		$Arsenal.add_child(nouveau_lanceur)
		
		# 4. On règle son chronomètre par le code et on le lance !
		nouveau_lanceur.get_node("cadence").wait_time = temps_recharge
		nouveau_lanceur.get_node("cadence").start()
	
# Collectible
func _on_collecteur_area_entered(area: Area2D) -> void:
	if "etat" in area and area.etat == "attente":
		area.cible = self # On dit au loot : "Ta cible, c'est MOI (self) !"
		area.etat = "pret" # On réveille le loot
	
func maj_collectible(type:int):
	if type == 0:
		xp +=1
	else:
		piece +=1
	xp_piece.emit(xp,piece)
	
	
	
	
	
	
	
	
	
	
	
	
	
