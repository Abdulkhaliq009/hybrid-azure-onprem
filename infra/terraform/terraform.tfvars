# FILL THESE IN BEFORE RUNNING terraform apply

resource_group_name  = "rg-hybrid-lab"
location             = "westeurope"
onprem_public_ip     = "YOUR_HOME_PUBLIC_IP"    # run: curl ifconfig.me
onprem_address_space = "192.168.1.0/24"         # your LAN subnet
onprem_db_host       = "192.168.1.X"            # Windows Server private IP
db_name              = "labdb"
db_user              = "labuser"
db_password          = "ChangeMe123!"
