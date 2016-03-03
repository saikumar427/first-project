<%@ page import="java.util.*,java.sql.*,java.net.URLEncoder,com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.pagenating.*,java.text.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.streamer.*"%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
Authenticate authData=AuthUtil.getAuthData(pageContext);
String loginname="";
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

String displaypowerlink=request.getParameter("displaypowerlink");
if(displaypowerlink==null||"null".equals(displaypowerlink)) displaypowerlink="yes";

String eventid=request.getParameter("GROUPID");

String agentid=request.getParameter("participant");

//String heightstr=EbeeConstantsF.get("event.streamer."+streamsize+".height","200");
//String widthstr=EbeeConstantsF.get("event.stream."+streamsize+".width","160");
String heightstr="200";
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

String ulclass=listclass + "eventlist";
String liclass=listclass + "eventitem";
String blockclass=listclass + "eventblock";

if(heightstr != null){
        height = Integer.parseInt(heightstr);
}
if(widthstr != null){
        width = Integer.parseInt(widthstr);
}

HashMap eventmap =StreamingDB.getEventInfo(serveraddress,eventid);

if(eventmap!=null){
%>
document.write('<style type="text/css">');
document.write('.EventItemBody {');
document.write('        font-family: <%=medfonttype%>;');
document.write('        font-size:<%=medfontsize%>;');
document.write('	line-height: 95%;');
document.write('        padding: 0px;');
document.write('        margin-top: 0px;');
document.write('        margin-left: 5px;');
document.write('        margin-right: 5px;');
document.write('        margin-bottom: 10px;');
document.write('        color: <%=medtextcolor%>;');
document.write('}');
document.write('.eventtitletop {');
document.write('        font-family: <%=bigfonttype%>;');
document.write('        font-size:<%=bigfontsize%>;');
document.write('        font-weight:bold;');
document.write('        text-align:center;');
document.write('        margin-top: 0px;');
document.write('        margin-bottom: 15px;');
document.write('        color: <%=bigtextcolor%>;');
document.write('}');
document.write('.bottomlink {');
document.write('        text-align:center;');
document.write('        font-family: <%=smallfonttype%>;');
document.write('        font-size:<%=smallfontsize%>;');
document.write('        text-align:center;');
document.write('        color: <%=smalltextcolor%>;');
document.write('	padding: 5px;');
document.write('}       ');
document.write('.blockeventblock{');
document.write('        border: solid 1px <%=bordercolor%>;');
document.write('        width:<%=width%>;');
//document.write('        height:<%=height-10%>px;');
document.write('        font-size:11px;');
document.write('        background:<%=background%>;');

document.write('}');
document.write('.blockeventlist{');
document.write('        margin-top: 5;');
document.write('        margin-bottom: 0;');
document.write('        margin-left: 0;');
document.write('        margin-right: 0;');
document.write('        padding: 0;');
document.write('        border: solid 0px <%=bordercolor%>;');
document.write('        background:<%=background%>;');

document.write('}');
document.write('.blockeventitem {');
document.write('	display: inline; ');
document.write('        font-family: Verdana;');
document.write('        font-size:2px;');
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
document.write('.blockeventitem a { ');
document.write('	 color: <%=linkcolor%> ');
document.write('}');
document.write('a {');
document.write('        text-decoration: none;');
document.write('        font-family: Verdana;');
document.write('        color: <%=linkcolor%>;');
document.write('}');
document.write('.toptable {'); 
document.write('	background-color: white ; '); 
document.write('	border-color:  black; ');
document.write('	border-style: solid; ');
document.write('	border-top-width: 1px; ');
document.write('	border-right-width: 1px; ');
document.write('	border-bottom-width: 1px;  ');
document.write('	border-left-width: 1px; ');
document.write('	padding-top: 0px; ');
document.write('	padding-bottom: 0px; ');
document.write('	padding-left:0px; ');
document.write('	padding-right:0px; ');
document.write('}');
document.write('.upline {  border-color:black;border-style : solid; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 1px;  height:8px; padding-top: 0px; padding-bottom: 0px; padding-left:0px; padding-right:0px}');
document.write('.toptable1 { height:8px; border-color:  black; border-style: solid; border-top-width: 0px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 1px; padding-top: 0px; padding-bottom: 0px; padding-left:0px; padding-right:0px}');
document.write('.toptable2 { height:8px; border-color:  black; border-style: solid; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px; padding-bottom: 0px; padding-left:0px; padding-right:0px}');
document.write('.shadetable { background-color: red ;  border-color:  black; border-style: solid; border-top-width: 0px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px; padding-top: 0px; padding-bottom: 0px; padding-left:0px; padding-right:0px}');
document.write('</style>');

<%	
String raisedamt=null;
int gwidth=-1;
double goalamt=0.0;
String totaldonationamt=null;
String campaigngoalgraph=null;
double donatedamt=0.0;
String colorclass="";
Currency dollars = Currency.getInstance("USD");
NumberFormat usFormat = NumberFormat.getCurrencyInstance(Locale.US);
String totgoalamt=null;
String donatamt=null;
String title=null;
String path=ShortUrlPattern.get(GenUtil.getHMvalue(eventmap,"username","",false))+"/event";
out.print("var ITEMS=[");

	out.print("{ 'file': '', ");
	out.print(" 'content' : '");
     		
	     try{
	     		if(agentid!=null&&!"".equals(agentid)&&!"null".equals(agentid)){
	     			HashMap agenthm=StreamingDB.getAgentDetails(agentid);
	     			title=(String)agenthm.get("title");
	     			String gamt=(String)agenthm.get("goalamount");
	     			if (gamt==null||"".equals(gamt)||"null".equals(gamt))
	     			gamt="0";
	     			goalamt=Double.parseDouble(gamt);
	     			  			
				totaldonationamt=DbUtil.getVal("select sum(to_number(grandtotal,'9999.99')) as d_amount from transaction where agentid=? and refid=?",new String [] {agentid,eventid});
				}else {
			         title=GenUtil.getHMvalue(eventmap,"eventname","",false) ;
			      }
			if(totaldonationamt==null)totaldonationamt="0";
			donatedamt=Double.parseDouble(totaldonationamt);
			if(goalamt>0){
								
				if(donatedamt>0){
					gwidth=(int)(donatedamt*150/goalamt);
					colorclass="shadetable";
				}
			}
				totgoalamt=usFormat.format(goalamt);
				donatamt=usFormat.format(donatedamt);
			
		}catch(Exception e){
			System.out.println("exception : "+e.getMessage());
		}

		if(title.indexOf("'")>-1){
			title=title.replaceAll("'","&#39;");
		}
     		out.print("<form  action=\""+ path +"\">");
		out.print("<li class=\"" + liclass  + "\">");
		out.print("<table border=\"0\"  cellspacing=\"0\" cellpadding=\"5\" align=\"center\">");
		out.print("<tr><td  align=\"center\">");
		out.print("<div class=\"eventtitletop\">");
		out.print(title);
		out.print("</div>");
		out.print("</td></tr>");
		if(agentid!=null){
		out.print("<tr><td align=\"center\">");
		out.print("<table width=\"100%\"  cellspacing=\"0\" cellpadding=\"0\" border=\"0\" >");
		out.print("<tr><td height=\"5\" align=\"center\">");
		out.print("<table width=\"150\" height=\"30\" cellspacing=\"0\" cellpadding=\"0\" class=\"toptable\"> ");
		out.print("<tr><td width=\""+gwidth+"\" height=\"15\" class=\""+colorclass+"\"></td><td width=\""+(150-gwidth)+"\" height=\"5\"></td></tr>");
		out.print("</table></td></tr>");
		out.print("<tr ><td height=\"8px\" align=\"center\"> ");
		out.print("<table width=\"150\" cellspacing=\"0\" cellpadding=\"0\" class=\"toptable1\"  >");
		out.print("<tr><td width=\"45\"><span  style=\"float:right\"   class=\"upline\" height=\"8px\"></span></td>");
		out.print("<td width=\"45\" ><span  style=\"float:right\"   class=\"upline\"></span></td>");
		out.print("<td width=\"45\" ><span  style=\"float:right\"   class=\"upline\"></span></td>");
		out.print("<td width=\"45\" ></td></tr> </table></td></tr>");
		out.print("<tr><td align=\"center\"><table width=\"150\" cellspacing=\"0\" cellpadding=\"0\" class=\"toptable2\" ><tr>");
		out.print("<td width=\"45\"> <span  style=\"float:left\" ><font size=\"1\">0%</font></span></td>");
		out.print("<td width=\"45\"><span  style=\"float:right; align:center\" ><font size=\"1\">25%</font></span></td>");
		out.print("<td width=\"45\" ><span  style=\"float:right\"><font size=\"1\">50%</font></span></td>");
		out.print("<td width=\"45\" ><span  style=\"float:right\" ><font size=\"1\">75%</font></span></td>");
		out.print("<td width=\"45\" ><span  style=\"float:right\" ><font size=\"1\">100%</font></span></td>");
		out.print("</tr>  </table>");
		out.print("</td></tr></table>");
		out.print("</td></tr>");
		out.print("<tr><td align=\"center\">");
		out.print("<div class=\"EventItemBody\">");
		out.print("Goal:&nbsp;"+totgoalamt);
		out.print("&nbsp;&nbsp;");
		out.print("Sold:&nbsp;"+donatamt);
		}
		else{
		out.print("<tr><td align=\"center\">");
		out.print("<table height=\"0\" cellpadding=\"0\" align=\"center\">");
		out.print("<tr><td>");
		out.print("<div class=\"EventItemBody\">");
		out.print(GenUtil.getHMvalue(eventmap,"start_date","",false)+", ");
		out.print(DateTime.getTimeAM(GenUtil.getHMvalue(eventmap,"starttime","",false)));
		out.print(" - ");
		out.print(GenUtil.getHMvalue(eventmap,"end_date","",false)+", ");
		out.print(DateTime.getTimeAM(GenUtil.getHMvalue(eventmap,"endtime","",false)));
		out.print("</div>");
		out.print("</td></tr>");
		out.print("<tr><td align=\"center\">");
		out.print("<div class=\"EventItemBody\">");
		
		out.print(GenUtil.getHMvalue(eventmap,"city","",false));
		if(GenUtil.getHMvalue(eventmap,"city","",false)!=null&&!"".equals(GenUtil.getHMvalue(eventmap,"city","",false)))
		out.print(", ");
		out.print(GenUtil.getHMvalue(eventmap,"state","",false));
		if(GenUtil.getHMvalue(eventmap,"state","",false)!=null&&!"".equals(GenUtil.getHMvalue(eventmap,"state","",false)))
		out.print(", ");
		out.print(GenUtil.getHMvalue(eventmap,"country","",false));
		out.print("</div>");
		out.print("</td></tr>");
		out.print("</table>");
		
		out.print("</td></tr>");
		}
		out.print("<tr><td align=\"center\">");
		out.print("<input type=\"submit\" value=\"Register\" >");
		out.print("</td></tr>");
		out.print("</div>");
		out.print("<input type=\"hidden\" name=\"eventid\" value=\""+eventid+"\" />");
		if(agentid!=null)
		out.print("<input type=\"hidden\" name=\"participant\" value=\""+agentid+"\" />");
		
		out.print("</table>");
		out.print("</li>");
		out.print("</form>");	
	out.print("', 'pause_b': 1, 'pause_a': 0  }, ");
	
out.println("]");
%>

document.write('<div class="<%=blockclass%>" >');

document.write('<ul class="<%=ulclass%>">');
var items=ITEMS;
for (var i in items) {
        document.write(items[i].content);
}
document.write('</ul>');
document.write('<div class="bottomlink">');
document.write('<table align=\"center\">');
<%
if("yes".equals(displaypowerlink)){%>
document.write('<a href="<%=serveraddress%>" target="_parent" style="text-decoration: none; "    ><font color="<%=smalltextcolor%>">Tickets by Eventbee</font></a>');
<%
}%>

document.write('</table>');
document.write('</div>');
document.write('</div>');
<%
}
%>