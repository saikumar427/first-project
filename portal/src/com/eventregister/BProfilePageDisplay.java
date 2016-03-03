package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONObject;
import com.customquestions.BCustomAttribsDB;
import com.customquestions.beans.BAttribOption;
import com.customquestions.beans.BCustomAttribSet;
import com.customquestions.beans.BCustomAttribute;
import com.event.dbhelpers.BDisplayAttribsDB;
import com.eventbee.general.DBManager;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
public class BProfilePageDisplay {
	public JSONObject getProfilesJson(String tid,String eid){
		JSONArray buyerDetails=new JSONArray();
		JSONArray ticketsDetails=new JSONArray();


		ArrayList<String> buyerAttribs=null;
		ArrayList<String> ticketAtts=null;
		
		HashMap<String,ArrayList<String>> ticketSpecificAttIds=null;
		BRegistrationTiketingManager regManager=new BRegistrationTiketingManager();
		BCustomAttribsDB ticketCustomAtts=new BCustomAttribsDB();
		ArrayList<HashMap<String, String>> selectedTickets=regManager.getSelectedTickets(tid);
		System.out.println("selectedtickets"+selectedTickets);

		JSONObject profilesetObject=new JSONObject();
		

		try{
			HashMap<String,String> profilePageLabels=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
			BCustomAttribSet customAttribs=(BCustomAttribSet)ticketCustomAtts.getCustomAttribSet(eid,"EVENT" );
			BCustomAttribute[]  attributeSet=customAttribs.getAttributes();


			HashMap<String,HashMap<String, String>> allTicketAtts=getAttribsForAllTickets(eid);
			ticketSpecificAttIds=ticketCustomAtts.getTicketLevelAttributes(eid);		
			
			

			for(int i=0;i<selectedTickets.size();i++){
				JSONArray questionArray=new JSONArray();				
				JSONObject ticketOject=new JSONObject();				
				HashMap<String, String> profileMap=(HashMap<String, String>)selectedTickets.get(i);
				String selecedticket=(String)profileMap.get("selectedTicket");
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

					if(ticketAtts!=null&&attributeSet!=null&&attributeSet.length>0){	

						for(int k=0;k<attributeSet.length;k++){ //make loop through all attribute set
							BCustomAttribute cb=(BCustomAttribute)attributeSet[k];
							
							if(ticketAtts.contains(cb.getAttribId())){	// if ticket attribute in all attribute set					

								JSONObject attributesObj=new JSONObject();
								attributesObj.put("label",cb.getAttributeName());
								attributesObj.put("type",cb.getAttributeType());
								attributesObj.put("required","Required".equals(cb.getisRequired())?"y":"n");

								attributesObj.put("id",cb.getAttribId());
								if("text".equals(cb.getAttributeType())){

								}

								else if("textarea".equals(cb.getAttributeType())){

								}
								else{
									ArrayList<BAttribOption>  customattribOptions=cb.getOptions();
									if(customattribOptions!=null&&customattribOptions.size()>0){
										JSONArray optionsArrayObj=new JSONArray();
										for(int p=0;p<customattribOptions.size();p++){
											BAttribOption option=(BAttribOption)customattribOptions.get(p);
											JSONObject optionObj=new JSONObject();
											optionObj.put("display",option.getOptionValue());
											optionObj.put("value",option.getOptionid());
											optionsArrayObj.put(optionObj);
										}
										if("select".equals(cb.getAttributeType()))
											attributesObj.put("validate","n");
										attributesObj.put("options",optionsArrayObj);
									}
								}
								questionArray.put(attributesObj);
								//profilesetObject.put(selecedticket+"_"+cb.getAttribId(),attributesObj);
								//questionArray.put(cb.getAttribId());
							}

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
				if(questionArray.length()!=0){
					JSONArray profiles= new JSONArray();
					for(int q=0;q<qty;q++){
						profiles.put(new JSONObject().put("seat_code","NA").put("attendee_key", ""));						
					}
					ticketOject.put("profiles", profiles);
					ticketsDetails.put(ticketOject);
				}
			}			

			profilesetObject.put("attendee_questions",ticketsDetails);


			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
			HashMap<Object,Object> attribMap=getAttribsForTickets("0",eid);
			String isRequired=(String)attribMap.get("phone");
			System.out.println("phone"+isRequired);
			buyerDetails.put(getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",isRequired));
			
			buyerAttribs=regManager.getBuyerSpecificAttribs(eid);
			if(attributeSet!=null&&attributeSet.length>0){
				for(int k=0;k<attributeSet.length;k++){
					
					JSONObject attributesObj=new JSONObject();
					BCustomAttribute cb=(BCustomAttribute)attributeSet[k];
					attributesObj.put("type",cb.getAttributeType());
					attributesObj.put("id",cb.getAttribId());
					attributesObj.put("label",cb.getAttributeName());
					attributesObj.put("required","Required".equals(cb.getisRequired())?"y":"n");
					attributesObj.put("isactive",cb.getIsActive());
					attributesObj.put("attrib_shortform",cb.getAttributeName_shortForm());

					if("text".equals(cb.getAttributeType())){

					}

					else if("textarea".equals(cb.getAttributeType())){

					}
					else{
						ArrayList<BAttribOption>  customAttOptions=cb.getOptions();
						if(customAttOptions!=null&&customAttOptions.size()>0){
							JSONArray optionsArrayObj=new JSONArray();
							for(int p=0;p<customAttOptions.size();p++){
								BAttribOption option=(BAttribOption)customAttOptions.get(p);
								JSONObject optionObj=new JSONObject();
								optionObj.put("display",option.getOptionValue());
								optionObj.put("value",option.getOptionid());
								optionsArrayObj.put(optionObj);
							}
							if("select".equals(cb.getAttributeType()))
								attributesObj.put("validate","n");
							attributesObj.put("options",optionsArrayObj);
						}
					}
					if(buyerAttribs!=null&&buyerAttribs.contains(cb.getAttribId())){
						buyerDetails.put(attributesObj);						
					}
				}
			}
						profilesetObject.put("buyer_questions",buyerDetails);
		}
		catch(Exception e)
		{
			System.out.println("Exception occured in getting profileJson Is"+e.getMessage());
		}
		return profilesetObject;
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

}