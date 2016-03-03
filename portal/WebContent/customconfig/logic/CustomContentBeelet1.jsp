
<%@ page import=" java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.contentbeelet.*" %>


<%
	String groupid=null;
	String portletid=request.getParameter("portletid");
	 groupid=(request.getParameter("forgroup")!=null)?request.getParameter("forgroup"):request.getParameter("GROUPID");
	 String cellpadd="2";
	HashMap customcontent=null;
	boolean isbeeletdisplay=(portletid !=null);
	if(isbeeletdisplay)
	 customcontent=CustomContentDB.getCustomContent(portletid, groupid);
	  isbeeletdisplay=(customcontent!=null);
%>

<%if (isbeeletdisplay){
if("HTML".equals((String)customcontent.get("contenttype")))
	cellpadd="0";

		String title=(String)customcontent.get("title");
		if((title==null)|| ("".equals(title.trim()) ) ) title=null;
		StringBuffer content=new StringBuffer("<span>");
				content.append(GenUtil.getHMvalue(customcontent,"desc" ));
				content.append("</span>");
%>
<%
String customborder=request.getParameter("customborder");

String tableclass="0";
if(customborder==null)
{
customborder="0";
tableclass=request.getParameter("border");
}
//tableclass="beelettable";

if(request.getParameter("guestpage") ==null){

%>
<%= PageUtil.startContent(title,tableclass,request.getParameter("width"),true) %>
<%
}else{
%>
<table border="0" width="100%"   cellspacing="0">
<tr><td>
<%= PageUtil.startContentForGuest(title,tableclass,request.getParameter("width"),true,"beelet-header") %>
<%
}
%>

		<table width='100%' cellpadding="<%=cellpadd%>" class="<%=customborder%>">
		<tr><td>
		<%=content.toString() %>
		</td></tr>
		</table>
		
<%=PageUtil.endContent() %>
</td></tr>
</table>

<%}%>
