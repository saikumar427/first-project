<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.*" %>
 <%@ page import="com.eventbee.authentication.*" %>
 <%@ page import="com.eventbee.context.ContextConstants" %>

<%!

String users_query="select user_id,login_name, password from authentication order by user_id";


%>

<html>
<body>

<table border="0" width="100%" align="center"  class="innerbeelet" cellspacing="0">
<tr width="100%"><td > Userid</td><td > loginname</td><td > password</td>      </tr>
<%


DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery( users_query,null);
int recordcounttodata1=statobj.getCount();
if(statobj !=null && statobj.getStatus()){

for(int i=0;i<recordcounttodata1;i++){
			//currentusage=dbmanager1.getValue(i,"usage","0");
%>

<tr width="100%"><td > <%=dbmanager.getValue(i,"user_id","") %></td>

<td > <%=dbmanager.getValue(i,"login_name","") %></td>
<td > <%=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(dbmanager.getValue(i,"password","") ) %></td>
</tr>
<%
			
			
			
}
}//end if
%>

</table>
</form>
</body>
</html>

