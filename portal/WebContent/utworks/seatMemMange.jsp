 
 <%@page import="java.util.*,com.eventregister.SeatingDBHelper,java.util.Map.Entry"%>
 <script>
 function remove(id)
 {
 document.getElementById('venueid').value=id.id;
 document.seatmng.submit();
 }
  function removeAll()
 {
  document.getElementById('mode').value='all';
   document.seatmng.submit();
 }
</script>

 <%
	if(session.getAttribute("authDatauttool")==null){
		response.sendRedirect("login.jsp?usereq=seatMemMange");
		return;
	}
%>
 <%
 
 String venueid=request.getParameter("venueid");
 String mode=request.getParameter("mode");
  out.println("<center>Seating Memory Manage</center><br/><br/><br/>");
 
 if("all".equals(mode))
{
 SeatingDBHelper.glsecseats.clear();
 out.println("<center>REMOVED ALL</center><br/>");
} 
else if(venueid!=null && !"".equals(venueid)  )
{ SeatingDBHelper.glsecseats.remove(venueid);
 out.println("<center>REMOVED VENUEID IS: "+venueid+"</center><br/>");
}

out.println("<form id='seatmng'  name='seatmng' method='post' action=''><center>venueId &nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='removeAll();'>removeAll</a></center> <br/>");
Iterator entries =SeatingDBHelper.glsecseats.entrySet().iterator();
		while (entries.hasNext()) {
		  Entry thisEntry = (Entry) entries.next();
		  Object key = thisEntry.getKey();
  out.println("<center>"+key+"&nbsp;&nbsp;<a href='#' id="+key+" onclick=remove(this)>remove</a></center><br/>");
		}
	out.println("<input type='hidden' id='venueid' name='venueid' value=''><input type='hidden' id='mode' name='mode' value=''></form>");

%>