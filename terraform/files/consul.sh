#!/bin/bash

sed -i -- "s/{{ atlas_username }}/${atlas_username}/g" /etc/init/consul.conf
sed -i -- "s/{{ atlas_user_token }}/${atlas_user_token}/g" /etc/init/consul.conf
sed -i -- "s/{{ atlas_environment }}/${atlas_environment}/g" /etc/init/consul.conf
sed -i -- "s/{{ consul_server_count }}/${consul_server_count}/g" /etc/init/consul.conf
service consul restart

echo "Consul environment updated"

exit 0