extends Node2D
@export var scene_sort: PackedScene
@export var element_sort: Resource
@export var type: String # "projectile", "aura", ou "meteor"
@export var portee: float = 400.0
@export var niveau_sort: int = 1
var niveau: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#On "détache" le dessin du cercle pour qu'il soit unique a ce lanceur
	$radar/CollisionShape2D.shape = $radar/CollisionShape2D.shape.duplicate()#On "détache" le dessin du cercle pour qu'il soit unique
	$radar/CollisionShape2D.shape.radius = portee
	$radar.collision_layer = 0 # Le radar est un fantôme
	$radar.collision_mask = 0  # Il ferme tous ses yeux
	$radar.set_collision_mask_value(4, true)

# Récuperer les Mobs
func _on_cadence_timeout() -> void:

	# Repérage des ennemis
	var list_mob = $radar.get_overlapping_bodies()
	if len(list_mob) > 0:
		var enemis_vise = recup_mob_proche(list_mob)
		tirer(enemis_vise)
		
func comp_dist_mob(a,b):
	#juge
	var dist_a = global_position.distance_to(a.global_position)
	var dist_b = global_position.distance_to(b.global_position)
	return dist_a <= dist_b
	
func recup_mob_proche(list_mob):
	list_mob.sort_custom(comp_dist_mob)
	var five_mob = []
	five_mob = list_mob.slice(0,5)
	var mob = five_mob.pick_random()
	return mob
	
# Tirer avec le sort
func tirer(mob):
	var nouveau_sort = scene_sort.instantiate()
	nouveau_sort.element = element_sort
	nouveau_sort.niveau = niveau_sort
	
	# Le fameux "Aiguillage" magique de Godot
	match type:
		"projectile":
			nouveau_sort.global_position = global_position
			nouveau_sort.direction = global_position.direction_to(mob.global_position)
			get_tree().current_scene.add_child(nouveau_sort) # On met sur main
			
		"meteor":
			nouveau_sort.global_position = mob.global_position
			nouveau_sort.global_position.y = -100
			nouveau_sort.pos_finaly = mob.global_position.y
			get_tree().current_scene.add_child(nouveau_sort) # Sur main
			
		"aura":
			# Le Lanceur est dans l'Arsenal, qui est dans le Joueur. 
			add_child(nouveau_sort)
			$cadence.stop() # on a besoin de crée qu'une seul aura

		"laser":
			nouveau_sort.global_position = global_position
			nouveau_sort.direction = global_position.direction_to(mob.global_position)
			get_tree().current_scene.add_child(nouveau_sort) # On met sur main
	
