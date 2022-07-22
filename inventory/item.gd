extends Node

const ItemKind = preload("res://inventory/item_kind.gd");

class_name Item

var kind: int = ItemKind.Unknown;
var description := String();
var _name := String();

func _init(kind: int):
	self.kind = kind;
	self.description = description_from(kind);
	self._name = name_from(kind);

func equals(other: Item) -> bool:
	return self.kind == other.kind;
	
func path() -> String:
	return "res://assets/" + self._name + ".png";

func image() -> Texture:
	var texture = ImageTexture.new();
	var img = Image.new();
	img.load(self.path());
	texture.create_from_image(img);
	return texture;

static func description_from(kind: int):
	match kind:
		ItemKind.Metal:
			return "this is metal.";
		ItemKind.Wood:
			return "this is wood.";
		ItemKind.Useless:
			return "this is useless.";
		ItemKind.Ammo:
			return "good for shooting things.";
		_:
			return "[unknown]";
			
static func name_from(kind: int):
	match kind:
		ItemKind.Metal:
			return "metal";
		ItemKind.Wood:
			return "wood";
		ItemKind.Useless:
			return "useless";
		ItemKind.Ammo:
			return "ammo";
		_:
			return "[unknown]";
