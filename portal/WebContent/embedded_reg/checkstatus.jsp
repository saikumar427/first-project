<%@ page import="com.eventbee.general.*"%>
<%@ page import="org.json.*"%>
<%!
	public void sendError(String tid){
		EmailObj emailobj=new EmailObj();
		emailobj.setBcc("bala@eventbee.com");
		emailobj.setTo("pavani@eventbee.com");
		emailobj.setFrom("pavani@eventbee.com");
		emailobj.setSubject("Eventbee CC Fatal Error(Tid:"+tid+")");
		emailobj.setTextMessage("Error has occured for the transaction: "+tid);
		EventbeeMail.sendTextMail(emailobj);
	}
%>

<%
String tid=request.getParameter("tid");
String newtid=DbUtil.getVal("select new_tid from newtid_track where old_tid=?",new String[]{tid});
	if(newtid!=null && !"".equals(newtid))
		tid=newtid;
String selectedPaytype=DbUtil.getVal("select selectedpaytype from event_reg_details_temp where tid=?",new String[]{tid});
String googleorder=null;
String Status=DbUtil.getVal("select paymentstatus  from event_reg_transactions where tid=?",new String[]{tid});
if(Status==null&&"google".equals(selectedPaytype))
googleorder=DbUtil.getVal("select google_order_no  from google_payment_data where ebee_tran_id=?",new String[]{tid});
else if(Status==null&&"paypal".equals(selectedPaytype))
Status=DbUtil.getVal("select paymentstatus from event_reg_details_temp where tid=?",new String[]{tid});

if("Pending".equalsIgnoreCase(Status)||"CHARGED".equalsIgnoreCase(Status))
Status="Completed";
else if(googleorder!=null)
Status="Processing";
if("eventbee".equals(selectedPaytype) && !"Completed".equals(Status))
{
	String errorcount=DbUtil.getVal("select count(*) from cardtransaction where internal_ref=? and proces_status='F'",new String[]{tid});
	int fcount=0;
	try{
		fcount=Integer.parseInt(errorcount);	
	}
	catch(Exception ec){
	}
	if(fcount>0){
		Status="ccfatalerror";
		sendError(tid);
	}
	
	
	
}
String holdStatus="";
try{
holdStatus=DbUtil.getVal("select status  from event_reg_details_temp where tid=?",new String[]{tid});
if(holdStatus==null){holdStatus="";}
}catch(Exception e){System.out.println(" geting holdStatus error"+e.getMessage());}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "checkStatus.jsp", "Status for  the e transactionid---->"+request.getParameter("tid")+"is "+Status, "", null);

System.out.println("#########################################");
System.out.println("holdStatus"+holdStatus);
System.out.println("#########################################");

JSONObject obj=new JSONObject();
obj.put("status",Status);
obj.put("tid",tid);
obj.put("hstatus",holdStatus);
out.println(obj.toString());
%>