<%
System.out.println("toggleEventHandler.jsp:::: ");
try{
	String jbossserver=request.getParameter("jbossserver");
	System.out.println("toggleEventHandler.jsp jbossserver:::: "+jbossserver);
	if("jboss7".equals(jbossserver))
		Runtime.getRuntime().exec("/bin/sh /mnt/jboss/runner/standalone/active/portal.war/customevents/eventhandlernamechange.sh");
	else if("jboss4".equals(jbossserver))
		Runtime.getRuntime().exec("/bin/sh  /mnt/runner/inst/server/default/active/portal.ear/portal.war/customevents/eventhandlernamechange.sh");
}catch(Exception e){
	   System.out.println("Exception :"+e.getMessage());
  }
%>