extends Spatial

onready var handler = $handler;
onready var player = $player;
const i = preload("res://prefabs/item_object.tscn");
const ItemKind = preload("res://inventory/item_kind.gd");

onready var world = get_node("world");

func _ready():
	self.handler.init(self.player);
	self.handler.create_object(i, self.player.global_transform.origin + Vector3(0.0, 10.0, 0.0), [50, ItemKind.Metal]);
	self.handler.create_object(i, self.player.global_transform.origin + Vector3(0.0, 10.0, 0.0), [19, ItemKind.Wood]);
