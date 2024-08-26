var express = require('express');
var microservice = express.Router();
var database = require('../database/mysql');
var cors = require('cors')
var jwt = require('jsonwebtoken');
var mysql = require('mysql');
var token;

let cp = require('child_process');
const yaml = require('js-yaml');
const fs   = require('fs');

const axios = require('axios');
const request = require('request');

const Mongoose = require('mongoose');
Mongoose.Promise = global.Promise;
Mongoose.connect('mongodb://localhost/injectable1');


let mongodb = require('mongodb');
let Server = mongodb.Server;
let Db = mongodb.Db;
var db = new Db("injectable1", new Server("localhost", 27017));

// users.use(cors());

process.env.SECRET_KEY = "yauwa";

// SECURITY FINDING! CORS Enabled (CSRF)
microservice.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});

microservice.get('/case_sqli', function(req, res) {

    var appData = {};
    var email = req.query['input'];

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
            var vulnerable_sql = mysql.raw("SELECT * FROM users WHERE email = '" + email + "'");
           // console.log("SQL Query: " + vulnerable_sql.toSqlString());
            connection.query(vulnerable_sql.toSqlString(), function(err, rows) {
                if (err) {
                    appData.error = 1;
                    appData["data"] = "Error Occured!";
                    res.status(400).json(appData);
                    console.error(err);
                } else {
                    if (rows.length > 0) {
                        // TODO: Add jwt token signing
                        /*token = jwt.sign(rows[0], process.env.SECRET_KEY, {
                            expiresIn: 5000
                        });*/
                        console.log(rows);
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

// microservice.use(function(req, res, next) {
//     var token = req.body.token || req.headers['token'];
//     var appData = {};
//     if (token) {
//         jwt.verify(token, process.env.SECRET_KEY, function(err) {
//             if (err) {
//                 appData["error"] = 1;
//                 appData["data"] = "Token is invalid";
//                 res.status(500).json(appData);
//             } else {
//                 next();
//             }
//         });
//     } else {
//         appData["error"] = 1;
//         appData["data"] = "Please send a token";
//         res.status(403).json(appData);
//     }
// });


/* microservice test cases */
// forward request to next microservice
microservice.get('/forward', (req, res) => {
    var url = req.query['input'];
    if (!url.startsWith("http"))
      url = "http://" + url;
    request(url, (err, response, body) => {
      if (err) {
        res.send(err);
      }
      else {
        res.send(body.toString());
      }
    });
  });
  
  // FILE Read microservice
  microservice.get('/case_fileaccess', (req, res) => {
    var payload = req.query['input'];
    var path = payload;
    var buffer = fs.readFileSync(path);
    res.send(buffer.toString());
  });
  
  // RCE microservice
  microservice.get('/case_rce', (req, res) => {
    var payload = req.query['input'];
    var cmd = payload;
    cp.exec(cmd, (err, stdout, stderr) => {
      if (err) {
        console.error(err);
        return;
      }
      res.send(stdout.toString());
      return;
    });
  });
  
  // RCI microservice
  microservice.get('/case_rci', (req, res) => {
    var payload = req.query['input'];
    var cmd =payload;
    res.send('Hello ' + eval(cmd));
  });
  
  // SSRF microservice
  microservice.get('/case_ssrf', (req, res) => {
    var url = req.query['input'];
    if (!url.startsWith("http"))
      url = "http://" + url;
    axios.get(url).then(function (response) {
      res.send(response.data);
    }).catch(function(error){
      
    })
  });
  
  // XPATH microservice
  microservice.get('/case_xpath', (req, res) => {
    var username = req.query['input'];
    var xmlfile = __dirname + '/data/users.xml';
  
    fs.readFile(xmlfile, 'utf8', function (err, data) {
      if (!err) {
        var root = parser.parseFromString(data, 'text/xml');
        var query = "//users//user[username='" + username + "']";
        var nodes = xpath.select(query, root);
        if (nodes.toString() != 0) {
          res.send("done");
        }
        else {
          res.send("Username is incorrect");
        }
  
      }
    });
  });
  
  // LDAP microservice
  microservice.get('/case_ldap', (req, res) => {
    var username = req.query['input'];
    const ldapClient = ldapjs.createClient(ldapOptions);
    ldapClient.bind(
      'cn=root',
      'secret',
      err => {
        if (err) return reject(err);
      });
  
    var opts = {
      filter: '(&(uid=' + username + '))',
  
      attributes: ['cn', 'uid', 'gid', 'description', 'homedirectory', 'shell'],
    };
    ldapClient.search('o=myhost', opts, (err, res1) => {
      if (err) return reject(err);
      var entries = [];
      res1.on('searchEntry', function (entry) {
        var r = entry.object;
        entries.push(r);
      });
  
      res1.on('error', function (err) {
        console.log(err);
      });
  
      res1.on('end', function (result) {
        if (entries.length == 0)
          res.send("invalid Uid");
        else{
          res.send(entries);
        }
      });
    });
  });
  
  // Section is for Mongo
  const Document = Mongoose.model('Document2', {
    title: {
      type: String,
      unique: true
    },
    type: String
  });
  
  require('../documents.json').forEach((d) => (new Document(d)).save().catch(() => { }));
  // NOSQLI microservice
  microservice.get('/case_nosqli', (req, res) => {
    const query = {};
  
    var input = req.query['input'];
  
    if (input) {
      query.title = input;
    }
  
    Document.find(query).exec()
      .then((r) => res.json(r))
      .catch((err) => res.json(err));
  });
  
  // RXSS microservice
  microservice.get('/case_rxss', (req, res) => {
    var payload = req.query['input'];
    //console.log("payload is ::", payload);
    if (payload === '' || payload === undefined) {
      res.send('Expecting query parameter -paylaod- with some value');
    } else {
      var html = "<!DOCTYPE html><html><head><title>XSS</title></head><body>" + payload + "</body></html>";
      try {
        res.send(html);
      } catch (e) {
        res.send(e);
      }
    }
  });
  
  // FILE Read Microservice for DS
  // Ruby
  microservice.get('/dsforward/ruby/fileaccess', (req, res) => {
    var input = req.query['input'];
    fileRequestHandler("Ruby",input,res)
  });
  
  // Java
  microservice.get('/dsforward/java/fileaccess', (req, res) => {
    var input = req.query['input'];
    fileRequestHandler("Java",input,res)
  });
  
  // PHP
  microservice.get('/dsforward/php/fileaccess', (req, res) => {
    var input = req.query['input'];
    fileRequestHandler("PHP",input,res)
  });
  
  // Python
  microservice.get('/dsforward/python/fileaccess', (req, res) => {
    var input = req.query['input'];
    fileRequestHandler("Python",input,res)
  });
  
  // Go
  microservice.get('/dsforward/go/fileaccess', (req, res) => {
    var input = req.query['input'];
    fileRequestHandler("Go",input,res)
  });
  
  // RCE Microservice for DS
  // Ruby
  microservice.get('/dsforward/ruby/rce', (req, res) => {
    var input = req.query['input'];
    rceRequestHandler("Ruby",input,res)
  });
  
  // Java
  microservice.get('/dsforward/java/rce', (req, res) => {
    var input = req.query['input'];
    rceRequestHandler("Java",input,res)
  });
  
  // PHP
  microservice.get('/dsforward/php/rce', (req, res) => {
    var input = req.query['input'];
    rceRequestHandler("PHP",input,res)
  });
  
  // Python
  microservice.get('/dsforward/python/rce', (req, res) => {
    var input = req.query['input'];
    rceRequestHandler("Python",input,res)
  });
  
  // Go
  microservice.get('/dsforward/go/rce', (req, res) => {
    var input = req.query['input'];
    rceRequestHandler("Go",input,res)
  });
  
  // SQLI Microservice for DS
  // Ruby
  microservice.get('/dsforward/ruby/sqli', (req, res) => {
    var input = req.query['input'];
    sqliRequestHandler("Ruby",input,res)
  });
  
  // Java
  microservice.get('/dsforward/java/sqli', (req, res) => {
    var input = req.query['input'];
    sqliRequestHandler("Java",input,res)
  });
  
  // PHP
  microservice.get('/dsforward/php/sqli', (req, res) => {
    var input = req.query['input'];
    sqliRequestHandler("PHP",input,res)
  });
  
  // Python
  microservice.get('/dsforward/python/sqli', (req, res) => {
    var input = req.query['input'];
    sqliRequestHandler("Python",input,res)
  });
  
  // Go
  microservice.get('/dsforward/go/sqli', (req, res) => {
    var input = req.query['input'];
    sqliRequestHandler("Go",input,res)
  });
  
  // forward case for DS
  microservice.get('/dsforward', (req, response) => {
    var input = req.query['input'];

    // Get document, or throw exception on error
    try {
        const doc = yaml.load(fs.readFileSync('/opt/k2root/urls.yml', 'utf8'));
        console.log(doc);
        url = doc.url.FROM_NODE
        request(url+"?input="+input, (err, res, body) => {
          if (err) {
            response.send(err);
          }
          else {
            response.send(body.toString());
          }
        });
    } catch (e) {
        console.log(e);
    }
  });

  function requestHandler(lang){
    var env = process.env
    var url = ""
    switch(lang) {
      case "Ruby":
        url = env.RUBY_URL
        break;
      case "Java":
        url = env.JAVA_URL
        break;
      case "PHP":
        url = env.PHP_URL+"/syscall-app"
        break;
      case "Python":
        url = env.PYTHON_URL
        break;
      case "Go":
        url = env.GO_URL
        break;
      default:
        url = "http://localhost:8080"
    }
    return url
  }
  
  function fileRequestHandler(lang,input,response) {
    var url = requestHandler(lang)
    request(url+"/microservice/case_fileaccess"+(lang=="PHP"?".php":"")+"?input="+input, (err, res, body) => {
      if (err) {
        response.send(err);
      }
      else {
        response.send(body.toString());
      }
    });
  }
  
  function rceRequestHandler(lang,input,response) {
    var url = requestHandler(lang)
    request(url+"/microservice/case_rce"+(lang=="PHP"?".php":"")+"?input="+input, (err, res, body) => {
      if (err) {
        response.send(err);
      }
      else {
        response.send(body.toString());
      }
    });
  }
  
  function sqliRequestHandler(lang,input,response) {
    var url = requestHandler(lang)
    request(url+"/microservice/case_sqli"+(lang=="PHP"?".php":"")+"?input="+input, (err, res, body) => {
      if (err) {
        response.send(err);
      }
      else {
        response.send(body.toString());
      }
    });
  }

module.exports = microservice;