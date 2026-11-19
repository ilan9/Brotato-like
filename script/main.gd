extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%player.xp_piece.connect(%affichage._player_xp_piece)
	%Boutique._after_achat.connect(%affichage._after_achat)





func _on_generateur_fin_vague() -> void:
	%Boutique.visible = true
	%Boutique.piece = %player.piece
	%Boutique.raffraichir()


func _on_boutique_joueur_pret() -> void:
	%Boutique.visible = false
	%generateur.change_vague()
	%player.piece = %Boutique.piece
