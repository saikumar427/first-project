<%@ page import="java.net.*,com.eventbee.general.*,java.util.*"%>

<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
String eid=request.getParameter("eid");
String uri =serveraddress+"event?eid="+eid;
if(eid==null){
String username=request.getParameter("username");
uri=serveraddress+"/view/"+username;
}
String encodeurl=URLEncoder.encode(uri);
%>
<!-- Place this tag in your head or just before your close body tag -->
<script type="text/javascript" src="http://apis.google.com/js/plusone.js"></script>

<!-- Place this tag where you want the +1 button to render -->
<g:plusone size="tall" href="<%=uri%>" annotation="none"></g:plusone>