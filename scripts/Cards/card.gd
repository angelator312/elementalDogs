extends Node2D
class_name Card
@export var name_of_card="1"
@export var change_on_enter=100
var powerful=0 #0-not powerful; 1- powerful; 2 - very powerful
var explosive=false
signal End
signal alwaysUsed
func _init(ind,pos:=Vector2(0,0)) -> void:
	add_child(Area2D.new())
	get_child(0).name="dragArea"
	$dragArea.add_child(Sprite2D.new())
	$dragArea.mouse_entered.connect(mouse_entered)
	$dragArea.mouse_exited.connect(mouse_exited)
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
func mouse_exited():
	print("mouse_exited()")
	self.position.y+=GlobalConfig.get_change_on_enter_mouse()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.position.x+=GlobalConfig.get_change_on_up_mouse_wheel()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.position.x-=GlobalConfig.get_change_on_up_mouse_wheel()
func _ready() -> void:
	var sprite_3d:Sprite2D=$"dragArea".get_child(0);
	print(name_of_card)
	sprite_3d.texture=load("res://Cards/images/"+name_of_card+".png")
	#sprite_3d.set("size",Vector2(.5,.5))
	sprite_3d.scale=Vector2(.5,.5)
	create_collision_polygon(sprite_3d.texture.get_image(),Vector2(.5,.5))

func create_collision_polygon(texture,scale):
		var bm = BitMap.new()
		bm.create_from_image_alpha(texture)
		# in the original script, it was Rect2(position.x, position.y ...)
		var rect = Rect2(0, 0, texture.get_width(), texture.get_height())
		# change (rect, 2) for more or less precision
		# for ex. (rect, 5) will have the polygon points spaced apart more
		# (rect, 0.0001) will have points spaced very close together for a precise outline
		var my_array = bm.opaque_to_polygons(rect, 2)
		# optional - check if opaque_to_polygons() was able to get data
		#print(my_array)
		var my_polygon = Polygon2D.new()
		my_polygon.set_polygons(my_array)
		var offsetX = 0
		var offsetY = 0
		if (texture.get_width() % 2 != 0):
			offsetX = 1
		if (texture.get_height() % 2 != 0):
			offsetY = 1
		for i in range(my_polygon.polygons.size()):
			var my_collision = CollisionPolygon2D.new()
			my_collision.set_polygon(my_polygon.polygons[i])
			my_collision.position -= Vector2((texture.get_width() / 2) + offsetX, (texture.get_height() / 2) + offsetY) * scale.x
			my_collision.scale = scale
			$"dragArea".call_deferred("add_child", my_collision)
