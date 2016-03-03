<%@ page import="java.util.*,com.eventbee.general.*,java.sql.*,java.text.*, com.eventbee.authentication.*,java.io.*,com.eventbee.util.*,org.w3c.dom.*" %>
<%@ page import="com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.creditcard.*"%>

<%@ include file="/eventregister/reg/regemail.jsp" %>

<%!
		Vector getDetails(String query,String transid){		
			Vector dbvect=new Vector();
			DBManager dbmanager=new DBManager();
			HashMap dbhmap = null;
			StatusObj statobj=dbmanager.executeSelectQuery(query,new String [] {transid});
  			if(statobj.getStatus()){   
        		for(int k=0;k<statobj.getCount();k++){
		 			dbhmap=new HashMap();
					dbhmap.put("xmldata",dbmanager.getValue(k,"xmldata",""));
					dbhmap.put("time",dbmanager.getValue(k,"time",""));
		 			dbvect.add(dbhmap);
				}
			}
   			return dbvect;
		}
%>
<%!
	
	String gt=null;
	public String getNodeValue(Element el,String ename,String dfval){
		String nv=dfval;
		NodeList nl =el.getElementsByTagName(ename);
		if(nl != null && nl.getLength() > 0) {
		nv=nl.item(0).getChildNodes().item(0).getNodeValue();
		}		
		return nv;
	}
	public void initEventRegXmlData(String xmldata){
		StringBufferInputStream sbips= new StringBufferInputStream(xmldata);
		Document doc=ProcessXMLData.getDocument(sbips);
		NodeList regNodes = doc.getElementsByTagName("event-registration");
		if(regNodes != null && regNodes.getLength() > 0) {
			Element el = (Element)regNodes.item(0);
			gt=getNodeValue(el,"grand-total","0.00");
		}
	}
	
%>

<%!
	
	Vector vect_xml=null;
	EventRegisterDataBean edb= new EventRegisterDataBean();
	EventRegisterManager erm=new EventRegisterManager();
	
	public String insertRecords(String gpquery,String tid,String vendor){
		String result="false";
		vect_xml=getDetails(gpquery,tid);
		HashMap hm_gin=(HashMap)vect_xml.firstElement();
		String xml= (hm_gin.get("xmldata")).toString();
		if(xml!=null){
			initEventRegXmlData(xml);
		  	EventRegisterManager.initEventRegXmlData(xml,edb);
		  	erm.insertRegData(edb);
		  	StatusObj stobj_card=null;
		  	stobj_card=DbUtil.executeUpdateQuery("insert into cardtransaction (internal_ref,app_name,process_vendor,amount,proces_status,response_id,transaction_date) values (?,?,?,?,?,?,now())",new String[]{tid,"EVENT_REGISTRATION",vendor,gt,"Y","1"});
		  	if(stobj_card.getStatus()){
		  		result="true";
		  	}
		  	
		  	
		  	
		  	 ProfileData[] pd=edb.getProfileData();
			int mailstatus=sendRegistrationEmail(pd,edb);
 
		}
		return result;
	}
%>
<%!
	StatusObj stobj_dgp=null;
	public String deleteRecords(String query,String tid){
		String res="false";
		stobj_dgp=DbUtil.executeUpdateQuery(query,new String[] {tid});
		if(stobj_dgp.getStatus()){
			res="true";
		}
		return res;
	}
%>
<%!
	Vector vect_tickid=null;
	StatusObj stobj_update=null;
	public String updatePrice(String tid){
			String res="false";
			String tquery="select ticketid as xmldata,ticketqty as time from attendeeticket where transactionid = ? group by ticketid,ticketqty";
			vect_tickid=getDetails(tquery,tid);
			if(vect_tickid!=null&&vect_tickid.size()>0){
				for(int i=0;i<vect_tickid.size();i++){
					HashMap hm_tickid=(HashMap)vect_tickid.elementAt(i);
					String tickid= (hm_tickid.get("xmldata")).toString();
					String qt= (hm_tickid.get("time")).toString();
					stobj_update=DbUtil.executeUpdateQuery("update price set sold_qty= sold_qty -"+qt+" where price_id = ?",new String[] {tickid});
					res="true";
				}
			}
		return res;
	}
%>
<%!
	public String agentId(String tid){
		String res="false";int c=0;
		String query="select agentid as xmldata,transactionid as time from transaction where transactionid = ? group by transactionid,agentid";
		Vector vect_agent=getDetails(query,tid);
		if(vect_agent!=null&&vect_agent.size()>0){
			for(int i=0;i<vect_agent.size();i++){
				HashMap hm_agentid=(HashMap)vect_agent.elementAt(i);
				String agentid= (hm_agentid.get("xmldata")).toString();
				if(!agentid.equals("")){
					
					c=c+1;
				}
			}
			
			if(c==vect_agent.size()){
				String query_agent="delete from partner_transactions where transactionid=?";
				String dres=deleteRecords(query_agent,tid);
				res=dres;
			}
		}
		return res;
	}
%>






<%
String bname=request.getParameter("button");
String groupid=request.getParameter("groupid");
String platform = request.getParameter("platform");
String URLBase="mytasks";
    if("ning".equals(platform)){
	URLBase="ningapp/ticketing";	
    }

String type=request.getParameter("type");
String status=request.getParameter("status");
String querylist[]={"delete from eventattendee where transactionid = ?","delete from transaction where transactionid = ?","delete from cardtransaction where internal_ref = ?","delete from attendeeticket where transactionid = ?"};
boolean insertdetails=false;
if(bname.equals("insert")){
	String gin[]=request.getParameterValues("Googlenins");
	String pin[]=request.getParameterValues("Paypalnins");
	
	try{
		if(gin!=null){
			
			String query="select ebee_to_google_xml as xmldata,ebee_to_google_time as time from google_payment_data where ebee_tran_id = ?";
			for(int i=0;i<gin.length;i++){
				String result=insertRecords(query,gin[i],"google");
				if(result.equals("true")){
							StatusObj stobj_gp=null;
							stobj_gp=DbUtil.executeUpdateQuery("update google_payment_data set google_order_no = ?,google_charged_xml='Manual' where ebee_tran_id = ?",new String[] {"1",gin[i]});
							
							insertdetails=true;
						}
				
			}
			
		}
	}finally{
			
				if(pin!=null){
					
					String query="select ebee_xml_data as xmldata,time as time from paypal_payment_data where ebee_tran_id = ?";
					for(int i=0;i<pin.length;i++){
						String result=insertRecords(query,pin[i],"paypal");
						
						 		if(result.equals("true")){
						 			StatusObj stobj_gp=null;
									stobj_gp=DbUtil.executeUpdateQuery("update paypal_payment_data set paypal_order = ? where ebee_tran_id = ?",new String[] {"1",pin[i]});
									
									insertdetails=true;
								}
						
					}
					
				}
	}
	
}
else if(bname.equals("delete")){
	String gndel[]=request.getParameterValues("Googlendel");
	String gdel[]=request.getParameterValues("Googledel");
	String pndel[]=request.getParameterValues("Paypalndel");
	String pdel[]=request.getParameterValues("Paypaldel");
	boolean deletedetails=false;
	try{
		if(gdel!=null){			
			String query="delete from google_payment_data where ebee_tran_id = ?";			
			for(int i=0;i<gdel.length;i++){			
				String res=updatePrice(gdel[i]);				
				if(res.equals("true")){
					String resp=agentId(gdel[i]);
					
					int count=0;
					for(int j=0;j<querylist.length;j++){
						String result=deleteRecords(querylist[j],gdel[i]);
						
						count=count+1;
					}
					if(count==querylist.length){
						String dres=deleteRecords(query,gdel[i]); 
						if(dres.equals("true")){
							deletedetails=true;
						}
					}
				}
			}
		}
	}
	finally{
			try{
				if(pdel!=null){
					
					
					String query="delete from paypal_payment_data where ebee_tran_id = ?";
					for(int i=0;i<pdel.length;i++){
						String res=updatePrice(pdel[i]);
						if(res.equals("true")){
							String resp=agentId(pdel[i]);
							int count=0;
							for(int j=0;j<querylist.length;j++){
								String result=deleteRecords(querylist[j],pdel[i]);
								
								count=count+1;
							}
							if(count==querylist.length){
								String dres=deleteRecords(query,pdel[i]); 
								if(dres.equals("true")){
									deletedetails=true;
								}
							}
						}
					}
				}
			}
			finally{
					try{
						if(gndel!=null){
							
							int gnc=0;
							String query="delete from google_payment_data where ebee_tran_id = ?";
							for(int i=0;i<gndel.length;i++){
								String result=deleteRecords(query,gndel[i]);
								if(result.equals("true")){
									deletedetails=true;
								}
							}
							
						}
					}
					finally{
						try{
							if(pndel!=null){
								
								String query="delete from paypal_payment_data where ebee_tran_id = ?";
								for(int i=0;i<pndel.length;i++){
									String result=deleteRecords(query,pndel[i]);
									if(result.equals("true")){
										deletedetails=true;
										
									}
								}
							}
						}
						finally{
							
						}
					}
			}
	}
	
}

			
		GenUtil.Redirect(response,"/portal/"+URLBase+"/transactionmanagement.jsp?GROUPID="+groupid+"&platform="+platform+"&type="+type+"&status="+status);
		


%>
