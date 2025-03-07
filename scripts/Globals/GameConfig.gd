extends Node
# That is only for one game!
const DEFAULT_MAX_CARDS:=5
var max_cards:=DEFAULT_MAX_CARDS
func on_start()->void:
	reset_variables()
	
func reset_variables()->void:
	max_cards=DEFAULT_MAX_CARDS
	
