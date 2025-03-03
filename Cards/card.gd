extends Node3D
class_name Card
@export var name_of_card="1"
var powerful=0 #0-not powerful; 1- powerful; 2 - very powerful
var explosive=false
signal End
signal alwaysUsed
func _init(ind,pos:=Vector3(0,0,0)) -> void:
	add_child(Sprite3D.new())
	get_children()[0].rotation_degrees.x=90
	position=pos
	if(ind<0):
		position.y=-1000
	else:
		position.y=ind*.5+1
func simplePlay(event:String,arguments):
	End.emit()
func simplePlay2(event:String,arguments):
	alwaysUsed.emit()
var on_play=simplePlay;
func simpleOnGet(arguments):
	pass
var on_get=simpleOnGet;
func _ready() -> void:
	var sprite_3d:Sprite3D=get_children()[0];
	print(name_of_card)
	sprite_3d.texture=load("res://Cards/images/"+name_of_card+".png")
	sprite_3d.set("size",Vector2(.5,.5))
	sprite_3d.scale=Vector3(.1,.1,1)
