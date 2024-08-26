const express = require("express");
const app = express();
const compression = require("compression");
var cookieParser = require("cookie-parser");
var escape = require("escape-html");
var serialize = require("node-serialize");
var database = require('./database/mysql');

let cp = require("child_process");
let fs = require("fs");

const axios = require("axios");
const request = require("request");

const Mongoose = require("mongoose");
Mongoose.Promise = global.Promise;
Mongoose.connect("mongodb://localhost/injectable1");

let mongodb = require("mongodb");
let Server = mongodb.Server;
let Db = mongodb.Db;
var db = new Db("injectable1", new Server("localhost", 27017));

// app.use(cookieParser());

var cors = require("cors");
var bodyParser = require("body-parser");
app.use(bodyParser.json());
// app.use(cors());
app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);

app.use(compression());

var users = require("./routes/users");

app.use("/users", users);

var microservice = require("./routes/microservice");

app.use("/microservice", microservice);

var xmldom = require("xmldom");
var parser = new xmldom.DOMParser();
var xml_dot_js = require("xpath.js");
var xpath = require("xpath");

var ldapjs = require("ldapjs");
const ldapOptions = {
  url: "ldap://0.0.0.0:1389",
  timeout: 30000,
  connectTimeout: 30000,
  reconnect: true,
};

app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("index");
});

console.log("Node env:", process.env.NODE_ENV);

// rce exec valid
app.get("/rce/valid", (req, res) => {
  var payload = req.query["payload"];
  var cmd = "whoami";
  cp.exec(cmd, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    res.send(stdout.toString());
    return;
  });
});

// rce exec attack
app.get("/rce/attack", (req, res) => {
  var payload = req.query["payload"];
  if (!payload) {
    res.status(400)
    res.send("Please provide valid payload");
    return;
  }
  var cmd = 'ping -c 2 ' + payload;
  
  if (!cmd) {
    res.send("Please provide valid command");
    return;
  }
  cp.exec(cmd, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    res.send(stdout + stderr);
    return;
  });
});

// NPE

app.get("/npe", (req, res) => {
  var payload = null;
  var triggerError = payload.trigger;
});







// file read attack
app.get("/fileread/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/" + payload;
  var buffer = fs.readFileSync(path);
  res.send(buffer.toString());
});

// file read valid
app.get("/fileread/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "./temp.txt";
  var buffer = fs.readFileSync(path);
  res.send(buffer.toString());
});

// file read async attack
app.get("/fileread/async/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/" + payload;
  fs.readFile(path, "utf8", function (err, data) {
    if (err) {
      res.send(err);
    } else {
      res.send("done");
    }
  });
});

// file read async valid
app.get("/fileread/async/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "./temp.txt";
  fs.readFile(path, "utf8", function (err, data) {
    if (err) {
      res.send(err);
    } else {
      res.send("done");
    }
  });
});

// file write attack
app.get("/filewrite/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = payload;
  var buffer = fs.writeFileSync(path, "Hello K2 Cyber");
  res.send("File write attack done");
});

// file write valid
app.get("/filewrite/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "/tmp/foo.txt";
  var buffer = fs.writeFileSync(path, "Hello K2 Cyber");
  res.send("File write done");
});

// file write async attack
app.get("/filewrite/async/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = payload;
  fs.writeFile(path, "Hello K2 Cyber", (err) => {
    if (err) res.send(err);
    else {
      res.send("File write done");
    }
  });
});

// file write async attack
app.get("/filewrite/async/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "/tmp/foo.txt";
  fs.writeFile(path, "Hello K2 Cyber", (err) => {
    if (err) res.send(err);
    else {
      res.send("File write done");
    }
  });
});

// file integrity attack
app.get("/fileintegrity/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/" + payload;
  var buffer = fs.writeFileSync(path, "Hello K2 Cyber");
  res.send("File integirty attack done");
});

// file integrity valid
app.get("/fileintegrity/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/attack.txt";
  var buffer = fs.writeFileSync(path, "Hello K2 Cyber");
  res.send("File integirty valid done");
});

// file integrity async attack
app.get("/fileintegrity/async/attack", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/" + payload;
  fs.writeFile(path, "Hello K2 Cyber", (err) => {
    if (err) res.send(err);
    else {
      res.send("File integirty attack done");
    }
  });
});

// file integrity async vaid
app.get("/fileintegrity/async/valid", (req, res) => {
  var payload = req.query["payload"];
  var path = "./uploads/attack.txt";
  fs.writeFile(path, "Hello K2 Cyber", (err) => {
    if (err) res.send(err);
    else {
      res.send("File integirty valid done");
    }
  });
});

// RXSS
app.get("/rxss", (req, res) => {
  var payload = req.query["payload"];
  //console.log("payload is ::", payload);
  if (payload === "" || payload === undefined) {
    res.send("Expecting query parameter -paylaod- with some value");
  } else {
    var html =
      "<!DOCTYPE html><html><head><title>RXSS</title></head><body>" +
      payload +
      "</body></html>";
    try {
      res.send(html);
    } catch (e) {
      res.send(e);
    }
  }
});

// This section is for SSRF.

//request attack
app.get("/ssrf/request/", (req, res) => {
  var payload = req.query["payload"];
  let url = payload;
  request(url, (err, response, body) => {
    if (err) {
      res.send(err);
    } else {
      res.send(body.toString());
    }
  });
});

// axios attack
app.get("/ssrf/axios/", (req, res) => {
  var payload = req.query["payload"];
  let url = payload;
  axios
    .get(url)
    .then(function (response) {
      res.send(response.data);
    })
    .catch(function (error) { });
});

//request attack https protocol
app.get("/ssrf/https/request/", (req, res) => {
  try {
    var payload = req.query["payload"];
    let url = payload;
    request(url, (err, response, body) => {
      if (err) {
        res.send(err);
      } else {
        res.send(body.toString());
      }
    });
  } catch (err) {
    console.log(err)
  }
});

// axios attack https protocol
app.get("/ssrf/https/axios/", (req, res) => {
  var payload = req.query["payload"];
  let url = payload;
  axios
    .get(url)
    .then(function (response) {
      res.send(response.data);
    })
    .catch(function (error) { });
});

// Section is for Mongo
const Document = Mongoose.model("Document", {
  title: {
    type: String,
    unique: true,
  },
  type: String,
});

require("./documents.json").forEach((d) =>
  new Document(d).save().catch(() => { })
);

app.post("/nosqli/mongo", (req, res) => {
  const query = {};

  if (req.body.type === "secret projects") {
    // I don't want people to discover my secret projects,
    // it would be a shame is 'client.js' contained a method to show all the content of the collection here...
    return res.json([]);
  }
  if (req.body.title) {
    query.title = req.body.title;
  }
  if (req.body.type) {
    query.type = req.body.type;
  }
  if (!query.title && !query.type) {
    return res.json([]);
  }

  Document.find(query)
    .exec()
    .then((r) => res.json(r))
    .catch((err) => res.json(err));
});

// Section for Xpath attack
app.post("/xpath", (req, res) => {
  var username = req.body.username;
  var password = req.body.password;
  var xmlfile = __dirname + "/data/users.xml";
  try {
    fs.readFile(xmlfile, "utf8", function (err, data) {
      if (!err) {
        try {
          var root = parser.parseFromString(data, "text/xml");
          var query =
            "//users//user[username='" +
            username +
            "' and password='" +
            password +
            "']";
          var nodes = xpath.select(query, root);
          if (nodes.toString() != 0) {
            res.send(nodes.toString());
          }
        } catch (e) {
          err = e;
        }
      }
      if (err) res.send(`Username or Password are incorrect: ${err}`);
    });
  } catch (error) {
    res.send("error in xpath");
  }
});

//Section for LDAP attack
// function for check user in password file
app.post("/ldap", (req, res) => {
  var username = req.body.username;
  const ldapClient = ldapjs.createClient(ldapOptions);
  ldapClient.bind("cn=root", "secret", (err) => {
    if (err) return reject(err);
  });

  var opts = {
    filter: "(&(uid=" + username + "))",

    attributes: ["cn", "uid", "gid", "description", "homedirectory", "shell"],
  };
  ldapClient.search("o=myhost", opts, (err, res1) => {
    if (err) {
      console.log(err);
      return;
    }
    var entries = [];
    res1.on("searchEntry", function (entry) {
      var r = entry.object;
      entries.push(r);
    });

    res1.on("error", function (err) {
      console.log(err);
    });

    res1.on("end", function (result) {
      if (entries.length == 0) res.send("invalid Uid");
      else {
        res.send(entries);
      }
    });
  });
});

//Section for LDAP modify
// function for check user in password file
app.post("/ldap/modify", (req, res) => {
  var username = req.body.username;
  const ldapClient = ldapjs.createClient(ldapOptions);
  ldapClient.bind("cn=root", "secret", (err) => {
    if (err) return reject(err);
  });

  var opts = {
    filter: "(&(uid=" + username + "))",

    attributes: ["cn", "uid", "gid", "description", "homedirectory", "shell"],
  };

  const change = new ldapjs.Change({
    operation: 'add',
    modification: {
      pets: ['cat', 'dog']
    }
  });

  ldapClient.modify('o=myhost', change, (err) => {
    if (err) {
      console.log(err)
      res.send(err);
    }
    res.send("Updated")
  });
});

//rci network
app.get("/rci/network", function (req, res, next) {
  var payload = req.query["payload"];

  if (payload === " " || payload === undefined) {
    res.send("Expecting query parameter -paylaod- with some value");
  } else {
    var code = "" + payload + "";
    try {
      res.setHeader("query", code);
    } catch (e) {
      res.setHeader("query", escape(code));
    }
  }
  try {
    var out = eval(code);
    res.send("Done!" + "; " + out.toString());
  } catch (e) {
    console.log("error is:", e);
    res.send(e);
  }
});

//import attack
app.get("/pathTraversal/import", (req, res) => {
  var payload = req.query["payload"];
  try {
    import(payload)
      .then(function (data) {
        console.log(data);
      })
      .catch(function (error) {
        console.log("error is:", error);
      });
  } catch (error) {
    console.log("error:", error);
  }

  res.send("done");
});

//Stored-XSS attack
app.post("/sxss", function (req, res) {
  try {
    if (!req.body) {
      res.send(400);
      return;
    }
    var firstName = req.body.first_name;
    var lastName = req.body.last_name;
    var email = req.body.email;
    var password = req.body.password;
    var today = new Date();
    console.log(today.toDateString());
    var userData = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "created": today
    }
    database.connection.query(
      'INSERT INTO users SET ?',
      userData,
      function (error, results, fields) {
        if (error) {
          console.log(error);
          res.send(500);
        } else {
          res.end(JSON.stringify(results));
        }
      }
    );
  } catch (e) {
    console.log(e);
    res.send(500);
  }
});

//JS-Injection
app.get("/js-injection", (req, res) => {
  var payload = req.query["payload"];
  try {
    eval("console.log('Hello " + payload + "');")
    res.end("Success");
  } catch (e) {
    console.log(e);
    res.send(500);
  }
});

//error reporting

app.get("/sendFile", (req,res)=>{
  let payload = req.query.payload;
  console.log("payload is:", payload);
  res.sendFile(payload);
})

app.get("/npe", (req, res) => {
  var payload = null;
  var triggerError = payload.trigger;
});

app.get("/arithmatic-uncaught", (req, res) => {
  var payload = req.query["payload"];
  var result = 3 * payload;
  res.end(result);
});

app.get('/500-internal-server', (req, res) => {
  res.status(500);
  res.send({ error: 'internal-server' });
});

app.get('/501-not-implemented', (req, res) => {
  res.status(501);
  res.send({ error: 'not-implemented' });
});

app.get('/502-bad-gateway', (req, res) => {
  res.status(502);
  res.send({ error: 'Bad Gateway' });
});

app.get('/503-service-unavailable', (req, res) => {
  res.status(503);
  res.send({ error: 'service-unavailable' });
});

app.get('/504-gateway-timeout', (req, res) => {
  res.status(504);
  res.send({ error: 'Gateway Timeout' });
});

app.get('/505-version-unsupported', (req, res) => {
  res.status(505);
  res.send({ error: 'version-unsupported' });
});

app.get('/506-variant-negotiates', (req, res) => {
  res.status(506);
  res.send({ error: 'variant-negotiates' });
});

app.get('/507-insufficient-storage', (req, res) => {
  res.status(507);
  res.send({ error: 'insufficient-storage' });
});

app.get('/508-loop-detected', (req, res) => {
  res.status(508);
  res.send({ error: 'loop-detected' });
});

app.get('/509-bandwidth-limit-exceed', (req, res) => {
  res.status(509);
  res.send({ error: 'bandwidth-limit-exceeded' });
});

app.get('/510-not-extended', (req, res) => {
  res.status(510);
  res.send({ error: 'not-extended' });
});

app.get('/511-auth-required', (req, res) => {
  res.status(511);
  res.send({ error: 'auth-required' });
});

//error reporting

app.listen(8080);
console.log("App started at 8080 port");
