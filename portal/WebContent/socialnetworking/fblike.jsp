<%@ page import="java.net.*,com.eventbee.general.*,java.util.*"%>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
String eid=request.getParameter("eid");
String uri =serveraddress+"event?eid="+eid;
if(eid==null || "null".equals(eid)){
	String username=request.getParameter("username");
	uri=serveraddress+"view/"+username;
}
String encodeurl=URLEncoder.encode(uri);
%>

<iframe src='http://www.facebook.com/plugins/like.php?href=<%=encodeurl%>&amp;layout=box_count&amp;show_faces=false&amp;width=90&amp;action=like&amp;colorscheme=light&amp;height=20' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:90px; height:65px;' allowTransparency='true'></iframe>