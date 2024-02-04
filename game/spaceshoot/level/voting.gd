extends HTTPRequest

var url = "http://localhost:5001/api/trigger-redirect"
var headers = ["Content-Type: application/json"]

#pass the data here make lasers dynamic
func triggerVote():
	print("started voting")
	var data_to_send = {
		"value": "Lasers"
	}
	var json = JSON.stringify(data_to_send)
	request(url, headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result, response_code, headers, body):
	if(response_code):
		print("Voting has started")
