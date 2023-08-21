const express = require("express");
const app = express();

// const bodyParser = require("body-parser");
const cors = require("cors");
// app.use(bodyParser.json());
app.use(cors());
const corsOptions = {
  origin: '*',
  'Access-Control-Allow-Credentials': true,

  optionSuccessStatus: 200,
}

app.use(cors(corsOptions))

var bodyParser = require('body-parser');
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true, parameterLimit: 50000 }));


app.get("/usersignup", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/usersignup", (req, res) => {
  const { name, number, password } = req.body;

  // console.log("DATA RECEIVED "+ n);

  // SQL STARTS

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });

  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected! Signup User");
    // var sql = "INSERT INTO details (username, name,age, gender, interests, phoneno, country, maritalstat, work, prefferedage, city, religion, caste, height, description, hobbies) VALUES ('pathan77', ' "+a+" ', '', '', '', '', '', '', '', '', '', '', '', '', '','')";
    // var sql =
    //   "INSERT INTO userlogin (fullname,phone,password) VALUES ('" +
    //   name +
    //   "' ,'" +
    //   number +
    //   "' , '" 
    //   password +
    //   "'"+
    //   ")";
    var sql = "INSERT INTO userlogin (fullname, phone, password) VALUES (?, ?, ?)";
    con.query(sql, [name, number, password], function (err, result) {
      if (err) {
        console.error("Error executing the query:", err);
        // Handle the error here and send an appropriate response
        res.send("Error occurred while signing up");
      } else {
        // Success
        console.log("New user added:", result.insertId);
        res.send("New user added");
        res.status(200);
      }
      con.end();
    });
  });
});




app.get("/companysignup", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/companysignup", (req, res) => {
  const { businessname, phone, password, address, type } = req.body;

  // console.log("DATA RECEIVED "+ n);

  // SQL STARTS

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected! Signup Company");

    // Use placeholders in the query to prevent SQL injection
    var sql =
      "INSERT INTO companylogin (businessname, phone, password, address, businesstype) VALUES (?, ?, ?, ?, ?)";

    con.query(sql, [businessname, phone, password, address, type], function (err, result) {
      if (err) throw err;

      console.log("Company registered successfully!");
      res.send("Company registered successfully!");
      res.status(200);
    });

    con.end();
  });
});

// SQL ENDS

//   res.send(" NEW USER ADDED");
// });


app.get("/logout", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/logout", (req, res) => {

  const id = req.body.serviceid;
  const type = req.body.type;

  console.log("DATA RECEIVED "+ id,type);

  // SQL STARTS

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;

  if(type=='user'){
  con.connect(function (err) {
    if (err) throw err;
   
    // var sql = "INSERT INTO details (username, name,age, gender, interests, phoneno, country, maritalstat, work, prefferedage, city, religion, caste, height, description, hobbies) VALUES ('pathan77', ' "+a+" ', '', '', '', '', '', '', '', '', '', '', '', '', '','')";

    const sql = "UPDATE userlogin SET loginstatus = 0 WHERE phone = '"+id+"';";

    con.query(sql, function (err, result) {
      if (err) {
        res.send('0');
        con.end();
      }
    else{
      console.log("User Logout!");
        res.status(200);
        res.send("1");
        con.end();
    }
     
      // console.log(result[1].name);
    });
  }
  
  
  )
};



if(type=='company'){
  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected! Logout");
    // var sql = "INSERT INTO details (username, name,age, gender, interests, phoneno, country, maritalstat, work, prefferedage, city, religion, caste, height, description, hobbies) VALUES ('pathan77', ' "+a+" ', '', '', '', '', '', '', '', '', '', '', '', '', '','')";

    const sql = "UPDATE companylogin SET loginstatus = 0 WHERE phone = '"+id+"';";

    con.query(sql, function (err, result) {
      if (err) {
        res.send('0');
        con.end();
      }
    
       else{
        console.log("Company Logout!");
        res.status(200);
        res.send("1");
        con.end();
       }
     
      // console.log(result[1].name);
    });
  }
  
  
  )
};
});
// CHECK CREDENTIALS COMPANY

app.get("/checkcompanycredentials", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/checkcompanycredentials", (req, res) => {

  const n = req.body.data1.phone;
  const p = req.body.data1.password;

  console.log("DATA RECEIVED "+ n,p);

  // SQL STARTS

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected!");
    var sql = "SELECT * FROM companylogin WHERE phone= '" + n + "' AND password='" + p + "'";
    con.query(sql, function (err, result) {
      if (err) throw err;
      if (result.length > 0) {
        if (result[0].loginstatus == 7) {
          console.log("MULTIPLE DEVICE DETECTED");
          res.send("7");
        } 
        else {
          // Update loginstatus to 7
          var updateSql = "UPDATE companylogin SET loginstatus = 7 WHERE phone= '" + n + "' AND password='" + p + "'";
          con.query(updateSql, function (err, updateResult) {
            if (err) throw err;
            console.log("Loginstatus updated to 7 for phone:", n);
            res.send("1");
          });
        }
      } else {  
        res.send("0");
      }
      con.end();
    });
  });
});

// CHECK CREDENTIALS USER

// CHECK CREDENTIALS
app.get("/checkcredentialusers", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/checkcredentialsusers", (req, res) => {
  const n = req.body.data1.phone;
  const p = req.body.data1.password;

  console.log("DATA RECEIVED " + n, p);

  var mysql = require("mysql");

   var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });

  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected!");
    var sql = "SELECT * FROM userlogin WHERE phone= '" + n + "' AND password='" + p + "'";
    con.query(sql, function (err, result) {
      if (err) throw err;
     
      if (result.length > 0) {
        console.log("login status: "+result[0].loginstatus);
        if (result[0].loginstatus == 7) {
          console.log("MULTIPLE DEVICE DETECTED");
          res.json({ status: "7" });
        } 
        else{
          // Update loginstatus to 7
          var updateSql = "UPDATE userlogin SET loginstatus = 7 WHERE phone= '" + n + "' AND password='" + p + "'";
          con.query(updateSql, function (err, updateResult) {
            if (err) throw err;
            console.log("Loginstatus updated to 7 for phone:", n);
            res.json({ status: "1", data: result });
          });
        }
      } 
      else {
        res.json({ status: "0" });
      }
      con.end();
    });
  });
});




// USER ALL TICKETS  GET 
app.post("/useralltickets", (req, res) => {
  const userid = req.body.userid;
  const serviceid = req.body.serviceid;

  var mysql = require("mysql");

   var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });

  con.connect((err) => {
    if (err) {
      console.error("Error connecting to the database:", err);
      return;
    }

    console.log("Connected! allticket details");

    const sql =
      "SELECT companylogin.*, " +
      "slots - COALESCE(total_tickets, 0) AS result " +
      "FROM companylogin " +
      "LEFT JOIN (" +
      "  SELECT serviceid, COUNT(ticketid) AS total_tickets " +
      "  FROM alltickets " +
      "  WHERE status = 0 " + // Add this condition to count only tickets with status 0
      "  GROUP BY serviceid " +
      ") AS alltickets_counts ON companylogin.phone = alltickets_counts.serviceid " +
      "WHERE companylogin.businesstype = ? " + // Replace 'Bank' with your desired business type
      "LIMIT 0, 25;";
    const params = [userid];

    con.query(sql, params, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        res.json(results);
      } else {
        res.send("0");
      }

      con.end(); // Close the database connection
    });
  });
});



// USER ALL TICKETS  GET 

app.get("/historyalltickets", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});


app.post("/historyalltickets", (req, res) => {
  const userid = req.body.userid;
  // console.log("SScard"+ trainerid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected! History allticket details");
    const sql =
      "SELECT * FROM alltickets WHERE userid = '" + userid + "';";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        res.json(results);
        con.end();
      } else {
        console.log('no tickets found');
        res.send("0");
        con.end();
      }
    });
  });
});


app.get("/Companyhistoryalltickets", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});


app.post("/Companyhistoryalltickets", (req, res) => {
  const userid = req.body.userid;
  console.log("SScard" + userid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected! History allticket details");
    const sql =
      "SELECT * FROM alltickets WHERE serviceid = '" + userid + "';";

    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        res.status(200).json(results);
        con.end();

      } else {
        res.send("0");
        con.end();
      }
    });
  });
});


app.get("/resetpassword", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/resetpassword", (req, res) => {
  const phone = req.body.phone;
  const pass = req.body.password;
  const user = req.body.user;

  // console.log("SScard"+ trainerid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  resetpass");
    var sql = '';
    if (user == 'company') {


      sql =
        "UPDATE companylogin SET password = '" + pass + "' WHERE phone = '" + phone + "';";

    }
    else {
      sql =

        "UPDATE userlogin SET password = '" + pass + "' WHERE phone = '" + phone + "';"

    }



    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }
      console.log("RES " + JSON.stringify(results));

      // Process the results
      if (results.affectedRows > 0) {

        console.log("SENT 1");
        res.json({ code: '1' });
        con.end();
      } else {

        res.json({ code: '0' });
        con.end();
      }
    });
  });
});


// COMPANT ALL TICKETS GET

app.post("/companyalltickets", (req, res) => {
  const cid = req.body.serviceid;
  console.log("service id" + cid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  allticketscompany");
    const sql =
      "SELECT * FROM alltickets WHERE serviceid = '" + cid + "' and status=0;";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {

        const userid=results[0]
        // console.log("RES "+JSON.stringify(results));c
        const a = {
          total: results.length,
          tickets: results,


        }
        res.json(a);
        con.end();
      } else {
        res.send("0");
        con.end();
      }
    });





  });
});


function setnoti(id) {

  // console.log("service id noti"+ );

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  Notifications");
    const sql =
      "UPDATE notifications SET status = 1 WHERE status = 0 AND userid ='" + id + "';";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query Notifications:", error);
        con.end(); // Close the database connection
        return;
      }
      else {
        console.log("Notifications Seen!!");
      }
    }
    )
  })

}


app.get("/getnotifications", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/getnotifications", (req, res) => {
  const cid = req.body.serviceid;
  console.log("service id noti: " + cid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  Notifications");
    const sql =
      "SELECT * FROM notifications WHERE userid = '" + cid + "' and status=0;";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        // console.log("RES "+JSON.stringify(results));c
        const a = {

          notifications: results,

        }
        res.json(a);
        setnoti(cid);
        con.end();
      } else {
        res.send("0");
        con.end();
      }
    });




  });
});
app.get("/businessTickets", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/businessTickets", (req, res) => {
  const type = req.body.companyid;
  // console.log("SScard"+ trainerid);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  trainerdetails");
    const sql =
      "SELECT * FROM alltickets WHERE businesstype = '" + type + "';";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        res.json(results);
        con.end();
      } else {
        res.send("0");
        con.end();
      }
    });
  });
});

app.get("/cancelTickets", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});

app.post("/cancelTickets", (req, res) => {
  const ticket = req.body.ticketid;
  const n = 2;
  console.log("ticket: " + ticket);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Ticket Cancelled!");

    const sql = "UPDATE alltickets SET status = 2 WHERE ticketid = '" + ticket + "';";

    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        res.json(results);
        con.end();
        sendnoti(ticket);
        return res.status(200).json({ message: 'Ticket cancelled!' });
      } 
      else {
        res.send("0");
        con.end();
      }

    });
  });
});

// DELETE TICKETS PUSHHHH NOTIIFICATION ON DELETITION OF APPLICATION 

app.get("/delticket", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});
app.post("/delticket", (req, res) => {

  const t = req.body.ticketid;

  console.log("SScard" + t);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected! DEL tickets");
    // var sql = "INSERT INTO details (username, name,age, gender, interests, phoneno, country, maritalstat, work, prefferedage, city, religion, caste, height, description, hobbies) VALUES ('pathan77', ' "+a+" ', '', '', '', '', '', '', '', '', '', '', '', '', '','')";
    var sql =
      "UPDATE alltickets SET status = 2 WHERE ticketid ='" +
      t +
      "';";
    con.query(sql, function (err, result) {
      if (err) {
        res.send("0");

        con.end();
      } else {
        res.send("1");
        sendnoti(t);
        con.end();
      }
      // console.log(result[1].name);
    });
  });
});

app.get("/bookticket", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});
app.post("/bookticket", (req, res) => {

  // const ticket = {
  //   ticketid: 'ticketid',
  //   businessname: 'businessname',
  //   businessType: 'businessType',
  //   userid: 'userid',
  //   serviceid: 'serviceid',
  //   generationtime: 'generationtime',
  //   status: 'status',
  // };
  const ticket = req.body;
  console.log(ticket);
  // console.log("SScard"+ t+"  "+c);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0
  con.connect((err) => {
    if (err) {
      console.error('Error connecting to the database:', err);
      return;
    }
    console.log('Connected to the database!');

    const sql = 'INSERT INTO alltickets SET ?';
    con.query(sql, ticket, (err, result) => {
      if (err) {
        console.error('Error executing the query:', err);
        return;
      }
      console.log('Insert successful:', result);

      con.end((err) => {
        if (err) {
          console.error('Error closing the connection:', err);
        } else {
          console.log('Connection closed.');
        }
        return res.status(200).json({ message: 'Ticket Booked!' });
      });
    });
  });
});



app.get("/markdone", (req, res) => {
  res.send("This is the data endpoint");
  console.log("Received data:");
});
app.post("/markdone", (req, res) => {

  const t = req.body.ticketid;
  console.log(t);
  // const t='123'

  // console.log("SScard"+ t+"  "+c);

  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });
  const auth = 0;
  con.connect(function (err) {
    if (err) throw err;
    console.log("Connected! DEL tickets");
    // var sql = "INSERT INTO details (username, name,age, gender, interests, phoneno, country, maritalstat, work, prefferedage, city, religion, caste, height, description, hobbies) VALUES ('pathan77', ' "+a+" ', '', '', '', '', '', '', '', '', '', '', '', '', '','')";
    var sql = "UPDATE alltickets SET status = '1' WHERE ticketid = '" + t + "';";

    con.query(sql, function (err, result) {
      if (err) {
        res.send("0");

        con.end();
      } else {
        // const a={total: '112',tickets:[{ticektid: 1,time:'12'},{ticektid: 112,time:'10'}]}
        res.send('1');
        con.end();
      }
      // console.log(result[1].name);
    });
  });
});
function sendnoti(t) {


  var mysql = require("mysql");

  var con = mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "",
    database: "ewaiting",

  });

  con.connect(function (err) {
    if (err) throw err;
    // console.log(JSON.stringify(data1));
    console.log("Connected!  Send Notification");
    const sql =
      "SELECT * FROM alltickets WHERE ticketid = '" + t + "' ;";
    con.query(sql, (error, results) => {
      if (error) {
        console.error("Error executing the query:", error);
        con.end(); // Close the database connection
        return;
      }

      // Process the results
      if (results.length > 0) {
        const first = results[0].userid;
        const second = results[0].serviceid;
       
        const sql1 =
          "INSERT INTO notifications (userid, body, status) VALUES (?, ?, ?);";
        const sql2 =
          "INSERT INTO notifications (userid, body, status) VALUES (?, ?, ?);";

        // Assuming you have a MySQL connection 'con' already established
        con.query(sql1, [first, `Ticket Has Been Cancelled Ticket id ${t}`, 0], (error, result1) => {
          if (error) {
            console.error("Error executing the first query:", error);
            // Handle the error here
          } else {
            // First query executed successfully
            console.log("First notification inserted successfully.");

            // Execute the second query
            con.query(sql2, [second, `Ticket Has Been Cancelled Ticket id ${t}`, 0], (error, result2) => {
              if (error) {
                console.error("Error executing the second query:", error);
                // Handle the error here
              } else {
                // Second query executed successfully
                console.log("Second notification inserted successfully.");
              }
            });
          }
        });



      }
    }
    )
  });




}


app.listen(3000, () => {
  console.log("Server started on port 3000");
});