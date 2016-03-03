<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%!

	public HashMap getXmlData(String tranid,String source){
		String query =null;
		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj statobj=null;
		
		if("Google".equals(source)){
			 query = "select google_charged_status,ebee_to_google_xml,google_order_no from google_payment_data where ebee_tran_id=?" ;
			 statobj=dbmanager.executeSelectQuery(query,new String[]{tranid});
		
				if(statobj.getStatus()){
					for(int i=0;i<statobj.getCount();i++){
						hm.put("ORDER_STATUS",dbmanager.getValue(i,"google_charged_status","PENDING"));
						hm.put("NOTIF_XML",dbmanager.getValue(i,"ebee_to_google_xml",""));
						hm.put("ORDER_NO",dbmanager.getValue(i,"google_order_no",""));
					}
				}
		}
		if("Paypal".equals(source)){
			query = "select ebee_xml_data,paypal_order from paypal_payment_data where ebee_tran_id=?" ;
			 statobj=dbmanager.executeSelectQuery(query,new String[]{tranid});
		
				if(statobj.getStatus()){
					for(int i=0;i<statobj.getCount();i++){
						hm.put("ORDER_STATUS",dbmanager.getValue(i,"paypal_order",""));
						hm.put("NOTIF_XML",dbmanager.getValue(i,"ebee_xml_data",""));
						hm.put("ORDER_NO","");
					}
				}
		
		}		
				return hm;
	
	}

%>



<%
String tranid = request.getParameter("id");
String source = request.getParameter("source");


String order_status=null;
String xmlcontent=null;
String orderno=null;

HashMap hm= getXmlData(tranid,source);

if(hm!=null){
	order_status=(String)hm.get("ORDER_STATUS");
	xmlcontent=(String)hm.get("NOTIF_XML");
	orderno=(String)hm.get("ORDER_NO");


}

EventRegisterDataBean edb= new EventRegisterDataBean();
EventRegisterManager erm=new EventRegisterManager();
if(!"".equals(xmlcontent) && xmlcontent!=null ){
			EventRegisterManager.initEventRegXmlData(xmlcontent,edb);
 }
 
 
 request.setAttribute("EVENT_REG_DATA_BEAN",edb);	
 
 
%>

<%--
<jsp:forward page="paymentconfirm.jsp" >
	<jsp:param name="orderstatus" value="<%=order_status%>" />
	<jsp:param name="source" value="<%=request.getParameter("source")%>" />
</jsp:forward>
--%>

<jsp:include page="paymentconfirm.jsp" >
	<jsp:param name="orderstatus" value="<%=order_status%>" />
	<jsp:param name="source" value="<%=request.getParameter("source")%>" />
</jsp:include>


