<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">

<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-tiles" prefix="tiles" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<meta name="revisit-after" content="7 days" />
<meta name="ROBOTS" content="ALL" />
<meta http-equiv="keywords" name="keywords" content="online registration" />

<title>Eventbee - Online Event Management, Event Registration, Membership
Management, Email Marketing and Ticket Selling software </title>

<meta name="Description" content="Easy to use web based Event Management
solution that includes Event Registration/Ticketing, Email Marketing,
Event Photos,
Event Blogs and Membership Management" />

<meta name="Keywords" content="online ticketing, event ticketing, event
payments, email marketing, event blogs, membership management, event
credit card payments, event photos, event blogging, event communities,
membership payments, online memberships, event community, event
networking, event social networking, event promotion, event listing, local
events,registration software,conference software,conference
registration,event registration,training registration,registration,online
registration,on line registration,registration service,seminar
registration,event registration service,online registration
software,online event registration software,online conference
registration" />

<link rel="stylesheet" type="text/css" href="/home/css/niftyCorners.css" />

<jsp:include page="/main/customlnf.jsp" />
 <%if(request.getAttribute("CUSTOM_CSS")!=null){%>
<style type="text/css">
<%=(String)request.getAttribute("CUSTOM_CSS")%>
</style>
<link rel="stylesheet" type="text/css" href="/home/customlisting.css" />


<%}else{%>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<link rel="stylesheet" type="text/css" href='/home/homepage.css' />
<%}%>
<%if(("CUSTOM").equals(request.getAttribute("layout"))){%>
<style type="text/css">

#customleftcolumn {
 float: left;
 width: <%=request.getAttribute("CUSTOM_LEFT_WIDTH")%>px;
}

#customrightcolumn {
 float: right;
 width: <%=request.getAttribute("CUSTOM_RIGHT_WIDTH")%>px;
}

</style>
<%}%>
</head>
<body>
<script type="text/javascript" src="/home/js/niftycube.js">
</script>
<script type="text/javascript">
window.onload=function(){
Nifty("div#eventsblock","transparent");
Nifty("div#servicesblock","transparent");
Nifty("div#classblock","transparent");
Nifty("div#hubsblock","transparent");
Nifty("div#featureblock","transparent");
Nifty("div#content1a","transparent");
Nifty("div#content1b","transparent");
Nifty("div#content1c","transparent");
Nifty("div#content2a","transparent");
Nifty("div#content2b","transparent");
Nifty("div#content2c","transparent");
}
</script>
<script>
function dummy(){}
</script> 

<script type="text/javascript" src="/home/js/getcontent.js">
function dummy(){}
</script>


<div id="topcontainer">
<div id="container">
<tiles:insert attribute="head" />  
<tiles:insert attribute="mytabs" />

<table width="100%" cellpadding="5px"><tr>
						 
<% String tmp_subtitle="";
if(request.getAttribute("tasksubtitle") !=null)
	 tmp_subtitle=((String)request.getAttribute("tasksubtitle")).trim();
	  if("".equals(tmp_subtitle))
	tmp_subtitle=" ";
%>
<td <%=  (request.getAttribute("tasktitle")!=null)?"class='desiborderfull'":""  %>     >

 <% if(request.getAttribute("tasktitle") !=null){ %>
	<div  style='float:left'> <%=request.getAttribute("tasktitle") %> </div>
		<div style='float:right'><%=tmp_subtitle%></div>
	   <%}%>
	</td>
 	</tr>
 </table>
<div id="center" >


 
	<div id="<tiles:getAsString name="leftdivid" ignore="true"/>" >
		  <tiles:useAttribute id="leftdisplaylist" name="leftdisplaylist" classname="java.util.List"  ignore="true"/>
		  <logic:present name="leftdisplaylist" >
		  <logic:iterate  id="item" name="leftdisplaylist" type="com.eventbee.web.presentation.beans.BeeletItem">
			<bean:define id="iscollapsable" name="item" property="isCollapsable" type="java.lang.String"/>
			<bean:define id="beeletid" name="item" property="beeletId" type="java.lang.String"/>
			<bean:define id="pageresource" name="item" property="resource" type="java.lang.String"/>
			<bean:define id="pageincludeType" name="item" property="includeType" type="java.lang.String"/>
			<bean:define id="beeletBorderType" name="item" property="beeletBorderType" type="java.lang.String"/>
			<div id="<bean:write name="beeletid" />block" class="leftbox">
			<logic:equal name="iscollapsable" value="true">
				<div id="<bean:write name="beeletid" />header" class="leftboxheader" >
				<span class="rightarrows"  onclick="javascript:collapse('<bean:write name="beeletid" />content');">
				<%--<img id="<bean:write name="beeletid" />content_img" src="/home/images/downarrow.gif"/>--%></span>
				<span class="contentheadertext"><a href="<bean:write name="item" property="url"/>">
				<bean:write name="item" property="title"/>
				</a></span>
				</div>
			</logic:equal>	
			<div id="<bean:write name="beeletid" />content" class="leftboxcontent"></div>
			</div>
			<logic:equal name="pageincludeType" value="AJAX">
				<script>
				init('<bean:write name="item" property="resource"/>','<bean:write name="beeletid" />content','<bean:write name="beeletid" />block');
				</script>
			</logic:equal>
			<logic:equal name="pageincludeType" value="JSP">
				<jsp:include page='<%=pageresource%>' >
				<jsp:param name="border" value="<%=beeletBorderType%>"/>
				<jsp:param name="frompagebuilder" value="true"/>
				</jsp:include>
			</logic:equal><br/>
		    </logic:iterate>
		    </logic:present>
	</div>
	<div id="<tiles:getAsString name="centerdivid" ignore="true"/>">
	</div>
	<div id="<tiles:getAsString name="rightdivid" ignore="true"/>"  >
		  <tiles:useAttribute id="rightdisplaylist" name="rightdisplaylist" classname="java.util.List" />
		  <logic:iterate  id="rightitem" name="rightdisplaylist" type='com.eventbee.web.presentation.beans.BeeletItem'>
			  <bean:define id="iscollapsablert" name="rightitem" property="isCollapsable" type="java.lang.String"/>
			  <bean:define id="beeletidrt" name="rightitem" property="beeletId" type="java.lang.String"/>
			  <bean:define id="pageresourcert" name="rightitem" property="resource" type="java.lang.String"/>
			  <bean:define id="pageincludeTypert" name="rightitem" property="includeType" type="java.lang.String"/>
			  <bean:define id="beeletBorderTypert" name="rightitem" property="beeletBorderType" type="java.lang.String"/>

			  <div id="<bean:write name="beeletidrt" />block" class="rightbox">
			  <logic:equal name="iscollapsablert" value="true">
					<div id="<bean:write name="beeletidrt" />header" class="rightboxheader" >
						<span class="rightarrows"  onclick="javascript:collapse('<bean:write name="beeletidrt" />content');">
						<%--<img id="<bean:write name="beeletidrt" />content_img" src="/home/images/downarrow.gif"/>--%></span>
						<span class="contentheadertext"><a href="<bean:write name="rightitem" property="url"/>">
						<bean:write name="rightitem" property="title"/>
						</a></span>
					</div>
			 </logic:equal>		
			 <div id="<bean:write name="beeletidrt" />content" class="rightboxcontent"></div>
			 </div>
			 <logic:equal name="pageincludeTypert" value="AJAX">
				<script>
				init('<bean:write name="rightitem" property="resource"/>','<bean:write name="beeletidrt" />content','<bean:write name="beeletidrt" />block');
				</script>
			 </logic:equal>
			 <logic:equal name="pageincludeTypert" value="JSP">				
				<jsp:include page='<%=pageresourcert%>' >
					<jsp:param name="border" value="<%=beeletBorderTypert%>"/>
					<jsp:param name="frompagebuilder" value="true"/>
				</jsp:include>
			 </logic:equal><br/>
		    </logic:iterate>
	</div>
	
	
</div>

<tiles:insert attribute="footer" />
 </div>   
</div>
</body>
</html>

