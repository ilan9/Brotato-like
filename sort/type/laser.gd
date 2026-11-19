extends Area2D
@export var element: ElementStatistiques
@onready var sprite: Sprite2D = $Sprite2D


var vitesse = 400
var degat = 6
var direction:Vector2
var nom = "Laser"
var niveau: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.self_modulate = element.couleur
	rotation = direction.angle()
	collision_layer = 1
	set_collision_mask_value(4, true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		global_position += direction * vitesse * delta # deplacement


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mob"):
		var degat_tot = int(degat * element.degats_bonus * niveau)
		var etat = element.nom_etat
		body.degat(degat_tot,etat)
		body.effect(element,degat_tot)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
