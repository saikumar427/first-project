<%!
public class ProfilePageVm{

HashMap getProfilePageVmObjects(String tid,String eid,String copyfrombuyer){
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
TicketsDB ticketInfo=new TicketsDB();
HashMap ticketspecificAttributeIds=null;
CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
ArrayList selectedTickets=new ArrayList();
ArrayList ticketlevelbaseProfiles=null;
selectedTickets=regTktMgr.getSelectedTickets(tid);
Vector attribs=new Vector();
HashMap attribMap=new HashMap();
String arribsetid=null;
try{
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
arribsetid=customattribs.getAttribSetid();
HashMap allTicketAttribs=getAttribsForAllTickets(eid);
if(selectedTickets!=null&&selectedTickets.size()>0){
ticketspecificAttributeIds=ticketcustomattribs.getTicketLevelAttributes(eid);
ticketlevelbaseProfiles=regTktMgr.getTicketIdsForBaseProfiles(eid);
for(int i=0;i<selectedTickets.size();i++){
HashMap profileMap=(HashMap)selectedTickets.get(i);
String selecedticket=(String)profileMap.get("selectedTicket");
Vector questions=new Vector();
//if(ticketlevelbaseProfiles!=null&&ticketlevelbaseProfiles.contains(selecedticket)){
Vector p=getAttendeeObject(selecedticket,(HashMap)allTicketAttribs.get(selecedticket));
		
questions.addAll(p);
//}

if(ticketspecificAttributeIds!=null&&ticketspecificAttributeIds.containsKey(selecedticket))
{
ArrayList al=null;
al=(ArrayList)ticketspecificAttributeIds.get(selecedticket);
if(attributeSet!=null&&attributeSet.length>0){
for(int pindex=0;pindex<al.size();pindex++){
String qid=(String)al.get(pindex);
for(int k=0;k<attributeSet.length;k++){
boolean noattribs=false;
HashMap customMap=new HashMap();
CustomAttribute cb=(CustomAttribute)attributeSet[k];
if(qid.equals(cb.getAttribId())){
customMap.put("qType",cb.getAttributeType());
customMap.put("qId",cb.getAttribId());
questions.add(customMap);
}
String attrib_setid=cb.getAttribSetId();
}
}
}
}

if(questions!=null&&questions.size()>0){
profileMap.put("questions",questions);
if(i==0){
if( p!=null&&p.size()>0)
profileMap.put("copylink","<a href='#' onclick=\"copyByuerData('"+selecedticket+"'); return false; \">"+copyfrombuyer+"</a>");
}
attribs.add(profileMap);
}
}
}
attribMap.put("customProfile",attribs);


HashMap byerMap=new HashMap();
Vector buyerQues=getAttendeeObject("0",(HashMap)allTicketAttribs.get("0"));
ArrayList buyerAttribs=null;
buyerAttribs=regTktMgr.getBuyerSpecificAttribs(eid);

if(attributeSet!=null&&attributeSet.length>0){
for(int k=0;k<attributeSet.length;k++){
ArrayList al=null;
CustomAttribute cb=(CustomAttribute)attributeSet[k];
if(buyerAttribs!=null&&buyerAttribs.contains(cb.getAttribId())){
HashMap customattib=new HashMap();
customattib.put("qId",cb.getAttribId());
buyerQues.add(customattib);

}
}
}

byerMap.put("buyerQues",buyerQues);
attribMap.put("buyer",byerMap);
attribMap.put("arribsetid",arribsetid);

}
catch(Exception e){
}
return attribMap;
}



HashMap getfieldMap(String field){
HashMap map=new HashMap();
map.put("qId",field);
return map;
}

//public 	Vector getAttendeeObject(String ticketid,String eid){
public 	Vector getAttendeeObject(String ticketid,HashMap attribMap){
		Vector v=new Vector();
		//HashMap attribMap=getAttribsForTickets(ticketid,eid);
		if(attribMap==null)
		attribMap=new HashMap();
		List list=new ArrayList();
		if("0".equals(ticketid)||attribMap.containsKey("fname"))	
		list.add("fname");
		if("0".equals(ticketid)||attribMap.containsKey("lname"))	
		list.add("lname");
		if("0".equals(ticketid)||attribMap.containsKey("email"))	
		list.add("email");
	   	if(attribMap.containsKey("phone"))	
		 list.add("phone");
		
	
		for(int i=0;i<list.size();i++){
		HashMap hm=getfieldMap((String)list.get(i));
	
		v.add(hm);
     
		
		}
		return v;
		}



void fillVelocityContextForProfilePage(String eid,VelocityContext context,HashMap profilePageLabels){
String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});
if(currencyformat==null)
currencyformat="$";
String profilePageHeader=GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.page.Header","");
String BuyerInfoLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.buyerinfo.label","Buyer Information");

String RefundPolicyLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.refund.label","Refund Policy");
String GrandTotalLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.grandtotal.amount.label","Grand Total");
String totalAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.total.amount.label","Total");
String discountAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.discount.amount.label","Discount");
String NetAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.net.amount.label","Net Amount");
String taxAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.tax.amount.label","Tax");
String PaymentMethodLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.paymentsheader.label","Payment Method");
String discountAppliedMsg=GenUtil.getHMvalue(profilePageLabels,"event.reg.discount.applied.msg","Applied");
String discountInvalidMsg=GenUtil.getHMvalue(profilePageLabels,"event.reg.discount.invalid.msg","Invalid Discount Code");
String requiredMsg=GenUtil.getHMvalue(profilePageLabels,"event.reg.requiredprofile.empty.msg","Invalid Discount Code");
String promotionsectionheader=GenUtil.getHMvalue(profilePageLabels,"ebee.promotions.header","Promotions");

if("".equals(profilePageHeader))
profilePageHeader=null;
context.put("refundPolicyLabel",RefundPolicyLabel);
context.put("currencyFormat",currencyformat);
context.put("GrandTotalLabel",GrandTotalLabel);
context.put("profilePageHeader",profilePageHeader);
context.put("PaymentMethodLabel",PaymentMethodLabel);
context.put("BuyerInfoLabel",BuyerInfoLabel);
context.put("PaymentMethodLabel",PaymentMethodLabel);
context.put("GrandTotalLabel",GrandTotalLabel);
context.put("discountAmountLabel",discountAmountLabel);
context.put("taxAmountLabel",taxAmountLabel);
context.put("NetAmountLabel",NetAmountLabel);
context.put("totalAmountLabel",totalAmountLabel);
context.put("promotionSectionLabel",promotionsectionheader);
}
public HashMap getAttribsForTickets(String ticketid,String groupid){
HashMap hm=new HashMap();
String query="select attribid,isrequired from base_profile_questions where contextid=CAST(? AS INTEGER) and groupid=CAST(? AS BIGINT)";
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query, new String[]{ticketid,groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
hm.put(db.getValueFromRecord(i,"attribid",""),db.getValueFromRecord(i,"isrequired",""));	
}
}
return hm;
}
public HashMap getAttribsForAllTickets(String eid){
	HashMap ticketAttribsMap=new HashMap();
	String query="select contextid,attribid,isrequired from base_profile_questions where groupid=?::BIGINT";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{eid});
	if(sb.getStatus()){
	for(int i=0;i<sb.getCount();i++){
	String ticketid=db.getValue(i,"contextid","");
	if(ticketAttribsMap.containsKey(ticketid)){
		HashMap attribMap=(HashMap)ticketAttribsMap.get(ticketid);
		attribMap.put(db.getValue(i,"attribid",""),db.getValue(i,"isrequired",""));
	}
	else{
		HashMap attribMap=new HashMap();
		attribMap.put(db.getValue(i,"attribid",""),db.getValue(i,"isrequired",""));
		ticketAttribsMap.put(ticketid, attribMap);
	}
	}
	}
	return ticketAttribsMap;
	}
}
%>