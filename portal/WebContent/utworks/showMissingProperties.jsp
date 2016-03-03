<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*" %>

<%
HashMap map=EbeeConstantsF.missingpropsmap;
if(map!=null){
	Set set=map.entrySet();
	if(set!=null){
		for( Iterator iter=set.iterator();iter.hasNext();){
		Map.Entry me=(Map.Entry)iter.next();
		out.println(me.getKey()+"="+me.getValue());
		out.println("<br/>");
		}
	}
}
%>


