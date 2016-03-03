<%
request.setAttribute("subtabtype","My Pages");
String message=EbeeConstantsF.get("networkticket.disable.failure","Error while Disabling Eventbee Network Ticket Selling. Please Try Again");
%>


    <table align="center" width="100%">
        <tr><td align="center" class="inform"><%=message%></td></tr>
        </tr>
    </table>
