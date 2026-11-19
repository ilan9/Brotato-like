extends Area2D
@export var element: ElementStatistiques
@onready var sprite: Sprite2D = $Sprite2D

var degat = 4
var direction:Vector2
var nom = "Aura"
var niveau: int = 1


func _ready() -> void:
	sprite.self_modulate = element.couleur
	collision_layer = 1
	set_collision_mask_value(4, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	
		




func _on_timer_timeout() -> void:
	attaquer()
		

func _on_body_entered(body: Node2D) -> void:
	attaquer()

func attaquer():
	var list_mob = get_overlapping_bodies()
	var degat_sort = int(degat * element.degats_bonus * niveau)
	var etat = element.nom_etat
	for body in list_mob:
		if body.is_in_group("mob"):
			body.degat(degat_sort,etat)
			body.effect(element,degat_sort)
	
