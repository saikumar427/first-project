<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.EventDB" %>

<%
boolean exists=false;
HashMap photohash=null;
HashMap hm=(HashMap)session.getAttribute("groupinfo");
if(hm!=null){
	String groupid=(String)hm.get("groupid");
	photohash=new HashMap();
	exists=EventDB.getEventPhoto(photohash,groupid);
}
if(exists){
	
%>
        <div class='memberbeelet-header'></div>
	<table class='portalback' align='center' cellpadding='0' cellspacing='0' width='100%'>	
	<tr><td align='center'>
	<img src='<%=EbeeConstantsF.get("photo.image.webpath","")%>/<%=photohash.get("imgname")%>'/>
	</td></tr>					
	<tr><td align='center'><%=photohash.get("caption")%></td></tr>
	</table>
<%
	
}
%>