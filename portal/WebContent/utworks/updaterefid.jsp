<%@ page import="java.util.*,com.eventbee.general.*,java.sql.*,java.text.*, com.eventbee.authentication.*,java.io.*,com.eventbee.util.*,org.w3c.dom.*" %>

<%
	String fdate=request.getParameter("fdate")==null?"2005-01-01":request.getParameter("fdate");
	String tdate=request.getParameter("tdate")==null?"2005-12-31":request.getParameter("tdate");
%>

<html>
	<head>
		<script  language="javascript">
			function sendDetails(){
				document.f1.action="/beeadmin/paymentdetails/googleeventdetails.jsp";
				document.f1.submit();
			}
			function validation(){
				
				 if(document.f1.pay.options[document.f1.pay.selectedIndex].index==0){
		              window.alert("please select either Google/Paypal");
					  document.getElementById('pay').focus();}
		              else
						  document.f1.submit();
			}
		</script>
	</head>
<body>
	<form name="f1" method="post" action="">
		<table align='center'>
			<tr>
				<td>
					<b>Update Refid</b>
				</td>
			</tr><br>
			<tr>
				<td>Google/Paypal:</td>
				<td><select name="pay" id="pay">
					<option value="none">select</option>
					<option value="google">google</option>
					<option value="paypal">paypal</option>
					</select>
				<td>
			</tr>
			<tr>
				<td>
					Between
				</td>
				<td>
					<input type="text" name="fdate" value="<%=fdate%>"> To <input type="text" name="tdate" value="<%=tdate%>"> (YYYY-MM-DD)
					<input type="button" name="dsubmit" value="Go" onclick="validation()">
				</td>
			</tr>
			<br/>
		</table>

<%!
	
Vector getdetails(String fdate,String tdate,String paytype){
		System.out.println("pay:"+paytype);
		Vector v=new Vector();
		StatusObj statobj=null;
		DBManager dbmanager=new DBManager();
		HashMap hm = null;
		String query=null;
		if(paytype.equals("google")){
			query="select ebee_to_google_xml as xmldata from google_payment_data where ebee_to_google_time between ? and ? and refid is null";
		}
		else if(paytype.equals("paypal")){
			query= "select ebee_xml_data as xmldata from paypal_payment_data where time  between ? and ? and refid is null";
		}
		
		 statobj=dbmanager.executeSelectQuery(query,new String [] {fdate,tdate});	
			System.out.println("Status::: "+ statobj.getStatus());
			System.out.println("Record Size::: " + statobj.getCount());
			if(statobj.getStatus()){   
    		for(int k=0;k<statobj.getCount();k++){
	 			hm=new HashMap(); 
				hm.put("xmldata",dbmanager.getValue(k,"xmldata",""));
	 			v.add(hm);
			}
		}
			return v;
}
%>

<%!
	String nodename="";
	String nodeval="";
	String evid;
	String etid;
	public void initEventRegXmlData(String xmldata){
	try{
		StringBufferInputStream sbips= new StringBufferInputStream(xmldata);
		Document doc=ProcessXMLData.getDocument(sbips);
		//String xml[]={"event-registration"};
	
		NodeList listOfNodes = doc.getElementsByTagName("event-registration");
		
		if(listOfNodes != null && listOfNodes.getLength() > 0) {
			
			for(int i=0; i< listOfNodes.getLength(); i++){
				Element el = (Element)listOfNodes.item(i);
				NodeList textnList = el.getChildNodes();
				//Element e2=null;
								
				if(textnList != null && textnList.getLength() > 0) {
					
					for(int j=0; j< textnList.getLength(); j++){		
						Node n1=(Node)textnList.item(j);
						
							if(n1.getNodeType() == Node.ELEMENT_NODE){
								Element e2=(Element)n1;
								nodename=n1.getNodeName();
								NodeList elelist = e2.getChildNodes();
								
									if(elelist != null && elelist.getLength() > 0) {
										
										try{
											nodeval=((Node)elelist.item(0)).getNodeValue();
											
											if(nodeval==null)
												nodeval="";
											
										}
										catch(Exception e){
											nodeval="";
											System.out.println("exception elelist  block "+nodename+ "Tag----"+e.getMessage());
										}
										if("ebee-event-id".equals(nodename)){
											evid=nodeval;
										}
										if("ebee-trans-id".equals(nodename)){
											etid=nodeval;
											//System.out.println("bee-trans-id:"+nodeval);
										}
								}
							}
						}
					}
				}
			}
		  }catch(Exception e){
			System.out.println("Exception"+e);
		  }
		}

%>



<br>
	<table border=1 align="center">
		
		<%	try{
			String etgx=null;
			String query=null;
			String type=request.getParameter("pay");
			Vector v1=null;
			if(!type.equals("none")){
				v1=getdetails(fdate,tdate,type);
			}
			if(v1!=null&&v1.size()>0){
  				for(int i=0;i<v1.size();i++){
 					HashMap hmt=(HashMap)v1.elementAt(i);
 					etgx= (hmt.get("xmldata")).toString();
 					
 					initEventRegXmlData(etgx);
 					
 					if(type.equals("google")){
 						//System.out.println("evid"+evid+","+etid);
 						query="update google_payment_data set ref_type=?,refid=? where ebee_tran_id=?";
 					}
 					else if(type.equals("paypal")){
 						//System.out.println("evid"+evid+","+etid);
 						query="update paypal_payment_data set ref_type=?,refid=? where ebee_tran_id=?";
 					}
 					try{
 						StatusObj stobj=null;
 						stobj=DbUtil.executeUpdateQuery(query,new String[]{"EVENT",evid,etid});
 						System.out.println("evid:"+evid+",etid:"+etid);
 					}catch(Exception  e){
 						System.out.println("Exception:"+e);
 						
 					}
  				}
  				out.println("<tr><td><center>"+type+"_payment_data Table Updation completed</center></td></tr>");
			}
		}catch(Exception e){
			System.out.println("Exception"+e);
		}
%>
	</table>
	</form>
</body>
</html>
