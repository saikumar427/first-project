<%@ page import="java.util.*,com.customattributes.*,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>

<%!
public class TicketingManager{

	String GET_ATTRIBUTE_OPTIONS_QUERY="select attrib_id,attrib_setid,option_val  "
	         	           +" from custom_attrib_options  where attrib_id =?  and attrib_setid =?"
			           +" order by attrib_id,option ";
	String GET_GROUPS_OF_TICKET_TYPE_QUERY="select groupname ,ticket_groupid,description from event_ticket_groups where eventid=? and tickettype=? order by position ";
	String GET_GROUP_TICKETS_QUERY= " select p.price_id,gt.ticket_groupid,ticket_name,description,ticket_price,process_fee,ticket_type ,max_ticket,sold_qty,min_qty,max_qty,isdonation"
					+"  from price p,group_tickets gt "
					+" where to_number(gt.price_id,'9999999999999')=p.price_id  and gt.ticket_groupid=? and max_ticket>sold_qty  "
					+" and now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) "
				+" order by gt.position ";
	String GET_REQ_TICKETS_COUNT= " select count(*)  as reqcount from price where evt_id=? and ticket_type='Public'";
	String GET_MEMBER_TICKETS_QUERY= "select * from event_communities where eventid=?";
	String GET_TRANSACTION_ID_QUERY = "select nextval('seq_transactionid') as transactionid";
	String GET_PAYMENT_TYPES_QUERY="select distinct paytype,attrib_1 from payment_types where refid=? and status=? and purpose=?";
	String GET_DISCOUNT_TYPES_QUERY="select distinct coupontype from coupon_master where groupid =?";
	
	private int selectedTicketsQty=0;
        private String transactionid="";
        int totalAvailableTickets=0;
        private String eventid="";
        private HashMap memticketsHash=null;
        private boolean isMemberLoggedIn=false;
        private String collectAllProfiles="Y";
        public String selectedPaytype=null;
        public String appliedDiscountcode=null;
        public Vector selectedProfileInfo=null;
        public boolean memberTicketsExists=false;
        public boolean isUnavailableReqTicketsExists=false;
        public boolean isTransactionComplete=false;
        public ArrayList reqticketgroupsArray=null;
        public ArrayList optticketgroupsArray=null;        
        public HashMap customattribOptions=null;
        public Vector customattribs=null;
        public Vector paytypes=null;
        public List discountsMap=null;
        public HashMap selectedTicketsHash=null;
        
        
        String createNewTransaction(String eventid,HashMap contextMap){
        transactionid=getTransactionId();
        StatusObj sb=DbUtil.executeUpdateQuery("insert into event_reg_details(tid,useragent,eventid,transactiondate) values(?,?,?,now())",new String[]{transactionid,(String)contextMap.get("useragent"),eventid});
	String domain=(String)contextMap.get("domain");
	String oid=(String)contextMap.get("oid");
	if(domain!=null&&oid!=null)
	DbUtil.executeUpdateQuery("update event_reg_details set source=?,attrib1=?,attrib2=? where tid=?",new String[]{"ning",oid,domain,transactionid});
	return transactionid;
        }
        public StatusObj initialize(String eventid,String tid){
        	StatusObj sbObj=new StatusObj(true,"",null);
                this.eventid=eventid;
                transactionid=tid;
                getTransactionDetails(tid);
                if(isTransactionComplete){
			return sbObj;
		}
		memticketsHash=getMemberTickets(eventid);
		selectedTicketsHash=getSelectedTickets(tid);
		reqticketgroupsArray=getGroupsOfTicketType(eventid,"Public");
		
		isUnavailableReqTicketsExists=checkForReqTicketsUnavailability(eventid);
		if(isUnavailableReqTicketsExists){
			return sbObj;
		}
		
		optticketgroupsArray=getGroupsOfTicketType(eventid,"Optional");
		getCustomAttributes(eventid);
		paytypes=getAllPaymentTypes(eventid,"Event");
		discountsMap=getDiscountsMap(eventid);
		selectedProfileInfo=getProfileResponses(tid);
		getProfileOptions(eventid);
		
		return sbObj;
  	}
  	
  	boolean checkForReqTicketsUnavailability(String eventid){
  		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(GET_REQ_TICKETS_COUNT,new String[]{eventid});
		String reqticketscount="0";
		if(sb.getStatus() && sb.getCount()>0){
		reqticketscount=db.getValue(0,"reqcount","0");
		}
		if((!"0".equals(reqticketscount)) && totalAvailableTickets==0){
		return true;
		}else{
		return false;
		}
  	}
  	
  	void getCustomAttributes(String eventid){
		CustomAttributes [] customattribsTemp=CustomAttributesDB.getCustomAttributes(eventid,"EVENT");
		customattribs=new Vector();
		customattribOptions=new HashMap();
                for(int k=0;k<customattribsTemp.length;k++){
                	CustomAttributes attrib=customattribsTemp[k];
                	String [] custom_attrib_options=getOptionsOfCustomAttrib(attrib.getAttribId(),attrib.getAttribSetId());
                	customattribOptions.put(attrib.getAttribId(), custom_attrib_options);
			customattribs.add(customattribsTemp[k]);
		}
	}
  	
	ArrayList getGroupsOfTicketType(String eventid,String tickettype ){
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(GET_GROUPS_OF_TICKET_TYPE_QUERY,new String[]{eventid,tickettype});
		ArrayList al=new ArrayList();
		if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
		HashMap hm=new HashMap();
		hm.put("groupname",db.getValue(i,"groupname",""));
		hm.put("ticket_groupid",db.getValue(i,"ticket_groupid",""));
		hm.put("group_desc",db.getValue(i,"description",""));
		
		hm.put("Tickets",getGroupTickets(db.getValue(i,"ticket_groupid","")));
		al.add(hm);
		}
		}
		return al;
	}

	Vector getGroupTickets(String ticket_groupid){
		HashMap ticketMap=new HashMap();
		DBManager db=new DBManager();
		Vector vec=new Vector();
		StatusObj sb=db.executeSelectQuery(GET_GROUP_TICKETS_QUERY,new String[]{ticket_groupid});
		if(sb.getStatus()){
		for(int k=0;k<sb.getCount();k++){
		totalAvailableTickets++;
		HashMap hm=new HashMap();
		hm.put("price_id",db.getValue(k,"price_id",""));
		hm.put("ticket_name",db.getValue(k,"ticket_name",""));
		hm.put("ticket_price",CurrencyFormat.getCurrencyFormat("",db.getValue(k,"ticket_price","0"),true));
		hm.put("description",db.getValue(k,"description",""));
		hm.put("process_fee",CurrencyFormat.getCurrencyFormat("",db.getValue(k,"process_fee","0"),true));
		hm.put("ticket_type",db.getValue(k,"ticket_type",""));
		hm.put("max_ticket",db.getValue(k,"max_ticket",""));
		hm.put("sold_qty",db.getValue(k,"sold_qty",""));
		hm.put("min_qty",db.getValue(k,"min_qty",""));
		hm.put("max_qty",db.getValue(k,"max_qty",""));
		hm.put("isdonation",db.getValue(k,"isdonation",""));
		
		if(memticketsHash.containsKey(hm.get("price_id"))){
			hm.put("isMemberTicket","Y"); 
			memberTicketsExists=true;
		}else
		hm.put("isMemberTicket","N");
		if(selectedTicketsHash.containsKey(hm.get("price_id"))){
		hm.put("selected","Y");
		hm.put("selectedqty",selectedTicketsHash.get(hm.get("price_id")));
		hm.put("donationprice",selectedTicketsHash.get(hm.get("price_id")+"_price"));
		}
		vec.add(hm);
		}
		}
		return vec;
	}

	HashMap getMemberTickets(String eventid){
		HashMap hm=new HashMap();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(GET_MEMBER_TICKETS_QUERY,new String[]{eventid});
		if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
		hm.put(db.getValue(i,"price_id",""),"");
		}
		}
		return hm;
	}

	String getTransactionId(){
		String transid=DbUtil.getVal(GET_TRANSACTION_ID_QUERY,new String[]{});
		String transactionid="RK"+EncodeNum.encodeNum(transid).toUpperCase();
		return transactionid;
	}
	
	Vector getAllPaymentTypes(String eventid,String purpose){
		Vector payVector=new Vector();
		DBManager dbmanager=new DBManager();
		StatusObj sb=dbmanager.executeSelectQuery(GET_PAYMENT_TYPES_QUERY,new String[]{eventid,"Enabled","Event"});
		if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
		HashMap hm=new HashMap();
		hm.put("paytype",dbmanager.getValue(i,"paytype",""));
		hm.put("desc",dbmanager.getValue(i,"attrib_1",""));
		payVector.add(hm);
		}
		}
		return payVector;
	}
	
	String[] getOptionsOfCustomAttrib(String attrib_id,String attrib_set_id){
		DBManager dbmanager=new DBManager();
		ArrayList options=new ArrayList();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_ATTRIBUTE_OPTIONS_QUERY,new String []{attrib_id,attrib_set_id});
		if(statobj.getStatus()&&statobj.getCount()>0){
		for(int k=0;k<statobj.getCount();k++){
			String opt_val=dbmanager.getValue(k,"option_val","");
			options.add(dbmanager.getValue(k,"option_val","0"));
		}
		}
		return (String[]) options.toArray(new String[0]);
	}
	
	List getDiscountsMap(String eventid){	
		DBManager dbmanager=new DBManager();
		StatusObj sb=dbmanager.executeSelectQuery(GET_DISCOUNT_TYPES_QUERY,new String[]{eventid});
		List hm=new ArrayList();
		if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
		hm.add(dbmanager.getValue(i,"coupontype","0"));
		}
		//hm.add("discountcode",appliedDiscountcode);
		}
		return hm;
	}
	
       void getProfileOptions(String eventid){
	
	String profileoptions=DbUtil.getVal("select value from config where name=? and config_id in(select config_id from eventinfo where eventid=?)",new String[]{"event.admission.bulk",eventid});
	if("profile".equals(profileoptions))
	collectAllProfiles="Y";
	else
	collectAllProfiles="N";
	}
	
	StatusObj validateEvent(String eid){
	/*HashMap hm=new HashMap();
	String status=DbUtil.getVal("select status from eventinfo where eventid=?",new String[]{eid});
	if("Active".equals(Status)){
	
	}*/
	
	return new StatusObj(true,"","");
	}
	
	
	HashMap getSelectedTickets(String tid){
	HashMap ticketidsMap=new HashMap();
	
	String selectedTicketsQuery="select ticketid,qty,updatedprice from event_reg_ticket_details where tid=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(selectedTicketsQuery,new String[]{tid});
	if(sb.getStatus()){
	for(int j=0;j<sb.getCount();j++){
	ticketidsMap.put(db.getValue(j,"ticketid",""),db.getValue(j,"qty",""));
	ticketidsMap.put(db.getValue(j,"ticketid","")+"_price",db.getValue(j,"updatedprice",""));
	
	}
	}
	return ticketidsMap;
	}
	
	void getTransactionDetails(String tid){
	String regTransactionQuery="select * from event_reg_details where tid=?";
	DBManager dbmanager=new DBManager();
	StatusObj sb=dbmanager.executeSelectQuery(regTransactionQuery,new String[]{tid});
	if(sb.getStatus()){
	selectedPaytype=dbmanager.getValue(0,"selectedpaytype","");
	String status=dbmanager.getValue(0,"status","");
	if("Completed".equals(dbmanager.getValue(0,"status",""))){
		isTransactionComplete=true;
	}
	appliedDiscountcode=dbmanager.getValue(0,"discountcode","");
	if(!"".equals(dbmanager.getValue(0,"clubuserid",""))){
	isMemberLoggedIn=true;
	}
	
	}
	}
	
	Vector getProfileResponses(String transactionid){
	String query="select * from event_attendee_info where tid=?";
	DBManager dbmanager=new DBManager();
	Vector attendeevector=new Vector();
	StatusObj sb=dbmanager.executeSelectQuery(query,new String[]{transactionid});
	if(sb.getStatus()){
	for(int k=0;k<sb.getCount();k++){
	HashMap attendeeMap=new HashMap();
	attendeeMap.put("attendeeid",dbmanager.getValue(k,"attendeeid"," "));
	attendeeMap.put("attendeekey",dbmanager.getValue(k,"attendeekey"," "));
	attendeeMap.put("fname",dbmanager.getValue(k,"fname"," "));
	attendeeMap.put("lname",dbmanager.getValue(k,"lname"," "));
	attendeeMap.put("email",dbmanager.getValue(k,"email"," "));
	attendeeMap.put("phone",dbmanager.getValue(k,"phone"," "));
	attendeeMap.put("customreponses",CustomAttendeResponses(dbmanager.getValue(k,"attendeekey"," ")));
	attendeevector.add(attendeeMap);
	}
	}
	return attendeevector;
	}
	
	
	Vector CustomAttendeResponses(String attendeekey){
	String query="select attrib_name,response from custom_attrib_response where responseid=(select responseid from custom_attrib_response_master where userid=?)";
	DBManager dbmanager=new DBManager();
	Vector responsevector=new Vector();
	StatusObj sb=dbmanager.executeSelectQuery(query,new String[]{attendeekey});
	if(sb.getStatus()){
	for(int j=0;j<sb.getCount();j++)
	{
	HashMap qmap=new HashMap();
	qmap.put("question",dbmanager.getValue(j,"attrib_name",""));
	qmap.put("answer",dbmanager.getValue(j,"response",""));
	responsevector.add(qmap);
	
	}
	}
	return responsevector;
	}
	
	HashMap getRegTotalAmounts(String tid){
	String query="select totalamount, granddiscount, nettotal, tax, grandtotal,status from event_reg_details where tid=?";
	DBManager dbmanager=new DBManager();
	String totalamount="0.00";
	String granddiscount="0.00";
	String netamount="0.00";
	String tax="0.00";
	String grandtotal="0.00";
	HashMap hm=new HashMap();
	
	StatusObj sb=dbmanager.executeSelectQuery(query,new String []{tid});
	if(sb.getStatus()){
	totalamount=dbmanager.getValue(0,"totalamount","0");
	granddiscount=dbmanager.getValue(0,"granddiscount","0");
	netamount=dbmanager.getValue(0,"nettotal","0");
	tax=dbmanager.getValue(0,"tax","0");
	grandtotal=dbmanager.getValue(0,"grandtotal","0");
	}
	if(totalamount==null) totalamount="0";
	if(granddiscount==null) granddiscount="0";
	if(netamount==null) netamount="0";
	if(tax==null) tax="0";
	if(grandtotal==null) grandtotal="0";
	hm.put("status",dbmanager.getValue(0,"status","0"));
	hm.put("totamount",CurrencyFormat.getCurrencyFormat("",totalamount,true));
	hm.put("disamount",CurrencyFormat.getCurrencyFormat("",granddiscount,true));
	hm.put("netamount",CurrencyFormat.getCurrencyFormat("",netamount,true));
	hm.put("tax",CurrencyFormat.getCurrencyFormat("",tax,true));
	hm.put("grandtotamount",CurrencyFormat.getCurrencyFormat("",grandtotal,true));
	return hm;
	}
	
	void insertTicketInfo(String tid, String ticketid, HashMap ticketHash, String tickettype){
		String qty=(String)ticketHash.get("qty");
		String price=(String)ticketHash.get("price");
		String discount=(String)ticketHash.get("discount");
		String fee=(String)ticketHash.get("processfee");
		String finalPrice=(String)ticketHash.get("finalprice");
		String ticketname=(String)ticketHash.get("ticketname");
		String finalprocessfee=(String)ticketHash.get("finalprocessfee");
		try{
		selectedTicketsQty+=Integer.parseInt(qty);
		}
		catch(Exception e)
		{
		selectedTicketsQty+=0;
		}
		if(finalPrice==null||"".equals(finalPrice)){	
			finalPrice=price;
		}
		if(Double.parseDouble(finalPrice)==Double.parseDouble(price)){
		discount="0";
		}
		//if(Double.parseDouble(finalPrice)==0)	fee="0";
		if(fee==null)	fee="0";
		if(finalprocessfee==null)	finalprocessfee=fee;
		
		if(discount==null||"".equals(discount))	discount="0";
		StatusObj sb=DbUtil.executeUpdateQuery("insert into event_reg_ticket_details(tid,ticketid,tickettype,qty,price,processfee,discount,updatedprice,ticketname,originalprocessingfee) values(?,?,?,?,?,?,?,?,?,?)",
			new String[]{tid,ticketid,tickettype,qty,price,finalprocessfee,discount,finalPrice,ticketname,fee});
	
	}
	
	void clearOldTickets(String tid){
		DbUtil.executeUpdateQuery("delete from event_reg_ticket_details where tid=?",new String[]{tid});
	}
	
	void setTransactionAmounts(String eventid, String tid){
		String taxpercent=DbUtil.getVal("select value from config where name='event.tax.amount' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid} );
		if(taxpercent==null) taxpercent="0";
		String total="0.00";
		String discountamt="0.00";
		String nettotal="0.00";
		String query="select sum((price+processfee)*qty) as total,sum((updatedprice+processfee)*qty) as netamount,sum(discount*qty) as disamount from event_reg_ticket_details where tid=?";
		DBManager dbmanager=new DBManager();
		StatusObj sb=dbmanager.executeSelectQuery(query,new String []{tid});
		if(sb.getStatus()){
		discountamt=dbmanager.getValue(0,"disamount","0");
		total=dbmanager.getValue(0,"total","0");
		nettotal=dbmanager.getValue(0,"netamount","0");
		}
		if(total==null) total="0.00";
		if(discountamt==null) discountamt="0.00";
		if(nettotal==null) nettotal="0.00";
		DbUtil.executeUpdateQuery("update event_reg_details set totalamount=?,granddiscount=?,nettotal=? where tid=?",
		new String[]{total,discountamt,nettotal,tid});
		String tax=DbUtil.getVal("select (? * nettotal/100) as totaltax from event_reg_details where tid=?",new String [] {taxpercent, tid} );
		if(tax==null) tax="0.00";
		 sb=DbUtil.executeUpdateQuery("update event_reg_details set grandtotal=(nettotal+?),tax=?,ebeefee=(1.00*?),cardfee=((nettotal*.0495)+(.50*?)) where tid=?",new String[]{tax,tax, selectedTicketsQty+"",selectedTicketsQty+"",tid});
		sb=DbUtil.executeUpdateQuery("update event_reg_details set mgrfee=ebeefee+cardfee where tid=?",new String[]{tid});
		}
	
	public HashMap getNetWorkDetails(String tid){
		String query="select attrib1,attrib2 from event_reg_details where tid=?";
		DBManager db=new DBManager();
		HashMap hm=new HashMap();
		StatusObj sb=db.executeSelectQuery(query,new String[]{tid});
		if(sb.getStatus()){
		hm.put("domain",db.getValue(0,"attrib2"," "));
		hm.put("oid",db.getValue(0,"attrib1"," "));
		}
		return hm;
		}
	
	





}
%>
	
	

