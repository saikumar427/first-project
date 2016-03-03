<%@ page import="java.net.*,com.eventbee.general.*,java.util.*"%>

<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
String eid=request.getParameter("eid");
String uri =serveraddress+"event?eid="+eid;
String username=request.getParameter("username");
String encodeurl=URLEncoder.encode(uri);
//a.getAttribute('share_url')||window.location.href;
%>

<a name='fb_share' type='box_count' href='http://www.facebook.com/sharer.php'>Share</a><script src='FBShareJS.jsp?eid=<%=eid%>&username=<%=username%>' type='text/javascript'></script>