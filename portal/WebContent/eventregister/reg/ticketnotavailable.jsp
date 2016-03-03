<%@ page import="com.eventbee.event.*,com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.general.EbeeConstantsF"%>
<%
   String message="";
   EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
   Authenticate Auth=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");
   boolean isShowEbeePage=("No".equals((String)session.getAttribute("fromcontext")));
   EventTicket [] publictkts=jBean.getExistingPublicTickets();
   EventTicket [] soldoutpublictkts=jBean.getSoldoutPublicTickets();
   EventTicket [] yettostartpublictkts=jBean.getYetToStartPublicTickets();
   EventTicket [] endedpublictkts=jBean.getEndedPublicTickets();
  
    EventTicket [] opttkts=jBean.getExistingOptTickets();
      EventTicket [] soldoutopttkts=jBean.getSoldoutOptTickets();
      EventTicket [] yettostartopttkts=jBean.getYetToStartOptTickets();
      EventTicket [] endedopttkts=jBean.getEndedOptTickets();
  
   if(publictkts.length>0){
    if(publictkts.length>0&&soldoutpublictkts.length==publictkts.length)
    message=EbeeConstantsF.get("eventregistration.notavailable1","Tickets are sold out, please contact event manager for tickets ");
    else if(publictkts.length>0&&yettostartpublictkts.length>0)
    message=EbeeConstantsF.get("eventregistration.notavailable1","Online registration for this event is not yet started, please check back later");
    else if(publictkts.length>0&&endedpublictkts.length>0)
    message=EbeeConstantsF.get("eventregistration.notavailable1","Sorry, online registration for this event is closed, please contact event manager for tickets");
}
else
{

   
  
  if(soldoutopttkts.length==opttkts.length){
 
    message=EbeeConstantsF.get("eventregistration.notavailable1","Tickets are sold out, please contact event manager for tickets ");
   
   }else if(yettostartopttkts.length>0){
 
    message=EbeeConstantsF.get("eventregistration.notavailable1","Online registration for this event is not yet started, please check back later");
    
    }else if(endedopttkts.length>0){
  
    message=EbeeConstantsF.get("eventregistration.notavailable1","Sorry, online registration for this event is closed, please contact event manager for tickets");
 }

}
   
   String link1=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
   String link=EbeeConstantsF.get("link.home.page","Back to My Home");
   String eventstatus=request.getParameter("eventstatus");
    if("PENDING".equals(eventstatus)){
   	message=EbeeConstantsF.get("eventregistration.event.pending.status","Event registration is not yet enabled on this event, please check back later.");
   
   }
   
%>


<% 
	String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
 	
	String participant=jBean.getAgentId();
	String platform=(String)session.getAttribute("platform");
	
%>



   <table align="center" cellspacing="20">
          <tr>
            <td align="center" class="inform">
                   <%=message%>  
            </td>
          </tr>
    <tr> 
    <%if(!"ning".equals(platform)){%>
      <% if (isShowEbeePage||Auth!=null){ %>

            <td align="center" class="inform">
                <%--<a target="_top" href="<%=session.getAttribute("HTTP_SERVER_ADDRESS")%>/home/index.jsp?sid=<%=session.getId()%>"><%=link1%></a>--%>
		<%if("FB".equals(request.getParameter("context"))){%>
		<a  href="<%=ShortUrlPattern.get(username)%>/event?eventid=<%=request.getParameter("GROUPID") %>&context=FB"><%="Event Page"%></a>
		<%}else{%>
		<a  href="<%=ShortUrlPattern.get(username)%>/event?eventid=<%=request.getParameter("GROUPID") %>"><%="Event Page"%></a>
		<%}%>
            </td>
        <% }}%>

   </tr>
  </table>

