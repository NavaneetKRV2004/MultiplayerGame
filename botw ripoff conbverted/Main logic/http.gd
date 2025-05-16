extends HTTPRequest


func _ready() -> void:
	request_completed.connect(got_info)

func request_world_info(url):
	request(url)
	
func got_info(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var data = json.get_data()
# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(data)
