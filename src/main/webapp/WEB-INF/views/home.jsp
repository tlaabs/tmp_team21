<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page pageEncoding="utf-8"%>
<html>
<head>
<title>Team21</title>
</head>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
<script>
	$(document).ready(function() {
		
	});
	
	function goSubmit(){
		var channel = $("#channel").val();
		var nickname = $("#nickname").val();
		console.log(channel);
		if(validation(channel, nickname)){
			$("#form").submit();
		}else{
			alert("입력사항을 다시 확인해주세요!");
		}
	}
	
	function validation(channel, nickname){
		if(channel == null || channel == "") return false;
		if(nickname == null || nickname == "") return false;
		return true;
	}
</script>
<body style="text-align: center">
	<form id="form" action="/room" method="POST">
		<h1>Team21 Project</h1>
		<h3>채널 이름 입력해주세요</h3>
		<input id="channel" name="channel" type="text"><br>
		<h3>닉네임</h3>
		<input id="nickname" name="nickname" type="text"><br><br>
		<input type="button" value="Join" onclick="goSubmit()"/>
	</form>
</body>
</html>
