<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="com.eventregister.*"%>
<%!
public class UpdateMissedProfileInfo{
public HashMap <String,String> getBuyerData(String tid,String eid){
String query="select fname,lname,email,phone from event_reg_details_temp where tid=? and eventid=?";
HashMap <String,String> buyerMap=new HashMap <String,String>();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{tid,eid});
if(sb.getStatus()){
buyerMap.put("fname",db.getValue(0,"fname",""));
buyerMap.put("lname",db.getValue(0,"lname",""));
buyerMap.put("email",db.getValue(0,"email",""));
buyerMap.put("phone",db.getValue(0,"phone",""));
}
return buyerMap;
}


public void updateMissedProfiles(String tid,String eid){
try{
String isupdated=DbUtil.getVal("select 'yes' from buyer_base_info where transactionid=?",new String[]{tid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "missedprofileupdate.jsp", "checking for the buyer_base_info_dbstatus page for  the transaction---------"+tid+" is "+isupdated, "", null);
if(!"yes".equals(isupdated)){
ProfileActionDB profiledbaction=new ProfileActionDB();
HashMap <String,String>buyerMap=getBuyerData(tid,eid);
buyerMap.put("tid",tid);
buyerMap.put("eventid",eid);
String profileid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
String profilekey="AK"+EncodeNum.encodeNum(profileid).toUpperCase();
buyerMap.put("profileid",profileid);
buyerMap.put("profilekey",profilekey);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "missedprofileupdate.jsp", "Inserting   buyer_base_info for missed information for  the transaction---------"+tid, "", null);
profiledbaction.InserBuyerInfo(buyerMap);
DbUtil.executeUpdateQuery("update buyer_base_info set profilestatus=? where transactionid=?",new String[]{"temp",tid});

RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
ArrayList ticketsList=regTktMgr.getSelectedTickets(tid);
for(int i=0;i<ticketsList.size();i++){
HashMap hmap=(HashMap)ticketsList.get(i);
String ticketid=(String)hmap.get("selectedTicket");
String tickettype=(String)hmap.get("type");
String count=(String)hmap.get("qty");
String profileCount=DbUtil.getVal("select count(*) from profile_base_info where transactionid=? and ticketid=?",new String[]{tid,ticketid});
int balance=Integer.parseInt(count)-Integer.parseInt(profileCount);
if(balance>0){
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "missedprofileupdate.jsp", "There is mismatch in PrBaseInfo and Transaction Tickets for "+tid+" Ticketid"+ticketid+"Balance"+balance, "", null);
String attendeeids[]=DbUtil.getSeqVals("seq_attendeeId",balance);
for(int p=0;p<balance;p++){
String attendeeKey="AK"+EncodeNum.encodeNum(attendeeids[p]).toUpperCase();
HashMap <String,String>hm=new HashMap<String,String>();
hm.put("fname",buyerMap.get("fname"));
hm.put("lname",buyerMap.get("lname"));
hm.put("email",buyerMap.get("email"));
hm.put("phone",buyerMap.get("phone"));
hm.put("profileid",attendeeids[p]);
hm.put("profilekey",attendeeKey);
hm.put("eventid",eid);
hm.put("tid",tid);
hm.put("ticketid",ticketid);
hm.put("tickettype",tickettype);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "missedprofileupdate.jsp", "Updating profile db for missed info is   the transaction---------"+tid, "", null);
profiledbaction.updateBaseProfile(hm);
}
}//End of if(balance>0)
}
}
}

catch(Exception e){
System.out.println("Exception occured in missedprofileupdate.jsp is "+e.getMessage());
}
}
}
%>