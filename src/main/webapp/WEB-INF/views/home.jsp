<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page pageEncoding="utf-8"%>
<html>
<head>
<title>Study Code</title>
</head>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script>
	$(document).ready(function() {

	});

	function goSubmit() {
		var channel = $("#channel").val();
		var nickname = $("#nickname").val();
		console.log(channel);
		if (validation(channel, nickname)) {
			$("#form").submit();
		} else {
			alert("Check your channel or nickname!");
		}
	}

	function validation(channel, nickname) {
		if (channel == null || channel == "")
			return false;
		if (nickname == null || nickname == "")
			return false;
		return true;
	}
</script>
<style>
#body {
	background: url(resources/bg.jpg) no-repeat center center fixed;
	-webkit-background-size: cover;
	-moz-background-size: cover;
	-o-background-size: cover;
	background-size: cover;
}

#divbg {
	background: rgba(255, 255, 255, 0.6);
	 margin: 0;
    position: absolute;
    width : 40%;
    text-align : center;
    top: 50%;
    left: 50%;
    padding : 20px;
    transform: translate(-50%, -50%);
}
</style>

<body id="body">
	<form id="form" action="room" method="POST">
		<div id="divbg" width="500" height="500">
			<h1>Study Code</h1><br>
			<h4>Channel</h3>
			<input id="channel" class="form-control" name="channel" type="text"><br>
			<h4>Nickname</h3>
			<input id="nickname" class="form-control" name="nickname" type="text"><br> <br>
			<input type="button" class="btn btn-dark" value="&nbsp;Join&nbsp;" onclick="goSubmit()" />
		</div>
	</form>
</body>
</html>
