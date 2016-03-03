<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>


<jsp:include page="/auth/checkpermission.jsp">
<jsp:param name='Dummy_ph' value='' /></jsp:include>

<%!
String CLASS_NAME="customevents/customthemetemplate.jsp";
%>

<jsp:include page="/stylesheets/CoreRequestMap.jsp" />


<% 
request.setAttribute("linktohighlight","pagecontent");
request.setAttribute("tabtype","community");
request.setAttribute("subtabtype","My Pages");
%>

<jsp:include page="/stylesheets/TabSetter.jsp">
<jsp:param name='DEFTAB' value='community'/>
<jsp:param name='Dummy_ph' value='' /></jsp:include>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);
String platform = request.getParameter("platform");
 String url="/portal/mytasks/eventgroupcustomthemetemplate.jsp";
	    if("ning".equals(platform)){
		url="/portal/ningapp/ticketing/eventgroupcustomthemetemplate.jsp";
	 }

request.setAttribute("type","event");
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String act=request.getParameter("act");
String type=request.getParameter("type");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"type====="+type,"",null);
String evtname=request.getParameter("evtname");
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null)
userid=authData.getUserID();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid====="+userid,"",null);

String [] themedata=ThemeController.getThemeCodeAndType(type,request.getParameter("GROUPID"),"basic");

String userthemecode=themedata[1];
String selectedthemetype=themedata[0];
System.out.println(userthemecode);
System.out.println(selectedthemetype);

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userthemecode====="+userthemecode,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"selectedthemetype====="+selectedthemetype,"",null);

request.setAttribute("userid",userid);
boolean dispmaintemplate=true;
boolean displayeditblock=false;
boolean displayconfirm=false;


if("removecss".equals(act) || "removedata".equals(act) ){
	displayconfirm=true;
	dispmaintemplate=false;
}

if("editcss".equals(act) || "editdata".equals(act) ){
	displayeditblock=true;
	dispmaintemplate=false;
}

if(dispmaintemplate ){
%>
<table width='100%'  cellspacing="0" cellpadding="0">
<form name="geturllifestyle" method="post"  action="/mytasks/savetheme.jsp">
<input type='hidden' name='frompage' value='eventpages' />
<input type="hidden" name='GROUPID' value='<%=request.getParameter("GROUPID")%>'/>
<input type='hidden' name='type' value="<%=type %>" />
<input type='hidden' name='themeid' value='<%=userthemecode %>' />
<input type='hidden' name='themetype' value='<%=selectedthemetype %>' />
<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />		
<tr class='colheader'>
        <td width="20%">Name</td>
        <td width="70%">Description</td>
        <td width="5%">Edit</td>
       </tr>
<tr class="evenbase"><td >CSS</td>
            <td>Theme CSS style sheet</td>
            <td class="center">
               <a href="<%=url%>?themetype=<%=selectedthemetype%>&type=<%=type%>&event_groupid=<%=request.getParameter("event_groupid")%>&stype=template&act=editcss&GROUPID=<%=request.getParameter("GROUPID")%>"&frompage=groupevent><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
            </td>
             </tr>
    
<tr class="oddbase"><td >HTML</td>
            
            <td>Theme HTML data</td>
            <td class="center">
               <a href="<%=url%>?themetype=<%=selectedthemetype%>&type=<%=type%>&event_groupid=<%=request.getParameter("event_groupid")%>&evtname=<%=request.getParameter("evtname")%>&stype=template&act=editdata&GROUPID=<%=request.getParameter("GROUPID")%>"&frompage=groupevent><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
            </td>
             </tr>
	    <tr></tr>
	    <tr><td height="15"></td></tr>
		<tr></tr>
		
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>

<%
}
%>


<%
if(displayeditblock ){
String editedcontent="themecontent";
if("editcss".equals(act))editedcontent="css";
%>
		<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/customevents/themecontroller.jsp" >
		<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />	
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<input type='hidden' name='themeid' value='<%=userthemecode %>' />
		<input type='hidden' name='frompage' value='eventpages' />
		<input type='hidden' name='event_groupid' value='<%=request.getParameter("event_groupid")%>' />
		<tr><td align='center'>
			<%
			String themetype=request.getParameter("themetype");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);

			String content=null;

			if("editcss".equalsIgnoreCase(act)){
				if("CUSTOM".equals(themetype)){
					content=ThemeController.getDetailPageCSS(userthemecode,themetype,type,request.getParameter("GROUPID"));
				}
				else{
				
					content=ThemeController.getDetailPageCSS(userthemecode,themetype,type,request.getParameter("GROUPID"));
				}

			}else{
				content=ThemeController.getContent(userid,type,userthemecode,type,request.getParameter("GROUPID"),themetype);
			}					
			%>
			<textarea name='editcontent' rows='30' cols='80'><%=content %></textarea>
		
		</td></tr>
		<tr><td align='center'>
				<input type='submit' name='submit' value='Submit' />
				</td></tr>
		<input type='hidden' name='themetype' value='<%=themetype %>' />
		<input type='hidden' name='formname' value="edit" />
		<input type='hidden' name='purpose' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<input type='hidden' name='event_groupid' value='<%=request.getParameter("event_groupid")%>' />
		
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>

		
		</table>

<%
}
%>


<%
if(displayconfirm ){
%>
<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/customevents/themecontroller.jsp" >
		<input type='hidden' name='frompage' value='eventpages' />
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		
		<input type='hidden' name='event_groupid' value='<%=request.getParameter("event_groupid")%>' />
		<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />	
		<tr><td align='center'>This will remove your customization
		
		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		
		<input type='hidden' name='formname' value="remove" />
		<input type='hidden' name='purpose' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>
		
		
		</table>
<%
}
%>
