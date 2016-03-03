 <%@page import="com.eventbee.general.EbeeConstantsF,com.eventbee.general.EncodeNum,com.eventbee.general.DbUtil"%>
 <%@ page import="java.util.HashMap,com.eventbee.general.GenUtil,com.eventregister.RegistrationTiketingManager,org.json.JSONObject"%>
<%!String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
%>
<% 

String fbeid=request.getParameter("fbeid");
String domain=request.getParameter("domain");
String fbuid=request.getParameter("fbuid");
String record_id=request.getParameter("record_id");
String eid=request.getParameter("eid");
String venueid =request.getParameter("venueid");
 String email=request.getParameter("email");
String name=request.getParameter("name");
 String gender=request.getParameter("gender");
 String fname="";
 String lname="";
 String[] arr=GenUtil.strToArrayStr(name," ");
try{

if(arr.length>1){
fname=arr[0];
 lname=arr[1];
 }
 }catch(Exception e){
  System.out.println("exception :"+e.getMessage());
 }
 //System.out.println("rec"+record_id);
String status=DbUtil.getVal("select domain from nwf_party_attendee_list where fbeid=? and fbuid=?",new String[]{fbeid,fbuid});
 domain=DbUtil.getVal("select domain from venue_cities where cityid=(select cityid from venues_of_city where venueid=?)",new String[]{venueid});
  if(domain==null){domain="domain123";}
 //System.out.println("comming dbtrak"+fbeid+"  "+domain+"fbuid"+fbuid+""+venueid+"trck"+record_id+"name"+fname+"email"+email+lname);
if(status==null)
       { //System.out.println("success"+venueid);
	    String add_city="insert into nwf_party_attendee_list(domain,record_id,eid,venueid,fbeid,fbuid,date) values(?,?,?,?,?,?,?)";			
         System.out.println("suecess"+fbeid+"  "+domain+"fbuid"+fbuid+""+venueid);		
			DbUtil.executeUpdateQuery(add_city, new String[]{domain,record_id,eid,venueid,fbeid,fbuid,"now()"});
		}
		
	//	System.out.println("nts"+record_id);
	if(email.equals("undefined")) email="";
	if(gender.equals("undefined"))gender="";
  if(gender.equals("male"))
		gender="M";
 else
		gender="F";
   
   String fbcount=DbUtil.getVal("select count(*) from ebee_nts_partner where external_userid =?", new String[]{fbuid}); 
   //System.out.println("fbcount is:"+fbcount);  
  int count=Integer.parseInt(fbcount);
  //System.out.println("count is:"+count);
  if(count==0){
    String nts_partner_seq = DbUtil.getVal("select nextval('nts_partner_seq')",new String[]{});
	String ntsCode="nt"+EncodeNum.encodeNum(nts_partner_seq).toLowerCase();
	System.out.println("ntsCode:"+ntsCode);
    String insertQuery = "insert into ebee_nts_partner(external_userid, fname, lname, email, gender, partner_from, source, nts_code, nts_partnerid, nts_code_display) values(?,?,?,?,?,now(),?,?,?,?)";
	DbUtil.executeUpdateQuery(insertQuery, new String[]{fbuid,fname,lname,email,gender,domain,ntsCode,nts_partner_seq,ntsCode});
	}

%>