#
# Container Image Autopilot Consul
#

log_level = "warn"
log_json = true
data_dir = "/usr/local/var/lib/consul"
pid_file = "/usr/local/var/run/consul/consul.pid"
disable_update_check = true
datacenter = "dc"
domain = "consul"
server = true
bootstrap_expect = 3
leave_on_terminate = true
encrypt = "aPuGh+5UDskRAbkLaXRzFoSOcSM+5vAK+NEYOWHJH7w="
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
retry_join = ["consul"]
retry_interval = "10s"
ports {
	http = -1
	https = 8501
	grpc = 8502
	dns = 8600
}
tls {
	defaults {
		ca_file = "/usr/local/etc/consul/ca.pem"
		cert_file = "/usr/local/etc/consul/tls-cer.pem"
		key_file = "/usr/local/etc/consul/tls-key.pem"
	}
	internal_rpc {
		verify_server_hostname = true
	}
}
ui_config {
	enabled = true
}
