var express = require('express');
var users = express.Router();
var database = require('../database/mysql');
var cors = require('cors')
var jwt = require('jsonwebtoken');
var mysql = require('mysql');
var token;

// users.use(cors());

process.env.SECRET_KEY = "yauwa";

// SECURITY FINDING! CORS Enabled (CSRF)
users.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

users.post('/register', function(req, res) {

    var today = new Date();
    var appData = {
        "error": 1,
        "data": ""
    };
    var userData = {
        "first_name": req.body.first_name,
        "last_name": req.body.last_name,
        "email": req.body.email,
        "password": req.body.password,
        "created": today
    }

    database.connection.getConnection(function(err, connection) {
        if (err) {
            appData["error"] = 1;
            appData["data"] = "Internal Server Error";
            res.status(500).json(appData);
        } else {
            connection.query('INSERT INTO users SET ?', userData, function(err, rows, fields) {
                if (!err) {
                    appData.error = 0;
                    appData["data"] = "User registered successfully!";
                    res.status(201).json(appData);
                } else {
                    appData["data"] = "Error Occured!";
                    res.status(400).json(appData);
                }
            });
            connection.release();
        }
    });
});

users.post('/sqli/', function(req, res) {

    var appData = {};
    var email = req.body.email;
    var password = req.body.password;

    database.connection.getConnection(function(err, connection) {
        if (err) {
            appData["error"] = 1;
            appData["data"] = "Internal Server Error";
            res.status(500).json(appData);
            console.error(err);
        } else {
            // SECURITY FINDING: MYSQL-Injection !!!
            // Disable mysql escaping for better injection
           // connection.query(`SET GLOBAL sql_mode = "NO_BACKSLASH_ESCAPES" `);
            //connection.query(`SET SESSION sql_mode = "NO_BACKSLASH_ESCAPES" `);
            // Vector: admin' OR '1'='1
            // See https://github.com/mysqljs/mysql#escaping-query-values for details about dangerous raw()
            var vulnerable_sql = mysql.raw("SELECT * FROM users WHERE email = '" + email + "' AND password = '" + password + "'");
           // console.log("SQL Query: " + vulnerable_sql.toSqlString());
            connection.query(vulnerable_sql.toSqlString(), function(err, rows) {
                if (err) {
                    appData.error = 1;
                    appData["data"] = "Error Occured!";
                    res.status(400).json(appData);
                    // console.error(err);
                } else {
                    if (rows.length > 0) {
                        // TODO: Add jwt token signing
                        /*token = jwt.sign(rows[0], process.env.SECRET_KEY, {
                            expiresIn: 5000
                        });*/
                        // console.log(rows);
                        appData.error = 0;
                        appData["email"] = rows[0].email;
                        //appData["token"] = token;
                        res.status(200).json(rows);

                    } else {
                        appData.error = 1;
                        appData["data"] = "Email does not exists or mail and Password does not match.";
                        res.status(204).json(appData);
                    }
                }
            });
            connection.release();
        }
    });
});

users.use(function(req, res, next) {
    var token = req.body.token || req.headers['token'];
    var appData = {};
    if (token) {
        jwt.verify(token, process.env.SECRET_KEY, function(err) {
            if (err) {
                appData["error"] = 1;
                appData["data"] = "Token is invalid";
                res.status(500).json(appData);
            } else {
                next();
            }
        });
    } else {
        appData["error"] = 1;
        appData["data"] = "Please send a token";
        res.status(403).json(appData);
    }
});

users.get('/getUsers', function(req, res) {

    var appData = {};

    database.connection.getConnection(function(err, connection) {
        if (err) {
            appData["error"] = 1;
            appData["data"] = "Internal Server Error";
            res.status(500).json(appData);
        } else {
            connection.query('SELECT * FROM users', function(err, rows, fields) {
                if (!err) {
                    appData["error"] = 0;
                    appData["data"] = rows;
                    res.status(200).json(appData);
                } else {
                    appData["data"] = "No data found";
                    res.status(204).json(appData);
                }
            });
            connection.release();
        }
    });
});

module.exports = users;