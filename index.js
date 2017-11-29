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
   socket.emit('output', data);
});

// Listen on the client and send any input to the terminal
socket.on('input', function(data){
   //stuck echo in front to be "secure"
   term.write("echo " + data);
});

// When socket disconnects, destroy the terminal
socket.on("disconnect", function(){
   term.destroy();
   console.log("bye");
});
});
