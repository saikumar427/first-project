<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*"%>
<%
String purpose=request.getParameter("purpose");
String id=request.getParameter("id");
HashMap wordmap=(HashMap)session.getAttribute(id+"_"+purpose);
if(wordmap==null){
wordmap=new HashMap();
if("INVITE_FRIEND_TO_CLASSIFIED".equals(purpose)){
String title=DbUtil.getVal("select  title from classifieds where classifiedid=?",new String [] {id});
	wordmap.put("#**name**#",title);
	wordmap.put("#**classifiedid**#",id);
	wordmap.put("#**UNITID**#","13579");
}else if("INVITE_FRIEND_TO_EVENT".equals(purpose)){
String title=DbUtil.getVal("select  eventname from eventinfo where eventid=?",new String [] {id});
	wordmap.put("#**name**#",title);
	wordmap.put("#**GROUPID**#",id);
	wordmap.put("#**UNITID**#","13579");
}
else if("INVITE_FRIEND_TO_BLOG".equals(purpose)){
String title=DbUtil.getVal("select pagename from wikepages where  pageid=?",new String [] {id});
	wordmap.put("#**name**#",title);
	wordmap.put("#**wid**#",id);
	wordmap.put("#**UNITID**#","13579");
}else if("EMAIL_HOMEPAGE".equals(purpose)){
	wordmap.put("#**name**#",request.getParameter("pageurl"));
	wordmap.put("#**URL**#","http://"+request.getParameter("pageurl"));
      wordmap.put("#**UNITID**#","13579");
}
}
session.setAttribute(id+"_"+purpose,wordmap);
response.sendRedirect("emailcompose.jsp?id="+id+"&purpose="+purpose);
%>
