<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.general.EbeeConstantsF"%>


<%
   EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
   boolean isTransactionSuccess=false;
   Authenticate Auth=(Authenticate)session.getAttribute("authData");
   boolean isShowEbeePage=("No".equals((String)session.getAttribute("fromcontext")));
   String message=EbeeConstantsF.get("eventregistration.registered","Sorry, Your registration transaction seem to have already completed/aborted.");
   String message1=EbeeConstantsF.get("eventregistration.registered.note","Note: Clicking reform/reload on browser from end page will attend to duplicate registration and back with this failure message.");
   String link1=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
   String link=EbeeConstantsF.get("link.home.page","Back to My Home");
%>




<% 
String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
 	request.setAttribute("NavlinkNames",new String[]{event_name});
	request.setAttribute("NavlinkURLs",new String[]{"http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/portal/eventdetails/eventdetails.jsp"});
	request.setAttribute("tasktitle","Event Registration");
	request.setAttribute("tasksubtitle","Done");
	request.setAttribute("tabtype","event");
	
	
	
%>



   <table align="center" cellspacing="10">
   <tr><td>
     <table align="center" cellspacing="10">
          <tr>
            <td align="center" class="inform">
                  <%=message%>
            </td>
          </tr>
          <tr>
            <td align="center" class="inform">
                  <%=message1%>
            </td>
          </tr>
      <tr> 
      <% if (isShowEbeePage){ %>

            <td align="right" class="inform">
                <a target="_top" href="<%=session.getAttribute("HTTP_SERVER_ADDRESS")%>/home/index.jsp"><%=link1%></a>
            </td>
        <%  } %>

        <% if (Auth!=null){ %>
             <td align="left" class="inform">
        <a target="_top" href="<%=session.getAttribute("HTTP_SERVER_ADDRESS")%>/portal/club/myhome.jsp"><%=link%></a>
             </td>
        <%
          }
        %>
   
      </tr>
     </table>
</td></tr>
       
        </table>
