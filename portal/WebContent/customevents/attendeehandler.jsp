<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%!
String CLASS_NAME="customevents/attendeehandler.jsp";

%>


<%--
String groupid=request.getParameter("eventid");
String userid=(String)request.getAttribute("userid");
String participantid=request.getParameter("participant");
boolean nouser=false;
String displayevent="";
String uname=(String)request.getAttribute("username");
if(!(groupid==null||"000000".equals(groupid)|| "".equals(groupid)|| "0".equals(groupid))){

try{
		Integer.parseInt(groupid);
		
		displayevent=DbUtil.getVal("select 'yes' from eventinfo where eventid=? and mgr_id=?",new String[]{groupid,userid});
		if("yes".equals(displayevent) ){
			nouser=true;
			
			if(participantid!=null){
			nouser=false;
				Integer.parseInt(participantid);
				displayevent=DbUtil.getVal("select 'yes' from group_partner where partnerid=? and status='Active' ",new String[]{participantid});
				if("yes".equals(displayevent) )	nouser=true;			
			}
			
		}else
		nouser=false;

}catch(Exception e){
nouser=false;
}

}
if(!nouser){

%>
	
	<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr><td height='10'></td></tr>
		<tr><td align='center'>This user's F2F Ticket Selling Page is not yet approved</td></tr>
		<tr><td height='10'></td></tr>
		<tr><td align='center'><input align='center' type='button' name='back' value='Back' onclick='javascript:history.back()'/></td></tr>
	</table>


	
<%
}else{--%>
		
		<%
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);
		String purpose=request.getParameter("purpose");
		String transactionid=request.getParameter("transactionid");
		String attendeekey=request.getParameter("attendeekey");
		String GROUPID=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid","GROUPID"});
		String context=request.getParameter("context");
		%>
		<jsp:include page='attendeethemeprocessor.jsp' >
			<jsp:param name="context" value='<%=context%>' />
</jsp:include>                                                                      
		

<%--}--%>
