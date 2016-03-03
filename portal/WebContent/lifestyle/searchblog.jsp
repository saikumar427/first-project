<%@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>



<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String subtype=(request.getParameter("stype")==null)?"view":request.getParameter("stype");



//String UNITID=(request.getParameter("UNITID")!=null)?request.getParameter("UNITID"):"13579";


%>

<%--
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) );
--%>


<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class='notitletable2' >
<tr height="10" class='inputlabel' ><td></td></tr>
  <tr>
    <td  align='center'>



<form  method="get" action="/lifestyle/searchblog1.jsp" style="margin: 0; padding: 0" onsubmit="return validateSearch(this)">
Search Blogs <input type="text" id="q" name="q" size="15" maxlength="255" value="" />
<input type="submit" value="Go" />
<!--input type='hidden' name="UNITID" value="<%--=UNITID--%>" /-->
</form>
<script type="text/javascript">
function validateSearch(form) {
if (form.q.value == "") {
alert("Please enter a search term to continue.");
form.q.focus();
return false;
}
return true;
}
</script>

</td>
</tr>

</table>
<br />
<%--
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
--%>
