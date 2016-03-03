
<script type="text/javascript" language="JavaScript" src="/home/js/ajaxjson.js"></script>
<script>
function SubmitForm(){
jsonAJAX.get( {
		url   : 'test2.jsp',
		onSuccess : function(obj) {
		var data=obj.responseText;
		var jsondata=eval('(' + data + ')');
		if(jsondata.message)
		document.getElementById('msg').innerHTML=jsondata.message;
		},
		onError : function(obj) { 
		alert("Error: " + obj.status); 
		}
		});	
	}


</script>

<div id='msg'></div>
<input type='button' name='b1' value='Click Here' onClick='SubmitForm();'/>
