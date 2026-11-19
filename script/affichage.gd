extends CanvasLayer

func _ready() -> void:
	pass


func _player_xp_piece(xp: int, piece: int) -> void:
	$piece.text = str(piece)
	$xp.text = str(xp)

func _after_achat( piece: int) -> void:
	$piece.text = str(piece)
