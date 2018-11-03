<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page pageEncoding="utf-8"%>

<!DOCTYPE html>
<head>
<title>Study Code</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
	integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
	crossorigin="anonymous">

<script src="https://js.pusher.com/4.3/pusher.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script>
	// Enable pusher logging - don't include this in production
	Pusher.logToConsole = false;

	var userChannel = "${channel}";
	var userNickname = "${nickname}";
	xsHistory = [];
	ysHistory = [];
	colorHistory = [];

	var pusher = new Pusher('9aad0be92f1331f371c5', {
		cluster : 'ap1',
		forceTLS : true
	});
	var channel = pusher.subscribe("${channel}");
	channel.bind('event', function(data) {
		var xs = data.pos.xs;
		var ys = data.pos.ys;
		var color = data.pos.color;

		draw(xs, ys, color);
	});
	channel.bind('chat', function(data) {
		var msg = data.msg;
		$("#chatArea").append(msg + "\n");
		var scroll = document.getElementById("chatArea");
		scroll.scrollTop = scroll.scrollHeight;
	});
	channel.bind('enter', function(data) {
		var msg = data.msg;
		$("#chatArea").append(msg + "\n");
	});
	channel.bind('broadcast', function(data) {
		broadcast();
	});
	channel.bind('broadcastRecv', function(data) {
		var xs = data.history.xs;
		var ys = data.history.ys;
		var color = data.history.color;
		drawHistory(xs, ys, color);
	});
	channel.bind('clear', function(data) {
		xsHistory = [];
		ysHistory = [];
		colorHistory = [];

		var width = $("#canvas").width();
		var height = $("#canvas").height();

		var cnvs = document.getElementById('canvas');
		var ctx = canvas.getContext('2d');
		ctx.clearRect(0, 0, width, height);
	});

	function broadcast() {
		$.ajax({
			method : 'POST',
			url : 'broadcast',
			traditional : true,
			data : {
				channel : userChannel,
				nickname : userNickname,
				xs : JSON.stringify(xsHistory),
				ys : JSON.stringify(ysHistory),
				color : colorHistory
			},
			success : function(data) {
			}
		});
	}

	function send(stackX, stackY, color) {
		$.ajax({
			method : 'POST',
			url : 'event',
			traditional : true,
			data : {
				channel : userChannel,
				nickname : userNickname,
				xs : stackX,
				ys : stackY,
				color : color
			},
			success : function(data) {
			}
		});
	}

	function sendMsg() {
		var msg = $("#chatMsg").val();
		$("#chatMsg").val("");
		$.ajax({
			method : 'POST',
			url : 'chat',
			traditional : true,
			data : {
				channel : userChannel,
				nickname : userNickname,
				msg : msg
			},
			success : function(data) {
			}
		});
	}

	function enter() {
		$.ajax({
			method : 'POST',
			url : 'enter',
			traditional : true,
			data : {
				channel : userChannel,
				nickname : userNickname,
			},
			success : function(data) {
			}

		});
	}

	function allClear() {
		$.ajax({
			method : 'POST',
			url : 'clear',
			traditional : true,
			data : {
				channel : userChannel,
				nickname : userNickname,
			},
			success : function(data) {
			}

		});
	}

	function draw(xs, ys, color) {
		var canvas = document.getElementById('canvas');
		var ctx = canvas.getContext('2d');
		ctx.beginPath();
		ctx.moveTo(xs[0], ys[0]);
		for (var i = 1; i < xs.length; i++) {
			ctx.lineTo(xs[i], ys[i]);
		}
		ctx.strokeStyle = color;
		ctx.stroke();
		ctx.closePath();
	}

	function drawHistory(xs, ys, color) {
		var canvas = document.getElementById('canvas');
		var ctx = canvas.getContext('2d');

		for (var i = 0; i < xs.length; i++) {
			ctx.beginPath();
			for (var k = 0; k < xs[i].length; k++) {
				if (k == 0) {
					ctx.moveTo(xs[i][0], ys[i][0]);
				} else {
					ctx.lineTo(xs[i][k], ys[i][k]);
				}
			}
			ctx.strokeStyle = color[i];
			ctx.stroke();
			ctx.closePath();
		}
	}

	$(window).on("load", function() {
		var drawing = false;
		var stackX = [];
		var stackY = [];

		setTimeout(function() {
			enter();
		}, 1000);
		
		$("#chatMsg").keyup(function(event) {
		    if (event.keyCode === 13) {
		        $("#send").click();
		    }
		});

		$("#canvas").mousedown(function(event) {
			drawing = true;
			var relativeX = event.pageX;
			var relativeY = event.pageY;

		});

		$("#canvas").mousemove(function(event) {
			if (drawing == true) {
				var canvasX = $("canvas").offset().left;
				var canvasY = $("canvas").offset().top;

				var relativeX = (parseInt(event.pageX) - parseInt(canvasX));
				var relativeY = (parseInt(event.pageY) - parseInt(canvasY));
				stackX.push(relativeX);
				stackY.push(relativeY);

			}
		});

		$('#canvas').mouseup(function(event) {
			drawing = false;
			var relativeX = event.pageX;
			var relativeY = event.pageY;
			var color = $("#color").val();

			send(stackX, stackY, color);
			xsHistory.push(stackX);
			ysHistory.push(stackY);
			colorHistory.push(color);
			stackX = [];
			stackY = [];

		});
	});
</script>
<style>
#kk {
	display: inline;
	vertical-align: top;
}

#body {
	background: url(resources/wall.jpg) no-repeat center center fixed;
	-webkit-background-size: cover;
	-moz-background-size: cover;
	-o-background-size: cover;
	background-size: cover;
}

#chatArea {
	position: absolute;
}

#cen {
	display: flex;
	justify-content: center;
	align-items: center;
}

#boardContainer {
	margin: 0;
	padding: 0;
	position: absolute;
	width: 800px;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}

#canvas {
	background: rgba(255, 255, 255);
	display:inline;
}

#chatArea{
	background: rgba(255, 255, 255, 0.8);
	display:inline;
	height:500px;
	width:300px;
}

#chatMsg{
display:inline;
}

#cain{
display:inline;}

</style>
</head>
<body id="body">
	<div id="boardContainer">
		<canvas id="canvas" width="500px" height="500px"></canvas>
		
		<textarea id="chatArea" name="chat" cols="30" rows="30"></textarea><br>
		<input id="chatMsg" class="form-control" style="width:400px" type="text" />
		<input id="send" type="button" class="btn btn-primary" value="Send" onclick="sendMsg()" />
		
			<input id="clear"
			style="font-weight: bold" class="btn btn-warning" type="button"
			value="&nbsp;Board Clear&nbsp;" onclick="allClear()" />		
		<input id="color" type="color" />

	</div>
</body>