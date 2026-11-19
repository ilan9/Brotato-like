extends Area2D
@export var element: ElementStatistiques
@onready var sprite: Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("joueur")
var niveau: int = 1

var aura = preload("res://sort/type/aura.tscn")

var vitesse = 500
var degat = 40
var direction:Vector2 = Vector2.DOWN
var pos_finaly:float
var a_atteri = false
var nom = "Meteor"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.self_modulate = element.couleur
	collision_layer = 1
	set_collision_mask_value(4, true)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * vitesse * delta # deplacement
	if a_atteri == false:
		if global_position.y >= pos_finaly :
			a_atteri = true
			vitesse = 0
			$Sprite2D.hide()
			var nouv_aura = aura.instantiate()
			nouv_aura.element = element
			nouv_aura.scale = Vector2(2, 2)
			nouv_aura.degat = degat
			nouv_aura.global_position = global_position
			nouv_aura.niveau = niveau
			get_parent().add_child(nouv_aura)
			await get_tree().create_timer(10.0).timeout
			nouv_aura.queue_free()
			queue_free()
		
		
		
		
		
		
		
		
