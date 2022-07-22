extends Spatial

onready var handler = $handler;
onready var player = $player;
const i = preload("res://prefabs/item_object.tscn");
const ItemKind = preload("res://inventory/item_kind.gd");

onready var world = get_node("world");

func _ready():
	var spawn_position: Vector3 = self.player.global_transform.origin + Vector3(0.0, 10.0, 0.0);
	self.handler.init(self.player);
	self.handler.create_object(i, spawn_position, [50000, Item.new(ItemKind.Metal)]);
	self.handler.create_object(i, spawn_position, [1900, Item.new(ItemKind.Wood)]);
