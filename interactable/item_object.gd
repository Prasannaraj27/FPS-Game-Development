extends Interactable

class_name ItemObject

const Item = preload("res://inventory/item.gd");
const ItemKind = preload("res://inventory/item_kind.gd");

var item_amount := 0 setget set_item_amount, get_item_amount;
var item: Item = null;

func init(amount: int, i: Item) -> Interactable:
	item_amount = amount;
	item = i;
	
	var color: Color = Color.blueviolet;
	match item.kind:
		ItemKind.Metal:
			color = Color.gray;
		ItemKind.Wood:
			color = Color.brown;
		ItemKind.Useless:
			color = Color.black;
		ItemKind.Ammo:
			color = Color.yellow;
		_:
			pass
			
	var mat := SpatialMaterial.new();
	mat.albedo_color = color;
	mesh.material_override = mat;

	return self

func create_tooltip() -> String:
	return str(item_amount) + "x " + item._name;

func get_item_amount() -> int:
	return item_amount;

func set_item_amount(amount: int) -> void:
	item_amount = amount;
	tooltip.text = create_tooltip();
