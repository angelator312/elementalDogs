extends Node2D
class_name Card
@export var name_of_card="1"
@export var change_on_enter=100
var powerful=0 #0-not powerful; 1- powerful; 2 - very powerful
var explosive=false
signal End
signal alwaysUsed
func _init(ind,pos:=Vector2(0,0)) -> void:
	add_child(Sprite2D.new())
	#get_children()[0].rotation_degrees=90.0
	position=pos
func simplePlay(event:String,arguments):
	End.emit()
func simplePlay2(event:String,arguments):
	alwaysUsed.emit()
var on_play=simplePlay;
func simpleOnGet(arguments):
	pass
var on_get=simpleOnGet;
func mouse_entered():
	print("mouse_entered()")
	self.position.y-=GlobalConfig.get_change_on_enter_mouse()
	for i in get_children():
		pass
func mouse_exited():
	print("mouse_exited()")
	self.position.y+=GlobalConfig.get_change_on_enter_mouse()
func _ready() -> void:
	var sprite_3d:Sprite2D=self.get_child(0);
	print(name_of_card)
	sprite_3d.texture=load("res://Cards/images/"+name_of_card+".png")
	#sprite_3d.set("size",Vector2(.5,.5))
	sprite_3d.scale=Vector2(.5,.5)
