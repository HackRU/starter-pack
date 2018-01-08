var pty = require('node-pty');
// Setup the express app
var express = require('express');
var app = express();
// Static file serving
app.use("/",express.static("./"));
var http = require('http');
// Creating an HTTP server
var server = http.createServer(app).listen(8080);
var io = require('socket.io')(server);
var help = require('socket.io');

// Create terminal
var term = pty.spawn('sh', [], {
   name: 'xterm-color',
   cols: 80,
   rows: 30,
   cwd: process.env.HOME,
   env: process.env
});

// Listen on the terminal for output and send it to the client
term.on('data', function(data){
   console.log(data);
   io.emit("output", data);
  
});




// Listen on the client and send any input to the terminal
io.on('connection', (socket) =>{
   socket.on('input', function(data){
   //stuck echo in front to be "secure"
      term.write(data + "\r");
     // console.log(data)
   });
});


// When socket disconnects, destroy the terminal
io.on("disconnect", function(){
   term.destroy();
   console.log("bye");
});
