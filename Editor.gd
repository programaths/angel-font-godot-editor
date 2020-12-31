extends Control

var current_item_idx = -1
var metadada = []

onready var text_rect = $VBoxContainer/HBoxContainer/MarginContainer/TextureRect

func _ready():
	$VBoxContainer/Button.connect("pressed",self,"load_pic")
	$FileDialog.connect("file_selected",self,"file_selected")
	$VBoxContainer/HBoxContainer/VBoxContainer/ButtonAddItem.connect("pressed",self,"add_item")
	$VBoxContainer/HBoxContainer/VBoxContainer/ButtonRemoveItem.connect("pressed",self,"rem_item")
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxId.connect("value_changed",self,"changed_id")
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox2Top.connect("value_changed",self,"changed_top")
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox3Left.connect("value_changed",self,"changed_left")
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox4Width.connect("value_changed",self,"changed_width")
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxHeight.connect("value_changed",self,"changed_height")
	$VBoxContainer/HBoxContainer/VBoxContainer/ItemList.connect("item_selected",self,"item_selected")
	$VBoxContainer/HBoxContainer/VBoxContainer/ItemList.connect("nothing_selected",self,"none_selected")
	text_rect.connect("draw",self,"draw_boxes")
	text_rect.connect("gui_input",self,"rect_input")

var drawing_rect = false

func rect_input(input):
	if current_item_idx==-1: return
	if input is InputEventMouseMotion and drawing_rect:
		var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
		var mtd = item_list.get_item_metadata(current_item_idx)
		$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox4Width.value = input.position.x - mtd.left
		$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxHeight.value = input.position.y - mtd.top
		update_text_rect()
	if input is InputEventMouseButton:
		if input.button_index==BUTTON_LEFT:
			if input.pressed:
				if not drawing_rect:
					$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox2Top.value = input.position.y
					$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox3Left.value = input.position.x
					drawing_rect=true
					update_text_rect()
					print("draw rect")
			else:
				var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
				var mtd = item_list.get_item_metadata(current_item_idx) 
				$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox4Width.value = input.position.x - mtd.left
				$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxHeight.value = input.position.y - mtd.top
				update_text_rect()
				drawing_rect = false
		

func draw_boxes():
#	$VBoxContainer/HBoxContainer/TextureRect.draw_circle(Vector2(5,5),5,Color.red)
	for m in metadada:
		text_rect.draw_rect(Rect2(m.left,m.top,m.width,m.height),m.color)

func load_pic():
	$FileDialog.show()

func file_selected(file):
	
	var img = Image.new()
	img.load(file)
	img.resize(img.get_width()*2,img.get_height()*2)
	var bmp=ImageTexture.new()
	bmp.create_from_image(img)
	
	text_rect.texture=bmp

func item_selected(idx):
	current_item_idx = idx
	var mtd = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList.get_item_metadata(current_item_idx)
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxId.value = mtd.id
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox4Width.value = mtd.width
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxHeight.value = mtd.height
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox2Top.value = mtd.top
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox3Left.value = mtd.left

func none_selected():
	current_item_idx = -1

func rem_item():
	if current_item_idx==-1: return
	$VBoxContainer/HBoxContainer/VBoxContainer/ItemList.remove_item(current_item_idx)
	current_item_idx=-1
	update_text_rect()

func add_item():
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	current_item_idx = item_list.get_item_count()
	
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()
	var color = Color(randf(),randf(),randf(),0.5)
	dynImage.create(16,16,false,Image.FORMAT_RGBA8)
	dynImage.fill(color)
	
	imageTexture.create_from_image(dynImage)
	
	item_list.add_item("?",imageTexture)
	item_list.select(current_item_idx)
	item_list.set_item_metadata(current_item_idx,{id=0,left=0,top=0,width=0,height=0,color=color})
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxId.value = 0
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox4Width.value = 0
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBoxHeight.value = 0
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox2Top.value = 0
	$VBoxContainer/HBoxContainer/VBoxContainer/GridContainer/SpinBox3Left.value = 0

func changed_width(v):
	if current_item_idx==-1: return
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	var mtd = item_list.get_item_metadata(current_item_idx)
	mtd.width = v
	item_list.set_item_metadata(current_item_idx,mtd)
	update_text_rect()

func changed_height(v):
	if current_item_idx==-1: return
	print("changed height")
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	var mtd = item_list.get_item_metadata(current_item_idx)
	mtd.height = v
	item_list.set_item_metadata(current_item_idx,mtd)
	update_text_rect()

func changed_top(v):
	if current_item_idx==-1: return
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	var mtd = item_list.get_item_metadata(current_item_idx)
	mtd.top = v
	item_list.set_item_metadata(current_item_idx,mtd)
	update_text_rect()

func changed_left(v):
	if current_item_idx==-1: return
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	var mtd = item_list.get_item_metadata(current_item_idx)
	mtd.left = v
	item_list.set_item_metadata(current_item_idx,mtd)
	update_text_rect()

func changed_id(v):
	if current_item_idx==-1: return
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	var mtd = item_list.get_item_metadata(current_item_idx)
	mtd.id = v
	item_list.set_item_metadata(current_item_idx,mtd)
	item_list.set_item_text(current_item_idx,str(v))
	update_text_rect()

func update_text_rect():
	var item_list = $VBoxContainer/HBoxContainer/VBoxContainer/ItemList
	metadada = []
	for i in range(item_list.get_item_count()):
		metadada.push_back(item_list.get_item_metadata(i))
	text_rect.update()
