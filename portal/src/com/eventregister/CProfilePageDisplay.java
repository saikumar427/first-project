package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.customquestions.CCustomAttribsDB;
import com.customquestions.beans.BCustomAttribute;
import com.customquestions.beans.CAttribOption;
import com.customquestions.beans.CCustomAttribSet;
import com.customquestions.beans.CCustomAttribute;
import com.event.dbhelpers.CDisplayAttribsDB;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
public class CProfilePageDisplay {
	
	public static final String BUYER="buyer";
	public static final String ATTENDEE="attendee";
	private HashMap profilePageLabels=new HashMap();
	
	public HashMap getProfilePageLabels() {
		return profilePageLabels;
	}

	public void setProfilePageLabels(HashMap profilePageLabels) {
		this.profilePageLabels = profilePageLabels;
	}
	
	public JSONObject getProfilesJson(String tid,String eid){

		JSONArray buyerDetails=new JSONArray();
		JSONArray ticketsDetails=new JSONArray();
		ArrayList<String> buyerAttribs=null;
		ArrayList<String> ticketAtts=null;
		HashMap<String,ArrayList<String>> ticketSpecificAttIds=null;
		CRegistrationTiketingManager regTktMgr=new CRegistrationTiketingManager();
		CCustomAttribsDB ticketCustomAtts = new CCustomAttribsDB();
		ArrayList selectedTickets=regTktMgr.getSelectedTickets(tid);
		JSONObject profilesetObject=new JSONObject();
		
		try{
			try{
				//Map ticketSettingsMap=CacheManager.getData(eid, "ticketsettings");
				//profilePageLabels=(HashMap)ticketSettingsMap.get("RegFlowWordingsMap");
				
				profilePageLabels=CDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
				
				profilesetObject.put("promotionsectionmessage",GenUtil.getHMvalue(profilePageLabels,"promotion.section.message","I would like to receive promotions and " +
						"discounts from Eventbee and its partners."));
				profilesetObject.put("promotionsectionheader",GenUtil.getHMvalue(profilePageLabels,"ebee.promotions.header","Promotions"));
				profilesetObject.put("buyerheader",GenUtil.getHMvalue(profilePageLabels,"event.reg.buyerinfo.label","Buyer Information"));
				profilesetObject.put("profilecountinue",GenUtil.getHMvalue(profilePageLabels,"event.reg.profilepage.continue.label","Countine"));
				profilesetObject.put("profileheader",GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.page.Header","Profile"));
				profilesetObject.put("backbutton",GenUtil.getHMvalue(profilePageLabels,"event.reg.backbutton.label","Back To Tickets Page"));
				profilesetObject.put("Required", GenUtil.getHMvalue(profilePageLabels, "event.reg.requiredprofile.empty.msg","Required Field"));
			}catch(Exception e){
				System.out.println("Exception in ProfilePageDisplay getProfilesJson eventid: "+eid+" ERROR: "+e.getMessage());
			}
			
			CCustomAttribSet customAttribs=(CCustomAttribSet)ticketCustomAtts.getCustomAttribSet(eid,"EVENT");
			HashMap<String, CCustomAttribute> attributeSet = customAttribs.getAttributes();
			
			
			HashMap<String,HashMap<String, String>> allTicketAtts=getAttribsForAllTickets(eid);
			ticketSpecificAttIds=ticketCustomAtts.getTicketLevelAttributes(eid);	
			
			JSONObject attendeeDetails=new JSONObject();
			JSONObject attendeeCustomDetails = new JSONObject();
			
			if(!"".equals(tid)){
				attendeeDetails=regTktMgr.getAttendeeDetails(tid);
				attendeeCustomDetails=regTktMgr.getAttendeeCustomDetails(eid,tid);
			}
			
			for(int i=0;i<selectedTickets.size();i++){
				JSONArray questionArray=new JSONArray();				
				JSONObject ticketOject=new JSONObject();				
				HashMap<String, String> profileMap=(HashMap<String, String>)selectedTickets.get(i);
				String selecedticket=(String)profileMap.get("selectedTicket");
				String ticketName=(String)profileMap.get("ticketName");
				HashMap<String, String> hmap=null;//getAttribsForTickets(selecedticket,eid);
				
				if(allTicketAtts.get(selecedticket)!=null)
					hmap=(HashMap<String, String>)allTicketAtts.get(selecedticket);
				if(hmap!=null&&hmap.size()>0){
					String fisrequired=(String)hmap.get("fname");
					if(fisrequired!=null){
						questionArray.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname",fisrequired));
						//ticketOject.put("fname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname",fisrequired));
					}
					String lisrequired=(String)hmap.get("lname");
					if(lisrequired!=null){
						//ticketOject.put("lname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname",lisrequired));
						questionArray.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname",lisrequired));
					}
					String emailisrequired=(String)hmap.get("email");
					if(emailisrequired!=null){
						//ticketOject.put("email",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email",emailisrequired));
						questionArray.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email",emailisrequired));
					}
					String phoneisrequired=(String)hmap.get("phone");
					if(phoneisrequired!=null){
						//ticketOject.put("phone",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",phoneisrequired));
						questionArray.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",phoneisrequired));
					}
				}
				
				if(ticketSpecificAttIds!=null&&ticketSpecificAttIds.containsKey(selecedticket)){
					ticketAtts=(ArrayList<String>)ticketSpecificAttIds.get(selecedticket);

					if(ticketAtts!=null&&attributeSet!=null&&attributeSet.size()>0){
						for(int k=0;k<ticketAtts.size();k++){ //make loop through all attribute set
							CCustomAttribute cb=attributeSet.get(ticketAtts.get(k));
								JSONObject attributesObj=new JSONObject();
								fillQuestionObject(cb,questionArray,attributeSet,attributesObj,null,ATTENDEE);	
						}//k end 
					}

				}
				int qty=0;
				try{
				qty=Integer.parseInt(profileMap.get("qty"));
				}
				catch(Exception e){
					
				}
				ticketOject.put("qty",qty);
				ticketOject.put("questions", questionArray);
				ticketOject.put("ticket_id",selecedticket );
				ticketOject.put("ticket_name",ticketName);

				if(questionArray.length()!=0){
					JSONArray profiles= new JSONArray();
					for(int q=0;q<qty;q++){
						JSONObject jsonObj=null;
						if(attendeeDetails.has(selecedticket)){
							if(attendeeDetails.getJSONArray(selecedticket).length()>q){
							jsonObj=attendeeDetails.getJSONArray(selecedticket).getJSONObject(q);
							String attendeekey=jsonObj.has("profile_key")?jsonObj.get("profile_key")+"".trim():"";
							jsonObj=regTktMgr.getFinalResonse(attendeekey,jsonObj,attendeeCustomDetails);
							profiles.put(jsonObj);
							}else{
							profiles.put(new JSONObject().put("seat_code","NA").put("attendee_key","").put("response",new JSONObject()));
							}
						}else{
							System.out.println("in new CASE::");
							profiles.put(new JSONObject().put("seat_code","NA").put("attendee_key","").put("response",new JSONObject()));
					}

					}

					ticketOject.put("profiles", profiles);
					ticketsDetails.put(ticketOject);
				}
			
			}
			profilesetObject.put("attendee_questions",ticketsDetails);
            HashMap bdetails=regTktMgr.getBuyerDeails(tid);
            
            buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
			HashMap<Object,Object> attribMap=getAttribsForTickets("0",eid);
			String isRequired=(String)attribMap.get("phone");
			System.out.println("attribMap.isEmpty() - "+attribMap.isEmpty());
			if(attribMap.isEmpty()==false){
				buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",isRequired));
			}
			
			buyerAttribs=regTktMgr.getBuyerSpecificAttribs(eid);
			
			JSONObject buyerCustomResponses=regTktMgr.getbuyerCustomResponses(eid,tid);
			
			if(buyerAttribs!=null && attributeSet!=null&&attributeSet.size()>0){
				for(int k=0;k<buyerAttribs.size();k++){
					
					CCustomAttribute cb=attributeSet.get(buyerAttribs.get(k));
					JSONObject attributesObj=new JSONObject();
					
					fillQuestionObject(cb, buyerDetails, attributeSet,attributesObj,buyerCustomResponses,BUYER);
				}
			}
			profilesetObject.put("buyer_questions",buyerDetails);
		}catch(Exception e){
			System.out.println("Exception occured in getting profileJson Is"+e.getMessage());
		}
		return profilesetObject;
	}
	
	
	public HashMap<String,HashMap<String, String>> getAttribsForAllTickets(String eid){
		HashMap<String,HashMap<String, String>> ticketAttribsMap=new HashMap<String,HashMap<String,String>>();
		String query="select contextid,attribid,isrequired from base_profile_questions where groupid=?::BIGINT";
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query, new String[]{eid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				String ticketid=db.getValue(i,"contextid","");
				if(ticketAttribsMap.containsKey(ticketid)){
					HashMap<String,String> attribMap=(HashMap<String,String>)ticketAttribsMap.get(ticketid);
					attribMap.put(db.getValue(i,"attribid",""),db.getValue(i,"isrequired",""));
				}
				else{
					HashMap<String,String> attribMap=new HashMap<String,String>();
					attribMap.put(db.getValue(i,"attribid",""),db.getValue(i,"isrequired",""));
					ticketAttribsMap.put(ticketid, attribMap);
				}
			}
		}
		return ticketAttribsMap;
	}
	
	public  void fillQuestionObject(CCustomAttribute customAttribute,JSONArray mainArray,HashMap<String,CCustomAttribute> attributeSet ,JSONObject attributesObj,JSONObject buyerCustomResponses,String module){
		try{
			
			attributesObj.put("label",customAttribute.getAttributeName());
			attributesObj.put("type",customAttribute.getAttributeType());
			attributesObj.put("required","Required".equals(customAttribute.getisRequired())?"y":"n");
			attributesObj.put("id",customAttribute.getAttribId());
			if(BUYER.equals(module)){
				JSONObject customResponses = new JSONObject();
				if(buyerCustomResponses.has(customAttribute.getAttribId()))
					customResponses = buyerCustomResponses.getJSONObject(customAttribute.getAttribId());
				if("checkbox".equals(customAttribute.getAttributeType()))
					attributesObj.put("response",customResponses.has("response")?customResponses.get("response"):new JSONObject());
				else
					attributesObj.put("response",customResponses.has("response")?customResponses.get("response"):"");
			}
			if("text".equals(customAttribute.getAttributeType())){
			}
			else if("textarea".equals(customAttribute.getAttributeType())){
			}
			else{
				ArrayList<CAttribOption>  customattribOptions=customAttribute.getOptions();
				if(customattribOptions!=null&&customattribOptions.size()>0){
					JSONArray optionsArrayObj=new JSONArray();
					for(int p=0;p<customattribOptions.size();p++){
						CAttribOption option=(CAttribOption)customattribOptions.get(p);
						JSONObject optionObj=new JSONObject();
						optionObj.put("display",option.getOptionValue());
						optionObj.put("value",option.getOptionid());
						if(option.getSubQuestions().length>0){
							JSONArray subQuestions=new JSONArray();
							
							System.out.println("option.getSubQuestions - - - "+option.getSubQuestions());
							
							for(int sub=0;sub<option.getSubQuestions().length;sub++){	
								//System.out.println("attrib_id"+option.getSubQuestions()[sub]+"</end>");
								if(!"".equals(option.getSubQuestions()[sub])){
									CCustomAttribute cb=attributeSet.get(option.getSubQuestions()[sub]);	
									JSONObject subQuestion=new JSONObject();
									fillQuestionObject(cb,subQuestions,attributeSet,subQuestion,buyerCustomResponses,module);
								}
							}
							if(subQuestions.length()>0)
								optionObj.put("sub_questions",subQuestions);
						}
						optionsArrayObj.put(optionObj);
					}
					if("select".equals(customAttribute.getAttributeType()))
						attributesObj.put("validate","n");
					attributesObj.put("options",optionsArrayObj);
				}
			}
			mainArray.put(attributesObj);
		}catch(Exception e){
		}
	}
	
	public JSONObject getAttendeeObject(String question,String id,String isRequired){
		JSONObject obj=new JSONObject();
		try{
			obj.put("id",id);
			obj.put("label",question);
			obj.put("type","text");
			obj.put("required",("Y".equals(isRequired)?"y":"n"));			
		}
		catch(Exception e){}
		return obj;
	}
	
	public HashMap<Object,Object> getAttribsForTickets(String ticketid,String eid){
		HashMap<Object,Object> hm=new HashMap<Object,Object>();
		String query="select attribid,isrequired from base_profile_questions where contextid=CAST(? AS INTEGER) and groupid=CAST(? AS BIGINT)";
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query, new String[]{ticketid,eid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				hm.put(db.getValueFromRecord(i,"attribid",""),db.getValueFromRecord(i,"isrequired",""));
			}
		}
		return hm;
	}

}
