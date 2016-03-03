<%@ page import="java.util.*,java.util.Map.Entry,com.eventbee.filters.IPFilter"%>
 <script>
 function remove(id)
 {
 alert("remove Ip:"+id.id);
 document.getElementById('ip').value=id.id;
 document.getElementById('mode').value='remove';
 document.blockmng.submit();
 }
  function removeAll()
 {
  document.getElementById('mode').value='removeAll';
  document.blockmng.submit();
 }
 function add()
 { alert("Ip:"+document.getElementById('ipblk').value);
   document.getElementById('ip').value=document.getElementById('ipblk').value;
   document.getElementById('mode').value='add';
   document.blockmng.submit();
 }
</script>
<%
	if(session.getAttribute("authDatauttool")==null){
		response.sendRedirect("login.jsp?usereq=EmailIpchecker");
		return;
	}
%>

 <%
 
 
 String ip=request.getParameter("ip");
 String mode=request.getParameter("mode");
 System.out.println("mode is:"+mode);
 System.out.println("email check ip is:"+ip);
 System.out.println("emailblock check::"+request.getHeader("x-forwarded-for")+ "   "+ request.getRemoteAddr());

  out.println("<center>Email Ipchecker Manage</center><br/><br/><br/>");
  out.println("<center>"+(String)session.getAttribute("captcha_invitationForm") +"</center><br/><br/><br/>");
 if("add".equals(mode) && !"".equals(ip))
{
 IPFilter.EmailBlockIps.put(ip,100);
 out.println("<center>added</center><br/>");
} 
else if("remove".equals(mode)  && !"".equals(ip)  )
{  IPFilter.EmailBlockIps.remove(ip);
 out.println("<center>REMOVED ip IS: "+ip+"</center><br/>");
}
else if("removeAll".equals(mode))
{  IPFilter.EmailBlockIps.clear();
}

out.println("<form id='blockmng'  name='blockmng' method='post' action=''><center>Ips &nbsp;&nbsp;&nbsp;&nbsp;<a href='#' onclick='removeAll();'>removeAll</a></center> <br/>");
out.println("Add Ip &nbsp;&nbsp;&nbsp;&nbsp;<input type='text' id='ipblk' value=''/><input type='button' value='add' onclick='add();'></center> <br/>");


		Iterator entries =IPFilter.EmailBlockIps.entrySet().iterator();
		while (entries.hasNext()) {
		  Entry thisEntry = (Entry) entries.next();
		  Object key = thisEntry.getKey();
  out.println("<center>"+key+"&nbsp;&nbsp;count:"+IPFilter.EmailBlockIps.get((String)key)+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='#' id='"+key+"' onclick='remove(this);'>remove</a></center><br/>");
		}
	out.println("<input type='hidden' id='ip' name='ip' value=''><input type='hidden' id='mode' name='mode' value=''></form>");

%>