<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*" %>

<%!
DBManager dbm =new DBManager();
static String updateQry="update trackurls set trackingid=?,password=COALESCE(password, trackingcode),secretcode=? where eventid=? and trackingcode=?";
static String selqry="select eventid,trackingcode,trackingid from eventurltrack order by eventid,trackingcode";
public Vector getDetailsFromEventURLTrack()
{
	Vector v= new Vector();
	HashMap eventurlhm=null;
	StatusObj statobj=null;
	statobj=dbm.executeSelectQuery(selqry,new String[]{});
	if(statobj.getStatus()){
	for(int k=0;k<statobj.getCount();k++){
			eventurlhm=new HashMap();
			eventurlhm.put("eventid",dbm.getValue(k,"eventid",""));
			eventurlhm.put("trackingid",dbm.getValue(k,"trackingid",""));
			eventurlhm.put("trackingcode",dbm.getValue(k,"trackingcode",""));
			v.add(eventurlhm);
			}
		}
	return v;

}
%>
<%
Vector evtvector=getDetailsFromEventURLTrack();
HashMap evthm=new HashMap();
for (int i=0;i<evtvector.size();i++){
	evthm=(HashMap)evtvector.elementAt(i);
	String eventid=(String)evthm.get("eventid");
	String trackingid=(String)evthm.get("trackingid");
	String trackingcode=(String)evthm.get("trackingcode");
	String secretcode=EncodeNum.encodeNum(trackingid);
	DbUtil.executeUpdateQuery(updateQry,new String[]{trackingid,secretcode,eventid,trackingcode});	
	
}
%>
