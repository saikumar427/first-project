package com.eventbeepartner.partnernetwork;

import java.util.*;
import com.eventbee.general.*;
import com.eventbee.event.EventDB;
public class PartnerLinks{

	public void GetCustomButtonsVector(String groupid, Vector customButtonsVector){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery("select url from network_ticketselling_images where refid=? ",new String [] {groupid});
		if(statobj.getStatus()){
			for(int k=0;k<statobj.getCount();k++){
				customButtonsVector.add(dbmanager.getValue(k,"url",""));
			}
		}
		return;
	}


	public HashMap Getcommisiondetails(String groupid,String partnerid){
		DBManager dbm =new DBManager();
		HashMap hm=null;
		StatusObj statobj;
		String query1="select eventid,friendscommission,otherscommision,partnerid from partner_friends_commission where eventid=? and partnerid=?";
		statobj=dbm.executeSelectQuery(query1,new String[]{groupid,partnerid});
	  if(statobj.getStatus()){
		  	hm=new HashMap();
			hm.put("eventid",dbm.getValue(0,"eventid",""));
			hm.put("friendscommission",dbm.getValue(0,"friendscommission",""));
			hm.put("otherscommision",dbm.getValue(0,"otherscommision",""));
			hm.put("partnerid",dbm.getValue(0,"partnerid",""));
		  }
		return hm;

	}

	public Vector getCommissiondetails(String groupid,String partnerid){
		Vector commissionvector=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap hm = null;
		StatusObj statobj=dbmanager.executeSelectQuery("select a.ticket_name,a.networkcommission as commision ,a.price_id,a.ticket_price, partnerlimit from price a where evt_id=cast(? as integer) and a.price_id not in(select c.price_id from partner_ticket_commision c where partnerid=?) UNION  select b.ticket_name,c.commision,c.price_id,b.ticket_price, c.partnerlimit from price b,partner_ticket_commision c where c.partnerid=? and c.price_id=b.price_id and b.evt_id=cast(c.eventid as integer)and b.evt_id=cast(? as integer)",new String [] {groupid,partnerid,partnerid,groupid});
		if(statobj.getStatus()){
       	 for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("ticket_name",dbmanager.getValue(k,"ticket_name",""));
			hm.put("networkcommission",dbmanager.getValue(k,"commision",""));
			hm.put("ticket_price",dbmanager.getValue(k,"ticket_price",""));
			hm.put("max_ticket",dbmanager.getValue(k,"partnerlimit",""));

			commissionvector.add(hm);
			}
	 	 }
		 return commissionvector;
	}
	public String getEventinfo(String groupid){
		HashMap eventinfoMap=EventDB.getMgrEvtDetails(groupid);
		String startdate=(String)eventinfoMap.get("startdate")+", "+(String)eventinfoMap.get("starttime");
		String enddate=(String)eventinfoMap.get("enddate")+", "+(String)eventinfoMap.get("endtime");
		String address=GenUtil.getCSVData(new String[]{(String)eventinfoMap.get("city"),(String)eventinfoMap.get("state"), (String)eventinfoMap.get("country")});
		StringBuffer evtinfo=new StringBuffer("<b>When:</b><br>Starts - ");
		evtinfo.append(startdate);
		evtinfo.append("<br>Ends - ");
		evtinfo.append(enddate);
		evtinfo.append("<br><b>Where:</b><br>");
		evtinfo.append(address);
		return evtinfo.toString();
	}
	public String getConfirmationEventinfo(String groupid){
			HashMap eventinfoMap=EventDB.getMgrEvtDetails(groupid);
			String startdate=(String)eventinfoMap.get("startdate")+", "+(String)eventinfoMap.get("starttime");
			String enddate=(String)eventinfoMap.get("enddate")+", "+(String)eventinfoMap.get("endtime");
			String address=GenUtil.getCSVData(new String[]{(String)eventinfoMap.get("city"),(String)eventinfoMap.get("state"), (String)eventinfoMap.get("country")});
			StringBuffer evtinfo=new StringBuffer("<br><b>When:</b> ");
			evtinfo.append(startdate);
			evtinfo.append(" to ");
			evtinfo.append(enddate);
			evtinfo.append("<br><b>Where:</b> ");
			evtinfo.append(address);
			return evtinfo.toString();
	}
	public HashMap GetGroupAgentSettings(String groupid){
		DBManager dbm =new DBManager();
		HashMap hm=null;
		StatusObj statobj;
		String query="select participationtype,salecommission,webeditable,socialeditable,friendshare,webshare  from group_agent_settings where groupid=? ";
		statobj=dbm.executeSelectQuery(query,new String[]{groupid});
	 	 if(statobj.getStatus()){
	 	 	hm=new HashMap();
			hm.put("participationtype",dbm.getValue(0,"participationtype",""));
			hm.put("salecommission",dbm.getValue(0,"salecommission",""));
			hm.put("webeditable",dbm.getValue(0,"webeditable",""));
			hm.put("socialeditable",dbm.getValue(0,"socialeditable",""));
			hm.put("friendshare",dbm.getValue(0,"friendshare","50"));
			hm.put("webshare",dbm.getValue(0,"webshare","0"));
	 	 }
		return hm;
	}
	public void SendEmail(String []emails1,String email,String message){
		try{
			EmailObj obj=EventbeeMail.getEmailObj();
			obj.setTextMessage(message);
			obj.setFrom(email);
			for(int k=0;k<emails1.length;k++){
           		String tomail=emails1[k];
				obj.setTo(tomail);
				EventbeeMail.sendHtmlMail(obj);
			}
		}catch(Exception e){
			System.out.println(" There is an error in send mail:"+ e.getMessage());
		}
	}

	public static boolean x1=true;
	public Vector getPhotoDetails( String userid){
	   Vector v3 = new Vector();
	   DBManager dbm=new DBManager();
	   HashMap hm=null;
	   int x=Integer.parseInt(userid);
	   StatusObj statobj=dbm.executeSelectQuery("select uploadurl,photo_size,caption,b.location_code from member_photos a,member_photos_location b where a.user_id=? and a.photo_id=b.photo_id and status not in ('decline')", new String[] {userid});
	   if(statobj.getStatus()){
			for(int k=0;k<statobj.getCount();k++){
				hm = new HashMap();
				hm.put("uploadurl",dbm.getValue(k,"uploadurl",""));
				v3.add(hm);
		 	}
	   }
	   else{
		   x1=statobj.getStatus();
	   }
	   return v3;
	}

	public Vector getFriendslist(String userid){
		Vector v= new Vector();
		DBManager dbm =new DBManager();
		HashMap hm= null;
		String s="select  a.user2 as userid,b.email, b.first_name||'  '||b.last_name as name from user_profile b, user_network_request a where a.status='A' and a.user2=b.user_id  and a.user1=?  union  select  a.user1 as userid,b.email,b.first_name||'  '||b.last_name as name from user_profile b, user_network_request a where a.status='A' and a.user1=b.user_id  and a.user2=?";
		StatusObj statobj=dbm.executeSelectQuery(s,new String[] {userid,userid});
		if(statobj.getStatus()){
			for(int k=0;k<statobj.getCount();k++){
				hm =new HashMap();
				hm.put("lname",dbm.getValue(k,"userid",""));
				hm.put("fname",dbm.getValue(k,"name",""));
				hm.put("email",dbm.getValue(k,"email",""));
				v.add(hm);
			}
		}
		else
			System.out.println("statusobject status isssss:"+statobj.getStatus());
		return v;
	}


}
