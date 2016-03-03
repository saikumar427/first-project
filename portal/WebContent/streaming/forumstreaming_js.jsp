<%@ page import="java.util.*,java.sql.*,java.net.URLEncoder,com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
Authenticate authData=AuthUtil.getAuthData(pageContext);
String loginname="";
String streamforums=request.getParameter("streamforums");
if(streamforums==null) streamforums="all";

String retrievecount=request.getParameter("retrievecount");
if(retrievecount==null)retrievecount="5";

String streamsize=request.getParameter("streamsize");
if(streamsize==null)streamsize="SQ";

String background=request.getParameter("background");
if(background==null)background="#FFFFFF";

String bordercolor=request.getParameter("bordercolor");
if(bordercolor==null||"null".equals(bordercolor)) bordercolor="#660033";

String linkcolor=request.getParameter("linkcolor");
if(linkcolor==null||"null".equals(linkcolor)) linkcolor="#3300CC";

String bigtextcolor=request.getParameter("bigtextcolor");
if(bigtextcolor==null||"null".equals(bigtextcolor))bigtextcolor="#3300CC";

String bigfonttype=request.getParameter("bigfonttype");
if(bigfonttype==null||"null".equals(bigfonttype)) bigfonttype="Verdana";

String bigfontsize=request.getParameter("bigfontsize");
if(bigfontsize==null||"null".equals(bigfontsize)) bigfontsize="21px";

String medtextcolor=request.getParameter("medtextcolor");
if(medtextcolor==null||"null".equals(medtextcolor)) medtextcolor="#3300CC";

String medfonttype=request.getParameter("medfonttype");
if(medfonttype==null||"null".equals(medfonttype))medfonttype="Verdana";

String medfontsize=request.getParameter("medfontsize");
if(medfontsize==null||"null".equals(medfontsize))medfontsize="15px";

String smalltextcolor=request.getParameter("smalltextcolor");
if(smalltextcolor==null||"null".equals(smalltextcolor)) smalltextcolor="#FF6600";

String smallfonttype=request.getParameter("smallfonttype");
if(smallfonttype==null||"null".equals(smallfonttype)) smallfonttype="Verdana";

String smallfontsize=request.getParameter("smallfontsize");
if(smallfontsize==null||"null".equals(smallfontsize)) smallfontsize="11px";

String forumlink=request.getParameter("forumlink");
if(forumlink==null)forumlink="yes";

String displaypowerlink=request.getParameter("displaypowerlink");
if(displaypowerlink==null)displaypowerlink="yes";

HashMap params=new HashMap();
params.put("streamforums",streamforums);
params.put("retrievecount",retrievecount);

//String heightstr=EbeeConstantsF.get("forum.streaming."+streamsize+".height","300");
//String widthstr=EbeeConstantsF.get("forum.streaming."+streamsize+".width","350");

String heightstr="250";
String widthstr=streamsize;

int position=0;
int no_of_records=3;
int totalrecords=0;
String link="";
String listclass="block";
int display_records=2;
int display_offset=0;
int columns=2;
int height=305;
int width=180;
boolean scrollauto=false;
boolean displayrandom=true;
boolean showlogo=true;

String ulclass=listclass + "forumlist";
String liclass=listclass + "forumitem";
String blockclass=listclass + "forumblock";
if(retrievecount != null){
	no_of_records = Integer.parseInt(retrievecount);
}
if(heightstr != null){
        height = Integer.parseInt(heightstr);
}
if(widthstr != null){
        width = Integer.parseInt(widthstr);
}
String groupid=request.getParameter("GROUPID");

HashMap forums =StreamingDB.getForumList(serveraddress,params,groupid);
if(forums!=null&&forums.size()>0)
{
%>
	document.write('<style type="text/css">');
	document.write('.ItemForumBody {');
	document.write('        font-family:<%=medfonttype%> ;');
	document.write('        font-size:<%=medfontsize%>;');
	document.write('        color: <%=medtextcolor%>;');
	document.write('        padding: 1px;');
	document.write('        margin-top: 0px;');
	document.write('        margin-left: 5px;');
	document.write('        margin-right: 5px;');
        document.write('        margin-bottom: 10px;');
	document.write('}');
	
	document.write('.forumtitletop {');
	document.write('        font-family: <%=bigfonttype%>;');
	document.write('        font-size:<%=bigfontsize%>;');
	document.write('        color: <%=bigtextcolor%>;');
	document.write('        font-weight:bold;');
	document.write('        text-align:center;');
	document.write('        margin-top: 0px;');
	document.write('        margin-bottom: 15px;');
	document.write('}');
	
	document.write('.forumbottom {');
	document.write('        font-family: <%=smallfonttype%>;');
	document.write('        font-size:<%=smallfontsize%>;');
	document.write('        color: <%=smalltextcolor%>;');
	document.write('		padding: 5px;');
	document.write('}       ');
	
	document.write('.blockforumblock{');
	document.write('        border: solid 1px <%=bordercolor%>;');
	document.write('        width:<%=width%>;');
	//document.write('        height:<%=height-10%>px;');
	document.write('        font-size:11px;');
	document.write('        background:<%=background%>;');
	document.write('}');
	
	document.write('.blockforumlist{');
	document.write('        margin-top: 5;');
	document.write('        margin-bottom: 0;');
	document.write('        margin-left: 0;');
	document.write('        margin-right: 0;');
	document.write('        padding: 0;');
	document.write('        border: solid 0px <%=bordercolor%>;');
	document.write('        background:<%=background%>;');
	document.write('}');
	
	document.write('.blockforumitem {');
	document.write('	display: inline; ');
	document.write('	list-style-type: none; ');
	document.write('	list-style-image: none; ');
	document.write('	padding: 0; ');
	document.write('        margin-right: 3;');
	document.write('        margin-left: 3;');
	document.write('        margin-top: 3;');
        document.write('        margin-bottom: 39;');
	document.write('        background:<%=background%>;');
	document.write('} ');
	document.write('img{');
	document.write('	border: solid 0px <%=bordercolor%>; ');
	document.write('	margin-left: 0px; ');
	document.write('} ');
	document.write('.blockforumitem a { ');
	document.write('	 color: <%=linkcolor%> ');
	document.write('}');
	document.write('a {');
	document.write('        text-decoration: none;');
	document.write('        font-family: Verdana;');
	//document.write('        font-weight: bold;');
	document.write('        color: <%=linkcolor%>;');
	document.write('}');
	
	document.write('</style>');

<%	
	out.print("var ITEMS=[");
     	String forum="";
	DBManager dbmanager=new DBManager();
	String Query1="select forumid from forum where groupid=? order by forumid desc";
		StatusObj statobj1=dbmanager.executeSelectQuery(Query1,new String[]{groupid});
	 	ArrayList list1 = new ArrayList();
		if(statobj1.getStatus())
		{      String [] columnname=dbmanager.getColumnNames();
				for(int i=0;i<statobj1.getCount();i++)
				{
					//forumids = columnname[0];
					forum=dbmanager.getValue(i,columnname[0],"");
					list1.add(i,forum);
				}	
		}
		
		
	Iterator iter=list1.iterator();
	while (iter.hasNext())
	{
		out.print("{ 'file': '', ");
		out.print(" 'content' : '");
		out.print("<li class=\"" + liclass  + "\">");
		
		if(forums!=null&&forums.size()>0)
		{
	
			String fid=(String)iter.next();
			
		    ArrayList fidlist=(ArrayList)forums.get(fid);
		    
		    
		    String forumname1=DbUtil.getVal("select forumname from forum where forumid=?",new String[]{fid});
	    	String ftopiccount=DbUtil.getVal("select count(*) from forummessages where forumid=?",new String[]{fid});
	    	
	    	int cnt=(Integer.parseInt(ftopiccount));
	    	
	 		//String forumnamelink="<a href="+serveraddress+"portal/discussionforums/logic/showForumTopics.jsp?forumid="+fid+"&GROUPID="+groupid"+">"+forumname1+"</a>";	
	 		
			if(cnt>0)
			{
			if("yes".equals(forumlink)){
			out.print("<div class=\"forumtitletop\">");
			out.print(forumname1);
			out.print("</div>");
			}
			}
						
			for(int j=0;j<fidlist.size();j++)
			{
				HashMap records=(HashMap)fidlist.get(j);
				
				String subject=(String)GenUtil.getHMvalue(records,"subject","0");
				String forumid=(String)GenUtil.getHMvalue(records,"forumid","0");
				String msgid=(String)GenUtil.getHMvalue(records,"msgid","0");
				String userid=(String)GenUtil.getHMvalue(records,"postedby","0");
				String grouptype=(String)GenUtil.getHMvalue(records,"grouptype","0");
				String parentid=(String)GenUtil.getHMvalue(records,"parentid","0");
				String topicid=(String)GenUtil.getHMvalue(records,"topicid","0");
				String name=(String)GenUtil.getHMvalue(records,"name","0");
				 
				String count=DbUtil.getVal("select count(*) from forummessages where topicid=?",new String []{msgid});
			
				String subjlink="&raquo;<a href="+serveraddress+"portal/guesttasks/showTopicMessages.jsp?forumid="+forumid+"&topicid="+msgid+"&GROUPID="+request.getParameter("GROUPID")+"&GROUPTYPE="+grouptype+">"+subject+"</a>";
				String userlink="<a href="+serveraddress+"portal/editprofiles/networkuserprofile.jsp?userid="+userid+"&GROUPID="+request.getParameter("GROUPID")+"&GROUPTYPE=Club"+">"+name+"</a>";
					
					out.print("<div class=\"ItemForumBody\" >");
					out.print(subjlink+"  "+"("+count+" Replies)");
					out.print("</div>");
					
			}
			out.print("</li>");
			
			out.print("', 'pause_b': 1, 'pause_a': 0  }, ");
		}
	}
out.println("]");
%>

document.write('<div class="<%=blockclass%>" >');

document.write('<ul class="<%=ulclass%>">');
var items=ITEMS;
for (var i in items) {
        document.write(items[i].content);
}
document.write('</ul>');

document.write('<div class="forumbottom">');
document.write('<table >');
document.write('<tr>');
document.write('<td align="left" width="<%=width-50%>" >');
<%
if("yes".equals(displaypowerlink)){%>
document.write('<a href="<%=serveraddress%>" target="_parent" style="text-decoration: none;  font-weight: bold ;font-size:<%=smallfontsize%>; font-family: <%=smallfonttype%>;  " ><font color="<%=smalltextcolor%>">Powered by Eventbee</font></a>');
<%
}%>

document.write('</td>');
document.write('<td align="right" width="<%=width-50%>" >');

<%
if("all".equals(streamforums)){%>

document.write('<a href="<%=serveraddress%>hub/clubview.jsp?GROUPID=<%=request.getParameter("GROUPID")%>" target="_parent" style="text-decoration: none;  font-size: <%=smallfontsize%>;  font-family: <%=smallfonttype%>; font-weight: bold ; "  > <font color="<%=smalltextcolor%>">View All Topics</font></a>');

<%}else{%>
document.write('<a href="<%=serveraddress%>club/myhubs.jsp" target="_parent" style="text-decoration: none; font-weight: bold"><font color="<%=smalltextcolor%>; font-weight: bold ;"> More Forums</font></a>');
<%}%>
document.write('</td>');
document.write('</tr>');
document.write('</table>');
document.write('</div>');
document.write('</div>');
<%
}
%>

