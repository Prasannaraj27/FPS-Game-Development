extends Interactable

class_name ItemObject

const Item = preload("res://inventory/item.gd");
const ItemKind = preload("res://inventory/item_kind.gd");

var item_amount := 50;
var item_kind: int = -1;

func init(item_amount: int, item_kind: int):
	self.item_amount = item_amount;
	self.item_kind = item_kind;
	
	var color: Color = Color.blueviolet;
	match item_kind:
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
	$mesh.material_override = mat;

func create_tooltip():
	return str(self.item_amount) + "x " + Item.name_from(self.item_kind);
