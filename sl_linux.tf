provider "softlayer" {
  username = "your user-id here"
  api_key = "your api key here"
}

resource "softlayer_ssh_key" "terraform_key" {
    label = "terraform_key"
    notes = "terraform key for 2017"
    public_key = "${file("/root/SSH/terra_key.pub")}"
}

resource "softlayer_virtual_guest" "centos-test" {
    hostname = "centos-test"
    domain = "test.com"
    ssh_key_ids = ["${softlayer_ssh_key.terraform_key.id}"]
    os_reference_code = "CENTOS_LATEST_64"
    datacenter = "syd01"
    hourly_billing = "true"
    local_disk = "false"
    private_network_only = "true"
    network_speed = 100
    cores = 1
    memory = 2048
    post_install_script_uri = "http://repo_ip/terraform/bootstrap.sh"

connection {
        user = "root"
        private_key = "${file("/root/SSH/terra_key")}"
        host = "${element(softlayer_virtual_guest.k8s_worker.*.ipv4_address_private, count.index)}"
        }
}
