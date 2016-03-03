<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.general.EbeeConstantsF"%>
<%
   EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
   Authenticate Auth=(Authenticate)session.getAttribute("authData");
   boolean isShowEbeePage=("No".equals((String)session.getAttribute("fromcontext")));
   String message=EbeeConstantsF.get("eventregistration.failure","Sorry, this event registration cannot be processed at this time due to a system failure. Please try back later");
   String link1=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
   String link=EbeeConstantsF.get("link.home.page","Back to My Home");

%>

     <table align="center" cellspacing="10">
          <tr>
            <td align="center" class="inform">
                   <%=message%>   
            </td>
          </tr>
    
   </table>
