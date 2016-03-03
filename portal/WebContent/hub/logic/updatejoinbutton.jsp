<%@ page import="com.eventbee.general.*" %>
<%!

String DELETE_CONFIG="delete from config where config_id=(select config_id from clubinfo where "
                                  +" clubid=?) and name=?";
String INSERT_CONFIG="insert into config (config_id,name,value) values ((select config_id from clubinfo where "
                                  +" clubid=?),?,?)";

%>

<%


String refid=request.getParameter("GROUPID");

String hubjoinbutton=request.getParameter("hubjoinbutton");
DbUtil.executeUpdateQuery(DELETE_CONFIG,new String[]{refid,"club.custom.joinbutton"});
StatusObj sbj=DbUtil.executeUpdateQuery(INSERT_CONFIG,new String[]{refid,"club.custom.joinbutton",hubjoinbutton});

if(sbj.getStatus())
out.println("Success");


%>