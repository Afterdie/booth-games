extends HTTPRequest

var url = "http://localhost:5001/api/get-winner"

func getVote():
	request(url)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)
