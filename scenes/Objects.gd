extends Node2D

func _on_player_grab(enemies : Array):
	for enemy in enemies:
		for tree in enemy.near_trees:
			if tree.shadow.tendril_on:
				continue
			else:
				enemy.freeze()
				tree.shadow.grab(enemy)
				break
