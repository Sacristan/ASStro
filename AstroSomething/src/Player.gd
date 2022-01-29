extends "res://_reference/Scripts/player.gd"
class_name Player

const LayerMask = 0b00000000000000000010 #assteroids
#export(AnimationPlayer) var IntersectLayer
const Explosive = preload("res://scenes/actors/props/Dynamite.tscn")

var currentAsteroid = null
var queued_asteroid = null

const healthDeductPerSecond = 0.1 #10 perc health rem/s
const healthRegenRate = healthDeductPerSecond * 0.5 #30perc per second
const healthRegenTimeout = 3 #seconds after regen starts working

var health = 1.0
var lastTimeReceivedDamage = 0
var currentTime = 0

signal onDied()
signal onHealthChanged(health)
signal onDamageReceived(health)

var died = false

func _ready():
	Global.player = self

func _process(delta):
	currentTime+=delta
	
	if(is_on_assteroid() && is_on_floor()):
		deductHealth(delta)
		emit_signal("onDamageReceived", health)
	
	if lastTimeReceivedDamageDelta() >= healthRegenTimeout:
		regenerateHealth(delta)
		
func _input(event):
	._input(event)
	
	if(Input.is_action_just_pressed(attack_command)):
		tryPlaceExplosive()

func lastTimeReceivedDamageDelta():
	return currentTime - lastTimeReceivedDamage

func entered_asteroid(asteroid):
#	print("asteroid enter: " + str(asteroid))
	
	if(asteroid):
		queued_asteroid = asteroid
		
		while(!is_on_floor()):
#			print("tick enter asteroid "+str(asteroid))
			yield(Global.wait(0.1),"timeout")
				
		if(queued_asteroid == asteroid):
			currentAsteroid = queued_asteroid
#			print("assign asteroid: "+str(queued_asteroid))
	
func left_asteroid(asteroid):
	if(currentAsteroid == asteroid):
		currentAsteroid = null

func tryPlaceExplosive():
	if(!is_on_floor() || currentAsteroid==null):
		return

	var asteroidBody = currentAsteroidBody()
	
	if(is_on_assteroid() && !asteroidBody.has_explosive()):
		placeExplosiveOn(asteroidBody)
	
func placeExplosiveOn(body):
	var explosive = Explosive.instance()
	body.assign_explosive(explosive)
	
	explosive.global_transform.origin = getPlacementPos()
	explosive.global_transform.basis = global_transform.basis
	
func getPlacementPos():
	var pos = global_transform.origin
#	var result = get_world().direct_space_state.intersect_ray(global_transform.origin, -global_transform.basis.y,[], LayerMask)
#
#	if(!result.empty()):
#		pos = result["position"]
	
	return pos - global_transform.basis.z * 3 - global_transform.basis.y * 2

func currentAsteroidBody():
	if(currentAsteroid):
		return currentAsteroid.get_node("Body")
	return null

func is_on_assteroid():
	return currentAsteroidBody() is Assteroid

func is_on_planetoid():
	return currentAsteroidBody() is Planetoid

func is_safe():
	return is_on_planetoid() && is_on_floor()

func regenerateHealth(delta):
	updateHealth(clamp(health+healthRegenRate*delta, 0, 1) )
	
func deductHealth(delta):
	updateHealth(clamp(health-healthDeductPerSecond*delta, 0, 1))
	lastTimeReceivedDamage = currentTime
	
	if(health <= 0):
		die()
	
func updateHealth(health):
	self.health = health
	emit_signal("onHealthChanged", health)
	
func die():
	died = true
	set_process(false)
	set_physics_process(false)
	emit_signal("onDied")
