package com.eventbeepartner.partnernetwork;

import java.util.*;
import com.eventbee.general.*;
import  com.eventbee.general.formatting.CurrencyFormat;
public class EarningDetails{


public  Vector getEarningEventsInfo(String agentid){
	Vector v=new Vector();
			String query="select distinct b.eventname,b.eventid"
					  +"  from eventinfo b,transaction d, partner_transactions c"
					  +"  where  b.eventid=cast(d.refid as integer) and d.agentid=? and c.agentid=d.agentid "
					  +"  and d.transactionid=c.transactionid and agentcommission>0";


			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid});
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


public  HashMap getEarningsInfo(String statusType, String agentid){
		HashMap earningsMap=new HashMap();
		CurrencyFormat cf=new CurrencyFormat();
		String query="select d.refid, sum(agentcommission) as agentcommission"
                                      +"  from transaction d, partner_transactions c"
                                      +"  where  d.agentid=? and c.agentid=d.agentid "
                                      +"  and d.transactionid=c.transactionid"
                                      +"  and paymentstatus=? and agentcommission>0 "
                                       +" group by refid";


			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid,statusType});
			if(statobj.getStatus()){

					for(int i=0;i<statobj.getCount();i++){
						String amount=dbmanager.getValue(i,"agentcommission","");
						amount=cf.getCurrencyFormat("",amount,true);
						earningsMap.put(dbmanager.getValue(i,"refid",""),amount);

					}
			}
			return earningsMap;
		}





public String getNTSEarningsInfo(String statusType, String agentid){
	CurrencyFormat cf=new CurrencyFormat();
	String earnings="0";
	String query="select  sum(agentcommission) as agentcommission"
	+"  from transaction d, partner_transactions c"
	+"  where  d.agentid=? and c.agentid=d.agentid "
	+"  and d.transactionid=c.transactionid"
	+"  and paymentstatus=?  "
	+" group by d.agentid";


	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid,statusType});
	if(statobj.getStatus()){
		String amount=dbmanager.getValue(0,"agentcommission","0");
		amount=cf.getCurrencyFormat("",amount,true);
		earnings=amount;

	}
	return earnings;
}

public String getNListingEarningsInfo(String agentid){
	CurrencyFormat cf=new CurrencyFormat();
	String earnings="0";
	double totalEarnings=0;
	String query="select  amount as amount from partner_listing "
			+" where partnerid=? ";
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid});
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
			try{
				String amount=dbmanager.getValue(i,"amount","0");
				amount=cf.getCurrencyFormat("",amount,true);

				totalEarnings+=Double.parseDouble(amount);
			}catch(Exception numberEx){
			}
		}

	}
	return ""+totalEarnings;
}

public String getImpressionEarningsInfo(String agentid){
	CurrencyFormat cf=new CurrencyFormat();
	String earnings="0";
	String query="select  sum(total)  as imptotal from impressions_summary  "
	+" where partnerid=? "
	+" and purpose='NETWORK_ADVERTISING' group by partnerid";


	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid});
	if(statobj.getStatus()){
		String amount=dbmanager.getValue(0,"imptotal","0");
		amount=cf.getCurrencyFormat("",amount,true);

		earnings=amount;

	}
	return earnings;
}

public String getClickEarningsInfo(String agentid){
	CurrencyFormat cf=new CurrencyFormat();
	String earnings="0";
	String query="select  sum(total)  as imptotal from clicks_summary  "
	+" where partnerid=? "
	+" and purpose='NETWORK_ADVERTISING' group by partnerid";


	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{agentid});
	if(statobj.getStatus()){
		String amount=dbmanager.getValue(0,"imptotal","0");
		amount=cf.getCurrencyFormat("",amount,true);

		earnings=amount;

	}
	return earnings;
}

public  Vector getListingEvents(Vector vec,String userid){
			String query="select  b.eventname,b.eventid,a.amount,a.duration,a.duration_type from eventinfo b,partner_listing a "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" order by  a.created_at desc";
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec.add(hm);
					}
			}

			return vec;
		}


public  Vector	getAdvertisingEvents(Vector vec1,String userid){
		String query="select  b.eventname,b.eventid,sum(a.impressioncount) as imp,sum(a.total)  as imptotal,au.login_name as username from eventinfo b,impressions_summary a,authentication au "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" and a.purpose='NETWORK_ADVERTISING' and au.user_id=b.mgr_id group by eventid, eventname ,login_name";
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm1=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm1.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec1.add(hm1);
					}
			}

			return vec1;
		}




public  Vector	getAdvertisingcpcEvents(Vector vec1,String userid){


String query="select  b.eventname,b.eventid,sum(a.clickcount) as clk,sum(a.total)  as clktotal,au.login_name as username from eventinfo b,clicks_summary a,authentication au "
						+" where a.refid=b.eventid and a.partnerid=(select partnerid from group_partner  where userid=? and status='Active') "
						+" and a.purpose='NETWORK_ADVERTISING' and au.user_id=b.mgr_id  group by eventid, eventname,login_name";
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
					for(int i=0;i<statobj.getCount();i++){
						HashMap hm1=new HashMap();
						for(int j=0;j<columnnames.length;j++){
							hm1.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
						}
						vec1.add(hm1);
					}
			}

			return vec1;
		}

}
