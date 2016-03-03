<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent("Discussion Forum",request.getParameter("border"),request.getParameter("width"),true) );
%>

<body>

<script language='javascript' src='<%=EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js") %>/forum.js' >
function dummy(){}
</script>

<%
Vector v=null;
if(forums!=null){
DBManager dbmanager=new DBManager();
String query1=" select count(*) as count,f.forumid,to_char(max(postedat),'MM/DD/YYYY HH:MI AM') as postedat1 from forummessages f,forum f1 where f.forumid=f1.forumid and groupid=? group by f.forumid,createdat "
		+" union "
		+" select '0' as count,forumid,to_char(createdat,'MM/DD/YYYY HH:MI AM') as postedat1 from forum f1 where forumid not in(select forumid from forummessages) and groupid=? group by forumid,createdat ";

StatusObj statobj=dbmanager.executeSelectQuery(query1,new String [] {groupid,groupid});
int recordcount=statobj.getCount();
HashMap counthm=new HashMap();
if(statobj.getStatus()){
	for(int i=0;i<recordcount;i++){
		counthm.put(dbmanager.getValue(i,"forumid","0"),dbmanager.getValue(i,"count","0")+"-"+dbmanager.getValue(i,"postedat1","0"));
	}
}
%>
	<table border='0' cellpadding='5' cellspacing='0' width='100%'>
        <form action="/<%=appname%>/discussionforums/msg_action" method="POST" name='form'>
	<%= com.eventbee.general.PageUtil.writeHiddenCore( grouphm )%>
	<input type="hidden" name="forumid" value="<%=forumid%>" />
	<input type="hidden" name="mode" value="single" />
	<input type='hidden' name='page' value='Topic' />
	<tr  class='colheader'>
		<td align='left'><b>Forum</b></td>
		<td align='left'><b>Topics</b></td>
		<td align='left'><b>Last Modified</b></td>
	</tr>
	<%
	String base="evenbase";
	Set set=forums.entrySet();
	int k=0;
	for(Iterator i=set.iterator();i.hasNext();){
	Map.Entry entry=(Map.Entry)i.next();
	String forum_id=(String)entry.getKey();
	HashMap forummap=(HashMap)entry.getValue();
	base=(k%2==0)?"oddbase":"evenbase";
	k++;
	String count_date=GenUtil.getHMvalue(counthm,forum_id,"0");
	StringTokenizer st=new StringTokenizer(count_date,"-");
	%>
	<tr class='<%=base%>'>
	<td>
	<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/showForumTopics.jsp?forumid="+forum_id,grouphm)  %>'>
	<%=(String)forummap.get("forumname")%>
	</a>
	</td>
	<td>
	<a href='/<%=com.eventbee.general.PageUtil.appendLinkWithGroup(appname+"/mytasks/showForumTopics.jsp?forumid="+forum_id,grouphm)  %>'>
	<%=(st.hasMoreTokens())?st.nextToken():"0"%>
	</a>
	</td>
	<td><%=(st.hasMoreTokens())?st.nextToken():" "%>
	</td>
	</tr>

<%}%>
	</table>
<% }%>

</body>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>
