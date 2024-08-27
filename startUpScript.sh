# Start mysql
chown -R mysql:mysql /var/lib/mysql
service mysql start
echo "Sleeping 30 sec for MySql startup..."
sleep 10s

mysql -u root --execute="create database K2test"
mysql -u root K2test < database/users.sql

# Start MongoDB
/mongodb-linux-x86_64-3.2.22/bin/mongod &
echo "Sleeping 10 sec for Mongo startup..."
sleep 10s

if [ -z "$CSEC_BRANCH" ]
then
    echo "CSEC_BRANCH is not set"
else
    rm -rf node_modules/\@newrelic/security-agent
    echo "https://github.com/newrelic/csec-node-agent.git/#${CSEC_BRANCH}"
    npm install "https://github.com/newrelic/csec-node-agent.git/#${CSEC_BRANCH}"
    rm -rf node_modules/newrelic/node_modules/@newrelic/security-agent
fi

# command to copy newrelic.js from node_modules to application directory and configure fields in config file
sleep 3s

sed -i "s/'My Application'/'${NEW_RELIC_APP_NAME}'/g" /syscall_node/newrelic.js
sed -i "s/'license key here'/'${NEW_RELIC_LICENSE_KEY}'/g" /syscall_node/newrelic.js
sed -i "/license_key:/a\  host: 'staging-collector.newrelic.com'," /syscall_node/newrelic.js

sed -i "/allow_all_headers:/a\  security: {\n    agent: {\n      enabled: true \n     },\n    enabled: true,\n    validator_service_url: 'wss://iast3-csec-se.test-poised-pear.cell.us.nr-data.net',\n   }," /syscall_node/newrelic.js


# start Ldap Server
node ldapServer.js & 
# start NodeJS application
node index.js 
