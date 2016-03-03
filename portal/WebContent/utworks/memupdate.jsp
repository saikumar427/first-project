<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*" %>

<%

String clubid=request.getParameter("GROUPID");
String fmemid=request.getParameter("fmemid");
String lmemid=request.getParameter("lmemid");
StatusObj ob=null;
String cmemberid="";
String memberid="";
int count=0;
DBManager dbmanager=new DBManager();
String CLUB_MEMBER_ID="select nextval('seq_clubmemberid') as memberid";
String query="update club_member set member_id=? where member_id=? and clubid=?";

StatusObj sb=dbmanager.executeSelectQuery("select member_id from club_member where clubid=? and member_id between ?  and  ? order by member_id",new String[]{clubid,fmemid,lmemid});
if(sb.getStatus()){

for(int i=0;i<sb.getCount();i++){
cmemberid=DbUtil.getVal(CLUB_MEMBER_ID,new String[]{});
memberid=dbmanager.getValue(i,"member_id","");

try{
 				
 ob=DbUtil.executeUpdateQuery(query, new String[]{cmemberid,memberid,clubid});

}

catch(Exception e){

System.out.println("Exception occured is while updating ----"+e.getMessage());
}

if(ob.getStatus())
{
count++;
}
out.println("updated Status is----: "+ob.getStatus());
out.println("oldid----"+memberid);
out.println("newid----"+cmemberid+"<br/>");

}
out.println("count-----"+count);
}
%>