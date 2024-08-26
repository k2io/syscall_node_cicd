var mysql = require('mysql');

var connection = mysql.createPool({
    connectionLimit: 100,
    host: 'localhost',
    port: '3306',
    user: 'root',
    password: '',
    database: 'K2test',
    debug: false,
    multipleStatements: true
});

module.exports.connection = connection;
