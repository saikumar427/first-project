<%@page import="java.util.Map"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventregister.*,com.event.dbhelpers.*"%>
<%@ include file='/globalprops.jsp' %>
<%!
	public void updateCCFee(String eid,String tid,String payment_type){
	if(payment_type.contains("paypal")) payment_type="paypal";
	if(payment_type.contains("CC")) payment_type="eventbee";
	DBManager db=new DBManager();
	String ccvendor="",ccfee_percentage="";
	String query="select other_ccfee,attrib_5 from payment_types where paytype=? and refid=?";
	StatusObj sb=db.executeSelectQuery(query,new String[]{payment_type,eid});
	if(sb.getStatus()){
		ccfee_percentage=db.getValue(0,"other_ccfee","0");
		ccvendor=db.getValue(0,"attrib_5","");
	}
	if("eventbee".equals(payment_type) && !("authorize.net".equals(ccvendor) ||"braintree_manager".equals(ccvendor) || "stripe".equals(ccvendor) || "payulatam".equals(ccvendor))){
		RegistrationTiketingManager regtm=new RegistrationTiketingManager();
		Map Feesmap=regtm.getFessDetails(eid);
		 String cardfactor=GenUtil.getHMvalue(Feesmap,"card_factor","0");
		   String cardbase=GenUtil.getHMvalue(Feesmap,"card_base","0");
		   DbUtil.executeUpdateQuery("update event_reg_details_temp set cardfee=((nettotal*CAST(? AS NUMERIC))+("+cardbase+")) where tid=?",new String[]{cardfactor,tid});
		return;
	}
	//String ccfee_percentage=DbUtil.getVal(query,new String[]{payment_type,eid});
	 Double ccad=0.0;
	if(ccfee_percentage==null) ccfee_percentage="0";
	 try{			   
			   String ccarr[]=ccfee_percentage.split("\\+");
			    if(ccarr.length==2)
			   {ccfee_percentage=ccarr[0];
			    ccad=Double.parseDouble(ccarr[1]);
			   }
			   Double.parseDouble(ccfee_percentage);
		   }
		   catch(Exception e){
			   System.out.println("exeception::"+e.getMessage());
			   ccfee_percentage="0";
			   ccad=0.0;
		   }
	DbUtil.executeUpdateQuery("update event_reg_details_temp set cardfee=((grandtotal*?::NUMERIC)/100)+?::NUMERIC where tid=?", new String[]{ccfee_percentage,ccad+"",tid});
	if("other".equals(payment_type))
		DbUtil.executeUpdateQuery("update event_reg_details_temp set tax='0.00',grandtotal=grandtotal-tax where tid=? and eventid=?", new String[]{tid,eid});
}

public boolean getSeatStatus(String eid,String tid){
	
	String seatres=DbUtil.getVal("select seatindex from profile_base_info   where eventid=?::bigint and seatindex is not null and transactionid=? limit 1", new String[]{eid,tid});
	if(seatres!=null && !"".equals(seatres))
	{/* String query="select  coalesce(a.eventid,0)||'_'||coalesce (b.eventdate,'')||'_'||coalesce (a.seatindex,'')   res from profile_base_info  a,event_reg_transactions b where a.eventid=b.eventid::bigint and a.transactionid=b.tid and  coalesce(a.eventid,0)||'_'||coalesce (b.eventdate,'')||'_'||coalesce (a.seatindex,'') ::text  in "+ 
			" (select  coalesce (eventid,'')||'_'||coalesce (eventdate,'')||'_'||coalesce (seatindex,'') from event_reg_block_seats_temp  where eventid=? and transactionid=?) ";
	DBManager db=new DBManager();
	
	  StatusObj statusee=db.executeSelectQuery(query,new String[]{eid,tid});
	  if(statusee.getStatus()&&(statusee.getCount()>0)){ 
		  
		  for(int i=0;i<statusee.getCount();i++)
		  System.out.println("seat already sold check:"+db.getValue(i, "res", ""));
		  
		  return false;
	  }
	  else
	  return true; */ //commented for dbfix on 24-01-2015 
	  String query=" SELECT count(*) as res   from seat_booking_status   where  coalesce(eventid,'0')||'_'||coalesce (eventdate,'')||'_'||coalesce (seatindex,'')  in (select  coalesce (eventid,'0')||'_'||coalesce (eventdate,'')||'_'||coalesce (seatindex,'') " 
			  + " from event_reg_block_seats_temp where eventid=? and transactionid=?)";
	  String count=DbUtil.getVal(query, new String[]{eid,tid});
	  if(count==null)count="0";
	  if(Integer.parseInt(count)>0)
		  return false;
	  else
		  return true;
	}
	else
		return true;
	
	
}



%>
<%
String isExceeded="N";
String statusmsg="Exceeded";
String paytype=request.getParameter("paytype");
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
String reqscheme=request.getParameter("scheme");

//System.out.println(eid+"::checkavalibityscheme::"+reqscheme);

if(reqscheme!=null && "https".equals(reqscheme))
serveraddress="https://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

if("other".equals(paytype) || "nopayment".equals(paytype)){}
else{
if("CC".equals(paytype)){
%>
<script>
function cancelRedirect(){
var url="<%=serveraddress%>/embedded_reg/cancelredirect.jsp";
	window.location.href=url;
}
</script>
<%
}
else
{%>
<script>
function cancelRedirect(){
var url="<%=serveraddress%>/embedded_reg/otherclose.jsp";
	window.location.href=url;
}
</script>
<%
}
}
DBManager db=new DBManager();
System.out.println("check availabilty");



String msg="<table width='100%'><tr><td height='200px'></td></tr><tr><td align='center'>"+getPropValue("ca.tkt.not.avail",eid)+"</td></tr></table>";

/* DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=? and current_action in ('','profile page','tickets page','payment section','confirmation page'))and locked_time <(select now()- interval '20 minutes');",new String[]{eid});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=? and current_action in('paypal','google','eventbee','other','ebeecredits'))and locked_time <(select now()- interval '1 hours');",new String[]{eid});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where eventid=? and current_action is null ) and locked_time < (select now()- interval '20 minutes') ;",new String[]{eid});
 */
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
 regtktmgr.autoLocksAndBlockDelete(eid, tid, "checkavailabiltylevel");
 
		if("CC".equals(paytype))
      regtktmgr.setEventRegTempAction(eid,tid,"eventbee");
	  else if("paypal".equals(paytype)||"paypalx".equals(paytype))
      regtktmgr.setEventRegTempAction(eid,tid,"paypal");
       else 
      regtktmgr.setEventRegTempAction(eid,tid,paytype);



String status_qry="select eventid from event_reg_locked_tickets where tid=?";
  StatusObj statusee=db.executeSelectQuery(status_qry,new String[]{tid});
  if(statusee.getStatus()&&(statusee.getCount()>0)){  
  }
  else{isExceeded="Y";
   statusmsg="TimeOut";
   msg="<table width='100%'><tr><td height='200px'></td></tr><tr><td align='center'><b>"+getPropValue("ca.timeout.first",eid)+"</b><br/>* "+getPropValue("ca.timeout.second",eid)+"<br/>"+getPropValue("ca.timeout.third",eid)+"</p><br/> <b><a href='#' onclick='cancelRedirect();'>"+getPropValue("ca.back",eid)+"</a></b></td></tr></table>";
    }
  if(!getSeatStatus(eid, tid)){
	  isExceeded="Y";
	   statusmsg="TimeOut";
	   msg="<table width='100%'><tr><td height='200px'></td></tr><tr><td align='center'><b>"+getPropValue("ca.seats.not.available",eid)+"</b><br/> <b><a href='#' onclick='cancelRedirect();'>"+getPropValue("ca.back",eid)+"</a></b></td></tr></table>";
	 
  }
  
String soldstatquery="select price_id from price a,event_reg_ticket_details_temp b, event_reg_details_temp c where b.tid=?"+
		" and b.tid=c.tid and c.eventdate is null and a.price_id=b.ticketid and (b.qty+a.sold_qty>a.max_ticket or b.qty<a.min_qty or b.qty>a.max_qty)";
	
	StatusObj sb=db.executeSelectQuery(soldstatquery,new String[]{tid});
	if(sb.getStatus()){
		if(sb.getCount()>0){
			isExceeded="Y";
		}
	}
	
	 if("CC".equals(paytype))
      regtktmgr.setEventRegTempAction(eid,tid,"eventbee");
	  else if("paypal".equals(paytype)||"paypalx".equals(paytype))
      regtktmgr.setEventRegTempAction(eid,tid,"paypal");  
       else 
      regtktmgr.setEventRegTempAction(eid,tid,paytype);
	

System.out.println("paytype: "+paytype+" tid: "+tid+" eid: "+eid+" exceeded: "+isExceeded);
if("N".equals(isExceeded)){
	updateCCFee(eid,tid,paytype);
	if("CC".equals(paytype)){
		response.sendRedirect(sslserveraddress+"/embedded_reg/payment.jsp?tid="+tid+"&eid="+eid+"&scheme="+reqscheme);
	}else if("paypalx".equals(paytype)){
		response.sendRedirect(sslserveraddress+"/embedded_reg/paypalxpaymentdata.jsp?tid="+tid+"&eid="+eid+"&paytype=paypal");
	}else if("paypal".equals(paytype)){
		response.sendRedirect(sslserveraddress+"/embedded_reg/paymentdata.jsp?tid="+tid+"&eid="+eid+"&paytype=paypal");
	}else if("google".equals(paytype)){
		response.sendRedirect(sslserveraddress+"/embedded_reg/googlepaymentdata.jsp?tid="+tid+"&eid="+eid+"&paytype=google");
	}else if("ebeecredits".equals(paytype)){
	System.out.println("in ebee credits");
		String  ntsenable=request.getParameter("ntsenable");
		String  fbuserid=request.getParameter("fbuserid");
		String  fname=request.getParameter("fname");
		String  lname=request.getParameter("lname");
		String  email=request.getParameter("email");
		response.sendRedirect(serveraddress+"/embedded_reg/getebeecreditdetails.jsp?tid="+tid+"&eid="+eid+"&paytype=ebeecredits"+"&ntsenable="+ntsenable+"&fbuserid="+fbuserid+"&fname="+fname+"&lname="+lname+"&email="+email);
	}else {
		response.sendRedirect(serveraddress+"/embedded_reg/registrationprocess.jsp?tid="+tid+"&eid="+eid+"&paytype="+paytype);
	}
}else{
        DbUtil.executeUpdateQuery("update event_reg_details_temp set status=? where tid=?", new String[]{statusmsg,tid});
 	if("CC".equals(paytype)){
		out.println(msg);
	}else if("paypalx".equals(paytype)){
		out.println(msg);
	}else if("paypal".equals(paytype)){
		out.println(msg);
	}else if("google".equals(paytype)){
		out.println(msg);
	}else {
		String isExists=DbUtil.getVal("select 'yes' from event_reg_transactions where eventid=? and tid=? and paymentstatus in('Completed','Need Approval')",new String[]{eid,tid});
		if(isExists==null)isExists="";
	   if("yes".equals(isExists))
		response.sendRedirect(serveraddress+"/embedded_reg/registrationprocess.jsp?tid="+tid+"&eid="+eid+"&paytype="+paytype+"&iscompleted=yes");
		else
		out.println("{'status':'Fail','exceeded':'true','paymenttype':'other','msg':'"+getPropValue("ca.tkt.not.avail",eid)+"'}");
	}
}
%>

