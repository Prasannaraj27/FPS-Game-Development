extends Control

class_name Inventory

const ItemFrame = preload("res://prefabs/item_frame.tscn");
const ItemKind = preload("res://inventory/item_kind.gd");

onready var grid = $scroll/grid;
onready var scroll = $scroll;
onready var scrollbar = scroll.get_v_scrollbar();

var separation := 5.0;
var slot_size := 75.0;
var full_size := slot_size + separation;
var slots := Array();
var num_slots := 0;
var used_slots := 0;
var changed := false;

const DEFAULT_SLOTS := 128;

func _ready() -> void:
	var root: Viewport = get_tree().root;
	var size: Vector2 = root.size;
	var grid_columns: int = floor(size.x / full_size);
	var grid_rows: int = floor(size.y / full_size);
	var grid_size: Vector2 = Vector2(
		grid_columns * slot_size + (grid_columns - 1) * separation,
		grid_rows * slot_size + (grid_rows - 1) * separation
	);
	var scroll_size: Vector2 = Vector2(grid_size.x + scrollbar.rect_size.x, grid_size.y);
	var scroll_padding = size - scroll_size;
	var grid_padding = scroll_size - grid_size;
	
	scroll.rect_size = scroll_size;
	scroll.rect_min_size = scroll_size;
	scroll.rect_position = scroll_padding / 2.0;
	
	grid.rect_size = grid_size;
	grid.rect_min_size = grid_size;
	grid.columns = grid_columns;
	grid.add_constant_override("hseparation", separation);
	grid.add_constant_override("vseparation", separation);

	build();
	
func create_slot() -> void:
	var item_frame = ItemFrame.instance();
	item_frame.rect_size = Vector2(slot_size, slot_size);
	item_frame.rect_min_size = Vector2(slot_size, slot_size);
	grid.add_child(item_frame);
	slots.append(item_frame);

func build() -> void:
	slots.empty();
	num_slots = 0;
	extend(DEFAULT_SLOTS);

func extend(slots) -> void:
	num_slots += slots;
	for _i in slots:
		create_slot();

### returns number of overflowed items
func add_items(item: Item, amount: int) -> int:
	if amount <= 0:
		return 0;
		
	### go over the already used slots to look for
	### already existing stacks
	for i in range(used_slots):
		var slot = slots[i]
		### is the slot is not full and the item type is the same
		### add as much items as possible to that slot
		if (slot.item_kind == item.kind) and (not slot.is_full()):
			amount = slot.add(amount);
			### if no more items to add return
			if amount == 0:
				break;

	### if there are still items to add
	### then start consuming unused slots
	while (amount != 0) and (used_slots < num_slots):
		var slot = slots[used_slots];
		slot.assign(item);
		amount = slot.add(amount);
		used_slots += 1;

	### return amount of overflowed items
	return amount;
