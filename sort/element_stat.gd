extends Resource
# Cette ligne est magique : elle crée une nouvelle catégorie dans Godot !
class_name ElementStatistiques

# On prépare les cases que tu pourras remplir dans l'Inspecteur
@export var nom_element: String = "Inconnu"
@export var couleur: Color = Color.WHITE
@export var degats_bonus: float = 1.0
@export var nom_etat: String = "Aucun" # Ex: "Brûlure", "Mouillé"
