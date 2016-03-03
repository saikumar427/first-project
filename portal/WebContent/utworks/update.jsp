<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*" %>



<%

DBManager dbmanager=new DBManager();
HashMap hm=null;
Vector v=new Vector();
String query="UPDATE svasetarsaction SET refid =(select eventbeeuserid from svasemembers where userid=?) where refid=?";
StatusObj ob=null;
StatusObj sb=dbmanager.executeSelectQuery("select eventbeeuserid,userid from svasemembers",new String[]{});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
hm=new HashMap();
hm.put("eventbeeuserid",dbmanager.getValue(i,"eventbeeuserid","") );
hm.put("userid",dbmanager.getValue(i,"userid","") );

v.add(dbmanager.getValue(i,"userid",""));

try{
 ob=DbUtil.executeUpdateQuery(query, new String[]{(String)hm.get("userid"),(String)hm.get("userid")});
}

catch(Exception e)
{
System.out.println("Exception occured is---------------"+e.getMessage());
}

out.println(" Status--"+ob.getStatus());
out.println("<br/>");
out.println(" eventbeeuserid--"+(String)hm.get("eventbeeuserid"));
out.println("<br/>");
out.println(" userid is---"+(String)hm.get("userid"));
}

}



%>