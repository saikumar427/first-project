package com.eventbeepartner.partnernetwork;

import java.util.*;
import com.eventbee.general.*;

public class NetworkTicketSelling{

public Vector getUserdetails(String retrieve,String type)
{
	String s1="",s2="";
	Vector v= new Vector();
	DBManager dbm =new DBManager();
	HashMap userhashmap=null;
	StatusObj statobj=null;
	String	query1="select a.first_name,a.last_name,a.user_id,a.title,a.email,b.url,b.partnerid from user_profile a,group_partner b ";
	if("pid".equals(type)){
		query1+=" where b.partnerid=? and a.user_id=b.userid";
		statobj=dbm.executeSelectQuery(query1,new String[]{retrieve});
	}
	if("pBeeid".equals(type)){
		query1+=" where a.user_id=(select user_id from authentication where UPPER(login_name) like ?) and a.user_id=b.userid";
		statobj=dbm.executeSelectQuery(query1,new String[]{retrieve});
	}
	if("pname".equals(type)){
		query1+=" where UPPER(a.first_name||' '||a.last_name) like ? and a.user_id=b.userid";
		statobj=dbm.executeSelectQuery(query1,new String[]{"%"+retrieve+"%"});
	}
	if("pemail".equals(type)){
		query1+=" where UPPER(email) like ? and a.user_id=b.userid";
		statobj=dbm.executeSelectQuery(query1,new String[]{"%"+retrieve+"%"});
	}
	if("Approved".equals(type)){
		query1+=" where a.user_id=b.userid and b.partnerid in(select partnerid  from manual_nts_events where eventid=? and status='Approved' )";
		statobj=dbm.executeSelectQuery(query1,new String[]{retrieve});
	}
	if("Pending".equals(type)){
		query1+=" where a.user_id=b.userid and b.partnerid in(select partnerid  from manual_nts_events where eventid=? and status='Pending' )";
		statobj=dbm.executeSelectQuery(query1,new String[]{retrieve});
	}
	if("Suspended".equals(type)){
		query1+=" where a.user_id=b.userid and b.partnerid in(select partnerid  from manual_nts_events where eventid=? and status='Suspended' )";
		statobj=dbm.executeSelectQuery(query1,new String[]{retrieve});
	}
	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			userhashmap=new HashMap();
			userhashmap.put("first_name",dbm.getValue(k,"first_name",""));
			userhashmap.put("last_name",dbm.getValue(k,"last_name",""));
			userhashmap.put("email",dbm.getValue(k,"email",""));
			userhashmap.put("title",dbm.getValue(k,"title",""));
			userhashmap.put("url",dbm.getValue(k,"url",""));
			userhashmap.put("user_id",dbm.getValue(k,"user_id",""));
			userhashmap.put("partnerid",dbm.getValue(k,"partnerid",""));
			v.add(userhashmap);
		}
	}
	return v;
	}
public Vector getEventtickets(String groupid,String partnerid){

	Vector ticket= new Vector();
	DBManager dbm =new DBManager();
	HashMap hm=null;
	StatusObj statobj=null;

	String	query1="select a.ticket_name,a.networkcommission as commision ,a.price_id,a.ticket_price,a.partnerlimit  from price a where evt_id=cast(? as integer) and a.price_id not in(select c.price_id from partner_ticket_commision c where partnerid=?)"
				  +" UNION "
				  +" select b.ticket_name,c.commision,c.price_id,b.ticket_price,c.partnerlimit from price b,partner_ticket_commision c where c.partnerid=? and c.price_id=b.price_id and b.evt_id=cast(c.eventid as integer) and b.evt_id=cast(? as integer)";

	statobj=dbm.executeSelectQuery(query1,new String[]{groupid,partnerid,partnerid,groupid});

	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("ticket_name",dbm.getValue(k,"ticket_name",""));
			hm.put("commision",dbm.getValue(k,"commision",""));
			hm.put("priceid",dbm.getValue(k,"price_id",""));
			hm.put("ticket_price",dbm.getValue(k,"ticket_price",""));
			hm.put("partnerlimit",dbm.getValue(k,"partnerlimit",""));

			ticket.add(hm);
		}

	}
	return ticket;
	}

public String getPartnerNTSStatus(String partnerid, String eventid){
	String Query=" select status from manual_nts_events where partnerid=? and eventid=?";
	String apprvstatus=DbUtil.getVal(Query,new String[]{partnerid, eventid});
	if(apprvstatus==null) apprvstatus="";
	return apprvstatus;
}


public  String getEarningsInfo(String statusType, String agentid,String eventid){

		String query="select d.refid, sum(agentcommission) as agentcommission"
                               +"  from transaction d, partner_transactions c"
                               +"  where  d.agentid=? and c.agentid=d.agentid "
                               +"  and d.transactionid=c.transactionid"
                               +"  and d.refid=?"
                               +"  and paymentstatus=? and agentcommission>0 "
                               +"  group by refid";

	  String commission="0";
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid,eventid,statusType});
			if(statobj.getStatus()){
				if(statobj.getCount()>0)
					commission=dbmanager.getValue(0,"agentcommission","0");
			}
			return commission;
		}

public HashMap getntsdetails(String groupid){

DBManager dbm= new DBManager();
HashMap hm=null;
hm = new HashMap();

StatusObj statobj =dbm.executeSelectQuery("select participationtype,nts_approvaltype,webshare,friendshare,webeditable,socialeditable from group_agent_settings where groupid=?",new String[] {groupid});
if(statobj.getStatus()){
	hm.put("participationtype",dbm.getValue(0,"participationtype",""));
	hm.put("nts_approvaltype",dbm.getValue(0,"nts_approvaltype",""));
	hm.put("web_friendshare",dbm.getValue(0,"webshare",""));
	hm.put("social_friendshare",dbm.getValue(0,"friendshare",""));
	hm.put("web_editable",dbm.getValue(0,"webeditable",""));
	hm.put("social_editable",dbm.getValue(0,"socialeditable",""));
}
return hm;
}

}
