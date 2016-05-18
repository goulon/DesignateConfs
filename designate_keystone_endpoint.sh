get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

SERVICE_ID=$(get_id keystone service-create --name=designate --type="dns" --description="DNS_Service")
keystone endpoint-create \
    --region RegionOne \
    --service-id=$SERVICE_ID \
    --publicurl=http://172.16.21.3:9001/v1 \
    --internalurl=http://172.16.21.3:9001/v1 \
    --adminurl=http://172.16.21.3:9001/v1


ADMIN_ROLE=$(get_id keystone role-get admin)
tenant_id=$(get_id keystone tenant-get demo)
user_id=$(get_id keystone user-create --name="designate" --pass="designate" --email=admin@domain.com)
keystone user-role-add --user $user_id --role $ADMIN_ROLE --tenant-id $tenant_id
