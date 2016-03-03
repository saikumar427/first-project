<html>
<head>
<title>Fetch Content</title>
<center><b>Fetch Content</b></center>
<hr/>
</head>
<style type="text/css">
 .note {
  	font-family: tahoma, verdana; 
  	font-size:10px;
        color:#FF0000;
 }
 .status {
   	font-family: tahoma, verdana; 
   	font-size:13px;
         color:	#4169E1;
 }
 
</style>
<script type="text/javascript" language="JavaScript" src="/home/js/ajaxjson.js"></script>
<script language="javascript">
function getCustomCode(){
	if(document.getElementById('dirpath').value.length > 0 && document.getElementById('query').value.length > 0){
	document.getElementById('customcode').action="getcontent.jsp";
	jsonAJAX.submit(document.getElementById('customcode'),{
			onSuccess : function(obj) { 
				data=obj.responseText;
				eval("myData="+data);
				document.getElementById('status').className="status";
				if(myData.status=="success"){
					document.getElementById('status').innerHTML="Created files count "+myData.count;
				}else{
					document.getElementById('status').innerHTML="Error";
				}
			},
			onError : function(obj) {
			alert("error"+obj);
			}
	});
	}else{
		alert("Please fill the fields.");
	}
}
function updateCustomCode(){
	if(document.getElementById('dirpath').value.length > 0 && document.getElementById('query').value.length > 0){
	document.getElementById('customcode').action="updatecontent.jsp";
	jsonAJAX.submit(document.getElementById('customcode'),{
			onSuccess : function(obj) { 
				data=obj.responseText;
				eval("myData="+data);
				document.getElementById('status').className="status";
				if(myData.status=="success"){
					document.getElementById('status').innerHTML="Updated files count "+myData.count;
				}else{
					document.getElementById('status').innerHTML="Error";
				}
			},
			onError : function(obj) {
			alert("error"+obj);
			}
	});
	}else{
		alert("Please fill the fields.");
	}
}
</script>
<body>
<form id="customcode" method="post">
<table>
<tr>
<td colspan="2"><div id="status"></div></td>
</tr>
<tr><td>
Directory Path
</td>
<td>
<input type="text" id="dirpath" name="dirpath" size="60">
</td></tr>
<tr><td>
Query
</td>
<td>
<input type="text" id="query" name="query" size="60">
</td></tr>
<tr><td colspan="2"/>
<td>
<input type="button" value="Get Content" onclick="getCustomCode()">
<input type="button" value="Update Content" onclick="updateCustomCode()">
</td></tr>
<table>
<tr>
<td class="note">Note* : Use as refid for first field and as contenttocopy for secong field in query.</td>
</tr>
</table>
</form>
<bodt>
</html>