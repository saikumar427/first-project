<%@ page import="java.util.*,com.customattributes.*"%>
<%@ page import="org.json.*"%>

<%!
public class TicketsJsonBuilder{
	public void fillPayTypes(Vector paytypes,JSONObject obj,String selectedPaytype){
	try{
	JSONObject payTypesObj=new JSONObject();
	for(int i=0;i<paytypes.size();i++){
	HashMap hm=(HashMap)paytypes.elementAt(i);
	if(hm!=null&&hm.size()>0){
	if("other".equals((String)hm.get("paytype"))){
	payTypesObj.put((String)hm.get("paytype"),(String)hm.get("desc"));
	}
	else
	payTypesObj.put((String)hm.get("paytype"),"Y");
	}
	}
	payTypesObj.put("payselected",selectedPaytype);
	obj.put("paymenttypes",payTypesObj);
	}
	catch(Exception e){
	}
	}
	
	public void fillDiscountDetails(List couponsList,JSONObject obj,String selectedDiscountcode){
	JSONObject DiscountsObj=new JSONObject();
	try{
	for(int i=0;i<couponsList.size();i++){
	if("General".equals((String)couponsList.get(i))){
	DiscountsObj.put("IsCouponsExists","Y");
	}
	if("Member".equals((String)couponsList.get(i))){
	DiscountsObj.put("IsMemberDiscountsExists","Y");
	}
	}
	DiscountsObj.put("discountcode",selectedDiscountcode);
	
	if(selectedDiscountcode!=null&&selectedDiscountcode.length()>0)
	{
	DiscountsObj.put("discountapplied","Y");
	DiscountsObj.put("discountmsg","");
	}
	
	obj.put("discounts",DiscountsObj);
	}
	catch(Exception e){
	}
	}
	void fillAmountDetails(HashMap amountsMap, JSONObject jsonObj){
		JSONObject obj=new JSONObject();
		try{
		obj.put("totamount",amountsMap.get("totamount"));
		obj.put("disamount",amountsMap.get("disamount"));
		obj.put("netamount",amountsMap.get("netamount"));
		obj.put("tax",amountsMap.get("tax"));
		obj.put("grandtotamount",amountsMap.get("grandtotamount"));
		jsonObj.put("amounts",obj);
		}
		catch(Exception e){
		
		}
	}
	
	void fillGroupTicketsArry(String groupType,JSONObject JsonObj,ArrayList ticketGroupsArray){
		try{
			JSONArray ticketGroupsArrayObj=new JSONArray();
			for(int i=0; i<ticketGroupsArray.size();i++){
				HashMap ticketGroupMap=(HashMap)ticketGroupsArray.get(i);
				JSONObject ticketGroupObj=new JSONObject();
				ticketGroupObj.put("group_name",ticketGroupMap.get("groupname"));
				ticketGroupObj.put("ticket_groupid",ticketGroupMap.get("ticket_groupid"));
				ticketGroupObj.put("group_desc",ticketGroupMap.get("group_desc"));
				Vector groupTickets=(Vector)ticketGroupMap.get("Tickets");
				if(groupTickets!=null&&groupTickets.size()>0){
				JSONArray ticketsArrayObj=new JSONArray();
				for(int k=0;k<groupTickets.size();k++){
				HashMap ticketMap=(HashMap)groupTickets.elementAt(k);
				JSONObject ticketObj=new JSONObject();
				ticketObj.put("ticket_name",ticketMap.get("ticket_name"));  
				ticketObj.put("ticket_price",ticketMap.get("ticket_price"));   
				ticketObj.put("ticket_id",ticketMap.get("price_id")); 
				ticketObj.put("ticket_type",ticketMap.get("ticket_type")); 
				ticketObj.put("processing_fee",ticketMap.get("process_fee"));   
				ticketObj.put("final_price",ticketMap.get("final_price"));   
				ticketObj.put("discount",ticketMap.get("discount"));
				ticketObj.put("capacity",ticketMap.get("max_ticket")); 
				ticketObj.put("min_qty",ticketMap.get("min_qty")); 
				ticketObj.put("max_qty",ticketMap.get("max_qty")); 
				ticketObj.put("sold_qty",ticketMap.get("sold_qty"));
				ticketObj.put("isdonation",ticketMap.get("isdonation"));
				
				if(ticketMap.get("selected")!=null)
					ticketObj.put("selected",ticketMap.get("selected"));
				if(ticketMap.get("selectedqty")!=null){
					ticketObj.put("selectedqty",ticketMap.get("selectedqty"));
				}
				if(ticketMap.get("donationprice")!=null){
				ticketObj.put("donationprice",ticketMap.get("donationprice"));
				}
				else
				ticketObj.put("donationprice","0.00");
				
				
				ticketObj.put("description",ticketMap.get("description")); 
				ticketObj.put("isMemberTicket",ticketMap.get("isMemberTicket")); 				
				ticketsArrayObj.put(ticketObj);
				}
				ticketGroupObj.put("tickets",ticketsArrayObj);
				ticketGroupsArrayObj.put(ticketGroupObj);
				}
				
			}
			JsonObj.put(groupType,ticketGroupsArrayObj);
		}catch(Exception e){}
	}

	void fillCustomAttribs(Vector customattribs, HashMap customattribOptionsMap, JSONObject attributesArrayObj,String profileOptions){
		try{
		
		        JSONObject profilesetObject=new JSONObject();
			JSONArray customAttributesArrayObj=new JSONArray();
			String attrib_setid="";
			for(int k=0;k<customattribs.size();k++){
			JSONObject attributesObj=new JSONObject();
			CustomAttributes cb=(CustomAttributes)customattribs.get(k);
			attributesObj.put("question",cb.getAttributeName());		
			attributesObj.put("type",cb.getAttributeType());
			attributesObj.put("req","Required".equals(cb.getIsRequired())?"Y":"N");
			attrib_setid=cb.getAttribSetId();
			if("text".equals(cb.getAttributeType()))
			attributesObj.put("textbox_size",cb.getTextBoxSize());
			else if("textarea".equals(cb.getAttributeType())){
			attributesObj.put("rows",cb.getRows());		
			attributesObj.put("cols",cb.getCols());
			}
			else{
			//String [] customattribOptions=cb.getOptions();
			String [] customattribOptions=(String [])customattribOptionsMap.get(cb.getAttribId());
			if(customattribOptions!=null&&customattribOptions.length>0){
			JSONArray optionsArrayObj=new JSONArray();
			for(int p=0;p<customattribOptions.length;p++){
			optionsArrayObj.put(customattribOptions[p].replaceAll("'","\\\\\'"));
			}
			attributesObj.put("options",optionsArrayObj);
			}
			}
			customAttributesArrayObj.put(attributesObj);
			}
			profilesetObject.put("collectAll",profileOptions);
			profilesetObject.put("attribsetid",attrib_setid);
			profilesetObject.put("attribs",customAttributesArrayObj);
			attributesArrayObj.put("profileset",profilesetObject);

		}
		catch(Exception e){
			System.out.println("Exception in Fill Json Custom attrib info"+e.getMessage());
		}
	}

void fillselectedProfileInfo(Vector profileResponses,JSONObject profilesAttributesObj){
 try{
JSONArray profileArray=new JSONArray();
for(int i=0;i<profileResponses.size();i++){
HashMap attendeeMap=(HashMap)profileResponses.elementAt(i);
JSONObject profileObject=new JSONObject();
profileObject.put("fname",attendeeMap.get("fname"));
profileObject.put("lname",attendeeMap.get("lname"));
profileObject.put("email",attendeeMap.get("email"));
profileObject.put("phone",attendeeMap.get("phone"));
profileObject.put("attendeekey",attendeeMap.get("attendeekey"));
profileObject.put("attendeeid",attendeeMap.get("attendeeid"));
Vector attrinresponse=(Vector)attendeeMap.get("customreponses");
JSONArray CustomResponsesArray=new JSONArray();
if(attrinresponse!=null&&attrinresponse.size()>0){
for(int j=0;j<attrinresponse.size();j++){
HashMap qmap=(HashMap)attrinresponse.elementAt(j);
JSONObject answerObject=new JSONObject();
if(qmap!=null&&qmap.size()>0){
answerObject.put("q",qmap.get("question"));
answerObject.put("A",qmap.get("answer"));
CustomResponsesArray.put(answerObject);
}
}
}
profileObject.put("attribresponses",CustomResponsesArray);
profileArray.put(profileObject);
 }
 profilesAttributesObj.put("profiledata",profileArray);
 }
 catch(Exception e)
 {
 System.out.println("Exception in fillselectedProfileInfo"+e.getMessage());
 }
 }
}
%>