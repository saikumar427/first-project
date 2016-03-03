<%@ page import="org.eventbee.sitemap.util.Presentation,com.eventbee.general.*"%>
<%@ page import="java.util.*,com.eventregister.*,com.event.dbhelpers.*"%>
<%@ page import="org.json.*"%>
<%@ include file="PaypalXPaymentDetails.jsp" %>
<%@ page import="com.eventbee.cachemanage.CacheManager"%>
<%@ page import="com.eventbee.cachemanage.CacheLoader"%>
<%@ page import="com.eventbee.regcaheloader.RegFormActionLoader"%>
<%!
String GET_TICKETS_QUERY="select groupname,ticket_groupid,price_id,ticket_name,networkcommission from tickets_details_view where eventid=?";
 HashMap getTicketDetails(String eid){
    HashMap ticketsMap=new HashMap();
    /* DBManager db=new DBManager();
    StatusObj sb=db.executeSelectQuery(GET_TICKETS_QUERY,new String[]{eid});
    if(sb.getStatus()){
    for(int i=0;i<sb.getCount();i++){
    HashMap priceMap=new HashMap();
    priceMap.put("ticketname",db.getValue(i,"ticket_name",""));
    priceMap.put("groupname",db.getValue(i,"groupname",""));
    priceMap.put("ticket_groupid",db.getValue(i,"ticket_groupid",""));
    priceMap.put("price_id",db.getValue(i,"price_id",""));
	String ntscommission=db.getValue(i,"networkcommission","0.00");
	ntscommission=ntscommission==null?"0.00":ntscommission;
	if(Double.parseDouble(ntscommission)<0)
		ntscommission="0";
	priceMap.put("nts_commission",ntscommission);
    ticketsMap.put(db.getValue(i,"price_id",""),priceMap);
    }
    } */
    
    ticketsMap=(HashMap)getRegFormActionMap(eid).get("ticket_details_view");
	
    return ticketsMap;

    }	
 
	public Map getRegFormActionMap(String eid){
		
		if(!CacheManager.getInstanceMap().containsKey("regformaction")){
			CacheLoader cacheLoader=new RegFormActionLoader();
			cacheLoader.setRefreshInterval(3*60*1000);
			cacheLoader.setMaxIdleTime(3*60*1000);
			CacheManager.getInstanceMap().put("regformaction",cacheLoader);		
		}
		Map regFormActionMap=CacheManager.getData(eid, "regformaction");
		int t=0;
		while(regFormActionMap==null && t<20){
			try {
			    Thread.sleep(200);
			    regFormActionMap=CacheManager.getData(eid, "regformaction");
			    t++;
			} catch(InterruptedException ex) {
				System.out.println("InterruptedException in regformaction.jsp getTicketDetails: eventid: "+eid+" iteration: "+t+" Exception: "+ex.getMessage());
			    Thread.currentThread().interrupt();
			}
		}
		
		return regFormActionMap;
	}
%>
<%
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
String eid=request.getParameter("eid");
String discountcode=request.getParameter("code");
String track=request.getParameter("track");
String ticketurlcode=request.getParameter("ticketurlcode");
String eventdate=request.getParameter("evtdate");
String clubuserid=request.getParameter("clubuserid");
String context=request.getParameter("context");
String sectionid=request.getParameter("sectionid");
String selected_ticketid=request.getParameter("selected_ticket");
String registrationsource=request.getParameter("registrationsource");
String fbuserid=request.getParameter("fbuserid");
String nts_enable=request.getParameter("nts_enable");
String nts_commission=request.getParameter("nts_commission");
String referral_ntscode=request.getParameter("referral_ntscode");
String fname=request.getParameter("fname");
String lname=request.getParameter("lname");
String email=request.getParameter("email");
String waitlistid=request.getParameter("wid");
String priorityToken=request.getParameter("priregtoken");
String prilistId=request.getParameter("prilistid");
if(priorityToken==null)priorityToken="";
if(prilistId==null)prilistId="";
if(waitlistid==null)waitlistid="";
String discountfalg="true";
String donationList="";

JSONObject jsonresponseobj=new JSONObject();
if(" ".equals(referral_ntscode))
	referral_ntscode="";
String ntscode="",display_ntscode="";
JSONObject obj=new JSONObject();
try{
obj=(JSONObject)new JSONTokener(selected_ticketid).nextValue();
}catch(Exception e){System.out.println("empty select_ticketid"+e.getMessage());}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "Registration Strated for the  event---->"+eid, "", null);
HashMap ticketDetailsMap=getTicketDetails(eid);
String actionname=request.getParameter("actiontype");
String tid=Presentation.GetRequestParam(request,  new String []{"tid","transactionid"});
double disAmount=0.0;
	HashMap ntsdata=new HashMap();
	HashMap ntsdetails=new HashMap();
	System.out.println("fbuserid in regformaction: "+fbuserid);
if(!"0".equals(fbuserid)){
	ntsdata.put("fbuserid",fbuserid);
	ntsdata.put("eventid",eid);
	ntsdata.put("ntsenable",nts_enable);
	ntsdata.put("fname",fname);
	ntsdata.put("lname",lname);
	ntsdata.put("email",email);
	ntsdata.put("network","facebook");
	try{
		System.out.println("calling get nts code method: "+fbuserid);
		ntsdetails=regTktMgr.getPartnerNTSCode(ntsdata);
		ntscode=(String)ntsdetails.get("nts_code");
		System.out.println("obtained nts code: "+ntscode);
		display_ntscode=(String)ntsdetails.get("display_ntscode");
	}
	catch(Exception e){
		System.out.println("exception in nts code: "+e.getMessage());
	}
}
if(tid==null||"".equals(tid)){
HashMap contextdata=new HashMap();
String customerIp=request.getHeader("x-forwarded-for");
if(customerIp==null || "".equals(customerIp)) customerIp=request.getRemoteAddr();
contextdata.put("useragent",request.getHeader("User-Agent")+"["+customerIp+"]");
contextdata.put("trackurl",track);
contextdata.put("clubuserid",clubuserid);
contextdata.put("ticketurlcode",ticketurlcode);
contextdata.put("eventdate",eventdate);
contextdata.put("registrationsource",registrationsource);
contextdata.put("wid",waitlistid);
contextdata.put("prilistid",prilistId);
contextdata.put("pritoken",priorityToken);
System.out.println("wid in regformaction::"+waitlistid);
if(context==null||"".equals(context))
context="EB";
contextdata.put("context",context);
if(discountcode==null)
discountcode="";
contextdata.put("discountcode",discountcode);
if("ning".equals(context)){
contextdata.put("oid",request.getParameter("oid"));
contextdata.put("domain",request.getParameter("domain"));
}
tid=regTktMgr.createNewTransaction(eid,contextdata);
}

if(!"{}".equals(obj+"")){
String trackquery="insert into querystring_temp (tid,useragent,created_at,querystring,jsp ) values(?,?,now(),?,?)";
DbUtil.executeUpdateQuery(trackquery,new String[]{tid,request.getHeader("User-Agent"),obj+"","regformaction"});
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "Registration Strated for the  event---"+eid+" and transactionid is"+tid, "", null);
String ticketids=request.getParameter("ticketids");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "ticketids---"+ticketids, "", null);
StatusObj locked_tickets_sb=DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where eventid=? and tid=?",new String[]{eid,tid});
StatusObj blockseats_del=DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where eventid=? and transactionid=?", new String[]{eid,tid});
ArrayList <String>selectedTicketsList=new ArrayList();
String []ticketsArray=GenUtil.strToArrayStr(ticketids,",");
StatusObj sb=DbUtil.executeUpdateQuery("delete from event_reg_ticket_details_temp where tid=?",new String[]{tid});
int disccount=0;
for(int k=0;k<ticketsArray.length;k++){
	HashMap ticketMap=new HashMap();
	ticketMap.put("nts_enable",nts_enable);
	ticketMap.put("nts_commission","0");
	ticketMap.put("referral_ntscode",referral_ntscode);
	
	String qty=request.getParameter("qty_"+ticketsArray[k]);
	if(qty==null)
		qty="0";

	if(Integer.parseInt(qty)>0){
	String price=request.getParameter("originalprice_"+ticketsArray[k]);
	String ticketid=ticketsArray[k];
	String finalprice=request.getParameter("finalprice_"+ticketsArray[k]);
	String fee=request.getParameter("processfee_"+ticketsArray[k]);
	String ticketGroupId=request.getParameter("ticketGroup_"+ticketsArray[k]);
	String finalfee=request.getParameter("finalprocessfee_"+ticketsArray[k]);
	String ticketType=request.getParameter("ticketType_"+ticketsArray[k]);
	ticketMap.put("originalPrice",request.getParameter("originalprice_"+ticketsArray[k]));
	ticketMap.put("finalPrice",request.getParameter("finalprice_"+ticketsArray[k]));
	
	finalprice=finalprice==null?"0.00":finalprice;
	price=price==null?"0.00":price;
	if(Double.parseDouble(price)==Double.parseDouble(finalprice))
	disAmount=0.00;
	else{
	disAmount=Double.parseDouble(price)-Double.parseDouble(finalprice);
	disccount++;
	}
	ticketMap.put("originalFee",request.getParameter("processfee_"+ticketsArray[k]));
	ticketMap.put("finalFee",request.getParameter("processfee_"+ticketsArray[k]));
	if("donationType".equals(ticketType))
	 donationList=donationList+ticketid+",";	 
	 
	ticketMap.put("qty",qty);
	ticketMap.put("ticketid",ticketid);
	ticketMap.put("ticketGroupId",ticketGroupId);
	ticketMap.put("ticketType",ticketType);
	ticketMap.put("discount",disAmount+"");


	if(ticketDetailsMap!=null&&ticketDetailsMap.size()>0){
	HashMap priceDetails=(HashMap)ticketDetailsMap.get(ticketid);
	if(priceDetails!=null&&priceDetails.size()>0){
	ticketMap.put("ticket_nts_commission", priceDetails.get("nts_commission"));
	ticketMap.put("ticketName",priceDetails.get("ticketname"));
	ticketMap.put("groupname",priceDetails.get("groupname"));
	}
	}
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "Selected TicketDetails for the transaction---------"+tid+" is"+ticketMap, "", null);
	try{
	JSONArray ja=obj.getJSONArray(ticketid);
	ticketMap.put("seat_index",ja);
	}
	catch(Exception ex){
	JSONArray ja=new JSONArray();
	ticketMap.put("seat_index",ja);
	}
	ticketMap.put("eventdate",eventdate);
	regTktMgr.InsertTicketDetailsToDb(ticketMap,tid,eid);
	}
}

regTktMgr.setTransactionAmounts(eid, tid);
HashMap amounts=(HashMap)regTktMgr.getRegTotalAmounts(tid);

ntsdata.put("ntscode",ntscode);
ntsdata.put("fbuserid",fbuserid);
ntsdata.put("ntsenable",nts_enable);
ntsdata.put("referral_ntscode",referral_ntscode);
ntsdata.put("tid",tid);
ntsdata.put("eventid",eid);
regTktMgr.updateDetailsTempNTSDetails(ntsdata);
if("Order Now".equals(actionname)){
if(eid==null)
jsonresponseobj.put("status","Failed");
else
jsonresponseobj.put("status","success");
jsonresponseobj.put("tid",tid);
jsonresponseobj.put("eid",eid);
jsonresponseobj.put("ntscode",ntscode);
jsonresponseobj.put("display_ntscode",display_ntscode);



PaypalXPaymentDetails paypalxdetails=new PaypalXPaymentDetails();
String paymentmode=paypalxdetails.getPaymentMode(eid);
System.out.println("paymentmode---"+paymentmode);
jsonresponseobj.put("paymentmode",paymentmode);


}
else
regTktMgr.fillAmountDetails(amounts,jsonresponseobj,tid);


if(donationList.length()>4)  
{ if(donationList.length()-1==donationList.lastIndexOf(","))
  donationList=donationList.substring(0, donationList.length()-1);
  System.out.println("donationlist::"+donationList);
  DbUtil.executeUpdateQuery("update event_reg_locked_tickets set locked_qty=?::integer where ticketid in ("+donationList+")",new String[]{"0"});
}
if(discountcode!=null && !"".equals(discountcode)){discountcode=discountcode.trim();}
if(disccount==0) discountcode="";
DbUtil.executeUpdateQuery("update event_reg_details_temp set discountcode=? where tid=?",new String[]{discountcode,tid});
if(discountcode!=null && !"".equals(discountcode))
{
    	
	DiscountsManager discountsManager = new DiscountsManager();
	HashMap DiscountLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
	HashMap discountinfomap=discountsManager.getDiscountInfo(discountcode, eid, "",DiscountLabels);
	discountfalg=(String)discountinfomap.get("discountfalg");
	String discountMsg=(String)discountinfomap.get("message");
	jsonresponseobj.put("discountfalg",discountfalg);
	jsonresponseobj.put("remcnt",discountinfomap.get("remcnt"));
    jsonresponseobj.put("discountMsg",discountMsg);
	if("false".equals(discountfalg))
	{
	DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=? ",new String[]{tid});
	}

}
//String timeout=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=?::bigint) and name='timeout' ",new String[]{eid});
String timeout="";
try{
	Map ticketSettingsMap=CacheManager.getData(eid, "ticketsettings");	
	HashMap configMap=(HashMap)ticketSettingsMap.get("configmap");
	timeout=GenUtil.getHMvalue(configMap,"timeout","14");
}catch(Exception e){
	System.out.println("Exception checkticketstatus.jsp eventLevelCheck CacheManager: eventid: "+eid+" ERROR:: "+e.getMessage());
}
timeout=timeout==null||"".equals(timeout) ?"14":timeout;
try{Integer.parseInt(timeout);}catch(Exception e){timeout="14";};
jsonresponseobj.put("timeout",timeout);
out.print(jsonresponseobj.toString());

%>