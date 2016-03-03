<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.event.*"%>
<%

	request.setAttribute("tasktitle","Event Registration");
	request.setAttribute("tasksubtitle","Login");
	request.setAttribute("tabtype","event");
	 EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
	LoginData ebeeLoginData=jBean.getEbeeLoginData();
%>
<script>
function submitform(){
document.form1.elements["cocoon-action-next"].click();
}
</script>
<form name='form1' id="form-register-event" view="memberlogin" action="/portal/eventregister/register" method="post">
<input value="memberlogin" name="cocoon-xmlform-view" type="hidden" />
 <table>
         <%
Object obj=(Object)session.getAttribute("regerrors");
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='center'>",obj,"</td></tr>" ));
%>
                 Member? Enter login information to auto-fill your profile data,if not choose None.
 </table>
  <table>
	<tr><td>
	<input type='radio' name='/selectedLogin' value=""%>
        </td><td>Login <input type='text' name="/ebeeLoginData/loginName"  value="">
     <td>Password <input type='text' name="/ebeeLoginData/password" value="" >
        </td>
  </tr>
    <tr><td>
   <input type='radio' name='/selectedLogin' value="none"%>
    </td><td>None</td></tr>
    <%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
   <tr><td align='center' colspan='3'> 
  
   <input value="Continue" type="submit" name="cocoon-action-next" class="button" title="Go to Next Page" />
    <input type="submit" name="cocoon-action-prev" value="Back">
     </td></tr>
   </table>
  </form>
