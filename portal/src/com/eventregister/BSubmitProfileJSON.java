package com.eventregister;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.customquestions.beans.BAttribOption;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.customquestions.beans.BCustomAttribute;
import com.customquestions.beans.BCustomAttribSet;
import com.customquestions.BCustomAttribsDB;
import com.eventbee.general.EventbeeLogger;
import com.eventregister.BProfileActionDB;
import com.eventregister.BRegistrationTiketingManager;
import java.util.ArrayList;

import java.util.HashMap;


public class BSubmitProfileJSON {

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
			DbUtil
			.executeUpdateQuery(
					"insert into querystring_temp (tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",
					new String[] { tid,
							userAgent,
							dbJSON, "profileformaction.jsp" });
		} catch (Exception e) {
			System.out.println("(Box office) error in profileformaction.jsp(tid: " + tid
					+ ") inserting  query string" + e.getMessage());
		}
		
		System.out.println("after querystring_temp entry");
		BRegistrationTiketingManager regManager = new BRegistrationTiketingManager();
		BProfileActionDB profileActionDB= new BProfileActionDB();	

		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO,
				"profileformaction.jsp",
				"(Box office) Entered profile action page with  the transaction---------"
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
			String missing = "<br/>missing:<br/>\n\n buyername:"
					+ buyerFname
					+ " email:"
					+ buyerEmail
					+ " eid: " + eid
					+ "  tid: " + tid;
			DbUtil
			.executeUpdateQuery(
					"insert into event_reg_empty_profile_info (tid,useragent,created_at) values (?,?,now())",
					new String[] {
							tid,
							userAgent
							+ missing });			

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

		BCustomAttribsDB ticketCustomAttribs = new BCustomAttribsDB();
		BCustomAttribSet customAttribsInfo = (BCustomAttribSet) ticketCustomAttribs
				.getCustomAttribSet(eid, "EVENT");
		BCustomAttribute[] customAttributes = customAttribsInfo.getAttributes();
		HashMap<String,ArrayList<String>> ticketSpecificAttributeIds  = ticketCustomAttribs
				.getTicketLevelAttributes(eid);

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

					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "(Box Office)before Updating  profile data---------"+tid+"--------"+basicProfile, "", null);

					if ("y".equalsIgnoreCase(seatingEnabled)) {
						try {
							ArrayList<String> seating = seatingTickets.get(ticketId + "_index");
							if (seating.get(index) != null
									|| !"null".equals(seating.get(index)))
								seatIndex=(String) seating.get(index);
						} catch (Exception e) {	seatIndex="";}
					}		
					basicProfile.put("seat_index", seatIndex);
					profileActionDB.updateBaseProfile(basicProfile);
					

					if (customAttributes != null && customAttributes.length > 0) {
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

							String shortresponse = null;
							String bigresponse = null;
							for (int j = 0; j < customAttributes.length; j++) {
								shortresponse = null;
								bigresponse = null;
								BCustomAttribute cb = (BCustomAttribute) customAttributes[j];
								if (attribListOfTicket.contains(cb.getAttribId())) {
									String questionid = cb.getAttribId();
									String question = cb.getAttributeName();
									String type = cb.getAttributeType();
									ArrayList<BAttribOption> options = cb.getOptions();
										
									if(qtyLevel.has(questionid)&&qtyLevel.getJSONObject(questionid).has("value")){									
										try{
											//if( qtyLevel.get("value") instanceof JSONArray ){}
											if("text".equals(type)||"textarea".equals(type)){
												shortresponse = qtyLevel.getJSONObject(questionid).get("value").toString();										
												bigresponse = qtyLevel.getJSONObject(questionid).get("value").toString();
											}
											else if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
												String[] responses=null;
												try{
													if("radio".equals(type)||"select".equals(type)){
														responses=new String[]{qtyLevel.getJSONObject(questionid).get("value").toString()};
													}else if("checkbox".equals(type))													
														responses=getStringArray(qtyLevel.getJSONObject(questionid).getJSONArray("value"));																									
													if(responses!=null){
														String responsesVal[]=profileActionDB.getOptionVal(options,responses);
														shortresponse=GenUtil.stringArrayToStr(responses,",");
														bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
													}
												}catch(Exception e){
													shortresponse = qtyLevel.getJSONObject(questionid).get("value").toString();										
													bigresponse = qtyLevel.getJSONObject(questionid).get("value").toString();
													
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
									}

								}
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

			if (customAttributes != null && customAttributes.length > 0
					&& buyerAttribs != null && buyerAttribs.size() > 0) {
				String responseId = DbUtil.getVal(
						"select nextval('attributes_survey_responseid')",
						null);
				HashMap<String,String> buyerResponsemaster = new HashMap<String,String>();
				buyerResponsemaster.put("responseid", responseId);
				buyerResponsemaster.put("ticketid", "0");
				buyerResponsemaster.put("profileid", buyer_profileid);
				buyerResponsemaster.put("eventid", eid);
				buyerResponsemaster.put("profilekey", profilekey);
				buyerResponsemaster.put("tid", tid);
				buyerResponsemaster.put("custom_setid", customAttribsInfo.getAttribSetid());

				/*db*/	profileActionDB.InsertResponseMaster(buyerResponsemaster);

				String bigResponse = null;
				String shortResponse = null;
				for (int j = 0; j < customAttributes.length; j++) {
					shortResponse = null;
					bigResponse = null;
					BCustomAttribute cb = (BCustomAttribute) customAttributes[j];
					if (buyerAttribs.contains(cb.getAttribId())) {
						String questionid = cb.getAttribId();
						String question = cb.getAttributeName();
						String type = cb.getAttributeType();
						ArrayList<BAttribOption> options = cb.getOptions();
						if(buyerJSON.has(questionid)&& buyerJSON.getJSONObject(questionid).has("value")){	
							try {
								if("text".equals(type)||"textarea".equals(type)){
									shortResponse = buyerJSON
											.getJSONObject(questionid)
											.get("value").toString();
									bigResponse = buyerJSON
											.getJSONObject(questionid)
											.get("value").toString();
								} 	
								else if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
									String[] responses=null;
									try{
										if("radio".equals(type)||"select".equals(type)){
											responses=new String[]{ buyerJSON.getJSONObject(questionid).get("value").toString()};
										}else if("checkbox".equals(type))
											responses=getStringArray(buyerJSON.getJSONObject(questionid).getJSONArray("value"));
										if(responses!=null){
											String responsesVal[]=profileActionDB.getOptionVal(options,responses);
											shortResponse=GenUtil.stringArrayToStr(responses,",");
											bigResponse=GenUtil.stringArrayToStr(responsesVal,",");
										}
									}catch(Exception e){
										shortResponse = buyerJSON.getJSONObject(questionid).get("value").toString();										
										bigResponse = buyerJSON.getJSONObject(questionid).get("value").toString();										
									}
								}
							} catch (Exception e) {
								shortResponse = "";
								bigResponse = "";
							}
	
							HashMap<String, String> buyerResponse = new HashMap<String, String>();
							buyerResponse.put("question", question);
							buyerResponse.put("questionid", questionid);
							buyerResponse.put("shortresponse", shortResponse);
							buyerResponse.put("bigresponse", bigResponse);
							buyerResponse.put("responseid", responseId);
							if (bigResponse != null
									&& !"".equals(bigResponse.trim()))
								profileActionDB.insertResponse(buyerResponse);
						}
					}
				}
			}
		} catch (Exception e) {
			status = false;
			System.out.println("Exception In  PROFILE SUBMISSION(tid" + tid
					+ ")" + e.getMessage());

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
