extends Area2D
var piece = preload("uid://73xk8dw7wpsn")
var xp = preload("uid://cp77ioue8kljy")

var type: int = 0
var etat = "attente"
var direction:Vector2
var speed = 100
var cible: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type == 0:
		$Sprite2D.texture = xp
	else:
		$Sprite2D.texture = piece
	collision_mask = 16
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if etat == "pret" and cible != null:
		var direction = global_position.direction_to(cible.global_position)
		global_position += direction * speed * delta
		speed += 400 * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player": # Ou body.is_in_group("joueur")
		if type == 0:
			body.maj_collectible(0)
		else:
			body.maj_collectible(1)
		
		queue_free()
