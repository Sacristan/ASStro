extends "res://_reference/Scripts/player.gd"
class_name Player

const LayerMask = 0b00000000000000000010 #assteroids
#export(AnimationPlayer) var IntersectLayer
const Explosive = preload("res://scenes/actors/props/Dynamite.tscn")

var canPlaceExplosive = true

func _ready():
	Global.player = self

func _input(event):
	._input(event)
	
	if(Input.is_action_just_pressed(attack_command)):
		tryPlaceExplosive()

func tryPlaceExplosive():
	if(!canPlaceExplosive):
		return
	canPlaceExplosive = true
	placeExplosive()
	
func placeExplosive():
	var explosive = Explosive.instance()
	Global.gameManager.rootNode.add_child(explosive)
	explosive.global_transform.origin = getPlacementPos()
	explosive.global_transform.basis = global_transform.basis
	
func getPlacementPos():
	var pos = global_transform.origin
#	var result = get_world().direct_space_state.intersect_ray(global_transform.origin, -global_transform.basis.y,[], LayerMask)
#
#	if(!result.empty()):
#		pos = result["position"]
	
	return pos - global_transform.basis.z * 3 - global_transform.basis.y * 2
