extends Area

func _ready():
	connect("body_entered", self, "back")

func back(other: Node):
	print("hello")
