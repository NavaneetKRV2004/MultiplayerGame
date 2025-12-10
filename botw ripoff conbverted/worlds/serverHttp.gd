extends Node
@export var my_world:World
var server := TCPServer.new()
var client : StreamPeerTCP = null
var port:int
# Simulated game state

func response():
	var response_d= {
		"world_name":my_world.world_name,
		"world_type":my_world.world_type,
		"player_count":len(my_world.players)
	}
	return JSON.stringify(response_d)


func _ready():
	port=g.PORT_HTTP
	var err = server.listen(port)
	if err == OK:
		g.p("HTTP game info server started on port: "+str( port),self,g.DEBUG_MESSAGES_TYPE.LOGIN)
	else:
		push_error("Failed to start server: ", err)

func _process(_delta):
	# Accept new client if available
	if server.is_connection_available():
		client = server.take_connection()
		#print("Client connected")

	# Validate client before using
	if client != null:
		var status = client.get_status()
		if status == StreamPeerTCP.STATUS_CONNECTED:
			var available_bytes = client.get_available_bytes()
			if available_bytes > 0:
				var request = client.get_utf8_string(available_bytes)
				#print("Received request\n")


				if request.begins_with("GET /gameinfo"):
					#print("request valid")
					var body = response()
					var content_length = body.to_utf8_buffer().size()
					var response =[
									"HTTP/1.1 200 OK\r\n",
									"Content-Type: application/json\r\n",
									"Content-Length: %d\r\n"%content_length,
									"Connection: close\r\n",
									"\r\n",
									"%s"%body,
								]

					
					client.put_data("".join(response).to_utf8_buffer())
					
					client.disconnect_from_host()
					client=null
				
		
		# Clean up dead or disconnected clients
		elif status == StreamPeerTCP.STATUS_NONE:
			client = null
		elif status == StreamPeerTCP.STATUS_ERROR:
			push_error("Client error")
			client=null
func _exit_tree():
	if client:
		if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			client.disconnect_from_host()
		client = null

	if server and server.is_listening():
		server.stop()
