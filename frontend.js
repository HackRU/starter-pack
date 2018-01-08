var socket = io();

//reads input from text box, upon enter key pressed
$(document).ready(function(){
    $("#temp").keypress(function(event){
	console.log("registered");
	if(event.keyCode == 13){
/*	    $.ajax({
		type:"POST",
		data: document.getElementById("temp").value,
		success:function(){
		    console.log("I did it");
		}
	    });
*/	    data = document.getElementById('temp').value;
	    socket.emit("input", data);
	    socket.emit("fuck");

	    //clears text box
	    document.getElementById('temp').value = ""
	}
    });
});

socket.on('output', function(data){
    console.log("output");
    $("#outputs").append( "<p>"+data+ "</p>");
});

socket.on('fuck', function(){
    console.log('fuck');
});
