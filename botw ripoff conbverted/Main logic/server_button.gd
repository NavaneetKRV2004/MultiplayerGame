extends Control
class_name ServerButton
@export var world:WorldClient
@onready var server_name:RichTextLabel=$name
@onready var online:RichTextLabel=$status
@onready var player_count:RichTextLabel=$count
@onready var type:RichTextLabel=$type
@onready var http:HTTPRequest=$HTTPRequest
@export var ip:ip_enum=ip_enum.disabled
var address:String
enum ip_enum{
	disabled=-2,
	localhost=-1,
	lan=0,
	ms1=1,
	ms2=2,
	ms3=3,
	
}
var type_int:int=0



func _ready() -> void:
	_onlineSet(false)
	ask_server()
	

func _get_tooltip(_at_position: Vector2) -> String:
	if ip==ip_enum.localhost:
		return "127.0.0.1"
	elif ip == ip_enum.disabled:
		return "IP not set"
	else: 
		return s.settings.server_list[ip]
func _onlineSet(isOnline:bool,server_name:String="",players_count:int=0,type:String=""):
	if isOnline:
		$TextureButton.disabled=false
		online.text="[color=green]online"
		self.server_name.text="[b]%s[/b]"%server_name
		player_count.text="[color=green]%d/10"%players_count
		self.type.text="[i]%s[/i]"%type
		
		modulate=Color("ffffff")
		return
		
	modulate=Color("3d3d3d")
	online.text="[color=red]offline"
	self.server_name.text=""
	player_count.text=""
	self.type.text=""
	$TextureButton.disabled=true
	
	
	
func ask_server():
	if ip==ip_enum.disabled:
		return
		
	
	if ip == ip_enum.localhost:
		address="127.0.0.1"
	elif ip == ip_enum.lan:
		address="192.168.1."+s.settings.server_list[0]
	else:
		address=s.settings.server_list[ip]
	
	#while http.get_http_client_status() != HTTPClient.Status.STATUS_DISCONNECTED:
		#pass
	g.p("Server selector button set to ip: "+address,self,g.DEBUG_MESSAGES_TYPE.LOGIN)
	
		
	
	if address.is_valid_ip_address():
		
		var error = http.request("http://%s:%d/gameinfo"%[address,g.PORT_HTTP])
		if error != OK:
			push_error("failed")
			_onlineSet(false)
		
	else:
		push_error("failed, ip:",address)
		_onlineSet(false)	


func _http_request_completed(_result, _response_code, _headers, body:PackedByteArray):
	if not body:
		_onlineSet(false)
		return
	var d:Dictionary=JSON.parse_string(body.get_string_from_utf8())
	_onlineSet(true,d.world_name,d.player_count,g.world_types[d.world_type][0])
	type_int=d.world_type
	
	
	
	


func _on_texture_button_button_down() -> void:
	var ip = s.settings.server_list[ip]
	world.join_world(address,type_int)
	
