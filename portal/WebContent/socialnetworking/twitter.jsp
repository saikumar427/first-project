<%@ page import="com.eventbee.general.EbeeConstantsF"%>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
%>
<%
String eid=request.getParameter("eid");
String eventname=request.getParameter("eventname");
String uri =serveraddress+"view/event/"+eid;
String twitterText="Check out "+eventname;
%>
<!--
<a href="http://twitter.com/share" class="twitter-share-button" data-url="<%=uri%>" data-text="<%=twitterText%>" data-count="vertical" data-via="eventbee">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
-->
<a href="http://twitter.com/share" class="twitter-share-button" data-url="<%=uri%>" data-text="<%=twitterText%>" data-count="vertical" data-via="eventbee" rel="external">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>