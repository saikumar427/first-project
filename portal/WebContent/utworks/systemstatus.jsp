<%@ page import="java.util.*, java.io.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>




<h1>Date and Time  </h1>
DB    : <%=DbUtil.getVal("select now() as dbdate",null)%><br />
System: <%= DateUtil.getFormatedDate(new Date(),"yyyy-MM-dd HH:mm:ssZ", "") %>


<h1>System statistics</h1>
<%
    try{
      Process p = Runtime.getRuntime().exec("df -k");
      BufferedReader r = new BufferedReader(
        new InputStreamReader(p.getInputStream())
      );
      String x="";
      while ((x = r.readLine()) != null) {
        out.println(x);
	out.println("<br />");
      }
      r.close();
      
      
    }catch(Exception exp){
    }


%>
