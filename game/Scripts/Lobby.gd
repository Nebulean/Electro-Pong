extends Control


func _ready():
	$VBoxContainer2/Logo.set_animation("idle")
	MultiVariables.list_id = []
	MultiVariables.is_multi = true


func _on_VBoxContainer2_mouse_entered():
	$VBoxContainer2/Logo.set_animation("hover")


func _on_Logo_animation_finished():
	$VBoxContainer2/Logo.set_animation("idle")


func start_server():
	print("Start server")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(3333, 1)
	get_tree().network_peer = peer
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_disconnect")
	$VBoxContainer.hide()
	create_player(1)
	$WaitingFor.show()


func _on_ClientButton_pressed():
	$VBoxContainer.hide()
	$IPInput.show()


func start_client(ip="localhost"):
	if ip == "":
		ip="localhost"
	print("Start client")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, 3333)
	get_tree().network_peer = peer
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_on_connection_failed")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_on_disconnect")
	$IPInput.hide()
	$WaitingFor.text = "Waiting for " + ip
	# Only ASCII characters are displayed
	$WaitingFor.show()


func _on_connected_to_server():
	print("Connected to server")
	create_player(get_tree().get_network_unique_id())


func _on_connection_failed():
	print("Connection failed")
	$WaitingFor.text = "Connection failed :("
	$WaitForMenu.start()


func _on_peer_connected(id):
	print("Peer connected %s" % id)
	create_player(id)
	var status := get_tree().change_scene("res://Scenes/Gameplay.tscn")
	assert(status == OK)


func _on_disconnect():
	print("Connection lost")
	get_tree().network_peer = null


func create_player(id):
	MultiVariables.list_id.append(id)


func _on_Return_pressed():
	get_tree().network_peer = null
	var status := get_tree().change_scene("res://Scenes/MainMenu.tscn")
	assert(status == OK)
