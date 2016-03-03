
package com.eventbee.event.ticketinfo;
import com.eventbee.general.StatusObj;
import com.eventbee.general.EventbeeConnection;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.formatting.CurrencyFormat;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.*;
import com.eventbee.event.*;
import com.eventbee.editevent.EditEventDB;

import com.eventbee.authentication.*;
import com.eventbee.listmanagement.MailListMember;
import com.eventbee.listmanagement.ListDB;
import java.util.List;
import java.util.ArrayList;
import java.sql.*;
import java.util.HashMap;
import java.util.Vector;
import java.util.*;
import java.text.*;

 public class EventTicketDB {

   final static String FILE_NAME="EventTicketDB";
   public static SimpleDateFormat EST_DATE_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");


   final String GET_EBEE_FEE_UNIT ="select * from ebeefees where purpose=? and unitid=? ";

   final String INSERT_ATTENDEE_TICKET = " insert into attendeeticket(userid, "
		+" eventid, transactionid, transactiontype, ticketname, ticketprice, ticketqty, "
		+" couponcode,coupondiscount,bookdate, bookingsource, agentid,ticketid) "
 		+" values (to_number(?,'99999999999999999'),?,?,?,?,?,?,?,?,now(),?,?,to_number(?,'99999999999999999'))";
   final String UPDATE_TICKET_COUNT = " update price set sold_qty=sold_qty+to_number(?,'9999999999') where price_id=to_number(?,'9999999999') ";
   final String UPDATE_PROMO_COUNT = "update promotionsales set sold=sold+to_number(?,'9999999999') where promoitemid=to_number(?,'9999999999') ";

   final String INSERT_EVENT_ATTENDEE = " insert into eventattendee("
		 +" authid, eventid, transactionid,  username,"
  +" firstname, lastname,email,phone,company,title,city,state,country,zip,priattendee,"
  +"attendeeid,attendeekey,sourceunitid,gender,shareprofile,comments,address1,address2) "
	+" values (to_number(?,'9999999999'),to_number(?,'999999999999999'),?,?,?,?,?,?,?,?,?,?,?,?,?,to_number(?,'9999999999'),?,?,?,'Yes',?,?,?) ";

   final String INSERT_PROMO_SALES = " insert into attendeepromosales(userid, "
			+" eventid, promoitemid, price, qty, transactionid, transactiontype,itemname) "
			 +" values (to_number(?,'9999999999'),to_number(?,'9999999999'),to_number(?,'9999999999'),?,to_number(?,'9999999999'),?,?,?) ";
   final String INSERT_ATTENDEE_TRANSACTION = " insert into transaction(transactionid, "
			+" refid,purpose,trandate,ebeefee,cardfee,mgrfee,attendeefee, "
			+" totalamount,grandtotal,unitid,discount,source,agentid,agentcommission) values (?,?,?,now(),?,?,?,?,?,?,?,?,?,?,?) ";
   final String GET_TRANSACTION_QUERY = " select nextval('seq_transactionid') as transactionid";
   final String GET_EVENT_CONFIG_QUERY = " select name, value from config  "
			+" where config_id=(select config_id from eventinfo where eventid=to_number(?,'999999999999999999')) ";


   final static String GET_EVENT_CONFIG_VALUE = " select value from config where config_id="
     +"(select config_id from eventinfo where eventid=?) and name=?";

   final String GET_CLUB_INFO_QUERY = " select c.mgr_id, c.clubid, membership_id,  "
				+" membership_name,b.description,b.price, mship_term   "
    				+" from eventinfo a,club_membership_master b,clubinfo c  "
    				+" where a.eventid=to_number(?,'99999999999999999') and a.unitid=c.unitid  "
    				+" and b.clubid=c.clubid";
   final String GET_PROMO_QUERY = " select promoitemid,itemname,description,price, "
				+" qty,transactiontype,policy,imagename from promotionsales "
                                 +" where now() between startdate and (enddate+1)  "
				 +" and max_ticket>sold and eventid=to_number(?,'99999999999999999')";

   final String EVENT_INFO_QUERY="select getMemberPref(mgr_id||'','pref:myurl','') as username,venue,starttime,endtime,unitpkg_type,eventname,status,email,mgr_id,evt_level,phone, to_char(start_date,'mm/dd/yyyy')  as startdate, to_char(end_date,'mm/dd/yyyy') as enddate,trim(to_char(start_date,'Day')) ||', '|| to_char(start_date,'Month DD, YYYY') as start_date,trim(to_char(end_date,'Day')) ||', '|| to_char(end_date,'Month DD, YYYY') as end_date,city,state,address1,address2,country "
   +" from org_unit a,eventinfo b where  a.unit_id=b.unitid and b.eventid=to_number(?,'999999999999999999')";

   final String MGR_INFO_QUERY="select first_name,last_name,phone,mobile from user_profile "
                              +" where user_id=? ";

   final String CLUB_LINK_URL=" select value,name from config where config_id =(select "
   +" config_id from clubinfo where clubid=to_number(?,'999999999999999999')) and name in('club.url','club.signup.url','eventreg.login.msg')";


   final String GET_TICKET_QUERY= " select price.price_id,ticket_name,description,ticket_price,process_fee,ticket_type ,max_ticket,sold_qty,min_qty,max_qty,"
                                 +" count(couponid) as couponid from price left outer join "
                                 +" coupon_ticket on price.price_id =coupon_ticket.price_id "
                                 +" where evt_id=to_number(?,'99999999999999999') and max_ticket>sold_qty and price.status is null "
				+" and now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) "
                                +"group by price.price_id,ticket_name, ticket_price,process_fee,ticket_type,description,max_ticket,sold_qty,min_qty,max_qty "
                                 +" order by ticket_type ";
   final static String GET_COUPON_DISCOUNT= " select a.discount from coupon_master a," 				+" coupon_ticket b, coupon_codes c "
 				+" where a.couponid=b.couponid "
				+" and b.couponid=c.couponid "
				+" and c.couponcode=? "
				+" and b.price_id=? ";

   final String TICKET_INFO_REQUIRED = " select * from price where evt_id=? "
                                    +" and ticket_category='required'";
   final String TICKET_INFO_OPTIONAL = " select * from price where evt_id=? and "
                                    +" ticket_category='optional'";
   final String GET_EBEE_FEE ="select * from ebeefees where purpose=?";
   final String TICKET_UPDATE_QUERY= "select ticket_name,description,ticket_price,process_fee, max_ticket,ticket_type,"
				     +" to_char(start_date,'yyyy') as start_yy, "
				     +" to_char(start_date,'mm') as start_mm, "
                                     +" to_char(start_date,'dd') as start_dd, "
				     +" to_char(end_date,'yyyy') as end_yy, "
				     +" to_char(end_date,'mm') as end_mm, "
                                     +" to_char(end_date,'dd') as end_dd ,max_qty,min_qty,starttime,endtime "
                                     +" from price where evt_id=? and price_id=? ";
   final String UPDATE_EVENT_TICKET = "update price set ticket_name=?,description=?,ticket_price=?,"
                                    +" max_ticket=?,start_date=?,end_date=?,min_qty=?,max_qty=?,starttime=?,endtime=?,process_fee=? "
                                    +" where evt_id=? and price_id=? ";
   final String ADD_EVENT_TICKET = " insert into price (ticket_name,description,ticket_price,"
                                 +" max_ticket,start_date,end_date,ticket_category,ticket_type,"
                                 +" evt_id,price_id,sold_qty,min_qty,max_qty,starttime,endtime) values (?,?,?,?,?,?,?,?,?,"
				 +"nextval('seq_priceid'),0,?,?,?,?)";
   final String TICKET_INSERT = " insert into price (ticket_name,description,ticket_price,"
                                 +" max_ticket,start_date,end_date,ticket_category,ticket_type,"
                                 +" evt_id,price_id,sold_qty,min_qty,max_qty,starttime,endtime,networkcommission,process_fee,partnerlimit,isdonation) values (?,?,?,?,?,?,?,?,?,"
				 +"nextval('seq_priceid'),0,?,?,?,?,?,?,?,?)";
   final String TICKET_UPDATE = " update price set ticket_name=?,description=?,ticket_price=?,"
                                    +" max_ticket=?,start_date=?,end_date=?,min_qty=?,max_qty=?,starttime=?,endtime=?,process_fee=? "
                                    +" where evt_id=? and price_id=?  ";
   final String DELETE_EVENT_ATTENDEETICKET= " delete from attendeeticket where transactionid=?";
   final String DELETE_EVENT_ATTENDEE= " delete from eventattendee where transactionid=?";
   final String DELETE_EVENT_ATTENDEEPROMO= " delete from attendeepromosales where transactionid=?";
   final String DELETE_EVENT_TRANSACTION = " delete from transaction where transactionid=?";
   final static String TICKET_QUERY="select ticket_name,description,price_id,max_ticket"
        +",sold_qty,ticket_price,to_char(start_date,'Mon DD') as start_date,"
        +"to_char(end_date,'Mon DD') as end_date,ticket_type from price where evt_id=?";
	final static String ACTIVE_TICKET_QUERY="select ticket_name,description,price_id,max_ticket"
        +",sold_qty,ticket_price,to_char(start_date,'Mon DD') as start_date,"
        +"to_char(end_date,'Mon DD') as end_date,ticket_type from price where evt_id=? and status is null";

	final String DECREASE_TICKETS_SOLD_COUNT = "update price set sold_qty=sold_qty-? where price_id=?";

	final String GET_PAYMENT_TYPES_QUERY ="select status,paytype,attrib_1,attrib_2 from payment_types where refid=? and purpose=?";

 public double getHiddenPrice(EventRegisterBean jBean){
 	double ebeefee=0.0;
	double ebeepercent=0.0;
	DBManager dbmanager=new DBManager();
	EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","The UNITID is:"+jBean.getUnitId(),null);
	StatusObj statobj=dbmanager.executeSelectQuery(GET_EBEE_FEE_UNIT,new String[]{"EVENT_REGISTRATION_HIDDEN",jBean.getUnitId()});
	EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","The statusobj is:"+statobj.getStatus(),null);
		if(!(statobj != null && statobj.getStatus() && statobj.getCount()>0   ))
		statobj=dbmanager.executeSelectQuery(GET_EBEE_FEE_UNIT,new String[]{"EVENT_REGISTRATION_HIDDEN","0"});
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","The statusobj11 is:"+statobj.getStatus(),null);
		if(statobj != null && statobj.getStatus() && statobj.getCount()>0   ){
		ebeepercent=Double.parseDouble(dbmanager.getValue(0,"ebee_factor","0"));
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","Ebeepercent is:--->"+ebeepercent,null);
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","Grand total is:--->"+jBean.getGrandTotal(),null);
		if("Amex".equals(jBean.getCard().getCardtype()))
			ebeepercent=ebeepercent+0.00;
		ebeefee=Double.parseDouble(dbmanager.getValue(0,"ebee_base","0"))+(ebeepercent*jBean.getGrandTotal());
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getHiddenPrice()","Ebeefee is:--->"+ebeefee,null);
	}
	return ebeefee;
}

 public Vector getReqTicketInfo(String eventid){
	return getTicketInfo(eventid,TICKET_INFO_REQUIRED);
 }
 public Vector getOptTicketInfo(String eventid){
	return getTicketInfo(eventid,TICKET_INFO_OPTIONAL);
 }
 public StatusObj getEventInfo(String EventId,HashMap evtInfo){
       boolean status=fillEventInfo(evtInfo, EventId);
       if(status)
       status=fillEventTicketsInfo(evtInfo,EventId);

       return new StatusObj(status, "", "");
 }

 public void unregisterEvent(EventRegisterBean jBean){
          String tranid=jBean.getTransactionId();
          Connection con=null;
          int rcount=0;
          java.sql.PreparedStatement pstmt=null;
        try{
		con=EventbeeConnection.getWriteConnection("event");
		pstmt=con.prepareStatement(DELETE_EVENT_ATTENDEE);
			pstmt.setString(1,tranid);
			rcount=pstmt.executeUpdate();
                  EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "initialize()", " Enter the ATTENDEE",null);
		pstmt.close();
        	pstmt=con.prepareStatement(DELETE_EVENT_ATTENDEETICKET);
			pstmt.setString(1,tranid);
			rcount=pstmt.executeUpdate();
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "initialize()", " enter the ATTENDEETICKET ",null);
		pstmt.close();
                pstmt=con.prepareStatement(DELETE_EVENT_ATTENDEEPROMO);
			pstmt.setString(1,tranid);
			rcount=pstmt.executeUpdate();
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "initialize()", "entere the ATTENDEEPROMO",null);
		pstmt.close();
                pstmt=con.prepareStatement(DELETE_EVENT_TRANSACTION);
			pstmt.setString(1,tranid);
			rcount=pstmt.executeUpdate();
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "initialize()", "entere the TRANSACTION",null);
		pstmt.close();
                pstmt=null;
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "initialize()", "REMOVE DONE SUCCESSFULLY",null);
		rollbackTicketCount(jBean,con);
	}catch(Exception e){
                 EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"SendMail()","ERROR in UnregisterEvent()",e);
	}finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}

 }
public void rollbackTicketCount(EventRegisterBean jBean,Connection con){
java.sql.PreparedStatement pstmt=null;
EventTicket evtticket=jBean.getSelectedReqTicket();
Membership mship=jBean.getSelectedMshipTicket();
EventTicket[] optionalticket=jBean.getSelectedOptTickets();
try{
	pstmt=con.prepareStatement(DECREASE_TICKETS_SOLD_COUNT);
	if(evtticket!=null){
		  pstmt.setString(1,evtticket.getTicketQty());
		  pstmt.setString(2,evtticket.getTicketId());
		  pstmt.executeUpdate();
	}
	if(mship!=null){
		 pstmt.setString(1,mship.getSelQty()+"");
		 pstmt.setString(2,mship.getId());
		 pstmt.executeUpdate();
	}
	if(optionalticket!=null)
	{
		for(int i=0;i<optionalticket.length;i++)
		{
			evtticket=optionalticket[i];
			if(evtticket!=null){
				pstmt.setString(1,evtticket.getTicketQty());
				pstmt.setString(2,evtticket.getTicketId());
				pstmt.executeUpdate();
			}
		}
	}
			  pstmt.close();
  			  pstmt=null;
	}catch(Exception e){
  		EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"rollbackTicketCount()","Error in rollbackTicketCount:",e);
		}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
}


public StatusObj registerEvent(EventRegisterBean jBean){
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "registerEvent()","The jBean is:"+jBean,null);
String agentid=jBean.getAgentId();
EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "registerEvent()","The jBean is:"+jBean,null);
String groupid=jBean.getEventId();
String agentcommission=null;
String commtype=null;
String salelimit=null;
boolean status=false;
HashMap agentcommmap=new HashMap();
if(agentid!=null){
	agentcommmap=getAgentComm(groupid);
	if(agentcommmap!=null){
		//agentcommission=(String)agentcommmap.get("salecommission");
		commtype=(String)agentcommmap.get("commtype");
		salelimit=(String)agentcommmap.get("saleslimit");
	}
}

String totalsales=DbUtil.getVal("select sum(to_number(totalamount,'9999.99')) from transaction where refid=? and agentid=? ",new String[]{groupid,agentid});
double limit=0;
double sales=0;

try{
	if(salelimit!=null)
		 limit=Double.parseDouble(salelimit);
	if (totalsales!=null)
		sales=Double.parseDouble(totalsales);

}catch(Exception e){
EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"RegisterEvent()","There is an error in:",e);
}

DecimalFormat df=new DecimalFormat("0.00");

String xmlregdata=EventRegisterManager.writeDatatoXml(jBean);
 StatusObj statobjn=null;
String tran_id=DbUtil.getVal("select transactionid from eventbee_payment_data where transactionid=?", new String []{jBean.getTransactionId()});
if(tran_id==null)
statobjn= DbUtil.executeUpdateQuery("insert into eventbee_payment_data (transactionid,ebee_xml,trandate,refid,ref_type) values(?,?,now(),?,?)", new String []{jBean.getTransactionId(),xmlregdata,jBean.getEventId(),"EVENT"});
else
statobjn= DbUtil.executeUpdateQuery("update eventbee_payment_data set ebee_xml=?,trandate=now() where transactionid=?", new String []{xmlregdata,jBean.getTransactionId()});



EventRegisterDataBean edb= new EventRegisterDataBean();
EventRegisterManager erm=new EventRegisterManager();
if(xmlregdata!=null)
EventRegisterManager.initEventRegXmlData(xmlregdata,edb);
StatusObj statobj=erm.insertRegData(edb);

if(statobj.getStatus()){
	status=true;

}



	double totalagentcommission=0.0;
	Connection con=null;
        ResultSet rs=null;
        int rcount=0;

        String userid=jBean.getUserId()!=null?jBean.getUserId():"0";
        java.sql.PreparedStatement pstmt=null;
        try{
	double commission=0.0;
	//if(agentcommission!=null)
	//commission=Double.parseDouble(agentcommission);

		double ebee_hidden_fee=0;
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "registerEvent()","The Grand Total is:"+jBean.getGrandTotal(),null);
		if(("eventbee".equals(jBean.getSelectPayType()))&&(jBean.getGrandTotal()>0)){
		EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "registerEvent()","<---Before The getHiddenPrice(jBean)-->",null);
		ebee_hidden_fee=Double.parseDouble(df.format(getHiddenPrice(jBean)));
		}



	}catch(Exception e){

	}finally{}
	return new StatusObj(status,"","");
}

 public boolean fillEventTicketsInfo(HashMap evtInfo,String eventid){
	 boolean status=false;
Vector req=new Vector();
Vector opt=new Vector();
Vector streq=new Vector();
Vector stopt=new Vector();
Vector endreq=new Vector();
Vector endopt=new Vector();
Vector soldreq=new Vector();
Vector soldopt=new Vector();

String REQ_TICKETS="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Public'";
String OPT_TICKETS="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Optional'";
String REQ_YET_TO_START_TICKETS="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Public' and start_date+cast(cast(starttime as text) as time )>now()";
String OPT_YET_TO_START_TICKETS="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Optional' and start_date+cast(cast(starttime as text) as time )>now()";
String REQ_TICKETS_DATE_ENDED="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Public' and end_date<now()";
String OPT_TICKETS_DATE_ENDED="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Optional' and end_date<now()";
String REQ_TICKETS_SOLDOUT="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Public' and sold_qty=max_ticket";
String OPT_TICKETS_SOLDOUT="select * from price where evt_id=to_number(?,'9999999999999999') and ticket_type='Optional' and sold_qty=max_ticket";
req=getTickets(REQ_TICKETS,eventid);
  EventTicket[] req_tkt=new EventTicket[req.size()];
for(int i=0;i<req.size();i++){
		req_tkt[i]=(EventTicket)req.elementAt(i);
}
evtInfo.put("REQUIRED_TICKETS",req_tkt);
req=null;

opt=getTickets(OPT_TICKETS,eventid);
  EventTicket[] opt_tkt=new EventTicket[opt.size()];
for(int i=0;i<opt.size();i++){
		opt_tkt[i]=(EventTicket)opt.elementAt(i);
}
evtInfo.put("TOTAl_OPTIONAL_TICKETS",opt_tkt);
opt=null;

streq=getTickets(REQ_YET_TO_START_TICKETS,eventid);
  EventTicket[] streq_tkt=new EventTicket[streq.size()];
for(int i=0;i<streq.size();i++){
		streq_tkt[i]=(EventTicket)streq.elementAt(i);
}
evtInfo.put("YET_TO_START_REQ_TICKETS",streq_tkt);
streq=null;

stopt=getTickets(OPT_YET_TO_START_TICKETS,eventid);
  EventTicket[] stopt_tkt=new EventTicket[stopt.size()];
for(int i=0;i<stopt.size();i++){
		stopt_tkt[i]=(EventTicket)stopt.elementAt(i);
}
evtInfo.put("YET_TO_START_OPT_TICKETS",stopt_tkt);
stopt=null;
endreq=getTickets(REQ_TICKETS_DATE_ENDED,eventid);
  EventTicket[] endreq_tkt=new EventTicket[endreq.size()];
for(int i=0;i<endreq.size();i++){
		endreq_tkt[i]=(EventTicket)endreq.elementAt(i);
}
evtInfo.put("ENDED_REQ_TICKETS",endreq_tkt);
endreq=null;
endopt=getTickets(OPT_TICKETS_DATE_ENDED,eventid);
  EventTicket[] endopt_tkt=new EventTicket[endopt.size()];
for(int i=0;i<endopt.size();i++){
		endopt_tkt[i]=(EventTicket)endopt.elementAt(i);
}
evtInfo.put("ENDED_OPT_TICKETS",endopt_tkt);
endopt=null;
soldreq=getTickets(REQ_TICKETS_SOLDOUT,eventid);
  EventTicket[] soldreq_tkt=new EventTicket[soldreq.size()];
for(int i=0;i<soldreq.size();i++){
		soldreq_tkt[i]=(EventTicket)soldreq.elementAt(i);
}
evtInfo.put("SOLDOUT_REQ_TICKETS",soldreq_tkt);
soldreq=null;
soldopt=getTickets(OPT_TICKETS_SOLDOUT,eventid);
  EventTicket[] soldopt_tkt=new EventTicket[soldopt.size()];
for(int i=0;i<soldopt.size();i++){
		soldopt_tkt[i]=(EventTicket)soldopt.elementAt(i);
}
evtInfo.put("SOLDOUT_OPT_TICKETS",soldopt_tkt);
soldopt=null;


status=true;
return status;

}



public Vector getDetails(String query,String transactionId){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{transactionId});

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




public  HashMap getResponses(String RESPONSE_QUERY,String setid){
		DBManager dbmanager=new DBManager();
		Vector responses=new Vector();
		StatusObj statobj=null;
		HashMap hm=null;
		statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY,new String []{setid});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){

				hm=new HashMap();
				for(int k=0;k<count;k++){
					String userid=dbmanager.getValue(k,"userid","");
					HashMap options=(HashMap)hm.get(userid);
					if (options==null)
						options=new HashMap();
					options.put(dbmanager.getValue(k,"attrib_name","0"),dbmanager.getValue(k,"response","0"));

					hm.put(userid,options);

				}

		}

	return hm;
}





public HashMap getTransactionDetails(String transactionId){
String attendeequery="select firstname,lastname,email,priattendee,phone,attendeekey from eventattendee where transactionid=?";
String ticketsquery="select ticketname,ticketqty,ticketid,ticketprice,couponcode,transactiontype from attendeeticket where transactionid=?";
String transactionquery="select discount,grandtotal,totalamount,agentid,tax from transaction where transactionid=?";
String customattribquery="select attrib_name,response,userid,a.responseid,b.attrib_setid,c.transactionid   from  custom_attrib_response a,"
+"custom_attrib_response_master b,eventattendee c"
+" where a.responseid=b.responseid and c.attendeekey=b.userid  and c.transactionid=?";
String transactiontype=DbUtil.getVal("select transactiontype from attendeeticket where transactionid=?",new String[]{transactionId});
HashMap hm=new HashMap();
Vector attendeeDetails=getDetails(attendeequery,transactionId);
Vector Tickets=getDetails(ticketsquery,transactionId);
Vector Transactiondetails=getDetails(transactionquery,transactionId);
HashMap customresponses=getResponses(customattribquery,transactionId);
hm.put("AttendeeDetails",attendeeDetails);
hm.put("Tickets",Tickets);
hm.put("TransactionDetails",Transactiondetails);
hm.put("CustomAttribs",customresponses);
hm.put("OldTransactionId",transactionId);
hm.put("Old_Payment_Type",transactiontype);
return hm;
}











Vector getTickets(String query,String eventid){
	Vector ticketsvec=new Vector();
DBManager dbmanager=new DBManager();
StatusObj sb=dbmanager.executeSelectQuery(query,new String[]{eventid});

if(sb.getStatus()){

for(int i=0;i<sb.getCount();i++){
EventTicket et=new EventTicket();
et.setTicketName( dbmanager.getValue(i,"ticket_name",""));
et.setTicketId(dbmanager.getValue(i,"price_id",""));
et.setDescription(dbmanager.getValue(i,"description",""));
double tprice=Double.parseDouble(dbmanager.getValue(i,"ticket_price",""))+Double.parseDouble(dbmanager.getValue(i,"process_fee",""));
et.setTicketPrice(Double.toString(tprice));
et.setTicketProcessFee(dbmanager.getValue(i,"process_fee",""));
et.setTicketDisplayPrice(dbmanager.getValue(i,"ticket_price",""));

et.setMinQty(Integer.parseInt(dbmanager.getValue(i,"min_qty","")));
et.setMaxQty(Integer.parseInt(dbmanager.getValue(i,"max_qty","")));
et.setMaxTicket(dbmanager.getValue(i,"max_ticket",""));
et.setTicketType(dbmanager.getValue(i,"ticket_type",""));
et.setSoldQty(Integer.parseInt(dbmanager.getValue(i,"sold_qty","")));

ticketsvec.add(et);
}

}


return ticketsvec;
}




 public boolean fillEventInfo(HashMap evtInfo,String eventid){
	    boolean status=false;
        String userid="";
	Connection con=null;
        java.sql.PreparedStatement pstmt=null;
        java.sql.PreparedStatement pstmtX=null;
	try{
                con=EventbeeConnection.getReadConnection("event");
                pstmt=con.prepareStatement(GET_TRANSACTION_QUERY);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
			evtInfo.put("TRANSACTION_ID", rs.getString("transactionid"));
		}


		rs.close();
		pstmt.close();
                pstmt=con.prepareStatement(EVENT_INFO_QUERY);
                pstmt.setString(1,eventid);
                rs=pstmt.executeQuery();
                if(rs.next()){
               		evtInfo.put("PKGNAME", rs.getString("unitpkg_type"));
			evtInfo.put("EVENTNAME", rs.getString("eventname"));
                        evtInfo.put("STATUS", rs.getString("status"));
                        evtInfo.put("EMAIL",rs.getString("email"));
			evtInfo.put("STARTDATE",rs.getString("startdate"));
			evtInfo.put("ENDDATE",rs.getString("enddate"));
			evtInfo.put("StartDate_Day",rs.getString("start_date"));
			evtInfo.put("EndDate_Day",rs.getString("end_date"));

			evtInfo.put("STARTTIME", DateTime.getTimeAM(rs.getString("starttime")));
			evtInfo.put("ENDTIME", DateTime.getTimeAM(rs.getString("endtime")));

                        userid=rs.getString("mgr_id");
			evtInfo.put("LOCATION",GenUtil.getCSVData(new String[]{rs.getString("city"),rs.getString("state"),rs.getString("country")}));
			evtInfo.put("VENUE",GenUtil.getCSVData(new String[]{rs.getString("venue"),rs.getString("address1"),rs.getString("address2")}));
            evtInfo.put("FULLADDRESS",GenUtil.getCSVData(new String[]{rs.getString("venue"),rs.getString("address1"),rs.getString("address2"),rs.getString("city"),rs.getString("state"),rs.getString("country")}));
             evtInfo.put("ADDRESS",GenUtil.getCSVData(new String[]{rs.getString("address1"),           rs.getString("address2")}));
                        evtInfo.put("EVENTLEVEL",rs.getString("evt_level"));
		}
		rs.close();
		pstmt.close();
                pstmt=con.prepareStatement(MGR_INFO_QUERY);
                pstmt.setString(1,userid);
                rs=pstmt.executeQuery();
                if(rs.next()){
			evtInfo.put("FIRSTNAME",rs.getString("first_name"));
                        evtInfo.put("LASTNAME",rs.getString("last_name"));
                        evtInfo.put("PHONE",rs.getString("phone"));

                        evtInfo.put("MOBILE",rs.getString("mobile"));
		}
		rs.close();
		pstmt.close();
                pstmt=con.prepareStatement(GET_EVENT_CONFIG_QUERY);
                pstmt.setString(1,eventid);
                rs=pstmt.executeQuery();
                if(rs.next()){
			do{
				evtInfo.put(rs.getString("name"), rs.getString("value"));

			  }while(rs.next());

		}
		rs.close();
				pstmt.close();
		                pstmt=con.prepareStatement(GET_PAYMENT_TYPES_QUERY);
		                pstmt.setString(1,eventid);
		                pstmt.setString(2,"Event");
		                rs=pstmt.executeQuery();
		                if(rs.next()){
					do{
						evtInfo.put(rs.getString("paytype"), rs.getString("status"));
						if("eventbee".equals(rs.getString("paytype")))
							evtInfo.put("event.payment.transactionfee.payee", rs.getString("attrib_1"));
						else
							evtInfo.put("event.payment.transactionfee.payee", "");


					  }while(rs.next());



		}
		rs.close();
		pstmt.close();
                pstmt=con.prepareStatement(GET_CLUB_INFO_QUERY);
                pstmt.setString(1,eventid);
                rs=pstmt.executeQuery();
                if(rs.next()){
			ClubData cd=new ClubData();
			Vector vm=new Vector();
			do{
				cd.setClubId(rs.getString("clubid"));
				Membership ms= new Membership();
				ms.setId(rs.getString("membership_id"));
				ms.setName(rs.getString("membership_name"));
                                ms.setDesc(rs.getString("description"));
                                ms.setPrice(rs.getString("price"));
				ms.setTerm(rs.getString("mship_term"));
                                vm.addElement(ms);
			}while(rs.next());
			Membership[] ms=new Membership[vm.size()];
			for(int i=0;i<vm.size();i++){
			        ms[i]=(Membership)vm.elementAt(i);
			}
			vm=null;

                         pstmtX=con.prepareStatement(CLUB_LINK_URL);
                         pstmtX.setString(1,cd.getClubId());
                         ResultSet rsX=pstmtX.executeQuery();
                         if (rsX.next()){
				do{
				if("club.url".equals(rsX.getString("name")))
				cd.setClubUrl(rsX.getString("value"));
				if("club.signup.url".equals(rsX.getString("name")))
				cd.setSignUpClubUrl(rsX.getString("value"));
				if("eventreg.login.msg".equals(rsX.getString("name")))
				cd.setLoginTitle(rsX.getString("value"));

				}while(rsX.next());
    			 }
                         rsX.close();
                	 pstmtX.close();
			 cd.setMemberships(ms);
			 evtInfo.put("CLUB_DATA",cd);
		}
		rs.close();
		pstmt.close();
		pstmt=con.prepareStatement(GET_PROMO_QUERY);
                pstmt.setString(1,eventid);
                rs=pstmt.executeQuery();
                if(rs.next()){
		     PromoData pd=new PromoData();
		       do{
				pd.setId(rs.getString("promoitemid"));
				pd.setName(rs.getString("itemname"));
				pd.setDesc(rs.getString("description"));
                 		pd.setImage(rs.getString("imagename"));
				pd.setOrderType(rs.getString("transactiontype"));
                                pd.setPrice(rs.getString("price"));
                                pd.setQty(rs.getString("qty"));
                                pd.setPolicy(rs.getString("policy"));
                          }while(rs.next());
				evtInfo.put("PROMO_DATA",pd);
		}
		rs.close();
		pstmt.close();
                pstmt=con.prepareStatement(GET_TICKET_QUERY);
                pstmt.setString(1,eventid);
                rs=pstmt.executeQuery();
                if(rs.next()){
			Vector vm_pub=new Vector();
			Vector vm_mem=new Vector();
			Vector vm_opt=new Vector();
      			Vector vm_evt=new Vector();
			do{
			      EventTicket et=new EventTicket();
                  et.setTicketId(rs.getString("price_id"));
			      et.setTicketName(rs.getString("ticket_name"));
				  et.setDescription(rs.getString("description"));

				  double tprice=0.0;

			  try{
				 tprice=Double.parseDouble(rs.getString("ticket_price"))+Double.parseDouble(rs.getString("process_fee"));
			    }
					catch(Exception e){

					  System.out.println("Exception e----"+e.getMessage());


					}

                  et.setTicketPrice(Double.toString(tprice));
			      et.setTicketProcessFee(rs.getString("process_fee"));
                  et.setTicketDisplayPrice(rs.getString("ticket_price"));
                              et.setTicketType(rs.getString("ticket_type"));
                              et.setMaxTicket(rs.getString("max_ticket"));
                              et.setMinQty(rs.getInt("min_qty"));
                              et.setMaxQty(rs.getInt("max_qty"));
                              et.setSoldQty(Integer.parseInt(rs.getString("sold_qty")));
                              et.setCouponCount(rs.getInt("couponid"));
			      if("Public".equals(et.getTicketType()))
                                	vm_pub.addElement(et);
				else if("Member".equals(et.getTicketType()))
                                	vm_mem.addElement(et);
				else if("Eventbee".equals(et.getTicketType()))
                                        vm_evt.addElement(et);
                                else
					vm_opt.addElement(et);

			}while(rs.next());
                        EventTicket[] ms_pub=new EventTicket[vm_pub.size()];
			for(int i=0;i<vm_pub.size();i++){
			        ms_pub[i]=(EventTicket)vm_pub.elementAt(i);
			}
			evtInfo.put("PUBLIC_TICKETS",ms_pub);
			vm_pub=null;
                        EventTicket[] ms_mem=new EventTicket[vm_mem.size()];
			for(int i=0;i<vm_mem.size();i++){
			        ms_mem[i]=(EventTicket)vm_mem.elementAt(i);
			}
			evtInfo.put("MEMBER_TICKETS",ms_mem);
			vm_mem=null;
                        EventTicket[] ms_opt=new EventTicket[vm_opt.size()];
			for(int i=0;i<vm_opt.size();i++){
			        ms_opt[i]=(EventTicket)vm_opt.elementAt(i);
			}

			evtInfo.put("OPTIONAL_TICKETS",ms_opt);
                        vm_opt=null;
                        EventTicket[] ms_evt=new EventTicket[vm_evt.size()];
			for(int i=0;i<vm_evt.size();i++){
			        ms_evt[i]=(EventTicket)vm_evt.elementAt(i);
			}
			evtInfo.put("EVENTBEE_TICKETS",ms_evt);
			vm_evt=null;

        	}
                rs.close();
		pstmt.close();
               pstmt=con.prepareStatement(GET_EBEE_FEE);
               pstmt.setString(1,"EVENT_REGISTRATION");
               rs=pstmt.executeQuery();
               if(rs.next()){
		      evtInfo.put("ebee_fee_base", rs.getString("ebee_base"));
                             evtInfo.put("ebee_fee_percent",rs.getString("ebee_factor"));
                             evtInfo.put("card_fee_base",rs.getString("card_base"));
                             evtInfo.put("card_fee_percent",rs.getString("card_factor"));
        	}
		rs.close();
		pstmt.close();

               	pstmt=null;
                status=true;
	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"fillEventInfo()","There is an error in filleventinfo:",e);
                System.out.println(e+pstmt.toString());
		status=false;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
                        if(con!=null) con.close();
		}catch(Exception e){}
	}
	return status;
    }

   public void AddMemberList(EventRegisterBean jBean){
          ProfileData[] pd=jBean.getProfileData();
          List l1=new ArrayList();
          for (int i=0;i<pd.length;i++){
               MailListMember ml=new MailListMember();
               ml.setName(pd[i].getFirstName() + "" + pd[i].getLastName());
               ml.setCompany(pd[i].getCompany());
               ml.setJobType(pd[i].getTitle());
               ml.setPhone(pd[i].getPhone());
               ml.setEmail(pd[i].getEmail());
               ml.setManagerId("0");
               l1.add(ml);
          }
        ListDB.addMembers(l1,jBean.getMaillistId());
  }

  public static String getCouponDiscount(String couponcode, String ticketId){
	Connection con=null;
	String discount="0";
        java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("event");
		pstmt=con.prepareStatement(GET_COUPON_DISCOUNT);
                pstmt.setString(1,couponcode);
		pstmt.setString(2,ticketId);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
                      discount = rs.getString("discount");
		}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getCouponDiscount()","There is an error in getCouponDiscount:",e);
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
                        if(con!=null) con.close();
		}catch(Exception e){}
	}
	return discount;
  }

  public static String getEventConfig(String eventid, String configname){
  	Connection con=null;
  	String value=null;
          java.sql.PreparedStatement pstmt=null;
  	try{
  		con=EventbeeConnection.getReadConnection("event");
  		pstmt=con.prepareStatement(GET_EVENT_CONFIG_VALUE);
        pstmt.setString(1,eventid);
  		pstmt.setString(2,configname);
        ResultSet rs=pstmt.executeQuery();
        if(rs.next()){
                  value = rs.getString("value");
  		}
  		rs.close();
  		pstmt.close();
  		pstmt=null;
  	}catch(Exception e){
                  EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getCouponDiscount()","There is an error in getCouponDiscount:",e);
  	}
  	finally{
  		try{
  			if (pstmt!=null) pstmt.close();
                          if(con!=null) con.close();
  		}catch(Exception e){}
  	}
  	return value;
  }

  public Vector getTicketInfo(String eventid,String query){
	Connection con=null;
        HashMap hm=null;
        Vector v=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("event");
		pstmt=con.prepareStatement(query);
                pstmt.setString(1,eventid);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
                                v=new Vector();
			do{
				hm=new HashMap();
				hm.put("ticket_name", rs.getString("ticket_name"));
				hm.put("description",rs.getString("description"));
                                hm.put("price_id", rs.getString("price_id"));
				hm.put("max_ticket", rs.getString("max_ticket"));
				hm.put("sold", rs.getString("sold_qty"));
				hm.put("ticket_price", rs.getString("ticket_price"));
				hm.put("start_date", rs.getString("start_date"));
				hm.put("end_date", rs.getString("end_date"));
				hm.put("starttime",rs.getString("starttime"));
				hm.put("endtime",rs.getString("endtime"));


                		hm.put("ticket_type", rs.getString("ticket_type"));
				hm.put("status", rs.getString("status"));
				v.addElement(hm);
			}while(rs.next());

			}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getTicketInfo()","There is an error in getEventInfo:",e);
		v=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
                        if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }

    public HashMap getEditTicketInfo(String eventid,String priceid){
	Connection con=null;
        HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("event");
		pstmt=con.prepareStatement(TICKET_UPDATE_QUERY);
                pstmt.setString(1,eventid);
                pstmt.setString(2,priceid);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
				hm=new HashMap();
				hm.put("ticketname",rs.getString("ticket_name"));
				hm.put("description",rs.getString("description"));
				hm.put("ticketprice",rs.getString("ticket_price"));
				hm.put("process_fee",rs.getString("process_fee"));

				hm.put("minqty",rs.getString("min_qty"));
				hm.put("maxqty",rs.getString("max_qty"));
				hm.put("capacity",rs.getString("max_ticket"));
				hm.put("type",rs.getString("ticket_type"));
				hm.put("startYear",rs.getString("start_yy"));
				hm.put("startMonth",rs.getString("start_mm"));
				hm.put("startYear",rs.getString("start_yy"));

				hm.put("startDay",rs.getString("start_dd"));
				hm.put("endYear",rs.getString("end_yy"));
				hm.put("endMonth",rs.getString("end_mm"));
				hm.put("endDay",rs.getString("end_dd"));
				hm.put("starttime",(rs.getString("starttime")==null|| "".equals(rs.getString("starttime")) )?"01:00":rs.getString("starttime")   );
				hm.put("endtime",(rs.getString("endtime")==null|| "".equals(rs.getString("endtime")) )?"01:00":rs.getString("endtime")   );
  			}
		rs.close();
		pstmt.close();
		pstmt=null;

	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getEditTicketInfo()","There is an error in:",e);
		hm=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
                        if(con!=null) con.close();
		}catch(Exception e){}
	}
	return hm;
    }

     public int updateReqPrice(HashMap hm){
		 getTimezones(hm);
             return updatePrice(hm,UPDATE_EVENT_TICKET);}

     public int updateOptPrice(HashMap hm){
		  getTimezones(hm);
             return updatePrice(hm,UPDATE_EVENT_TICKET);}

     public int updateTicket(HashMap hm){
	    return updatePrice(hm,TICKET_UPDATE);
     }

     public int updatePrice(HashMap hm,String query){

	Connection con=null;
        int rcount=0;
        java.sql.PreparedStatement pstmt=null;
        try{
		con=EventbeeConnection.getWriteConnection("event");
  String startdate=(String)hm.get("startdate");
  String enddate=(String)hm.get("enddate");
        	pstmt=con.prepareStatement(query);
		pstmt.setString(1,(String)hm.get("ticketname"));
		pstmt.setString(2,(String)hm.get("description"));
		pstmt.setString(3,(String)hm.get("ticketprice"));
		pstmt.setString(4,(String)hm.get("capacity"));
		pstmt.setString(5,startdate);
		pstmt.setString(6,enddate);
		pstmt.setString(7,(String)hm.get("minqty"));
		pstmt.setString(8,(String)hm.get("maxqty"));

		pstmt.setString(9,(String)hm.get("starttime"));
		pstmt.setString(10,(String)hm.get("endtime"));
        pstmt.setString(11,(String)hm.get("process_fee"));

      	pstmt.setString(12,(String)hm.get("eventid"));
		pstmt.setString(13,(String)hm.get("priceid"));


		rcount=pstmt.executeUpdate();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.INFO,FILE_NAME, "updatePrice()", "DONE SUCCESSFULLY",null);
	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"updatePrice()","There is an error in:",e);
	}finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
   }

    public int addReqPrice(HashMap hm){
             return addPrice(hm,ADD_EVENT_TICKET);
    }



public void getTimezones(HashMap hm){

	String sd=(String)hm.get("startDay");

	String ed=(String)hm.get("endDay");
	String sm=(String)hm.get("startMonth");
	String em=(String)hm.get("endMonth");
	String eh=(String)hm.get("/endHour24");
	String sh=(String)hm.get("/startHour24");

	String ey=(String)hm.get("endYear");
	String sy=(String)hm.get("startYear");
	String emin=(String)hm.get("/endMinute");
	String smin=(String)hm.get("/startMinute");




	EditEventDB evtDB=new EditEventDB();
	HashMap evtinfo=evtDB.getEventInfo((String)hm.get("eventid"));
	String timezone1=DateTime.getTimeZoneVal((String)evtinfo.get("/timezone"));

   TimeZone T1=new SimpleTimeZone(TimeZone.getTimeZone(timezone1).getRawOffset(), timezone1);
  Calendar scalendar = Calendar.getInstance(T1);
  	scalendar.set(Integer.parseInt(sy),
  						Integer.parseInt(sm)-1,
  						Integer.parseInt(sd),
  						Integer.parseInt(sh),
  						Integer.parseInt(smin));

  	Calendar ecalendar = Calendar.getInstance(T1);
  	       ecalendar.set(Integer.parseInt(ey),
  						Integer.parseInt(em)-1,
  						Integer.parseInt(ed),
  						Integer.parseInt(eh),
  						Integer.parseInt(emin));





	String timezone2=EbeeConstantsF.get("Server.time.zone","SystemV/EST5");
	DateTime startdate=new DateTime();
	DateTime enddate=new DateTime();

	String[] starttimes= startdate.getTimeZoneForTickets(scalendar,timezone2);
	String[] endtimes= enddate.getTimeZoneForTickets(ecalendar,timezone2);
	hm.put("startdate",starttimes[0]);

	hm.put("starttime",starttimes[1]);
	hm.put("enddate",endtimes[0]);

   hm.put("endtime",endtimes[1]);



}

    public int addTicket(HashMap hm){

    getTimezones(hm);

EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,"EventTicketDB.java", "addTicket()--","hm isss---->:"+hm,null);

			return addPrice(hm,TICKET_INSERT);
    }

    public int addPrice(HashMap hm,String query){
	Connection con=null;
        int rcount=0;
        java.sql.PreparedStatement pstmt=null;
        try{
		con=EventbeeConnection.getWriteConnection("event");
  String startdate=(String)hm.get("startdate");
  String enddate=(String)hm.get("enddate") ;
		pstmt=con.prepareStatement(query);
		pstmt.setString(1,(String)hm.get("ticketname"));
		pstmt.setString(2,(String)hm.get("description"));
		pstmt.setString(3,(String)hm.get("ticketprice"));
		pstmt.setString(4,(String)hm.get("capacity"));
		pstmt.setString(5,startdate);
		pstmt.setString(6,enddate);
		pstmt.setString(7,(String)hm.get("categorytype")); //required,optional-ticket_category
		pstmt.setString(8,(String)hm.get("tickettype")); //Public,Member-ticket_type
		pstmt.setString(9,(String)hm.get("eventid"));
		pstmt.setString(10,(String)hm.get("minqty"));
		pstmt.setString(11,(String)hm.get("maxqty"));
		pstmt.setString(12,(String)hm.get("starttime"));
		pstmt.setString(13,(String)hm.get("endtime"));
		pstmt.setString(14,(String)hm.get("commission"));
		pstmt.setString(15,(String)hm.get("process_fee")); //
		pstmt.setString(16,(String)hm.get("capacity")); //
		pstmt.setString(17,(String)hm.get("ticket_typedon")); //

       		rcount=pstmt.executeUpdate();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
                EventbeeLogger.log("com.eventbee.main",EventbeeLogger.INFO,FILE_NAME, "addPrice()", "DONE SUCCESSFULLY",null);

	}catch(Exception e){
		       System.out.println("exception occured in adding ticket is"+e.getMessage());
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"addPrice()","There is an error in  addPrice() in:",e);
	}finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
    }

   public static HashMap getAllTickets(String groupid){

	 	HashMap tickets=new HashMap();

	 	java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		java.sql.ResultSet rs=null;

		String price=null,query=null;
		try{
			con=EventbeeConnection.getReadConnection("event");
			pstmt=con.prepareStatement(TICKET_QUERY);
			pstmt.setString(1,groupid);

			rs=pstmt.executeQuery();
			while(rs.next()){
				HashMap ticket=new HashMap();
				price=rs.getString("ticket_price");
				CurrencyFormat cf=new CurrencyFormat();
				price=cf.getCurrency2decimal(price);
				ticket.put("price",price);
				ticket.put("description",rs.getString("description"));
				tickets.put(rs.getString("ticket_name"),ticket);

			}

			if(tickets.size()==0){
				tickets=null;
			}
			rs.close();
			pstmt.close();
			pstmt=null;
			con.close();
		}catch(Exception e){
                        EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getAllTickets()","There is an EXCEPTION in:",e);
		}finally{
			try{
				if(pstmt!=null)
					pstmt.close();
				if(con!=null)
					con.close();
			}catch(Exception ex){}
		}
		return tickets;
	}
 public static Vector getAllTicketInfo(String groupid){
 return  getAllTicketInfo(groupid,TICKET_QUERY);
 }
 public static Vector getAllActiveTicketInfo(String groupid){
 return  getAllTicketInfo(groupid,ACTIVE_TICKET_QUERY);
 }
   public static Vector getAllTicketInfo(String groupid,String QUERY1){
	 	java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		java.sql.ResultSet rs=null;
		String price=null,query=null;
                HashMap ticket=null;
                Vector v=new Vector();
		try{
			con=EventbeeConnection.getReadConnection("event");
			pstmt=con.prepareStatement(QUERY1);
			pstmt.setString(1,groupid);
			rs=pstmt.executeQuery();
			while(rs.next()){
				ticket=new HashMap();
				price=rs.getString("ticket_price");
				CurrencyFormat cf=new CurrencyFormat();
				price=cf.getCurrency2decimal(price);
				ticket.put("price",price);
				ticket.put("price_id",rs.getString("price_id"));
				ticket.put("description",rs.getString("description"));
				ticket.put("ticketname",rs.getString("ticket_name"));
				ticket.put("start_date", rs.getString("start_date"));
				ticket.put("end_date", rs.getString("end_date"));
				ticket.put("tickettype",rs.getString("ticket_type"));
				v.addElement(ticket);
			}
			rs.close();
			pstmt.close();
			pstmt=null;
			con.close();
		}catch(Exception e){
                        EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getAllTicketInfo()","There is an EXCEPTION in:",e);
		}finally{
			try{
				if (pstmt!=null) pstmt.close();
				if (con!=null) 	 con.close();
			}catch(Exception ex){}
		}
		return v;
	}

	public static HashMap getAgentComm(String groupid){
			DBManager dbmanager=new DBManager();
			HashMap hm=new HashMap();
			String agentcommquery="select salecommission,saleslimit,commtype from group_agent_settings where groupid=? and purpose='event'";
			StatusObj statobj=dbmanager.executeSelectQuery(agentcommquery,new String[]{groupid});
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					for(int j=0;j<columnnames.length;j++){
							hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
				}
			}
			return hm;
	}
 }
