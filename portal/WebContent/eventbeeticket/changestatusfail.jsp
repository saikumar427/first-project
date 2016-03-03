<%
request.setAttribute("subtabtype","My Pages");
String message=EbeeConstantsF.get("changeagent.status.failure","Error While Changing Status. Please Try Again");
%>


    <table align="center" width="100%">
        <tr><td align="center" class="inform"><%=message%></td></tr>
        </tr>
    </table>
