extends Node

signal download_succeeded
signal download_failed


func _ready():
	pass

func request_json_file(url: String):
	$HTTPRequest.request(url)

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("request completed")
	if result != HTTPRequest.RESULT_SUCCESS:
		emit_signal("download_failed")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	emit_signal("download_succeeded", json.result)
