extends HTTPRequest

var url = "https://9c7e-59-98-20-32.ngrok-free.app/api/get-winner"

func getVote():
	request(url)

func _on_request_completed(result, response_code, headers, body):
	if(response_code==200):
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
		get_parent().handleEvent(json)
	else:
		print("failed to get vote result CODE: ",response_code)
