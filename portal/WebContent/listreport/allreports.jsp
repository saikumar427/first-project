<%!
public static final String  commonselectpart="select distinct partnerid,email,discountcode,trackpartner,tid,fname,lname,paymenttype ,fname || ' ' || lname  as name,upper(fname), upper(lname),to_char(transaction_date,'yyyy-mm-dd') as transaction_date,to_char(transaction_date,'dd/mm/yyyy') as trdate,ordernumber,current_amount,servicefee,ccfee,current_nts,current_discount,paymentstatus from event_reg_transactions where eventid=? and bookingsource='online' and current_amount >0";

public   String ALL_TRANSACTION_DETAILS=commonselectpart+" and paymenttype=? and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  ";

public   String TRANSACTION_DETAILS_BEETWEEN_DATES=commonselectpart+" and paymenttype=? and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and to_char(transaction_date,'yyyy-mm-dd') between ? and ? ";

public   String TRANSACTION_DETAILS_TRANSACTIONID=commonselectpart+" and paymenttype=? and  tid=? ";

public static  String TRANSACTION_DETAILS_ATTENDEENAME=commonselectpart+" and paymenttype=? and fname||' '||lname like ? ";

public   String TRANSACTION_DETAILS_PAYMENTSTATUS=commonselectpart+" and paymenttype=? and  upper(paymentstatus)=upper(?)";

public   String TRANSACTION_DETAILS_ORDERNUMBER=commonselectpart+" and paymenttype=? and ordernumber=? ";

public   String TRANSACTION_DETAILS_TRACKCODE=commonselectpart+" and paymenttype=? and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) and  trackpartner=? ";

public   String TRANSACTION_DETAILS_DIRECT=commonselectpart+" and paymenttype=? and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and  (trackpartner is null or trackpartner='') and (partnerid is null  or partnerid='null') ";

public   String TRANSACTION_DETAILS_NTS=commonselectpart+" and paymenttype=? and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and partnerid is not null and partnerid <>'null' ";

public   String TRANSACTION_DETAILS_ALLTRACKCODES=commonselectpart+" and paymenttype=? and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and trackpartner is not null and trackpartner <>'null' and trackpartner<>''";

public Vector getTransactionInfo(String groupid,int selectedvalue, HttpServletRequest req,String cardtype){

	String sortby=req.getParameter("sortby");
	String sortbyclause="";
	sortbyclause=getSortByClause(sortby);	
	DBManager dbmanager =new DBManager();	
	StatusObj statobj=null;
	if(selectedvalue==2){	
	String startdate=req.getParameter("startYear")+"-"
			+ req.getParameter("startMonth")+"-"
			+ req.getParameter("startDay");
	String enddate=req.getParameter("endYear")+"-"
			+req.getParameter("endMonth")+"-"
			+req.getParameter("endDay");	

	statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_BEETWEEN_DATES+sortbyclause,new String[]{groupid,cardtype,startdate,enddate});
	}else if(selectedvalue==3){
	String transactionid=req.getParameter("key");
	statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_TRANSACTIONID+sortbyclause,new String[]{groupid,cardtype,transactionid});
	}
	else if(selectedvalue==4){
	String attendee=req.getParameter("attendee");
	statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_ATTENDEENAME+sortbyclause,new String[]{groupid,cardtype,"%"+attendee+"%"});
	}
	else if(selectedvalue==5){
        String paymentstaus=req.getParameter("paymentstaus");
       	statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_PAYMENTSTATUS+sortbyclause,new String[]{groupid,cardtype,paymentstaus});
	}else if(selectedvalue==6){
        String ordernumber=req.getParameter("ordernumber");
       	statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_ORDERNUMBER+sortbyclause,new String[]{groupid,cardtype,ordernumber});
    	}else if(selectedvalue==7){
        String source=req.getParameter("source");
		if("direct".equals(source)){
		statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_DIRECT+sortbyclause,new String[]{groupid,cardtype});
		}else if("nts".equals(source)){
		statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_NTS+sortbyclause,new String[]{groupid,cardtype});
		}else if("alltrackcodes".equals(source)){
		statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_ALLTRACKCODES+sortbyclause,new String[]{groupid,cardtype});
		}else
		statobj=dbmanager.executeSelectQuery(TRANSACTION_DETAILS_TRACKCODE+sortbyclause,new String[]{groupid,cardtype,source});
    	}else{
       	statobj=dbmanager.executeSelectQuery(ALL_TRANSACTION_DETAILS+sortbyclause,new String[]{groupid,cardtype});
	}
	return fillTransactionDetails(statobj, dbmanager);
	
}

Vector fillTransactionDetails(StatusObj statobj, DBManager dbmanager){
Vector tv= new Vector();
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();   			
			hm.put("transactionid",dbmanager.getValue(i,"tid",""));
			hm.put("trandate",dbmanager.getValue(i,"trdate",""));
			hm.put("firstname",dbmanager.getValue(i,"fname",""));
			hm.put("lastname",dbmanager.getValue(i,"lname",""));
			hm.put("totalamount",dbmanager.getValue(i,"current_amount",""));
			hm.put("grandtotal",dbmanager.getValue(i,"current_amount",""));
			hm.put("ebeefee",dbmanager.getValue(i,"servicefee",""));
			hm.put("cardfee",dbmanager.getValue(i,"ccfee",""));
			String agentid=dbmanager.getValue(i,"partnerid","null");
			hm.put("agentid",agentid);
			hm.put("discount",dbmanager.getValue(i,"current_discount",""));
			hm.put("transactiontype",dbmanager.getValue(i,"paymenttype",""));
			hm.put("payment_status",dbmanager.getValue(i,"paymentstatus",""));
			hm.put("name",dbmanager.getValue(i,"name",""));
			hm.put("ordernumber",dbmanager.getValue(i,"ordernumber",""));
			String trackurl=dbmanager.getValue(i,"trackpartner","");
			String sourcecode=dbmanager.getValue(i,"trackpartner","");
			if("".equals(sourcecode) ) sourcecode="Direct";
			if(!("null".equals(agentid) ) && !("".equals(agentid))) sourcecode="NTS";
			if(!("null".equals(trackurl) ) && !("".equals(trackurl))) sourcecode="Track URL";
			hm.put("Source",sourcecode);
			hm.put("discountcode",dbmanager.getValue(i,"discountcode",""));
			hm.put("email",dbmanager.getValue(i,"email",""));
			hm.put("trackpartner",dbmanager.getValue(i,"trackpartner",""));
			hm.put("agentcommission",dbmanager.getValue(i,"current_nts",""));
			tv.addElement(hm);

		}
  	}
	
	return tv;
}
public  final String  commonzeroselectpart="select distinct partnerid,email,discountcode,trackpartner,tid,fname,lname,upper(fname), upper(lname),paymenttype ,fname || ' ' || lname  as name,to_char(transaction_date,'yyyy-mm-dd') as transaction_date,to_char(transaction_date,'dd/mm/yyyy') as trdate,ordernumber,current_amount,servicefee,ccfee,current_nts,current_discount,paymentstatus from event_reg_transactions where eventid=? and bookingsource='online' and current_amount <0.01";

public   String GET_ZERO_ALL_TRANSACTION_DETAILS=commonzeroselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) ";

public   String GET_ZERO_TRANSACTION_DETAILS_BEETWEEN_DATES=commonzeroselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and to_char(transaction_date,'yyyy-mm-dd') between ? and ? ";

public   String GET_ZERO_TRANSACTION_DETAILS_TRANSACTIONID=commonzeroselectpart+" and tid=? ";

public   String GET_ZERO_TRANSACTION_DETAILS_ATTENDEENAME=commonzeroselectpart+" and   fname||' '||lname like ? ";

public   String GET_ZERO_TRANSACTION_DETAILS_ORDERNUMBER=commonzeroselectpart+"  and ordernumber=? ";

public   String GET_ZERO_TRANSACTION_DETAILS_PAYMENTSTATUS=commonzeroselectpart+"  and upper(paymentstatus)=upper(?)  ";

public   String GET_ZERO_TRANSACTION_DETAILS_TRACKCODE=commonzeroselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) and trackpartner=? ";

public   String GET_ZERO_TRANSACTION_DETAILS_DIRECT=commonzeroselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and  (trackpartner is null or trackpartner='') and (partnerid is null  or partnerid='null') ";

public   String GET_ZERO_TRANSACTION_DETAILS_NTS=commonzeroselectpart+" and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and partnerid is not null and partnerid <>'null' ";

public   String GET_ZERO_TRANSACTION_DETAILS_ALLTRACKCODES=commonzeroselectpart+" and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and trackpartner is not null and trackpartner <>'null' and trackpartner<>''";

public String getSortByClause(String sortby)
{
		String desc="";
		String sortbytemp="";
	      	if("fn_az".equals(sortby)) {
	      		sortbytemp="upper(fname)";
	      	}
	      	else if("fn_za".equals(sortby)) {
	       		sortbytemp="upper(fname)";
	   			desc="desc";
	   		}
		else if("ln_az".equals(sortby)) {
	       		sortbytemp="upper(lname)";
	        }
	        else if("ln_za".equals(sortby)) {
	        	sortbytemp="upper(lname)";
	        	desc="desc";
	        }
	        else if("bookdate_new".equals(sortby)) {
		      	sortbytemp="to_char(transaction_date,'yyyy-mm-dd')";
		      	desc="desc";
	      	}
	      	else if("bookdate_old".equals(sortby)) {
	      		sortbytemp="to_char(transaction_date,'yyyy-mm-dd')";
	      	}
	 String SORTBY_CLAUSE="";
	 SORTBY_CLAUSE= "order by "+"  "+sortbytemp+" "+desc;
	 return SORTBY_CLAUSE;
}
public Vector getZeroTransactionInfo(String groupid,int selectedvalue, HttpServletRequest req,String cardtype){
	String sortby=req.getParameter("sortby");
	String sortbyclause="";
	sortbyclause=getSortByClause(sortby);
	DBManager dbmanager =new DBManager();	
	StatusObj statobj=null;	
	if(selectedvalue==2){	
	String startdate=req.getParameter("startYear")+"-"
			+ req.getParameter("startMonth")+"-"
			+ req.getParameter("startDay");
	String enddate=req.getParameter("endYear")+"-"
			+req.getParameter("endMonth")+"-"
			+req.getParameter("endDay");	
		
	statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_BEETWEEN_DATES+sortbyclause,new String[]{groupid,startdate,enddate});
	}else if(selectedvalue==3){
	String transactionid=req.getParameter("key");
	statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_TRANSACTIONID+sortbyclause,new String[]{groupid,transactionid});
	}
	else if(selectedvalue==4){
	String attendee=req.getParameter("attendee");
	statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_ATTENDEENAME+sortbyclause,new String[]{groupid,"%"+attendee+"%"});
	}else if(selectedvalue==5){
        String paymentstaus=req.getParameter("paymentstaus");
       	statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_PAYMENTSTATUS+sortbyclause,new String[]{groupid,paymentstaus});
	}else if(selectedvalue==6){
        String ordernumber=req.getParameter("ordernumber");
       	statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_ORDERNUMBER+sortbyclause,new String[]{groupid,ordernumber});
	}
	else if(selectedvalue==7){
	        String source=req.getParameter("source");
			if("direct".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_DIRECT+sortbyclause,new String[]{groupid});
			}else if("nts".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_NTS+sortbyclause,new String[]{groupid});
			}else if("alltrackcodes".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_ALLTRACKCODES+sortbyclause,new String[]{groupid});
			}else
			statobj=dbmanager.executeSelectQuery(GET_ZERO_TRANSACTION_DETAILS_TRACKCODE+sortbyclause,new String[]{groupid,source});
    	}	
	else{
	statobj=dbmanager.executeSelectQuery(GET_ZERO_ALL_TRANSACTION_DETAILS+sortbyclause,new String[]{groupid});
	}	
	return fillTransactionDetails(statobj, dbmanager);
}

public static  String  commonotherselectpart="select distinct partnerid,email,trackpartner,discountcode,tid,fname,lname,paymenttype,fname || ' ' || lname  as name,upper(fname), upper(lname),to_char(transaction_date,'yyyy-mm-dd') as transaction_date,to_char(transaction_date,'dd/mm/yyyy') as trdate,current_amount,ordernumber,servicefee,ccfee,current_nts,current_discount,paymentstatus from event_reg_transactions where eventid=? and LOWER(paymenttype) in ('other','nopayment')  and current_amount >0";

public   String GET_OTHER_ALL_TRANSACTION_DETAILS=commonotherselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) ";

public   String GET_OTHER_TRANSACTION_DETAILS_BEETWEEN_DATES=commonotherselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) and to_char(transaction_date,'yyyy-mm-dd') between ? and ? ";

public   String GET_OTHER_TRANSACTION_DETAILS_TRANSACTIONID=commonotherselectpart+" and tid=? ";

public   String GET_OTHER_TRANSACTION_DETAILS_ATTENDEENAME=commonotherselectpart+" and fname||' '||lname like ? ";

public   String GET_OTHER_TRANSACTION_DETAILS_ORDERNUMBER=commonotherselectpart+" and ordernumber=? ";

public   String GET_OTHER_TRANSACTION_DETAILS_PAYMENTSTATUS=commonotherselectpart+"  and upper(paymentstatus)=upper(?) ";

public   String GET_OTHER_TRANSACTION_DETAILS_TRACKCODE=commonotherselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) and trackpartner=?";

public   String GET_OTHER_TRANSACTION_DETAILS_DIRECT=commonotherselectpart+" and  (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and  (trackpartner is null or trackpartner='') and (partnerid is null  or partnerid='null') ";

public   String GET_OTHER_TRANSACTION_DETAILS_NTS=commonotherselectpart+" and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and partnerid is not null and partnerid <>'null' ";

public   String GET_OTHER_TRANSACTION_DETAILS_ALLTRACKCODES=commonotherselectpart+" and (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') )  and trackpartner is not null and trackpartner <>'null' and trackpartner<>''";

public Vector getOtherTransactionInfo(String groupid,int selectedvalue, HttpServletRequest req,String cardtype){

	DBManager dbmanager =new DBManager();	
	StatusObj statobj=null;
	String sortby=req.getParameter("sortby");
   	String sortbyclause="";
	sortbyclause=getSortByClause(sortby);
      	
		if(selectedvalue==2){	
		String startdate=req.getParameter("startYear")+"-"
				+ req.getParameter("startMonth")+"-"
				+ req.getParameter("startDay");
		String enddate=req.getParameter("endYear")+"-"
				+req.getParameter("endMonth")+"-"
				+req.getParameter("endDay");	
			
		
		statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_BEETWEEN_DATES+sortbyclause,new String[]{groupid,startdate,enddate});
		}else if(selectedvalue==3){
		String transactionid=req.getParameter("key");
		statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_TRANSACTIONID+sortbyclause,new String[]{groupid,transactionid});
		}
		else if(selectedvalue==4){
		String attendee=req.getParameter("attendee");
		statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_ATTENDEENAME+sortbyclause,new String[]{groupid,"%"+attendee+"%"});
		}else if(selectedvalue==5){
		String paymentstaus=req.getParameter("paymentstaus");
		statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_PAYMENTSTATUS+sortbyclause,new String[]{groupid,paymentstaus});
		}else if(selectedvalue==6){
       		 String ordernumber=req.getParameter("ordernumber");
       		statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_ORDERNUMBER+sortbyclause,new String[]{groupid,ordernumber});
		}else if(selectedvalue==7){
	        String source=req.getParameter("source");
			if("direct".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_DIRECT+sortbyclause,new String[]{groupid});
			}else if("nts".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_NTS+sortbyclause,new String[]{groupid});
			}else if("alltrackcodes".equals(source)){
			statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_ALLTRACKCODES+sortbyclause,new String[]{groupid});
			}else
			statobj=dbmanager.executeSelectQuery(GET_OTHER_TRANSACTION_DETAILS_TRACKCODE+sortbyclause,new String[]{groupid,source});
    		}else{
		statobj=dbmanager.executeSelectQuery(GET_OTHER_ALL_TRANSACTION_DETAILS+sortbyclause,new String[]{groupid});
		}
		
		return fillTransactionDetails(statobj, dbmanager);
}

public static final String GET_TICKETS_INFO="select ticketqty,ticketname,ticketid,tid,groupname,ticketprice from transaction_tickets where eventid=? order by ticketid";

public HashMap getTicketInfo(String groupid){

        System.out.println("we r in listreport,allreportsjsp getticketinfo method");
	HashMap hmap=new HashMap();
	DBManager dbmanager=new DBManager();
	HashMap ticketHistory = null;
	String ticketid="";
	String ticketname="";
	StatusObj statobj=dbmanager.executeSelectQuery(GET_TICKETS_INFO,new String [] {groupid});
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
			String tid =dbmanager.getValue(i,"tid",null);
			String ticketqty=dbmanager.getValue(i,"ticketqty","0");
			String ticketprice=dbmanager.getValue(i,"ticketprice","0");
			ticketid=dbmanager.getValue(i,"ticketid","");
			ticketname=dbmanager.getValue(i,"ticketname","");
			if(Integer.parseInt(ticketid)==102){
			    ticketname="Not Sure";
			  //  System.out.println("i am in get ticketinfo if"+ticketid+"--"+ticketname);
			}else{
			     ticketname=dbmanager.getValue(i,"ticketname","");
			    // System.out.println("i am in get ticketinfo if"+ticketid+"--"+ticketname);
			}
			
			
			
			String groupName=dbmanager.getValue(i,"groupname","");
			if(!"".equals(groupName) && groupName!=null)
			ticketname=groupName+" - "+ticketname;
			else
			ticketname=ticketname;
			if(hmap.get(tid)!=null){
				ticketHistory = (HashMap)hmap.get(tid);
				ticketname=ticketHistory.get("DESC")+", "+ticketname;
				ticketqty=ticketHistory.get("Count")+", "+ticketqty;
				ticketprice=ticketHistory.get("Price")+", "+ticketprice;
				ticketid=ticketHistory.get("TicketId")+", "+ticketid;
			 }else{
			  	ticketHistory = new HashMap();
			 }
			 ticketHistory.put("Count",ticketqty);
			 ticketHistory.put("Price",ticketprice);
			 ticketHistory.put("DESC",ticketname);
			 ticketHistory.put("TicketId",ticketid);
			 hmap.put(tid,ticketHistory);
		}
	}
 	return hmap;
}

public Vector getAttendeeListInfo(String groupid){
	return getAttendeeListInfo(groupid, "", "","");
	}

public Vector getAttendeeListInfo(String groupid,String selindex, String paramValue,String sortby){
        String desc="";
      	if("fn_az".equals(sortby)) {
      		sortby="fn";
      	}
      	if("fn_za".equals(sortby)) {
       		sortby="fn";
   			desc="desc";
   		}
		if("ln_az".equals(sortby)) {
       		sortby="ln";
        }
        if("ln_za".equals(sortby)) {
        	sortby="ln";
        	desc="desc";
        }
        if("bookdate_new".equals(sortby)) {
	      	sortby="bookdate";
	      	desc="desc";
      	}
      	if("bookdate_old".equals(sortby)) {
      		sortby="bookdate";
      	}

        Vector tv=null;
        HashMap traninfo=null;
        DBManager dbmanager=new DBManager();
        String GET_ATTENDEELIST_INFO="select distinct UPPER(firstname) as fn,firstname,UPPER(lastname) as ln,lastname,a.email, a.phone,state,max(transaction_date) as bookdate, "
        			+" city,country,address1,address2,comments,c.paymenttype,statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company,  "
        			+" bookingsource,current_amount from eventattendee a, transaction_tickets b, event_reg_transactions c  "
        			+" where (UPPER(paymentstatus)  in ('COMPLETED','CHARGED','PENDING') ) and a.eventid=? and a.transactionid=c.tid and  a.transactionid=b.tid ";
     
        if("2".equals(selindex)){

 GET_ATTENDEELIST_INFO+=" and  c.tid=b.tid and bookingsource='online' group by fn,ln,firstname, "
 			+" lastname,a.email, a.phone,state,city,country,address1,address2,comments, "
 			+" c.paymenttype, statement,priattendee,authid,attendeeid,attendeekey, "
 			+" a.transactionid,username,company,  bookingsource, current_amount "
 			+" order by "+sortby+" "+desc+"";
 }
 else if("3".equals(selindex)){
  GET_ATTENDEELIST_INFO+=" and  c.tid=b.tid and bookingsource='Manager' group by fn,ln,firstname, "
  			+" lastname,a.email, a.phone,state,city,country,address1,address2,comments, "
  			+" c.paymenttype, statement,priattendee,authid,attendeeid,attendeekey, "
  			+" a.transactionid,username,company,  bookingsource, current_amount "
 			+" order by "+sortby+" "+desc+"";
 			
 
 }else if("4".equals(selindex)){
 GET_ATTENDEELIST_INFO+=" and  c.tid=b.tid and b.ticketid="+paramValue+" group by fn,ln,firstname, "
   			+" lastname,a.email, a.phone,state,city,country,address1,address2,comments, "
   			+" c.paymenttype, statement,priattendee,authid,attendeeid,attendeekey, "
   			+" a.transactionid,username,company,  bookingsource, current_amount "
 			+" order by "+sortby+" "+desc+"";

 }else {
 GET_ATTENDEELIST_INFO+=" and  c.tid=b.tid group by fn,ln,firstname, "
    			+" lastname,a.email, a.phone,state,city,country,address1,address2,comments, "
    			+" c.paymenttype, statement,priattendee,authid,attendeeid,attendeekey, "
    			+" a.transactionid,username,company,  bookingsource, current_amount "
 			+" order by "+sortby+" "+desc+"";
 
 }

 StatusObj stobj=dbmanager.executeSelectQuery(GET_ATTENDEELIST_INFO,new String[]{groupid});

 if(stobj.getStatus()){
			tv=new Vector();
		for(int i=0;i<stobj.getCount();i++){
			traninfo=new HashMap();
			traninfo.put("firstname",dbmanager.getValue(i,"firstname",""));
			traninfo.put("lastname",dbmanager.getValue(i,"lastname","") );
			traninfo.put("name",dbmanager.getValue(i,"name",""));
			traninfo.put("company",dbmanager.getValue(i,"company","") );
			traninfo.put("city",dbmanager.getValue(i,"city","") );
			traninfo.put("attendeeid",dbmanager.getValue(i,"attendeeid","") );
			traninfo.put("email",dbmanager.getValue(i,"email",""));
			traninfo.put("phone",dbmanager.getValue(i,"phone","") );
			traninfo.put("authid",dbmanager.getValue(i,"authid","") );
			traninfo.put("address1",dbmanager.getValue(i,"address1","") );
			traninfo.put("address2",dbmanager.getValue(i,"address2","") );
			traninfo.put("country",dbmanager.getValue(i,"country","") );
			traninfo.put("state",dbmanager.getValue(i,"country","") );
			traninfo.put("username",dbmanager.getValue(i,"state","") );
			traninfo.put("comments",dbmanager.getValue(i,"comments","") );
			traninfo.put("transactionid",dbmanager.getValue(i,"transactionid","") );
			traninfo.put("bookingsource",dbmanager.getValue(i,"bookingsource","") );
			traninfo.put("attendeekey",dbmanager.getValue(i,"attendeekey","") );
			traninfo.put("transactiontype",dbmanager.getValue(i,"transactiontype","") );
			traninfo.put("grandtotal",dbmanager.getValue(i,"current_amount","") );
			traninfo.put("priattendee",dbmanager.getValue(i,"priattendee","") );
			tv.addElement(traninfo);
		}
}
return tv;
    }
%>