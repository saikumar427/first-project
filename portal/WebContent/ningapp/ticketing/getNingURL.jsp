<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%!

HashMap getManagerDetails(String eventid){

String query="select nid,e.mgr_id from eventinfo e,ebee_ning_link en where en.ebeeid=e.mgr_id and e.eventid=?";
DBManager dbmanager=new DBManager();
StatusObj sb=dbmanager.executeSelectQuery(query,new String[]{eventid});
HashMap hm=new HashMap();
if(sb.getStatus()){

hm.put("oid",dbmanager.getValue(0,"nid",""));
hm.put("ebeeid",dbmanager.getValue(0,"mgr_id",""));
}
return hm;
}

%>





<%
String eventid=request.getParameter("evtid");
String domain=request.getParameter("domain");
String source=request.getParameter("source");

if(domain!=null)
domain=domain.trim();
if(eventid!=null)
eventid=eventid.trim();
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
String tokenid=DbUtil.getVal("select encodedid from ning_event_tokens where eventid=? and ning_domain=?",new String[]{eventid,domain});
if(tokenid==null){
HashMap hm=getManagerDetails(eventid);
if(hm!=null&&hm.size()>0){
String tid=DbUtil.getVal("select nextval('ning_event_tokenid') as tid",new String[]{});
String encodedid=EncodeNum.encodeNum(tid);
String useragent = request.getHeader("User-Agent");
              
DbUtil.executeUpdateQuery("insert into ning_event_tokens(tokenid,encodedid,eventid,ningownerid,ning_domain,ebeeid,source,useragent,date) values(?,?,?,?,?,?,?,?,now())",new String[]{tid,encodedid,eventid,(String)hm.get("oid"),domain,(String)hm.get("ebeeid"),source,useragent});
tokenid=encodedid;
}
}







String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
String eveturl="http://"+serveraddress+"/ning/register?nid="+tokenid;		
JSONObject obj=new JSONObject();
obj.put("eventname",eventname);
obj.put("eventurl",eveturl);
out.print(obj);
   
  %>
 