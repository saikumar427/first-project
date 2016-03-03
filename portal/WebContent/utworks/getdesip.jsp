<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*" %>

<%!

%>



<%

String userid=request.getParameter("userid");
String userp="";

if( userid !=null ){
	String cusp=DbUtil.getVal("select password  from authentication where user_id=?", new String[]{userid});
	if(cusp !=null){
		userp=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(cusp);
	}else{
		userp="No recore exists for this userid";
	
	}
	

}
//14834
%>



<html>
<body>
<form action="getdesip.jsp" method="post" name="form">
<table border="0" width="100%" align="center"  class="innerbeelet" cellspacing="0">
<tr width="100%"><td colspan="2"> <%=userp %></td>      </tr>
<tr width="100%"><td colspan="2"> userid: <input type='text' name='userid'  /></td>      </tr>
<tr><td colspan="2"> <input type='submit' name='submit' value='Submit' /></td>      </tr>
</table>
</form>
</body>
</html>

