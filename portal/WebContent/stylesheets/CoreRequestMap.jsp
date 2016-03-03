<%@ page import="java.util.*" %>

<%
	HashMap REQMAP=null;
	if(request.getAttribute("REQMAP")==null)
	 REQMAP=new HashMap();
	 else
	REQMAP=(HashMap)request.getAttribute("REQMAP");
//	if(request.getParameter("UNITID") !=null)REQMAP.put("UNITID",request.getParameter("UNITID") );
	
	if(request.getParameter("GROUPID") !=null)REQMAP.put("GROUPID",request.getParameter("GROUPID") );
	if(request.getParameter("GROUPTYPE") !=null)REQMAP.put("GROUPTYPE",request.getParameter("GROUPTYPE") );
	if(request.getParameter("PS") !=null)REQMAP.put("PS",request.getParameter("PS") );
	request.setAttribute("REQMAP",REQMAP);
%>
