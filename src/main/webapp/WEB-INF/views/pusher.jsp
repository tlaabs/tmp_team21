<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page pageEncoding="utf-8"%>

<!DOCTYPE html>
<head>
<title>Pusher Test</title>
<script src="https://js.pusher.com/4.3/pusher.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script>
	// Enable pusher logging - don't include this in production
	Pusher.logToConsole = true;

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
		//alert(JSON.stringify(data));
		var xs = data.pos.xs;
		var ys = data.pos.ys;
		var color = data.pos.color;

		draw(xs, ys, color);
	});
	channel.bind('chat', function(data) {
		var msg = data.msg;
		$("#chatArea").append(msg + "\n");
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
			url : '/broadcast',
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
			url : '/event',
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
		$.ajax({
			method : 'POST',
			url : '/chat',
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
			url : '/enter',
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
			url : '/clear',
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

		$("#canvas").mousedown(function(event) {
			console.log("마우스 다운 발생");
			drawing = true;
			var relativeX = event.pageX;
			var relativeY = event.pageY;

			console.log(relativeX + ":" + relativeY);
		});

		$("#canvas").mousemove(function(event) {
			if (drawing == true) {
				console.log("마우스 드래그");
				var canvasX = $("canvas").offset().left;
				var canvasY = $("canvas").offset().top;

				var relativeX = (parseInt(event.pageX) - parseInt(canvasX));
				var relativeY = (parseInt(event.pageY) - parseInt(canvasY));
				stackX.push(relativeX);
				stackY.push(relativeY);

				console.log(relativeX + ":" + relativeY);
			}
		});

		$('#canvas').mouseup(function(event) {
			console.log("마우스 업");
			drawing = false;
			var relativeX = event.pageX;
			var relativeY = event.pageY;
			var color = $("#color").val();

			console.log(relativeX + ":" + relativeY + ":" + color);
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
</style>
</head>
<body>
	<h1>Pusher Test</h1>
	<p>
		Try publishing an event to channel
		<code>my-channel</code>
		with event name
		<code>my-event</code>
		.
	</p>
	<input type="button" onclick="add()" value="send" />
	<br>
	<br>
	<canvas id="canvas" width="500px" height="500px"
		style="border: 1px solid #000">
  </canvas>

	<textarea id="chatArea" name="chat" cols="40" rows="20"></textarea>
	<input id="chatMsg" type="text" />
	<input id="color" type="color" />
	<input id="clear" type="button" value="Clear" onclick="allClear()">
	<input type="button" value="전송" onclick="sendMsg()" />

</body>