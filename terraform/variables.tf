variable "atlas_username" {}
variable "atlas_user_token" {}
variable "atlas_environment" {
	default = "letschat-gce"
}
variable "consul_server_count" {
	default = 3
}
