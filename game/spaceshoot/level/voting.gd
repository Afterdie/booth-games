extends HTTPRequest

var url ="https://9c7e-59-98-20-32.ngrok-free.app/api/trigger-redirect"

var headers = ["Content-Type: application/json"]

#pass the data here make lasers dynamic
func triggerVote(type:String):
	print("started voting")
	var data_to_send = {
		"value": type
	}
	var json = JSON.stringify(data_to_send)
	request(url, headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(result, response_code, headers, body):
	if(response_code== 200):
		print("voting triggered succesfully")
	else:
		print("failed to trigger vote CODE: ",response_code)
