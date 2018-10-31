<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<!DOCTYPE html>
<head>
  <title>Pusher Test</title>
  <script src="https://js.pusher.com/4.3/pusher.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="http://code.jquery.com/ui/1.11.1/jquery-ui.js"></script> 
  <script>

    // Enable pusher logging - don't include this in production
    Pusher.logToConsole = true;

    var pusher = new Pusher('9aad0be92f1331f371c5', {
      cluster: 'ap1',
      forceTLS: true
    });

    var channel = pusher.subscribe('devsim');
    channel.bind('event', function(data) {
      alert(JSON.stringify(data));
    });
    
    function add(){
    	$.get("/event", {
    	}, function(data) {});
    }    
    
  </script>
</head>
<body>
  <h1>Pusher Test</h1>
  <p>
    Try publishing an event to channel <code>my-channel</code>
    with event name <code>my-event</code>.
  </p>
  <input type="button" onclick="add()" value="send"/>
</body>