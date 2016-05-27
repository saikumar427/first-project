package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.customquestions.CCustomAttribsDB;
import com.customquestions.beans.CAttribOption;
import com.customquestions.beans.CCustomAttribSet;
import com.customquestions.beans.CCustomAttribute;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.GenUtil;

public class CSubmitProfileJSON {
	public JSONObject doSubmitProfileAction( String tid ,String eid,String edate,String seatingEnabled,String buyerInfo,String attendeeInfo,String userAgent) throws JSONException{	 

		if(seatingEnabled==null||"".equals(seatingEnabled)){
			seatingEnabled="n";	
		}	
		if(edate==null){
			edate="";	
		}	
		JSONObject responseJSON=new JSONObject();

		if(tid==null||"".equals(tid)||eid==null||"".equals(eid)){
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "required parameters missing");			
			return responseJSON;			
		}
		
		String dbJSON="";
		JSONObject buyerJSON=null;
		JSONObject attendeeJSON=null;
		try{
			buyerJSON=new JSONObject(buyerInfo);
		}catch(Exception e){
			buyerJSON=new JSONObject();
		}
		try{
			attendeeJSON=new JSONObject(attendeeInfo);
		}catch(Exception e){
			attendeeJSON=new JSONObject();
		}
		dbJSON=buyerJSON.toString()+attendeeJSON.toString();	

		try {
			DbUtil.executeUpdateQuery("insert into querystring_temp (tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",
					new String[] { tid,userAgent,dbJSON, "CSubmitProfileJSON.java" });
		} catch (Exception e) {
			System.out.println("(Box office) error in CSubmitProfileJSON.java(tid: " + tid + ") inserting  query string" + e.getMessage());
		}
		
		System.out.println("after querystring_temp entry");
		CRegistrationTiketingManager regManager = new CRegistrationTiketingManager();
		CProfileActionDB profileActionDB= new CProfileActionDB();	

		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO,"CSubmitProfileJSON.java","(Box office) Entered profile action page with  the transaction---------"
						+ tid, "", null);
	
		String buyerFname="";
		String buyerLname = "";
		String buyerEmail="";
		String buyerPhone = "";

		try{
			if(buyerJSON.has("fname")){
				if(buyerJSON.getJSONObject("fname").getString("value")!=null)
					buyerFname=buyerJSON.getJSONObject("fname").getString("value");
			}
			if(buyerJSON.has("lname")){
				if(buyerJSON.getJSONObject("lname").getString("value")!=null)
					buyerLname=buyerJSON.getJSONObject("lname").getString("value");
			}
			
			try{
				if(buyerJSON.has("email")){
					if(buyerJSON.getJSONObject("email").getString("value")!=null)
						buyerEmail=buyerJSON.getJSONObject("email").getString("value");
				}
				if(buyerJSON.has("phone")){
					if(buyerJSON.getJSONObject("phone").getString("value")!=null)
						buyerPhone=buyerJSON.getJSONObject("phone").getString("value");
				}
			}
			catch(Exception e){

			}


		}catch(Exception e){
			String missing = "<br/>missing:<br/>\n\n buyername:"+ buyerFname+ " email:"+ buyerEmail+ " eid: " + eid+ "  tid: " + tid;
			DbUtil.executeUpdateQuery("insert into event_reg_empty_profile_info (tid,useragent,created_at) values (?,?,now())",
					new String[] {tid,userAgent+ missing });			

			/*responseJSON.put("status", "fail");
			responseJSON.put("reason", "iiinvalid params");
			return responseJSON;*/

		}


		System.out.println(" after collecting buyer info: " + tid);



		boolean status = true;
		ArrayList<HashMap<String, String>>  selTicketsList = regManager.getSelectedTickets(tid);
		
		HashMap<String,ArrayList<String>> seatingTickets = null;
		if ("Y".equalsIgnoreCase(seatingEnabled)) {		
			seatingTickets = profileActionDB.getSeatingCodeDetails(eid, tid, edate,selTicketsList);
		}
		/*else{
			seatingTickets=new HashMap<String,ArrayList<String>>();
		}*/

		CCustomAttribsDB ticketCustomAttribs = new CCustomAttribsDB();
		CCustomAttribSet customAttribsInfo = (CCustomAttribSet) ticketCustomAttribs.getCustomAttribSet(eid, "EVENT");
		HashMap<String,CCustomAttribute> customAttributes = customAttribsInfo.getAttributes();
		HashMap<String,ArrayList<String>> ticketSpecificAttributeIds  = ticketCustomAttribs.getTicketLevelAttributes(eid);
		profileActionDB.clearDBEntries(tid);

		try {	

			String buyer_profileid = DbUtil.getVal(	"select nextval('SEQ_attendeeid')", new String[] {});

			for (int i = 0; i < selTicketsList.size(); i++) {		

				HashMap<String, String> ticketData =  selTicketsList.get(i);
				ArrayList<String> seatingData=null;		
				String ticketId = (String) ticketData.get("selectedTicket");
				String ticketType = (String) ticketData.get("type");
				String count = (String) ticketData.get("qty");
				JSONObject ticketLevelAnswers=null;
				try{
					ticketLevelAnswers=attendeeJSON.getJSONObject(ticketId);
				}catch(Exception e){
				 ticketLevelAnswers=new JSONObject();
					System.out.println("error in getting ticket level answers");

				}


				String attendeeIds[] = DbUtil.getSeqVals("seq_attendeeId",Integer.parseInt(count));

				ArrayList<String> attribListOfTicket =  ticketSpecificAttributeIds.get(ticketId);
				String seatCode = "", seatIndex = "";
				if("y".equalsIgnoreCase(seatingEnabled))
					seatingData =  seatingTickets.get(ticketId);

				for (int index = 0; index < Integer.parseInt(count); index++) {

					JSONObject qtyLevel=null;
					try{
						qtyLevel=ticketLevelAnswers.getJSONObject("qty_"+(index+1));
					}catch(Exception e){
						qtyLevel=new JSONObject();
					}

					HashMap<String,String> basicProfile = new HashMap<String,String>();
					if("y".equalsIgnoreCase(seatingEnabled)){	
						try{
						seatCode = (String) seatingData.get(index);
						}catch(Exception e){seatCode = "";}
					} else{
						seatCode = "";
					}
					basicProfile.put("seatcode", seatCode);
					String attendeeKey = "AK"+ EncodeNum.encodeNum(attendeeIds[index]).toUpperCase();
					try{
						if(qtyLevel.has("fname")){
							if(qtyLevel.getJSONObject("fname").getString("value")!=null)
								basicProfile.put("fname", qtyLevel.getJSONObject("fname").getString("value"));									
						}
						else{
							basicProfile.put("fname", buyerFname);
						}

					}
					catch(Exception e){
						basicProfile.put("fname", buyerFname);
					}

					try{
						if(qtyLevel.has("lname")){
							if(qtyLevel.getJSONObject("lname").getString("value")!=null)
								basicProfile.put("lname", qtyLevel.getJSONObject("lname").getString("value"));									
						}
						else{
							basicProfile.put("lname", buyerLname);
						}

					}
					catch(Exception e){
						basicProfile.put("lname", buyerLname);
					}


					try{
						if(qtyLevel.has("email")){
							if(qtyLevel.getJSONObject("email").getString("value")!=null)
								basicProfile.put("email", qtyLevel.getJSONObject("email").getString("value"));									
						}
						else{
							basicProfile.put("email", buyerEmail);
						}

					}
					catch(Exception e){
						basicProfile.put("email", buyerEmail);
					}


					try{
						if(qtyLevel.has("phone")){
							if(qtyLevel.getJSONObject("phone").getString("value")!=null)
								basicProfile.put("phone", qtyLevel.getJSONObject("phone").getString("value"));									
						}
						else{
							basicProfile.put("phone", buyerPhone);
						}

					}
					catch(Exception e){
						basicProfile.put("phone", buyerPhone);
					}
					basicProfile.put("profileid", attendeeIds[index]);
					basicProfile.put("profilekey", attendeeKey);
					basicProfile.put("eventid", eid);
					basicProfile.put("tid", tid);
					basicProfile.put("ticketid", ticketId);
					basicProfile.put("tickettype", ticketType);
					basicProfile.put("profile_setid", buyer_profileid);

					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "CSubmitProfile.java", "(Box Office)before Updating  profile data---------"+tid+"--------"+basicProfile, "", null);

					if ("y".equalsIgnoreCase(seatingEnabled)) {
						try {
							ArrayList<String> seating = seatingTickets.get(ticketId + "_index");
							if (seating.get(index) != null || !"null".equals(seating.get(index)))
								seatIndex=(String) seating.get(index);
						} catch (Exception e) {	seatIndex="";}
					}		
					basicProfile.put("seat_index", seatIndex);
					profileActionDB.updateBaseProfile(basicProfile);
					

					if (customAttributes != null && customAttributes.size() > 0) {
						if (attribListOfTicket != null && attribListOfTicket.size() > 0) {
							HashMap<String,String> responseMasterMap = new HashMap<String,String>();
							String responseId = DbUtil.getVal("select nextval('attributes_survey_responseid')",	null);
							responseMasterMap.put("responseid", responseId);
							responseMasterMap.put("tid", tid);
							responseMasterMap.put("eventid", eid);
							responseMasterMap.put("profileid",attendeeIds[index]);
							responseMasterMap.put("profilekey", attendeeKey);
							responseMasterMap.put("ticketid", ticketId);
							responseMasterMap.put("custom_setid",customAttribsInfo.getAttribSetid());

							/*db*/	profileActionDB.InsertResponseMaster(responseMasterMap);

							
							for (int j = 0; j < attribListOfTicket.size(); j++) {
								CCustomAttribute cb = (CCustomAttribute) customAttributes.get(attribListOfTicket.get(j));
								fillAnswerMap(cb,qtyLevel,profileActionDB,responseId,customAttributes);

							}
						}
					}//custom attributes greater than zero end
				}
			} //selected Tickets loop close 

			String profilekey = "AK"
					+ EncodeNum.encodeNum(buyer_profileid).toUpperCase();
			HashMap<String,String> buyerBasInfo = new HashMap<String,String>();
			buyerBasInfo.put("fname", buyerFname);
			buyerBasInfo.put("lname", buyerLname);
			buyerBasInfo.put("email", buyerEmail);
			buyerBasInfo.put("phone", buyerPhone);
			buyerBasInfo.put("profileid", buyer_profileid);
			buyerBasInfo.put("profilekey", profilekey);
			buyerBasInfo.put("tid", tid);
			buyerBasInfo.put("eventid", eid);
			//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "before Updating  buyer data---------"+tid+"--------"+buyerBasInfo, "", null);

			/*db*/profileActionDB.inserBuyerInfo(buyerBasInfo);
			System.out.println("after buyer info insertion");		


			ArrayList<String> buyerAttribs = regManager.getBuyerSpecificAttribs(eid);

			if (customAttributes != null && customAttributes.size() > 0&& buyerAttribs != null && buyerAttribs.size() > 0) {
				String responseId = DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
				HashMap<String,String> buyerResponsemaster = new HashMap<String,String>();
				buyerResponsemaster.put("responseid", responseId);
				buyerResponsemaster.put("ticketid", "0");
				buyerResponsemaster.put("profileid", buyer_profileid);
				buyerResponsemaster.put("eventid", eid);
				buyerResponsemaster.put("profilekey", profilekey);
				buyerResponsemaster.put("tid", tid);
				buyerResponsemaster.put("custom_setid", customAttribsInfo.getAttribSetid());

				profileActionDB.InsertResponseMaster(buyerResponsemaster);
				
				for (int j = 0; j < buyerAttribs.size(); j++) {					
						CCustomAttribute cb = (CCustomAttribute) customAttributes.get(buyerAttribs.get(j));
						fillAnswerMap(cb,buyerJSON,profileActionDB,responseId,customAttributes);				
				}
			}
		} catch (Exception e) {
			status = false;
			System.out.println("Exception In  PROFILE SUBMISSION(tid" + tid + ")" + e.getMessage());

		}
		if (status){
			responseJSON.put("status", "success");			
		}
		else{
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "invalid params");
		}
		return responseJSON;


	}
	
	private void  fillAnswerMap(CCustomAttribute cb, JSONObject level,CProfileActionDB profileActionDB,String responseId,HashMap<String,CCustomAttribute> customAttributes) throws JSONException{
		String shortresponse = null;
		String bigresponse = null;
										
			String questionid = cb.getAttribId();
			String question = cb.getAttributeName();
			String type = cb.getAttributeType();
			ArrayList<CAttribOption> options = cb.getOptions();				
			
			if(level.has(questionid)&&level.getJSONObject(questionid).has("value")){									
				try{
					//if( qtyLevel.get("value") instanceof JSONArray ){}
					if("text".equals(type)||"textarea".equals(type)){
						shortresponse = level.getJSONObject(questionid).get("value").toString();										
						bigresponse = level.getJSONObject(questionid).get("value").toString();
					}
					else if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
						String[] responses=null;
						try{
							if("radio".equals(type)||"select".equals(type)){
								responses=new String[]{level.getJSONObject(questionid).get("value").toString()};
							}else if("checkbox".equals(type))													
								responses=getStringArray(level.getJSONObject(questionid).getJSONArray("value"));																									
							if(responses!=null){
								String responsesVal[]=profileActionDB.getOptionVal(options,responses);
								shortresponse=GenUtil.stringArrayToStr(responses,",");
								bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
							}
						}catch(Exception e){
							shortresponse = level.getJSONObject(questionid).get("value").toString();										
							bigresponse = level.getJSONObject(questionid).get("value").toString();							
						}												
					}
				}catch(Exception e){
					shortresponse = "";										
					bigresponse = "";
				}

				HashMap<String,String> responseMap = new HashMap<String,String>();
				responseMap.put("question", question);
				responseMap.put("questionid", questionid);
				responseMap.put("shortresponse",shortresponse);
				responseMap.put("bigresponse",bigresponse);
				responseMap.put("responseid", responseId);

				/**/	profileActionDB.insertResponse(responseMap);				
			
				if(options!=null&&options.size()>0){
					JSONArray optionsArrayObj=new JSONArray();
					for(int p=0;p<options.size();p++){
						CAttribOption option=(CAttribOption)options.get(p);
						JSONObject optionObj=new JSONObject();
						if(option.getSubQuestions().length>0){
							JSONArray subQuestions=new JSONArray();
							for(int sub=0;sub<option.getSubQuestions().length;sub++){	
								if(!"".equals(option.getSubQuestions()[sub])){
									CCustomAttribute eachAttrib=customAttributes.get(option.getSubQuestions()[sub]);
									fillAnswerMap(eachAttrib,level,profileActionDB,responseId,customAttributes);
								}
							}
							if(subQuestions.length()>0)
								optionObj.put("sub_questions",subQuestions);
						}
						optionsArrayObj.put(optionObj);
					}
				}
			}
	}
	
	
	public static String[] getStringArray(JSONArray jsonArray) throws JSONException{
	    String[] stringArray = null;
	    int length = jsonArray.length();
	    if(jsonArray!=null){
	    	stringArray = new String[length];
	        for(int i=0;i<length;i++){
	            stringArray[i]= jsonArray.getString(i);
	        }
	    }
	    return stringArray;
	}
}
