<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String [] attributes={"TITLE","NO_OF_ITEMS","CATEGORY","STREAMERSIZE","BACKGROUND","BORDERCOLOR","LINKCOLOR","BIGGER_TEXT_COLOR","BIGGER_FONT_TYPE",
		      "BIGGER_FONT_SIZE","MEDIUM_TEXT_COLOR","MEDIUM_FONT_TYPE","MEDIUM_FONT_SIZE","SMALL_TEXT_COLOR",
		      "SMALL_FONT_TYPE","SMALL_FONT_SIZE","DISPLAYEBEELINK"};

String str="";

String background=request.getParameter("BACKGROUND");
if("BACKGROUND_COLOR".equals(background)){
	background= request.getParameter("BACKGROUND_COLOR");
	background=java.net.URLEncoder.encode(background);
	}
else{
	background=request.getParameter("BACKGROUND_IMAGE");
	background="url("+background+")";
	
    }
    
String title=request.getParameter("TITLE");
if(title!=null)
str=str+"&title="+title;
String partnerid=request.getParameter("partnerid");
str=str+"&partnerid="+partnerid;
String no_of_items=request.getParameter("NO_OF_ITEMS");
if(no_of_items==null)no_of_items="5";
str=str+"&retrievecount="+no_of_items;
/*
String category=request.getParameter("CATEGORY");

if(category==null)category="All";

*/
String category=request.getParameter("ALLCATEGORY");

if(category!=null) 	{
	category="All";
}else {
	String categories[]=request.getParameterValues("CATEGORY");
	category=GenUtil.stringArrayToStr(categories,",");
	if("".equals(category.trim()))
		category="All";
	}

str=str+"&category="+category;


String streamsize=request.getParameter("STREAMERSIZE");
if(streamsize==null||"null".equals(streamsize)) streamsize="250";
str=str+"&streamsize="+streamsize;

str=str+"&background="+background;
String bordercolor=request.getParameter("BORDERCOLOR");
if(bordercolor==null||"null".equals(bordercolor)) bordercolor="#660033";
str=str+"&bordercolor="+java.net.URLEncoder.encode(bordercolor);

String linkcolor=request.getParameter("LINKCOLOR");
if(linkcolor==null||"null".equals(linkcolor)) linkcolor="#3300CC";
str=str+"&linkcolor="+java.net.URLEncoder.encode(linkcolor);

String bigtextcolor=request.getParameter("BIGGER_TEXT_COLOR");
if(bigtextcolor==null||"null".equals(bigtextcolor))bigtextcolor="#3300CC";
str=str+"&bigtextcolor="+java.net.URLEncoder.encode(bigtextcolor);

String bigfonttype=request.getParameter("BIGGER_FONT_TYPE");
if(bigfonttype==null||"null".equals(bigfonttype)) bigfonttype="Verdana";
str=str+"&bigfonttype="+java.net.URLEncoder.encode(bigfonttype);

String bigfontsize=request.getParameter("BIGGER_FONT_SIZE");
if(bigfontsize==null||"null".equals(bigfontsize)) bigfontsize="21px";
str=str+"&bigfontsize="+bigfontsize;

String medtextcolor=request.getParameter("MEDIUM_TEXT_COLOR");
if(medtextcolor==null||"null".equals(medtextcolor)) medtextcolor="#3300CC";
str=str+"&medtextcolor="+java.net.URLEncoder.encode(medtextcolor);

String medfonttype=request.getParameter("MEDIUM_FONT_TYPE");
if(medfonttype==null||"null".equals(medfonttype))medfonttype="Verdana";
str=str+"&medfonttype="+java.net.URLEncoder.encode(medfonttype);

String medfontsize=request.getParameter("MEDIUM_FONT_SIZE");
if(medfontsize==null||"null".equals(medfontsize))medfontsize="15px";
str=str+"&medfontsize="+java.net.URLEncoder.encode(medfontsize);

String smalltextcolor=request.getParameter("SMALL_TEXT_COLOR");
if(smalltextcolor==null||"null".equals(smalltextcolor)) smalltextcolor="#FF6600";
str=str+"&smalltextcolor="+java.net.URLEncoder.encode(smalltextcolor);

String smallfonttype=request.getParameter("SMALL_FONT_TYPE");
if(smallfonttype==null||"null".equals(smallfonttype)) smallfonttype="Verdana";
str=str+"&smallfonttype="+java.net.URLEncoder.encode(smallfonttype);

String smallfontsize=request.getParameter("SMALL_FONT_SIZE");
if(smallfontsize==null||"null".equals(smallfontsize)) smallfontsize="11px";
str=str+"&smallfontsize="+java.net.URLEncoder.encode(smallfontsize);

String displaypowerlink=request.getParameter("DISPLAYEBEELINK");
if(displaypowerlink==null||"null".equals(displaypowerlink)) displaypowerlink="yes";
str=str+"&displaypowerlink="+displaypowerlink;
%>
<table>
<tr><td>
<script type="text/javascript" language="javascript" src="<%=serveraddress%>portal/streaming/partnerstreaming_js.jsp?<%=str%>"></script>
</td></tr>
</table>

