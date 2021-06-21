extends Node2D

const PORT        = 6969
const MAX_PLAYERS = 15
var client_count=0
var connected_clients = []
var player_info = {}


func _ready():
# warning-ignore:return_value_discarded
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected",    self, "_client_connected"   )
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected",    self, "_client_disconnected"   )
	var server = NetworkedMultiplayerENet.new()
	server.create_server(PORT, MAX_PLAYERS)
	get_tree().set_network_peer(server)


func _client_connected(id):
	print('Client ' + str(id) + ' connected to Server')
	
	var newClient = load("res://remote_client.tscn").instance()
	newClient.set_name(str(id))	
	newClient.set_id(id)
#	print_debug(str(get_tree().get_network_unique_id()))
	get_tree().get_root().add_child(newClient)
	connected_clients.append({"id":id,"client":newClient})
	
	var n = null
	for i in connected_clients.size():
		n = connected_clients[i].client.get_id()
		rpc("_connected",n)


func _client_disconnected(id):
	
	print('Client ' + str(id) + ' disconnected from Server')
	player_info.erase(id)
	var remove = null
	var node = null
	var n = null
	for E in connected_clients.size():
		if(connected_clients[E].client.get_id()==id):
			remove = E
			node = connected_clients[E].client
			n = connected_clients[E].client.get_id()
			break
	if (remove !=null):
		connected_clients.remove(remove)
	if(node!=null):
#		node.queue_free() #commented this until i figure out why i cant send two rpcs from the same code.
		rpc("_disconnected",n)
		node.hide()                                              #to be removed
		node.get_node("CollisionShape2D").disabled = true        #to be removed

