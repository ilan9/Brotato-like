extends Node2D

var num_vague:int = 0
var nbr_mob_total:int
var nbr_mob:int
var taille_grp_max:int
var en_boutique = false

var pv_mob
var att_mob
var vit_mob

var mob = preload("res://scene/mob.tscn")
@onready var position_sapwn: PathFollow2D = $"../Path2D/PathFollow2D"

signal fin_vague

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_vague()

func change_vague():
	await aff_deb_vague()
	en_boutique = false
	num_vague +=1
	nbr_mob_total = round(14 * num_vague * 1.3)
	nbr_mob = nbr_mob_total
	taille_grp_max = round(nbr_mob_total/10)
	
	pv_mob = round(10*pow(1.25,num_vague))
	att_mob = round(4 + (2*num_vague))
	


func _on_timer_timeout() -> void:
	if en_boutique == false:
		if nbr_mob != 0:
			var taille_grp = randi_range(1, taille_grp_max)
			taille_grp = min(taille_grp,nbr_mob)
			for i in range(taille_grp):
				create_mob()
			nbr_mob -= taille_grp
		elif get_tree().get_nodes_in_group("mob").size() == 0:
			await aff_fin_vague()
			fin_vague.emit()
			en_boutique = true
		
		
func create_mob():
	var nouv_mob = mob.instantiate()
	nouv_mob.add_to_group("mob")
	position_sapwn.progress_ratio = randf()
	nouv_mob.global_position = position_sapwn.global_position
	nouv_mob.vie = pv_mob
	nouv_mob.attaque = att_mob
	get_parent().add_child(nouv_mob)
		
func aff_fin_vague():
	$Vague.show()
	$Vague.text = "Fin de la Vague " + str(num_vague)
	$Vague.modulate.a = 1
	var anim_Vague = create_tween().set_parallel()
	anim_Vague.tween_property($Vague,"modulate:a",0,0.75)
	await anim_Vague.finished
		
func aff_deb_vague():
	$deb_vague.show()
	$deb_vague.text = "Vague " + str(num_vague + 1)
	$deb_vague.modulate.a = 1
	var anim_Vague = create_tween().set_parallel()
	anim_Vague.tween_property($deb_vague,"modulate:a",0,0.75)
	await anim_Vague.finished
		
		
		
		
		
