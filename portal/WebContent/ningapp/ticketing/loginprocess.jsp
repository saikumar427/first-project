<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%  
String checkuser="";
String oid=request.getParameter("oid");
AuthDB authDB=new AuthDB();
String login=request.getParameter("login");
String password=request.getParameter("password");
String domain=request.getParameter("domain");
String useragent = request.getHeader("User-Agent");

if(domain==null){
domain=(String)session.getAttribute("domain");
}

Authenticate au=authDB.authenticateMember(login,password,"13579");

if(au !=null){
session.setAttribute("authData",au);
String authid=au.getUserID();
checkuser=DbUtil.getVal("select 'yes' from ebee_ning_link where nid=?",new String[]{oid});

if(checkuser==null || "".equals(checkuser)){

StatusObj statobjn= DbUtil.executeUpdateQuery("insert into ebee_ning_link (nid,ebeeid,created_at,network,useragent) values(?,?,now(),?,?)", new String[]{oid,authid,domain,useragent} );

} 
out.println("Success");
}
else{
out.println("Invalid");
}
%>
