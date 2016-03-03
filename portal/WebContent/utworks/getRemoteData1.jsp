<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.util.*" %>
<%
String url=request.getParameter("url");
String queryString="";
for(int i=1;i<7;i++){
String name=request.getParameter("param"+i);
if(name==null||"".equals(name))
break;
if(i>1)
queryString=queryString+"&";
queryString=queryString+name+"="+request.getParameter("value"+i);
}
CoreConnector cc1=new CoreConnector(url);
cc1.setQuery(queryString);
cc1.setTimeout(30000);
String data=cc1.MGet();
%>
<table border="0" width="100%" cellpadding="0" cellspacing="0" class="block">
<tr>
	<td  width="20%" height='30'><%=data%></td>
</tr>
</table>


