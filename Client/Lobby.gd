extends Node2D

const SERVER_IP = "192.168.1.6"
const SERVER_PORT = 6969
var connected_clients = []


func _on_Join_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(net)


# warning-ignore:unused_argument
remote func _connected(id):
	for i in connected_clients.size():
		if(id == connected_clients[i].id):
			return
	
	var newClient = load("res://remote_client.tscn").instance()
	newClient.set_name(str(id))
	get_tree().get_root().add_child(newClient)
	connected_clients.append({"id":id,"client":newClient})
	hide()

remote func _disconnected(id):
	var remove = null
	var node = null
	for E in connected_clients.size():
		if(connected_clients[E].id==id):
			remove = E
			node = connected_clients[E].client
			break
	if (remove !=null):
		connected_clients.remove(remove)
	if(node!=null):
		node.queue_free()
