<%
	session.removeAttribute("islogin");

response.sendRedirect("/portal/home.jsp?UNITID=13579");
%>
