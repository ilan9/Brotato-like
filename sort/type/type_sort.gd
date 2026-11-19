extends Resource
class_name TypeSort # C'est le nom magique qui va apparaître dans l'éditeur !

@export var nom: String
@export var degat: float
@export var portee: float
@export var cadence: float
@export var prix_base: int

# TRÈS IMPORTANT : On garde un lien vers la vraie scène pour quand le joueur l'achète !
@export var scene_associee: PackedScene
