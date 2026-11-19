extends CharacterBody2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var loot = preload("res://scene/loot.tscn")

var player:CharacterBody2D
var SPEED = 45
var vie = 1
var attaque = 1
var inverse_dir = 1

func _ready() -> void:
	player = get_tree().get_first_node_in_group("joueur")
	set_collision_mask_value(4, true)
	collision_mask = 0
	animation.play("walk")

func _physics_process(delta: float) -> void:
	if player != null and vie > 0:
		go_to_player()

func go_to_player():
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED * inverse_dir
	if direction[0] > 0:
		animation.flip_h = true
	elif direction[0] < 0:
		animation.flip_h = false
	move_and_slide()
	

func degat(degat_sub:int,etat:String):
	# gestion des bonus d'etat element plus tard
	aff_degat(degat_sub)
	vie -= degat_sub
	SPEED = 0
	if vie <= 0:
		SPEED = 0
		remove_from_group("mob")
		collision_layer = 0
		animation.play("dead")
	else:
		SPEED = 45
		animation.stop()
		animation.play("hurt")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "dead":
		mort()
	elif animation.animation == "hurt":
		animation.play("walk")

func mort():
	var anim_mort = create_tween()
	anim_mort.tween_property(animation, "modulate:a", 0, 0.5) 
	# XP
	var nb_xp = randi_range(1, 2) 
	for i in range(nb_xp):
		var nouv_xp = loot.instantiate()
		nouv_xp.type = 0 
		nouv_xp.global_position = global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
		get_tree().current_scene.add_child(nouv_xp)
	# piece
	var num_vague = get_tree().current_scene.get_node("generateur").num_vague
	var chance_piece = max(25, 100 - (5 * num_vague))
	var jet_de_des = randi_range(1, 100)
	if jet_de_des <= chance_piece:
		var nouv_piece = loot.instantiate()
		nouv_piece.type = 1 # On FORCE le type à 1 (Pièce)
		nouv_piece.global_position = global_position + Vector2(randf_range(-15, 15), randf_range(-15, 15))
		get_tree().current_scene.add_child(nouv_piece)

	anim_mort.tween_callback(queue_free)
	
	
	
func aff_degat(degat_sub):
	$Degat.text = str(degat_sub)
	$Degat.show()
	$Degat.modulate.a = 1
	$Degat.position.y = -20
	var anim_degat = create_tween().set_parallel()
	anim_degat.tween_property($Degat,"modulate:a",0,0.75)
	anim_degat.tween_property($Degat,"position:y",$Degat.position.y -20,0.5)
	
func effect(element,degat_initial):
	match element.nom_element:
		"Eau":
			SPEED = 22
			await get_tree().create_timer(5.0).timeout
			if is_instance_valid(self) and vie > 0:
				SPEED = 45
			
		"Feu":
			for i in range(4):
				degat(max(1, int(degat_initial * 0.25)),"brule")
				await get_tree().create_timer(0.75).timeout
				
		"Terre":
			SPEED = 0
			await get_tree().create_timer(3.0).timeout
			if is_instance_valid(self) and vie > 0:
				SPEED = 45
			
		"Foudre":
			for i in range(4):
				if is_instance_valid(self) and vie > 0:
					SPEED = 0
					degat(max(1, int(degat_initial * 0.10)),"electrifie")
					await get_tree().create_timer(0.5).timeout
					if is_instance_valid(self) and vie > 0:
						SPEED = 45
						await get_tree().create_timer(0.5).timeout
			
		"Vent":
			inverse_dir = -1
			await get_tree().create_timer(1.0).timeout
			inverse_dir = 1
	
	
	
	
	
	
	
