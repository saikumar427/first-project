<%@ page import="com.eventbee.general.*"%>



<%
String groupid=request.getParameter("clubid");
String grouptype=request.getParameter("grouptype");
String content=request.getParameter("content").trim();
String isExists=DbUtil.getVal("select 'yes' from content_beelet  where group_id=? and group_type=?",new String[]{groupid,grouptype});
if(content!=null&&!"".equals(content)){
if("yes".equals(isExists)){
DbUtil.executeUpdateQuery("update content_beelet set content=? where group_id=? and group_type=?",new String[]{content,groupid,grouptype});
}
else{
String contentbeeletid=DbUtil.getVal("select nextval('seq_emailbeeletid') as beeletid ",new String[]{});
DbUtil.executeUpdateQuery("insert into content_beelet(group_id,group_type,contentbeeletid,content) values(?,?,?,?)",new String[]{groupid,grouptype,contentbeeletid,content});

}
%>

<table width="70%" align="center">
<tr height="50"><td></td></tr>
	
<tr><td align="center">
Content Is Inserted</td></tr></table><%
}




else{


%>
<table width="70%" align="center">
<tr height="50"><td></td></tr>
	
<tr><td align="center">
Not Inserted</td></tr></table>
<%}%>