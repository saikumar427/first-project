<%@ page import="org.json.*"%>
<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.creditcard.*,com.eventbee.event.*" %>
<%@ page import="com.eventbee.authentication.*" %>


<%
JSONObject object=new JSONObject();
com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext);
CreditCardModel ccm=new CreditCardModel();
ProfileData m_ProfileData=new ProfileData();

HashMap hm=new HashMap();
String tid=request.getParameter("tid");
String m_cardamount=request.getParameter("totalamount");
hm.put(CardConstants.INTERNAL_REF,tid);
hm.put(CardConstants.REQUEST_APP,"EVENT_REGISTRATION");
hm.put(CardConstants.TRANSACTION_TYPE,CardConstants.TRANS_ONE_TIME);
hm.put(CardConstants.BASE_REF,"/card");
hm.put(CardConstants.LOGO_URL,"");
hm.put(CardConstants.AUTH_POLICY,"");
hm.put(CardConstants.AUTH_URL,"");
hm.put(CardConstants.AMOUNT,""+m_cardamount);
ccm.setParams(hm);
ccm.setProfiledata(m_ProfileData); 
Map reqMap=rsv.getReqMap();
String BASE_REF=GenUtil.getHMvalue(reqMap,"BASE_REF");
ccm.setCardtype(GenUtil.getHMvalue(reqMap,BASE_REF+"/cardtype"));
ccm.setCardnumber(GenUtil.getHMvalue(reqMap,BASE_REF+"/cardnumber"));
ccm.setCvvcode(GenUtil.getHMvalue(reqMap,BASE_REF+"/cvvcode",""));
ccm.setExpmonth(GenUtil.getHMvalue(reqMap,BASE_REF+"/expmonth"));
ccm.setExpyear(GenUtil.getHMvalue(reqMap,BASE_REF+"/expyear"));
ccm.getProfiledata().setFirstName(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/firstName"));
ccm.getProfiledata().setLastName(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/lastName"));
ccm.getProfiledata().setEmail(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/email"));
ccm.getProfiledata().setCompany(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/company"));
ccm.getProfiledata().setStreet1(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/street1"));
ccm.getProfiledata().setStreet2(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/street2"));
ccm.getProfiledata().setCity(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/city"));
ccm.getProfiledata().setState(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/state"));
ccm.getProfiledata().setCountry(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/country"));
ccm.getProfiledata().setZip(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/zip"));
ccm.getProfiledata().setPhone(GenUtil.getHMvalue(reqMap,BASE_REF+"/profiledata/phone"));
ccm.setCurrencyCode("USD");
StatusObj sobj= ccm.localValidate();

Vector v=new Vector();
String error="";
if(sobj.getStatus()){
	v=(Vector)(sobj.getData());
} 

if(v==null || v.size()==0){
sobj= ccm.validate();		       
if(sobj.getStatus()){
if(sobj.getData() instanceof Vector)
v =(Vector)(sobj.getData());
else if(sobj.getData() instanceof String){
error=(String)(sobj.getData());
v.add("This transaction can not be processed at this time, please try back later");

}
} 
}
if(v==null || v.size()==0){
object.put("status","success");
}else{
JSONArray errorsArray=new JSONArray();
if(v!=null&&v.size()>0){
for(int i=0;i<v.size();i++){
errorsArray.put(v.elementAt(i));
}
}
object.put("status","error");
object.put("errors",errorsArray);
}
out.println(object.toString());

%>



