package com.eventbeepartner.partnernetwork;

import java.util.*;
import com.eventbee.general.*;
import  com.eventbee.general.formatting.*;
import com.eventbee.event.EventDB;

public class PartnerDetails{

public Vector getParticipatedNtsEvents(int beginIndex, int count, String eventname){

Vector v=new Vector();
String query="select c.nts_approvaltype,b.eventname,b.eventid"
		+" from eventinfo b,group_agent_settings c where  b.eventid=c.groupid::integer "
		+" and listtype='PBL'  and c.enablenetworkticketing ='Yes'  and b.status='ACTIVE' "
		+" and upper(eventname) like upper(?)"
		+" order by b.created_at desc offset "+beginIndex;
	if(count>0) {
		query+=" limit "+count;
	}
        DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{"%"+eventname+"%"});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	HashMap hm=new HashMap();
	for(int j=0;j<columnnames.length;j++){
	hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	}
			v.add(hm);
		}
	}
	return v;
}


public HashMap PartnerApprovalStatusForEvents(String userid){

String Query="select status,eventid from manual_nts_events where partnerid=(select partnerid from group_partner where userid=?)";

HashMap eventstatusmap=new HashMap();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(Query,new String[]{userid});
if(stobj.getStatus())
{
for(int k=0;k<stobj.getCount();k++)
{
eventstatusmap.put(dbmanager.getValue(k,"eventid",""),dbmanager.getValue(k,"status",""));
}
}

return eventstatusmap;
}


public  Vector getTopNtsEvents(){
Vector v1=new Vector();

String Query1= "select distinct eventid,networkcommission,e.eventname, to_char(e.start_date,'MM/DD')as startdate ,"
              +"  d.login_name  as username from eventinfo e,price p,authentication d"
              +"  where(e.eventid,p.networkcommission ) in (select evt_id,max(networkcommission)"
              +"  from price where networkcommission is not null group by evt_id  order by max(networkcommission) desc ) and "
              +"  e.mgr_id=d.user_id::integer and e.status='ACTIVE'  and e.listtype='PBL' and e.end_date>=now() order by networkcommission desc limit 5";

DBManager dbmanager=new DBManager();
String eventids="0";
StatusObj statobj1=dbmanager.executeSelectQuery(Query1,null);

		if(statobj1.getStatus()){

			for(int i=0;i<statobj1.getCount();i++){
				HashMap hm1=new HashMap();

						hm1.put("startdate",dbmanager.getValue(i,"startdate",""));
						hm1.put("eventname",dbmanager.getValue(i,"eventname","").replaceAll("'","&#39;"));
						hm1.put("member",dbmanager.getValue(i,"username",""));
						hm1.put("eventid",dbmanager.getValue(i,"eventid",""));
						hm1.put("commission",dbmanager.getValue(i,"networkcommission",""));
						v1.addElement(hm1);
					}


               }
                          return v1;


}
public String getAgentStatus(HashMap eventstatusmap, String eventid, String nts_approvaltype){
String agentstatus=(String)GenUtil.getHMvalue(eventstatusmap,eventid,"");
String apprvstatus=nts_approvaltype;
		if ("".equalsIgnoreCase(agentstatus)){
			if("".equals(apprvstatus))
				apprvstatus=DbUtil.getVal("select nts_approvaltype from group_agent_settings where groupid=?",new String[]{eventid});
		if("Auto".equals(apprvstatus))
		agentstatus="Approved";
		else
		agentstatus="Need Approval";
		}
		return agentstatus;
}


public HashMap getPartnerListingPrices(String userid)
{


	CurrencyFormat cf=new CurrencyFormat();
	String query ="select amount,duration,duration_type from partner_listing_price where partnerid =(select partnerid from group_partner where userid=? and status='Active') and purpose='NETWORK_EVENT_LISTING'";

	         DBManager dbmanager=new DBManager();

	StatusObj statobj1=dbmanager.executeSelectQuery(query,new String[]{userid});
	HashMap hm=new HashMap();
	if(statobj1.getStatus())
	{
		for(int i=0;i<statobj1.getCount();i++)
		{
			String amount=dbmanager.getValue(i,"amount","");
			amount=cf.getCurrencyFormat("",amount,true);
			hm.put(dbmanager.getValue(i,"duration","")+"_"+dbmanager.getValue(i,"duration_type",""),amount);
		}
	}
    return hm;
}



}