extends PanelContainer

var texture_rect = null;
var text_amount = null;
var item_kind := -1;
var item_amount := 0;

const MAX_ITEM_STACK := 256;

func assign(item: Item) -> void:
	self.texture_rect = $image;
	self.text_amount = $amount;
	self.texture_rect.expand = true;
	self.item_kind = item.kind;
	self.texture_rect.texture = item.image();
	self.text_amount.text = str(item_amount);
	self.hint_tooltip = item.description;

func add(amount: int) -> int:
	var unclamped = self.item_amount + amount;
	self.item_amount = clamp(unclamped, 0, MAX_ITEM_STACK);
	self.text_amount.text = str(self.item_amount);
	return unclamped - self.item_amount;

func is_full() -> bool:
	return self.capacity_free() == MAX_ITEM_STACK;

func capacity_free() -> int:
	return MAX_ITEM_STACK - self.item_amount;

func capacity_used() -> int:
	return self.item_amount;
