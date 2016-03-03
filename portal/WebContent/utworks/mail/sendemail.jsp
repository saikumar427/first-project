<html>
<head>
<title>Mail</title>
<center><h3>Send Mail</h3></center>
<hr/>
<script type="text/javascript" language="JavaScript" src="/home/js/ajaxjson.js"></script>
<script language="javascript">
function sendEmail(){
	jsonAJAX.submit(document.getElementById("email"), {
	    onSuccess : function(obj) {
		var data=obj.responseText;
		var info="";
		var url='';
		alert(data);
		eval("myData="+data);
			if(myData.status=="success"){
				
			}else{
				
			}
		},
	    onError : function(obj) { alert("Error: " + obj.status); }
	});
}
</script>
</head>
<body>
<form id="email" method="post" action="email.jsp">
<table>
<tr>
<td>To</td><td><input type="text" name="to"></td>
</tr>
<tr>
<td>From</td><td><input type="text" name="from"></td>
</tr>
<tr>
<td>Subject</td><td><input type="text" name="subject"></td>
</tr>
<tr>
<td>Message</td><td><textarea name="msg"></textarea></td>
</tr>
<tr>
<td/><td><input type="button" value="send" onclick="sendEmail()"></td>
</tr>
</table>
</form>
</body>
</html>