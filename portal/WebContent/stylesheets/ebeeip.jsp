<%@ page import='java.net.*,java.io.*' %>

<%
    try {
	out.println(  "<input type='hidden' name='ebeeip' value='"+(InetAddress.getLocalHost() ).getHostName()+"'  />"  );
    } catch (UnknownHostException e) {
    }

%>
