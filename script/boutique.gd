extends CanvasLayer

signal joueur_pret
signal _after_achat(piece:int)
var piece = 0

var feu = preload("res://sort/element/feu.tres")
var vent = preload("res://sort/element/vent.tres")
var eau = preload("res://sort/element/eau.tres")
var terre = preload("res://sort/element/terre.tres")
var foudre = preload("res://sort/element/foudre.tres")
var list_elem = [feu,vent,eau,terre,foudre]

var projectile = preload("res://sort/type/info/projectile.tres")
var laser = preload("res://sort/type/info/laser.tres")
var aura = preload("res://sort/type/info/aura.tres")
var meteor = preload("res://sort/type/info/meteor.tres")
var list_type = [projectile,laser,aura,meteor]

var carte_boutique = preload("res://scene/carte_boutique.tscn")

# Icone
var icone = preload("res://asset/boutique/Icons_sort/fire_ball.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raffraichir()

func raffraichir():
	for carte in $Control/VBoxContainer/Rayon.get_children():
		if carte is not Button:
			carte.queue_free()
	for carte in $Control/VBoxContainer/Equiped.get_children():
		if carte is not Button:
			carte.queue_free()
	for i in range(5):
		create_carte_boutique()
	
	var arsenal = %player.get_node("Arsenal")
	
	# Pour chaque vraie arme possédée :
	for sort in arsenal.get_children():
		# On crée une carte "possédée" (random=false, possede=true)
		var ressource_type_trouvee = null
		for info in list_type:
			if info.nom == sort.type: # On compare les noms (assure-toi que info.nom est le bon nom de variable !)
				ressource_type_trouvee = info
				break
		
		# Si on a trouvé la bonne ressource, on fabrique la carte !
		if ressource_type_trouvee != null:
			create_carte_boutique(false, sort.element_sort, ressource_type_trouvee, 1, true, sort)
		

func create_carte_boutique(random = true, element=feu,type=projectile,level=1,possede=false,sort_joueur = null):
	if random == true :
		element = list_elem.pick_random()
		type = list_type.pick_random()
		level = randi_range(1,5)

	var nouv_carte = carte_boutique.instantiate()
	if possede == false:
		$Control/VBoxContainer/Rayon.add_child(nouv_carte)
	else:
		$Control/VBoxContainer/Equiped.add_child(nouv_carte)
	nouv_carte.nom.text = type.nom + " " + element.nom_element + " (Niv." + str(level) + ")"
	nouv_carte.image.texture = icone
	nouv_carte.type.text = "Type: " + type.nom
	nouv_carte.element.text = "Element: " + element.nom_element
	var degat = type.degat * element.degats_bonus *level
	var portee = type.portee
	var cadence = type.cadence
	nouv_carte.stat.text = "Statistiques :\n Effet: " + str(element.nom_etat) + "\n Degat: " + str(degat) + "\n Portée : " + str(portee) + "\n Cadence : " +  str(cadence) + " sec"
	var prix_calcule = int(round(type.prix_base * pow(level, 1.6)))
	
	
	if possede == false:
		nouv_carte.achat.pressed.connect(bouton_achat.bind(nouv_carte, prix_calcule, type, element,level))
		nouv_carte.achat.text = str(prix_calcule) + " coins" # On l'affiche en texte
	else:
		nouv_carte.achat.pressed.connect(bouton_vente.bind(nouv_carte, prix_calcule,sort_joueur))
		nouv_carte.achat.text = str(int(prix_calcule / 2)) + " coins" # On l'affiche en texte
func _on_raffraichir_pressed() -> void:
	raffraichir()

func _on_pret_pressed() -> void:
	joueur_pret.emit()

func bouton_achat(carte_clique, prix_de_la_carte: int, type , element,level):
	# 1. On vérifie si on a assez de pièces
	if piece >= prix_de_la_carte:
		# 2. On soustrait l'argent
		piece -= prix_de_la_carte
		_after_achat.emit(piece)
		# 4. PLUS TARD : C'est ici que tu devras donner l'arme au Joueur !
		%player.equiper_nouveau_sort(type.scene_associee, element, type.nom, type.cadence, type.portee,level)
		
		# 3. On détruit la carte visuellement
		carte_clique.queue_free()
		raffraichir()
		
		
func bouton_vente (carte_clique, prix_carte, sort_joueur ):
	piece += prix_carte / 2
	_after_achat.emit(piece)
	
	# On détruit la carte visuelle dans la boutique
	carte_clique.queue_free()
	
	# On détruit la VRAIE arme dans l'arsenal du joueur !
	if sort_joueur != null:
		sort_joueur.queue_free()

	
