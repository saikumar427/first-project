<%


request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");


%>
<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;
	
	String refid=request.getParameter("refid");
	String groupid=request.getParameter("GROUPID");
	if(refid!=null&&!"".equals(refid))
		status=DbUtil.getVal("select status from pending_signups where encodedid=?",new String[]{refid.trim()});
	
	if("P".equals(status)){
		session.removeAttribute("authData");
		session.removeAttribute("13579_authData");
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Login");
	item.setResource("/passivemember/passiveuserlogin.jsp?refid="+refid+"&GROUPID="+groupid);
	leftItems.add(item);
	}
	else{
	
	response.sendRedirect("/portal/mytasks/passiveerror.jsp");
	return;	
}     
	
	
%>	
	 
	<%@ include file="/templates/beeletspagebottom.jsp" %>
