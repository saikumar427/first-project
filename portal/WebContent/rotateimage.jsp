<%@ page import=" java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.contentbeelet.*" %>

<%!
static List homepageimagelist=new ArrayList();
static{
	homepageimagelist.add("/home/images/tennis.gif");
	homepageimagelist.add("/home/images/dance.gif");
	homepageimagelist.add("/home/images/cricket.gif");
	homepageimagelist.add("/home/images/yoga.gif");
	homepageimagelist.add("/home/images/business.gif");
	
}

java.util.Random randomnum=new java.util.Random();
%>

<%
			int num=randomnum.nextInt(homepageimagelist.size() );
%>

<%= PageUtil.startContentForGuest(null,request.getParameter("border"),request.getParameter("width"),true,"beelet-header") %>
		<a href='/portal/signup/signup.jsp?isnew=yes&UNITID=13579&entryunitid=13579' style='text-decoration:none'><img src='<%=(String)homepageimagelist.get(num) %>' border='0'> </a>
<%=PageUtil.endContent() %>

