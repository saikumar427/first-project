package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONObject;

import com.eventbee.general.DBManager;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;

public class BRegistrationDBHelper{
	final String EVENT_REG_DETAILS="select * from event_reg_details_temp where tid=? and eventid=?";
	final String BUYER_DETAILS_QUERY="select * from buyer_base_info where transactionid=?";
	final String EVENT_REG_TICKET_DETAIL="select *,,(finalprice+finalfee)*qty as total from event_reg_ticket_details_temp where tid=?";
	final String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
	final String INSERT_MEMBER="insert into member_profile(member_id,m_lastname,created_at,m_email,m_firstname,manager_id,m_email_type) values(CAST(? AS INTEGER),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,CAST(? AS INTEGER),?)"	;
	//final String INSERT_MEMBER="insert into member_profile(member_id,m_lastname,created_at,m_email,m_firstname,manager_id,m_email_type) values(?,?,now(),?,?,?,?)"	;
	final String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at,created_by) values(CAST(? AS INTEGER),CAST(? AS INTEGER),'available',to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),'Auto Subscription')";
	//final String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at,created_by) values(?,?,'available',now(),'Auto Subscription')";
	final String PROFILE_INFO="select * from profile_base_info where transactionid =? and tickettype='attendeeType'";
	final String ATTENDEE_QUERY="select * from profile_base_info where transactionid=?";
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
	
	private String  confirmationtype=null;
	public BRegistrationDBHelper(String type){
		confirmationtype=type;
	}
	public BRegistrationDBHelper(){
		
	}
	public HashMap <String,String>getRegistrationData(String tid,String eid){
		DBManager dbmanager=new DBManager();
		HashMap <String,String>hmap=new HashMap<String,String>();
		StatusObj statobj=dbmanager.executeSelectQuery(EVENT_REG_DETAILS,new String[]{tid,eid});
		try{
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
				for(int j=0;j<columnnames.length;j++){
					hmap.put(columnnames[j],dbmanager.getValue(0,columnnames[j],""));
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getRegistrationData"+e.getMessage());
		}
		return hmap;
	}
	
	public HashMap getBuyerInfo(String tid,String eid){
		HashMap hm=new HashMap();
		try{
			DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery(BUYER_DETAILS_QUERY,new String[]{tid});
			if(sb.getStatus()){
				hm.put("firstName",db.getValue(0,"fname",""));
				hm.put("lastName",db.getValue(0,"lname",""));
				hm.put("email",db.getValue(0,"email",""));
				hm.put("phone",db.getValue(0,"phone",""));
				hm.put("profilekey",db.getValue(0,"profilekey",""));
			}
		}
		catch(Exception e){
			System.out.println("Exception in getting buyerInfo"+e.getMessage());
		}
		return hm;
	}

	public ArrayList getpurchasedTickets(String tid){
		HashMap<String,ArrayList<HashMap<String,String>>> attendeeDetails=getAttendeeDetails(tid);
		ArrayList ticketlist=new ArrayList();
		try{
			String attendeeQuery="select *,(finalprice+finalfee)*qty as total from event_reg_ticket_details_temp where tid=?";
			DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery(attendeeQuery,new String[]{tid});
			if(sb.getStatus()){
				for(int k=0;k<sb.getCount();k++){
					HashMap hm=new HashMap();
					hm.put("ticketId",db.getValue(k,"ticketid",""));
					hm.put("ticketName",db.getValue(k,"ticketname",""));
					hm.put("ticketPrice",db.getValue(k,"originalprice",""));
					hm.put("discount",db.getValue(k,"discount",""));
					hm.put("ticketQuantity",db.getValue(k,"qty",""));
					hm.put("processingFee",db.getValue(k,"finalfee",""));
					hm.put("totalAmount",db.getValue(k,"total",""));
					hm.put("ticketType",db.getValue(k,"tickettype",""));
					if(attendeeDetails.containsKey(db.getValue(k,"ticketid",""))){
						hm.put("profiles",attendeeDetails.get(db.getValue(k,"ticketid","")));
					}
					ticketlist.add(hm);
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getting getpurchasedTickets"+e.getMessage());
		}
		return ticketlist;
	}

	public void InserMailingList(String eventid,HashMap hmap){
		/*try{
	String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
	String listid=DbUtil.getVal("select value from config where name='event.maillist.id' and config_id=(select config_id from eventinfo where eventid=to_number(?,'9999999999999999999'))", new String []{eventid});
	//StatusObj status1=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {memberid,(String)hmap.get("lname"),(String)hmap.get("email"),(String)hmap.get("fname"),"0","html"});
	StatusObj status1=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {memberid,(String)hmap.get("lname"),DateUtil.getCurrDBFormatDate(),(String)hmap.get("email"),(String)hmap.get("fname"),"0","html"});
	//StatusObj status2=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
	StatusObj status2=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid,DateUtil.getCurrDBFormatDate()});
	}
	catch(Exception e){
	System.out.println("Exception occured in InserMailingList"+e.getMessage());
	}*/
}

	public ArrayList getProfileInfo(String tid,String eid){
		ArrayList attendeeList=new ArrayList();
		DBManager db=new DBManager();
		try{
			StatusObj sb=db.executeSelectQuery(PROFILE_INFO,new String []{tid});
			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					HashMap attendeeMap=new HashMap();
					attendeeMap.put("fname",db.getValue(i,"fname",""));
					attendeeMap.put("lname",db.getValue(i,"lname",""));
					attendeeMap.put("email",db.getValue(i,"email",""));
					attendeeMap.put("ticketid",db.getValue(i,"ticketid",""));
					attendeeMap.put("profilekey",db.getValue(i,"profilekey",""));
					attendeeMap.put("tickettype",db.getValue(i,"tickettype",""));
					attendeeMap.put("seatCodes", db.getValueFromRecord(i, "seatcode", ""));
					attendeeList.add(attendeeMap);
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception occured in getProfileInfo"+e.getMessage());
		}
		return attendeeList;
	}

	public HashMap<String,ArrayList<HashMap<String,String>>> getAttendeeDetails(String tid){
		HashMap<String,ArrayList<HashMap<String,String>>> hm=new HashMap<String,ArrayList<HashMap<String,String>>>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(ATTENDEE_QUERY,new String[]{tid});
		if(sb.getStatus()){
			ArrayList<HashMap<String,String>> attndeeList=null;
			for(int k=0;k<sb.getCount();k++){
				HashMap<String,String> hmap=new HashMap<String,String>();
				hmap.put("profilekey",db.getValue(k,"profilekey",""));
				hmap.put("fname",db.getValue(k,"fname",""));
				hmap.put("lname",db.getValue(k,"lname",""));
				hmap.put("seatCodes",db.getValue(k,"seatcode",""));
				String name=db.getValue(k,"fname","")+" "+db.getValue(k,"lname","");
				hmap.put("name",name);
				if(hm.containsKey(db.getValue(k,"ticketid",""))){
					attndeeList=hm.get(db.getValue(k,"ticketid",""));
					attndeeList.add(hmap);
				}
				else{
					attndeeList=new ArrayList<HashMap<String,String>>();
					attndeeList.add(hmap);
				}
				hm.put(db.getValue(k,"ticketid",""),attndeeList);
			}
		}
		return hm;
	}

	String  getExternalPayId(HashMap eventRegData){
		String extpayid="";
		String paytype=(String)eventRegData.get("selectedpaytype");
		String tid=(String)eventRegData.get("tid");
		if("eventbee".equals(paytype) || "authorize.net".equals(paytype) || "braintree".equals(paytype) || "stripe".equals(paytype))
			extpayid=DbUtil.getVal("select response_id  from cardtransaction where internal_ref=? and proces_status=?",new String[]{tid,"Success"});
		else if("paypal".equals(paytype))
			extpayid=DbUtil.getVal("select paypal_tran_id   from paypal_payment_backup_data where ebee_tran_id=?",new String[]{tid});
		else if("google".equals(paytype))
			extpayid=DbUtil.getVal("select google_order_no   from google_payment_data where ebee_tran_id=?",new String[]{tid});
		else
			extpayid="";
		return extpayid;
	}
	
	public ArrayList getConfirmationTicketDetails(String tid,String eid, String eventdate){
		ArrayList al=new ArrayList();
		String ordernumber="";
		String extpayid="";
		HashMap<String,String> isscanbars=getEnableScanbars(eid);
		HashMap regDetails=getTransactionDetails(tid);
		if(regDetails!=null&&regDetails.size()>0){
			ordernumber=(String)regDetails.get("ordernumber");
			extpayid=(String)regDetails.get("extpayid");
		}	
		HashMap attendeemap=null;
		JSONObject jobj=null;
		String objstring=null;
		HashMap customquestions=new HashMap();
		HashMap buyercustomquestions=new HashMap();
		String showcustomquestions=null;
		if("confirmation_email".equals(confirmationtype))
			showcustomquestions=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name='event.confirmationemail.questions.show'", new String[]{eid});
		else 
			showcustomquestions=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) and name='event.confirmationpage.questions.show'", new String[]{eid});
		if("Y".equals(showcustomquestions)){
			customquestions=getCustomQuestions(eid,tid,"attendee");
		    buyercustomquestions=getCustomQuestions(eid,tid,"buyer");
		}
		
		HashMap buyerprofiles=getBuyerInfo(tid,eid);
		HashMap<String, String> buyerquestionMap=new HashMap<String, String>();
		for(int i=0;i<buyerprofiles.size();i++){
		 if("Y".equals(showcustomquestions)){
				String pkey=(String)buyerprofiles.get("profilekey");
				String buyercustquestion=getCustQuestionsResponse(pkey, buyercustomquestions);
				if(!"".equals(buyercustquestion))buyerquestionMap.put("buyercustomQuestion", buyercustquestion);
			}
	    }
		
		ArrayList purchasedTickets=getpurchasedTickets(tid);
		if(purchasedTickets!=null){
			HashMap qr_barcodemsg=getQrCodeBarCode(eid);
			try{
				for(int i=0;i<purchasedTickets.size();i++){
					HashMap hm=(HashMap)purchasedTickets.get(i);
					String qty=(String)hm.get("ticketQuantity");
					String tkttype=(String)hm.get("ticketType");
					String total=(String)hm.get("totalAmount");
					String enable=GenUtil.getHMvalue(isscanbars,hm.get("ticketId")+"", "Yes");
					ArrayList profile=(ArrayList)hm.get("profiles");
					String tickid=(String) hm.get("ticketId");
					//if("attendeeType".equals(tkttype))
					{
						for(int p=0;p<profile.size();p++){
							jobj=new JSONObject();
							jobj.put("eid",eid);
							jobj.put("xid",tid);
							jobj.put("on",ordernumber);
							jobj.put("tn",(String)hm.get("ticketName"));
							jobj.put("tId",(String)hm.get("ticketId"));
							attendeemap=(HashMap)profile.get(p);
							jobj.put("pkey",(String)attendeemap.get("profilekey"));
							jobj.put("fn",(String)attendeemap.get("fname"));
							jobj.put("ln",(String)attendeemap.get("lname"));
							objstring=jobj.toString();
							HashMap gm=new HashMap();
							gm.putAll(hm);
							gm.put("ticketQuantity","1");
							if("Y".equals(showcustomquestions)){
								String pkey=(String)attendeemap.get("profilekey");
								String custquestion=getCustQuestionsResponse(pkey, customquestions);
								if(!"".equals("custquestion"))gm.put("customQuestion", custquestion);
							}
							double tot=0.00;
							try{
								tot=Double.parseDouble(total)/Integer.parseInt(qty);
							}
							catch(Exception e){
								tot=0.00;
							}
							String seatcode=(String)attendeemap.get("seatCodes");
							if(!"".equals(seatcode))
								gm.put("seatCodes",seatcode);
							gm.put("totalAmount",CurrencyFormat.getCurrencyFormat("",tot+"",true));
							gm.put("attendeeName",(String)attendeemap.get("name"));
							String qrcode="",vbarcode="",hbarcode="";
							qrcode=(String)qr_barcodemsg.get("qrcode");
							vbarcode=(String)qr_barcodemsg.get("vbarcode");
							hbarcode=(String)qr_barcodemsg.get("hbarcode");
							try{
								String qr[]=qrcode.split("#msg");
								qrcode=qr[0]+java.net.URLEncoder.encode(objstring)+qr[1];
								String vbar[]=vbarcode.split("#msg");
								vbarcode=vbar[0]+jobj.get("pkey")+vbar[1];
								String hbar[]=hbarcode.split("#msg");
								hbarcode=hbar[0]+jobj.get("pkey")+hbar[1];
								String vserver[]=vbarcode.split("#serveraddress");
								vbarcode=vserver[0]+serveraddress+vserver[1];
								String hserver[]=hbarcode.split("#serveraddress");
								hbarcode=hserver[0]+serveraddress+hserver[1];
							}catch(Exception e){System.out.println("exception in try:"+e.getMessage());}
							gm.put("qrcode", "");
							if("Yes".equals(enable))
							{gm.put("qrcode", qrcode);	
							 gm.put("barcode", hbarcode);
							 gm.put("vBarcode", vbarcode);
							}
							//gm.put("qrcode","<img src='http://chart.apis.google.com/chart?chld=L|0&cht=qr&chs=117x117&chl="+java.net.URLEncoder.encode(objstring)+"'/>");
							//gm.put("barcode","<img width='200px' src='"+serveraddress+"/genbc?type=code128&msg="+jobj.get("pkey")+"&height=0.75cm&hrsize=6pt&hrp=bottom&fmt=gif'>");
							//gm.put("vBarcode","<img width='200px' style='-webkit-transform: rotate(-270deg);-moz-transform: rotate(-270deg);filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);' src='"+serveraddress+"/genbc?type=code128&msg="+jobj.get("pkey")+"&height=0.75cm&hrsize=6pt&hrp=bottom&fmt=gif'>");
							al.add(gm);
						}
					}
				/*	else{
						String ticketid=(String) hm.get("ticketId");
						ArrayList seatcode=new ArrayList();
						for(int p=0;p<profile.size();p++){
							attendeemap=(HashMap)profile.get(p);
							if("Y".equals(showcustomquestions)){
								String pkey=(String)attendeemap.get("profilekey");
								String custquestion=getCustQuestionsResponse(pkey, customquestions);
								if(!"".equals("custquestion"))hm.put("customQuestion", custquestion);
							}
							if(!"".equals((String)attendeemap.get("seatCodes"))){
								seatcode.add(attendeemap.get("seatCodes"));			
							}
						}
						if(!seatcode.isEmpty()||seatcode.size()>0)
							hm.put("seatCodes",seatcode);
						al.add(hm);
				}*/
			}
		}
		catch(Exception e){
			System.out.println("Exception occured is"+e.getMessage());
		}
	}
		al.add(buyerquestionMap);
		return al;
	}
	public HashMap<String,String> getEnableScanbars(String eid){
		
		 HashMap<String,String> result=new  HashMap<String,String>();
		 String query="select price_id,scan_code_required,isdonation from  price where evt_id=CAST(? AS BIGINT) ";
		 DBManager db=new DBManager();
		 StatusObj stb=db.executeSelectQuery(query,new String[]{eid} );
		 if(stb.getStatus())
		 { for(int i=0;i<stb.getCount();i++)
		   result.put(db.getValue(i, "price_id", ""),"Yes".equals(db.getValue(i, "isdonation", "No"))?db.getValue(i, "scan_code_required", "No"):db.getValue(i, "scan_code_required", "Yes"));
		 }	
		 
		 //System.out.println("scabars ::"+result);
	   return result;
		
	}
	
	public HashMap getCustomQuestions(String eid, String tid){
		HashMap hm=new HashMap();
		hm=getCustomQuestions(eid,tid,"attendee");
		return hm;
	}

	public HashMap getCustomQuestions(String eid, String tid,String contexttype) {
	HashMap hm=new HashMap();
	HashMap<String,String> attribnamesMap=getAtrribNames(eid,"EVENT",contexttype);
	String type=confirmationtype;
	type=(type==null || "".equals(type))?"confirmation_page":type;
	String query="";	
	try{
		if("attendee".equals(contexttype)){
			query="select attrib_id,bigresponse  as response, c.profilekey "
					+"from  custom_questions_response a, custom_questions_response_master b,profile_base_info c,confirmationscreen_questions d "
					+"where a.ref_id=b.ref_id "
					+"and c.profilekey=b.profilekey "
					+"and c.eventid=CAST(? AS BIGINT) "
					+"and d.eventid=cast(c.eventid as varchar) "
					+"and c.transactionid=? "
					+"and a.attribid=d.attrib_id and d.type=?"
					+"order by d.position";
		}else{
			query="select attrib_id,bigresponse  as response, c.profilekey "
				+"from  custom_questions_response a, custom_questions_response_master b,buyer_base_info c,confirmationscreen_questions d "
				+"where a.ref_id=b.ref_id "
				+"and c.profilekey=b.profilekey "
				+"and c.eventid=CAST(? AS BIGINT) "
				+"and d.eventid=cast(c.eventid as varchar) "
				+"and c.transactionid=? "
				+"and a.attribid=d.attrib_id and d.type=?"
				+"order by d.position";	
		}	
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String[]{eid,tid,type});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				String pkey=db.getValue(i, "profilekey", "");
				String attid=db.getValue(i, "attrib_id", "");
				String attname=attribnamesMap.get(attid);
				if(hm.containsKey(pkey)){
					ArrayList<BEntity> temp=(ArrayList)hm.get(pkey);
					temp.add(new BEntity(attname,db.getValue(i, "response", "")));
					hm.put(pkey, temp);
				}
				else{
					ArrayList<BEntity> temp=new ArrayList<BEntity>();
					temp.add(new BEntity(attname,db.getValue(i, "response", "")));
					hm.put(pkey, temp);
				}
			}
		}
/*		boolean hasBasicAttribs=false;
		DBManager db1=new DBManager();
		StatusObj sb1=db1.executeSelectQuery("select attrib_name,attrib_id from confirmationscreen_questions where eventid=? and attrib_id in (-1,-2)", new String[]{eid});
		HashMap<String, String> basicAttribs=new HashMap<String, String>();
		if(sb1.getStatus() && sb.getCount()>0){
			hasBasicAttribs=true;
			for(int i=0;i<sb1.getCount();i++){
				basicAttribs.put(db1.getValue(i, "attrib_name", "").toLowerCase(), db1.getValue(i, "attrib_id", ""));
			}
		}
*/		HashMap<String,HashMap<String,String>> basicResponses=null;
        if(attribnamesMap.containsKey("-1") || attribnamesMap.containsKey("-2") || attribnamesMap.containsKey("-3")){
	     basicResponses=getBasicResponses(eid, tid,contexttype);
	     if(basicResponses!=null){
		Iterator it = basicResponses.entrySet().iterator();
	    while (it.hasNext()) {
	        Map.Entry pairs = (Map.Entry)it.next();
	        String key=(String)pairs.getKey();
			ArrayList<BEntity> ent=(ArrayList<BEntity>)hm.get(key);
			if(ent==null) ent=new ArrayList<BEntity>();
			if(!"".equals(basicResponses.get(key).get("phone")) && attribnamesMap.get("-2")!=null)
			{
				ent.add(0, new BEntity("Phone",basicResponses.get(key).get("phone")));
			}
			if(!"".equals(basicResponses.get(key).get("email")) && attribnamesMap.get("-1")!=null)
			{
				ent.add(0, new BEntity("Email",basicResponses.get(key).get("email")));
			}
			if(!"".equals(basicResponses.get(key).get("phone")) && attribnamesMap.get("-3")!=null)
			{
				ent.add(0, new BEntity("Phone",basicResponses.get(key).get("phone")));
			}
			hm.put(key, ent);
		}
	    }
		}
	}
	catch(Exception e){
		System.out.println("Exception occured in getting custom questions:"+e.getMessage());
	}
	return hm;
}
	
	public static HashMap<String,HashMap<String,String>> getBasicResponses(String eid,String tid){
		HashMap<String,HashMap<String,String>> hmap=new HashMap<String,HashMap<String,String>>();
		hmap=getBasicResponses(eid,tid,"attendee");
		return hmap;
	}
	
	public static HashMap<String,HashMap<String,String>> getBasicResponses(String eid,String tid,String contexttype){
	HashMap<String,HashMap<String,String>> basicResponse=new HashMap<String,HashMap<String,String>>();
	String query="";
	if("attendee".equals(contexttype))
	   query="select profilekey,email,phone,b.attribid from profile_base_info a,base_profile_questions b where transactionid=? and a.eventid=b.groupid and a.ticketid=b.contextid and  b.attribid in ('email','phone') and eventid =?::bigint";
	else
		query="select profilekey,email,phone,b.attribid from buyer_base_info a,base_profile_questions b where transactionid=? and a.eventid=b.groupid and b.contextid=0 and  b.attribid='phone' and eventid =?::bigint";	
	
	StatusObj statobj=null;
	DBManager dbmanager=new DBManager();
	statobj=dbmanager.executeSelectQuery(query,new String []{tid,eid});
	if(statobj.getStatus() && statobj.getCount()>0){
	for(int k=0;k<statobj.getCount();k++){
		HashMap<String,String> hm=new HashMap<String,String>();
		String basicattrib=dbmanager.getValue(k,"attribid","");
		if(basicResponse.get(dbmanager.getValue(k,"profilekey",""))!=null)
			hm=basicResponse.get(dbmanager.getValue(k,"profilekey",""));
		if("email".equals(basicattrib))
		hm.put("email",dbmanager.getValue(k,"email",""));
		if("phone".equals(basicattrib))
		hm.put("phone",dbmanager.getValue(k,"phone",""));
		basicResponse.put(dbmanager.getValue(k,"profilekey",""),hm);
	}
	}
	return basicResponse;
}

	
	public HashMap<String,String> getAtrribNames(String eid,String purpose){
		HashMap<String,String> hmap=new HashMap();
		hmap=getAtrribNames(eid,purpose,"attendee");
		return hmap;
	}
	
	public HashMap<String,String> getAtrribNames(String eid,String purpose,String contexttype){
    HashMap<String,String> attribsMap=new HashMap();
    String query="";
    String type=confirmationtype;
	type=(type==null || "".equals(type))?"confirmation_page":type;
	if("attendee".equals(contexttype)){
		query="select attrib_id,attribname from custom_attrib_master a,custom_attribs b"+
	         " where a.groupid=CAST(? AS BIGINT) and a.attrib_setid=b.attrib_setid and a.purpose=?"+
	          " union select attrib_id,attrib_name as attribname from confirmationscreen_questions where eventid=? and attrib_id in (-1,-2) and type=?";
		}else{
			query="select attrib_id,attribname from custom_attrib_master a,custom_attribs b"+
	        " where a.groupid=CAST(? AS BIGINT) and a.attrib_setid=b.attrib_setid and a.purpose=?"+
	         " union select attrib_id,attrib_name as attribname from confirmationscreen_questions where eventid=? and attrib_id=-3  and type=?";
		}	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{eid,purpose,eid,type});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			attribsMap.put(db.getValue(i, "attrib_id",""), db.getValue(i, "attribname",""));
		}
	}
	return attribsMap;
}
public HashMap getQrCodeBarCode(String eid) {
	HashMap codemap=new HashMap();

	String code_query="select * from barcode_qrcode_settings where eventid=?";
	DBManager db=new DBManager();
	StatusObj code_sb=db.executeSelectQuery(code_query, new String[]{eid});
	if(code_sb.getStatus()){
		codemap.put("qrcode",db.getValue(0, "qrcode", ""));
		codemap.put("hbarcode",db.getValue(0, "hbarcode", ""));
		codemap.put("vbarcode",db.getValue(0, "vbarcode", ""));
		
	}
	else{
		code_sb=db.executeSelectQuery(code_query, new String[]{"0"});
		codemap.put("qrcode",db.getValue(0, "qrcode", ""));
		codemap.put("hbarcode",db.getValue(0, "hbarcode", ""));
		codemap.put("vbarcode",db.getValue(0, "vbarcode", ""));
		
	}
	return codemap;
}
public HashMap getTransactionDetails(String tid){
HashMap transactionMap=new HashMap();
try{
String  TRANSACTION_DETAILS="select current_discount,current_amount,original_tax,ordernumber,eventdate,paymenttype,ext_pay_id,bookingdomain  from event_reg_transactions where tid=?";
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(TRANSACTION_DETAILS,new String []{tid});
if(sb.getStatus()){
transactionMap.put("grandtotal",db.getValue(0,"current_amount",""));
transactionMap.put("tax",db.getValue(0,"original_tax",""));
transactionMap.put("ordernumber",db.getValue(0,"ordernumber",""));
transactionMap.put("eventdate",db.getValue(0,"eventdate"," "));
transactionMap.put("discount",db.getValue(0,"current_discount"," "));
transactionMap.put("paymenttype",db.getValue(0,"paymenttype"," "));
transactionMap.put("extpayid",db.getValue(0,"ext_pay_id"," "));
transactionMap.put("bookingdomain",db.getValue(0,"bookingdomain"," "));
}
}
catch(Exception e){
System.out.println("Exception in getTransactionDetails"+e.getMessage());
}
return transactionMap;
}


public String getUniqueOrderNumber(String eid,String ordernumber,String tid,String date){

String query="select count(*) from event_reg_transactions where eventid=? and ordernumber=? and transaction_date=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')";
//String ORDER_SEQ_INSERT="insert into transaction_sequence (groupid,sequence,grouptype) values(?,to_number(?,'9999999999999999'),'EVENT')";
String ORDER_SEQ_UPDATE="update transaction_sequence set sequence=CAST(? AS INTEGER) where groupid=?";
date=DbUtil.getVal("select transaction_date from event_reg_transactions where tid=?",new String[]{tid});
String count=DbUtil.getVal(query,new String[]{eid,ordernumber,date});

try{
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationConfirmation.jsp", "checking the count for the order number ---->+count+", ""+ordernumber, null);

if(Integer.parseInt(count)>1){
String eventmaxorder=DbUtil.getVal("select sequence+1 from transaction_sequence where groupid=? and grouptype=?",new String[]{eid,"EVENT"});
String paddedorderseq=null;

//StatusObj statobj=
DbUtil.executeUpdateQuery(ORDER_SEQ_UPDATE,new String[]{eventmaxorder,eid});

paddedorderseq=GenUtil.getLeftZeroPadded(eventmaxorder,8,"0");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationConfirmation.jsp", "order seq   insertion into transaction_sequence for the transactionid---->", ""+paddedorderseq, null);

ordernumber=paddedorderseq;
DbUtil.executeUpdateQuery("update event_reg_transactions set ordernumber=? where tid=?",new String[]{ordernumber,tid});
}



}
catch(Exception e){
System.out.println(""+e.getMessage());
}
return ordernumber;
}
public void insertSeatBookingStatus(HashMap seatinghm) {
	try{

	String seatbookingquery="insert into seat_booking_status (eventid,venue_id,section_id,seatindex,eventdate,bookingtime,ticketid,profilekey,tid) values"+
	"(CAST(? AS BIGINT),CAST(? AS INTEGER),CAST(? AS INTEGER),?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),CAST(? AS INTEGER),?,?)";
	StatusObj seatsb=DbUtil.executeUpdateQuery(seatbookingquery,new String[]{(String)seatinghm.get("eventid"),(String)seatinghm.get("venue_id"),(String)seatinghm.get("section_id"),(String)seatinghm.get("seatindex"),(String)seatinghm.get("eventdate"),DateUtil.getCurrDBFormatDate(),(String)seatinghm.get("ticketid"),(String)seatinghm.get("profilekey"),(String)seatinghm.get("tid")});
	/*
	 String seatbookingquery="insert into seat_booking_status (eventid,venue_id,section_id,seatindex,eventdate,bookingtime,ticketid,profilekey,tid) values"+
	"(?,to_number(?,'999999999'),to_number(?,'999999999'),?,?,now(),to_number(?,'999999999'),?,?)";
	StatusObj seatsb=DbUtil.executeUpdateQuery(seatbookingquery,new String[]{(String)seatinghm.get("eventid"),(String)seatinghm.get("venue_id"),(String)seatinghm.get("section_id"),(String)seatinghm.get("seatindex"),(String)seatinghm.get("eventdate"),(String)seatinghm.get("ticketid"),(String)seatinghm.get("profilekey"),(String)seatinghm.get("tid")});
	 * */
	if(!seatsb.getStatus()){
		System.out.println("Exception occured in insertseatbookingstatus: "+seatsb.getErrorMsg());
	}
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ProfileActionDB.java", "Status Of the inserting updateBaseProfile into seating booking status for the transactionid---->"+seatinghm.get("tid"), ""+seatsb.getStatus(), null );
	}catch(Exception e){
		System.out.println("exception in insertseatbookingstatus:"+e.getMessage());
	
	}
}
public ArrayList getallProfileInfo(String tid, String eid) {
	ArrayList attendeeList=new ArrayList();
	String PROFILE_INFO_query="select * from profile_base_info where transactionid =? and eventid=CAST(? AS BIGINT)";
	DBManager db=new DBManager();
	try{
	StatusObj sb=db.executeSelectQuery(PROFILE_INFO_query,new String []{tid,eid});
	if(sb.getStatus()){
	for(int i=0;i<sb.getCount();i++){
	HashMap attendeeMap=new HashMap();
	attendeeMap.put("fname",db.getValue(i,"fname",""));
	attendeeMap.put("lname",db.getValue(i,"lname",""));
	attendeeMap.put("email",db.getValue(i,"email",""));
	attendeeMap.put("ticketid",db.getValue(i,"ticketid",""));
	attendeeMap.put("profilekey",db.getValue(i,"profilekey",""));
	attendeeMap.put("tickettype",db.getValue(i,"tickettype",""));
	attendeeMap.put("seatCodes", db.getValue(i, "seatcode", ""));
	attendeeMap.put("seatIndex", db.getValue(i, "seatindex", ""));
	attendeeList.add(attendeeMap);
	}
	}
	}
	catch(Exception e){
	System.out.println("Exception occured in getProfileInfo"+e.getMessage());
	}
	return attendeeList;
}


public String getCustQuestionsResponse(String pkey,HashMap customquestions){
		String allcustquestions="";
	try{
		if(customquestions.containsKey(pkey)){
			allcustquestions="<table cellpadding='0px' cellspacing='0px'>";
			ArrayList<BEntity> custquestion=(ArrayList)customquestions.get(pkey);
			for(int a=0;a<custquestion.size();a++){
				BEntity en=custquestion.get(a);
				
				if(!"".equals(en.getValue()) && en.getValue()!="" && en.getValue()!=null)
					allcustquestions=allcustquestions+"<tr><td><b>"+en.getKey()+":</b>&nbsp;"+en.getValue()+"</td></tr>";
			}
			allcustquestions=allcustquestions+"</table>";
			
		}
	}catch(Exception e){System.out.println("Exception in customquests generation is"+e.getMessage());}
	return allcustquestions;
	
}
public String getVenueID(String eid) {
	String venueid="";
	venueid=DbUtil.getVal("select value from config where name='event.seating.venueid' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT)) ", new String[]{eid});
	return venueid;
}

public String ValidateNTSCode(String groupid,String referral_ntscode){
	String nts_code="";
	nts_code=DbUtil.getVal("select nts_code from event_nts_partner where eventid=? and nts_code in (select nts_code from ebee_nts_partner where nts_code=? or nts_code_display=?)",new String[]{groupid,referral_ntscode,referral_ntscode});
	if(!"".equals(nts_code)||nts_code!=null){
		StatusObj updateStatusObj=DbUtil.executeUpdateQuery("update nts_visit_track set visit_count=visit_count+1, last_visited_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where eventid=? and nts_code=?",new String[]{DateUtil.getCurrDBFormatDate(),groupid,nts_code});
		if(updateStatusObj.getCount()==0){
			DbUtil.executeUpdateQuery("insert into nts_visit_track (nts_code,eventid,last_visited_at,visit_count,ticket_sale_count) values (?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),1,0)",new String[]{nts_code,groupid,DateUtil.getCurrDBFormatDate()});
		}		
	}
	return nts_code;
}
public String getTransactionSeatcodes(String tid){
	String query="select seatcode from profile_base_info where transactionid=? and seatcode is not null and seatcode!=''";
	String seatcodes="";
	DBManager db=new DBManager();
	StatusObj sob=db.executeSelectQuery(query, new String[]{tid});
	if(sob.getStatus() && sob.getCount()>0){
		for(int i=0;i<sob.getCount();i++){
			if(i==0) seatcodes+=db.getValue(i, "seatcode","");
			else seatcodes+=", "+db.getValue(i, "seatcode",""); 
		}
	}else seatcodes=null;
	return seatcodes;
}
public HashMap getebeeNTSCommission(String referral_ntscode, String eventid) {
	String ebeentscommission="0.00";
	String ebeecommissiontype="default";
	String query="select commission from ebee_nts_commission where nts_code=? and eventid=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{referral_ntscode,eventid});
	if(sb.getStatus()){
		ebeentscommission=db.getValue(0, "commission", "0.00");
		ebeecommissiontype="event partner";
	}else{
		query="select commission from ebee_nts_commission where eventid=?";
		sb=db.executeSelectQuery(query, new String[]{eventid});
		if(sb.getStatus()){
			ebeentscommission=db.getValue(0, "commission", "0.00");
			ebeecommissiontype="event";
		}
		else{
			query="select commission from ebee_nts_commission where nts_code=? and eventid='0'";
			sb=db.executeSelectQuery(query, new String[]{referral_ntscode});
			if(sb.getStatus()){
				ebeentscommission=db.getValue(0, "commission", "0.00");
				ebeecommissiontype="partner";
			}
			else{
				query="select commission from ebee_nts_commission where nts_code='0' and eventid='0'";
				sb=db.executeSelectQuery(query, null);
				if(sb.getStatus()){
					ebeentscommission=db.getValue(0, "commission", "0.00");
					ebeecommissiontype="default";
				}
			}
		}
	}
	HashMap hm =new HashMap();
	hm.put("ebeentscommission", ebeentscommission);
	hm.put("ebeecommissiontype", ebeecommissiontype);
	return hm;
	//return ebeentscommission;
}
public String getcurrencyconversion(String eid) {
	String currencyconverter="1";
	currencyconverter=DbUtil.getVal("select conversion_factor from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eid});
	if(currencyconverter==null)
		currencyconverter="1";

	return currencyconverter;
}
public JSONObject getCreditDetails(HashMap ntsdata){
	JSONObject jobj=new JSONObject();
	String used="",reserved="",cleared="";
	String query="select reserved_credits,cleared_credits,used_credits from ebee_nts_partner where nts_code=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{(String)ntsdata.get("ntscode")});
	if(sb.getStatus()){
		used=db.getValue(0,"used_credits","");
		reserved=db.getValue(0,"reserved_credits","");
		cleared=db.getValue(0,"cleared_credits","");
	}
	if("".equals(used))
		used="0";
	if("".equals(cleared))
			cleared="0";
	if("".equals(reserved)){
		String reservedcreditsquery="select value from config where config_id=0 and name='ebee_nts_reserved_credits'";
		reserved=DbUtil.getVal(reservedcreditsquery,null);
	}
		try{
	jobj.put("usedcredits",used);
	}catch(Exception e){}
	try{
	jobj.put("availablecredits",cleared);
	}catch(Exception e){}
	try{
	jobj.put("reservedcredits",reserved);
	}catch(Exception e){}	
	return jobj;

	}
}