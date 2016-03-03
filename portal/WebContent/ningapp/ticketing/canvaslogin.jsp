<%@ page import="com.eventbee.general.*" %>

<script language="javascript" src="/home/js/ajax.js">
         function dummy12(){}
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>
var sessionid='<%=session.getId()%>';

function submitLogin(appname,oid){

var url="/portal/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+sessionid;
if(appname=='nts'){
url="/portal/ningapp/ntstabview.jsp";
}

     document.getElementById('loginerrormsg').style.color='red';
	document.getElementById('loginerrormsg').innerHTML='Please wait.....';

    advAJAX.submit(document.getElementById("loginform"), {
	onSuccess : function(obj) {
      var data=obj.responseText;
	if(data.indexOf("Success")>-1){
		
	window.location.href=url;
		
		}	if(data.indexOf("Invalid")>-1){
		  
		   document.getElementById('loginerrormsg').innerHTML='Invalid Login. Please try again.';
		
		}
	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}


</script>


<table  align="center" width="90%" class='gadget' style="border: 1px solid #ddddff" >
<tr ><td>
<div align="center" ><b>Already an Eventbee member? Please Login<b></div>



<form name='loginform' id="loginform" method="POST"  action="/portal/ningapp/ticketing/loginprocess.jsp;jsessionid=<%=session.getId()%>"  />


<table  cellspacing="0"  width="100%" valign="top" border="0" align="center" class='gadget'>
<tr><td id="loginerrormsg" colspan="2"></td></tr>
<tr>

<td colspan="2" width="10" height="10" /></tr>
<tr >
	<td align="center">Bee ID:  
	<input description="User" length="10" type="text" id="login"  name="login" />    
	Password:  <input description="Password"  id="password" length="10" type="password" name="password" />
	  <input value="Go" name="go" type="button"  onClick="submitLogin('<%=appname%>','<%=oid%>');" /></td>
</tr>
<tr >
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="oid" value="<%=oid%>">
<input type="hidden" name="UNITID" value="13579">
<input type="hidden" name="appname" value="<%=appname%>">


</table>
</form>

</td></tr></table>