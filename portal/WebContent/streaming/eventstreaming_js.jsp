<%@ page import="java.util.*,java.sql.*,java.net.URLEncoder,com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%@ page import="com.eventbee.streamer.*"%>
<%!
HashMap<String,String> getAttribValues(String userid,String module){
	HashMap<String,String> defaultValues=new HashMap<String,String>();
	defaultValues=getDefaultAttribs(module);
	DBManager dbmanager=new DBManager();
	StatusObj statobj=null;
	String attribValsQuery="select attrib_name,attrib_value from user_display_attribs " +
			"where userid::text=? and module=?";
	statobj=dbmanager.executeSelectQuery(attribValsQuery,new String []{userid,module});
	int count=statobj.getCount();
	if(statobj.getStatus() && count>0){
		for(int k=0;k<count;k++){
			 String attribname=dbmanager.getValue(k,"attrib_name","");
			 String attribval=dbmanager.getValue(k,"attrib_value","");
			 if(defaultValues.containsKey(attribname)){
				 defaultValues.remove(attribname);
			 }
			 defaultValues.put(attribname, attribval);
		}
		}
	return defaultValues;
	
}
HashMap<String,String> getDefaultAttribs(String module){
	HashMap<String,String> defaultAttribMap=new HashMap<String,String>();
	String defaultValsQuery="select attribname,attribdefaultvalue from user_display_defaultattribs where module=?";
	DBManager dbmanager=new DBManager();
	StatusObj statobj=null;
	statobj=dbmanager.executeSelectQuery(defaultValsQuery,new String []{module});
	int count=statobj.getCount();
	if(statobj.getStatus() && count>0){
		for(int k=0;k<count;k++){
		    String attribname=dbmanager.getValue(k,"attribname","");
		    String attribval=dbmanager.getValue(k,"attribdefaultvalue","");
		    defaultAttribMap.put(attribname, attribval);
		}
	}
	return defaultAttribMap;
}
%>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
Authenticate authData=AuthUtil.getAuthData(pageContext);
String userid="";
if(authData!=null)
	userid=authData.getUserID();
if("".equals(userid)) userid=request.getParameter("refid");
HashMap<String,String> streamerData=new HashMap<String,String>();
streamerData=getAttribValues(userid, "maineventstreamer");
//System.out.println("streamerData:::::::::::"+streamerData);

String title=streamerData.get("TITLE");
if(title==null) title="";

String location=streamerData.get("LOCATION");
if(location==null) location="USA";

String category=streamerData.get("CATEGORY");
if(category==null) category="All";

String retrievecount=streamerData.get("NO_OF_ITEMS");
if(retrievecount==null) retrievecount="10";

String streamsize=streamerData.get("STREAMERSIZE");
if(streamsize==null) streamsize="SQ";

String bgtype=streamerData.get("BG_TYPE");
if(bgtype==null) bgtype="COLOR";

String bgcolor=streamerData.get("BACKGROUND_COLOR");
String bgimage=streamerData.get("BACKGROUND_IMAGE");
if(bgcolor==null) bgcolor="#FFFFFF";

String background="";
if("IMAGE".equalsIgnoreCase(bgtype)){
background=	"http://"+EbeeConstantsF.get("serveraddress","");
background="url("+background+bgimage+")";

}
	else
	background=bgcolor;


String bordercolor=streamerData.get("BORDERCOLOR");
if(bordercolor==null||"null".equals(bordercolor)) bordercolor="#660033";

String linkcolor=streamerData.get("LINKCOLOR");
if(linkcolor==null||"null".equals(linkcolor)) linkcolor="#3300CC";

String bigtextcolor=streamerData.get("BIGGER_TEXT_COLOR");
if(bigtextcolor==null||"null".equals(bigtextcolor))bigtextcolor="#3300CC";

String bigfonttype=streamerData.get("BIGGER_FONT_TYPE");
if(bigfonttype==null||"null".equals(bigfonttype)) bigfonttype="Verdana";

String bigfontsize=streamerData.get("BIGGER_FONT_SIZE");
if(bigfontsize==null||"null".equals(bigfontsize)) bigfontsize="21px";

String medtextcolor=streamerData.get("MEDIUM_TEXT_COLOR");
if(medtextcolor==null||"null".equals(medtextcolor)) medtextcolor="#3300CC";

String medfonttype=streamerData.get("MEDIUM_FONT_TYPE");
if(medfonttype==null||"null".equals(medfonttype))medfonttype="Verdana";

String medfontsize=streamerData.get("MEDIUM_FONT_SIZE");
if(medfontsize==null||"null".equals(medfontsize))medfontsize="15px";

String smalltextcolor=streamerData.get("SMALL_TEXT_COLOR");
if(smalltextcolor==null||"null".equals(smalltextcolor)) smalltextcolor="#FF6600";

String smallfonttype=streamerData.get("SMALL_FONT_TYPE");
if(smallfonttype==null||"null".equals(smallfonttype)) smallfonttype="Verdana";

String smallfontsize=streamerData.get("SMALL_FONT_SIZE");
if(smallfontsize==null||"null".equals(smallfontsize)) smallfontsize="11px";

String displaypowerlink=streamerData.get("DISPLAYEBEELINK");
if(displaypowerlink==null)displaypowerlink="yes";

String heightstr="250";
String widthstr=streamsize;

try{Integer.parseInt(widthstr);}
catch(Exception e)
{System.out.println("eventstreaming_js sure numberformat"+e.getMessage());widthstr="100";}


HashMap params=new HashMap();
params.put("location",location);
params.put("category",category);
params.put("retrievecount",retrievecount);
params.put("userid",userid);
int position=0;
int no_of_records=10;
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
String ulclass=listclass + "list";
String liclass=listclass + "item";
String blockclass=listclass + "block";
if(retrievecount != null){
	no_of_records = Integer.parseInt(retrievecount);
}
if(heightstr != null){
        height = Integer.parseInt(heightstr);
}
if(widthstr != null){
        width = Integer.parseInt(widthstr);
}
String coutcss=streamerData.get("coustumcss");
if(coutcss!=null ){
String src="'";
String dec="\\\\'";
coutcss=coutcss.replaceAll(src,dec);
coutcss=coutcss.replaceAll("\r\n"," ");
}
coutcss=coutcss==null?"":coutcss;

Vector events =StreamingDB.getEventList(serveraddress,params);
%>
document.write('<style type="text/css">');
document.write('.ItemBody {');
document.write('        font-family: <%=medfonttype%>;');
document.write('        font-size:<%=medfontsize%>;');
document.write('        padding: 0px;');
document.write('        color: <%=medtextcolor%>;');
document.write('        margin-top: 0px;');
document.write('        margin-left: 5px;');
document.write('        margin-right: 5px;');
document.write('        margin-bottom: 10px;');
document.write('}');
document.write('.titletop {');
document.write('        font-family: <%=bigfonttype%>;');
document.write('        font-size:<%=bigfontsize%>;');
document.write('        font-weight:bold;');
document.write('        text-align:center;');
document.write('        color: <%=bigtextcolor%>;');
document.write('        margin-top: 0px;');
document.write('        margin-bottom: 15px;');
document.write('}');
document.write('.bottom {');
document.write('	z-index: 10;');
document.write('        text-align:center;');
document.write('        font-family: <%=smallfonttype%>;');
document.write('        font-size:<%=smallfontsize%>;');
document.write('        color: <%=smalltextcolor%>;');
document.write('	padding: 5px;');
document.write('}       ');
document.write('.blockblock{');
document.write('        border: solid 1px <%=bordercolor%>;');
document.write('        width:<%=width%>;');
document.write('        font-size:11px;');
document.write('        background:<%=background%>;');
document.write('}');
document.write('.blocklist{');
document.write('        margin-top: 5;');
document.write('        margin-bottom: 0;');
document.write('        margin-left: 0;');
document.write('        margin-right: 0;');
document.write('        padding: 0;');
document.write('        border: solid 0px <%=bordercolor%>;');
document.write('        background:<%=background%>;');
document.write('}');
document.write('.blockitem {');
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
document.write('.blockitem a { ');
document.write('	 color: <%=linkcolor%> ');
document.write('}');
document.write('blockblock a {');
document.write('        text-decoration: none;');
document.write('        font-family: Verdana;');
document.write('        color: <%=linkcolor%>;');
document.write('}');
<%if(!"".equals(coutcss))%>
document.write('<%=coutcss%>');

document.write('</style>');
document.write('<div class="<%=blockclass%>" >');
document.write('<ul class="<%=ulclass%>">');

<%
if(!"".equals(title)){%>
document.write('<li class="<%=liclass%>">');
document.write('<div class="titletop" >');
document.write('<%=title%>');
document.write('</div>');
document.write('</li>');
<%}%>
<%
if(events!=null){
for(int i=0;i<events.size();i++){
HashMap eventmap=(HashMap)events.get(i);
%>
document.write('<li class="<%=liclass%>">');
document.write('<div class="ItemBody">');
document.write('<%=GenUtil.getHMvalue(eventmap,"startdate","",false)%>');	
document.write('  ');
document.write('<%=GenUtil.getHMvalue(eventmap,"eventname","0")%>');
document.write('</div>');
document.write('</li>');
 <%      
}}

%>
document.write('</ul>');
<%
if("yes".equals(displaypowerlink)){%>
document.write('<div class="bottom"><a href="<%=serveraddress%>" target="blank" style="text-decoration: none; " ><font color="#696969">Powered By Eventbee</font></a></div>');
<%
}%>document.write('</div>');



