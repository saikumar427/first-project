
<%@ page import="com.eventbee.general.*"%>

<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
%>
<%
String eid=request.getParameter("eid");
String url=request.getParameter("url");
if(url==null ||"null".equals(url))
	url =serveraddress+"event?eid="+eid;
%>
<div id="fb-root" ></div><script src="http://connect.facebook.net/en_US/all.js#appId=578ea8f7fdc0ab02b19d74c53d21a0c4&amp;xfbml=1"></script>
<fb:comments href="<%=url%>" num_posts="10" width="500"></fb:comments>
