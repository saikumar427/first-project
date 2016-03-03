<%@ page import="com.eventbee.general.*"%>
<%
request.setAttribute("subtabtype","My Pages");
String message=EbeeConstantsF.get("networkticket.enable.failure","Error while Enabling Eventbee Network Ticket Selling. Please Try Again");
%>


    <table align="center" width="100%">
        <tr><td align="center" class="inform"><%=message%></td></tr>
        </tr>
    </table>
