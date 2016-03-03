<%@ page import="com.eventbee.general.*,com.eventbee.util.*"%>
<%@ page import="com.eventregister.*" %>
<%
String ebee_transaction_id= request.getParameter("tid");
String eventid=request.getParameter("eid");
StatusObj statob=null;
if(ebee_transaction_id!=null&&eventid!=null){
			  RegistrationProcessDB rgdb=new RegistrationProcessDB();
			  RegistrationConfirmationEmail regmail=new RegistrationConfirmationEmail();
		      int result=rgdb.InsertRegistrationDb(ebee_transaction_id,eventid);
		      int emailcount=regmail.sendRegistrationEmail(ebee_transaction_id,eventid);
		      statob=DbUtil.executeUpdateQuery("update event_reg_details_temp set status=? where tid=?", new String []{"Completed",ebee_transaction_id});
		      statob= DbUtil.executeUpdateQuery("update event_reg_transactions set paymentstatus=? where tid=?", new String []{"Completed",ebee_transaction_id});
            }
            %>