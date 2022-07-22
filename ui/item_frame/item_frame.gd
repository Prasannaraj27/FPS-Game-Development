extends PanelContainer

onready var texture_rect = $image;
onready var text_amount = $amount;

var item_kind := -1;
var item_amount := 0;

const MAX_ITEM_STACK := 256;

func assign(item: Item) -> void:
	texture_rect.expand = true;
	item_kind = item.kind;
	texture_rect.texture = item.image();
	text_amount.text = str(item_amount);
	hint_tooltip = item.description;

func add(amount: int) -> int:
	var unclamped = item_amount + amount;
	item_amount = clamp(unclamped, 0, MAX_ITEM_STACK);
	text_amount.text = str(item_amount);
	return unclamped - item_amount;

func is_full() -> bool:
	return capacity_free() == MAX_ITEM_STACK;

func capacity_free() -> int:
	return MAX_ITEM_STACK - item_amount;

func capacity_used() -> int:
	return item_amount;
