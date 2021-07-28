extends Node

var sector_data_json
var sector_data = {}

func parse_sector_data(json):
	sector_data_json = json

# Example data format
# sector_name: String
# systems: Array
# 	system_name: String
# 	rel_loc: Array float[3]
# 	color: String
# 	bodies: Array
# 		body_name: String
# 		rel_loc: Array float[3]
# 		color: String
