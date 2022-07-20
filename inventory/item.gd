const ItemKind = preload("res://inventory/item_kind.gd");

class_name Item

var kind: ItemKind = null;

func _init(k: ItemKind):
	kind = k;
