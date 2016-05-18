get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

SERVICE_ID=$(get_id keystone service-create --name=designate --type="dns" --description="Designate Service")
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

# In case you get Deprecation Warnings, consider running the following commands manually
#keystone service-create --name designate --type dns --description "Designate Service"
#keystone endpoint-create --region RegionOne --service designate --publicurl http://172.16.21.3:9001/v1 --adminurl http://172.16.21.3:9001/v1 --internalurl http://172.16.21.3:9001/v1
# This way, you still get your minimum requirements for the Designate endpoint
