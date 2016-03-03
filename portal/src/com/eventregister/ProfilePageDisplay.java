package com.eventregister;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.customquestions.CustomAttribsDB;
import com.customquestions.beans.AttribOption;
import com.customquestions.beans.CustomAttribSet;
import com.customquestions.beans.CustomAttribute;
import com.event.dbhelpers.DisplayAttribsDB;
import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.regcaheloader.BaseProfileLoader;
import com.eventbee.regcaheloader.TicketSettingsLoader;
public class ProfilePageDisplay{
	private HashMap profilePageLabels=new HashMap();
	
	public HashMap getProfilePageLabels() {
		return profilePageLabels;
	}

	public void setProfilePageLabels(HashMap profilePageLabels) {
		this.profilePageLabels = profilePageLabels;
	}

	public String getProfilesJson(String tid,String eid){		
		ArrayList buyerAttribs=null;
		ArrayList al=null;
		HashMap ticketspecificAttributeIds=null;
		RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
		CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
		ArrayList selectedTickets=regTktMgr.getSelectedTickets(tid);
		JSONArray ticketsArray=new JSONArray();
		JSONObject profilesetObject=new JSONObject();
		JSONObject profileCount=new JSONObject();
		JSONObject questionObj=new JSONObject();
		try{
			//HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
			//HashMap profilePageLabels=null;
			try{
				Map ticketSettingsMap=CacheManager.getData(eid, "ticketsettings");
				profilePageLabels=(HashMap)ticketSettingsMap.get("RegFlowWordingsMap");
			}catch(Exception e){
				System.out.println("Exception in ProfilePageDisplay getProfilesJson eventid: "+eid+" ERROR: "+e.getMessage());
			}
			Map baseProfilesMap=getBaseProfileMap(eid);
			//CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eid,"EVENT" );
			CustomAttribSet customattribs=(CustomAttribSet)baseProfilesMap.get("customattribset");
			CustomAttribute[]  attributeSet=customattribs.getAttributes();
			//HashMap allticketatribs=getAttribsForAllTickets(eid);
			
			HashMap allticketatribs=(HashMap)baseProfilesMap.get("attribsforalltickets");
			//ticketspecificAttributeIds=ticketcustomattribs.getTicketLevelAttributes(eid);
			ticketspecificAttributeIds=(HashMap)baseProfilesMap.get("ticketlevelattributes");
			for(int i=0;i<selectedTickets.size();i++){
				JSONArray questionArray=new JSONArray();
				HashMap profileMap=(HashMap)selectedTickets.get(i);
				String selecedticket=(String)profileMap.get("selectedTicket");
				HashMap hmap=null;//getAttribsForTickets(selecedticket,eid);
				if(allticketatribs.get(selecedticket)!=null)
					hmap=(HashMap)allticketatribs.get(selecedticket);
				if(hmap!=null&&hmap.size()>0){
					String fisrequired=(String)hmap.get("fname");
					if(fisrequired!=null){
						questionArray.put("fname");
						profilesetObject.put(selecedticket+"_fname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname",fisrequired));
					}
					String lisrequired=(String)hmap.get("lname");
					if(lisrequired!=null){
						profilesetObject.put(selecedticket+"_lname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname",lisrequired));
						questionArray.put("lname");
					}
					String emailisrequired=(String)hmap.get("email");
					if(emailisrequired!=null){
						profilesetObject.put(selecedticket+"_email",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email",emailisrequired));
						questionArray.put("email");
					}
					String phoneisrequired=(String)hmap.get("phone");
					if(phoneisrequired!=null){
						profilesetObject.put(selecedticket+"_phone",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",phoneisrequired));
						questionArray.put("phone");
					}
				}
				if(ticketspecificAttributeIds!=null&&ticketspecificAttributeIds.containsKey(selecedticket)){
					al=(ArrayList)ticketspecificAttributeIds.get(selecedticket);
					if(attributeSet!=null&&attributeSet.length>0){
						for(int k=0;k<attributeSet.length;k++){
							HashMap customMap=new HashMap();
							JSONObject attributesObj=new JSONObject();
							CustomAttribute cb=(CustomAttribute)attributeSet[k];
							customMap.put("qType",cb.getAttributeType());
							customMap.put("qId",cb.getAttribId());
							attributesObj.put("lblText",cb.getAttributeName());
							attributesObj.put("type",cb.getAttributeType());
							attributesObj.put("Required","Required".equals(cb.getisRequired())?"Y":"N");
							attributesObj.put("ErrorMsg",GenUtil.getHMvalue(profilePageLabels,"event.reg.requiredprofile.empty.msg","Required"));
							attributesObj.put("StarColor","red");
							attributesObj.put("Id",cb.getAttribId());
							String attrib_setid=cb.getAttribSetId();
							if("text".equals(cb.getAttributeType()))
								attributesObj.put("textboxsize",cb.getTextboxSize());
							else if("textarea".equals(cb.getAttributeType())){
								attributesObj.put("rows",cb.getRows());
								attributesObj.put("cols",cb.getCols());
							}
							else{
								ArrayList  customattribOptions=cb.getOptions();
								if(customattribOptions!=null&&customattribOptions.size()>0){
									JSONArray optionsArrayObj=new JSONArray();
									for(int p=0;p<customattribOptions.size();p++){
										AttribOption option=(AttribOption)customattribOptions.get(p);
										JSONObject optionObj=new JSONObject();
										optionObj.put("Display",option.getOptionValue());
										optionObj.put("Value",option.getOptionid());
										optionsArrayObj.put(optionObj);
									}
									if("select".equals(cb.getAttributeType()))
										attributesObj.put("Validate","N");
									attributesObj.put("Options",optionsArrayObj);
								}
							}
							if((al!=null&&al.contains(cb.getAttribId()))){
								profilesetObject.put(selecedticket+"_"+cb.getAttribId(),attributesObj);
								questionArray.put(cb.getAttribId());
							}
						}
					}
				}
				profileCount.put(selecedticket,profileMap.get("qty"));
				ticketsArray.put(selecedticket);
				questionObj.put(selecedticket,questionArray);
			}
			profilesetObject.put("profilecount",profileCount);
			profilesetObject.put("questions",questionObj);
			profilesetObject.put("tickets",ticketsArray);
			profilesetObject.put("buyer_fname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
			profilesetObject.put("buyer_lname",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
			profilesetObject.put("buyer_email",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
			//HashMap attribMap=getAttribsForTickets("0",eid);
			HashMap attribMap=(HashMap)baseProfilesMap.get("attribsfortickets");
			String isRequired=(String)attribMap.get("phone");
			profilesetObject.put("buyer_phone",getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",isRequired));
			JSONArray buyerarray=new JSONArray();
			buyerarray.put("fname");
			buyerarray.put("lname");
			buyerarray.put("email");
			buyerarray.put("phone");
			buyerAttribs=regTktMgr.getBuyerSpecificAttribs(eid);
			if(attributeSet!=null&&attributeSet.length>0){
				for(int k=0;k<attributeSet.length;k++){
					HashMap customMap=new HashMap();
					JSONObject attributesObj=new JSONObject();
					CustomAttribute cb=(CustomAttribute)attributeSet[k];
					customMap.put("qType",cb.getAttributeType());
					customMap.put("qId",cb.getAttribId());
					attributesObj.put("lblText",cb.getAttributeName());
					attributesObj.put("type",cb.getAttributeType());
					attributesObj.put("Required","Required".equals(cb.getisRequired())?"Y":"N");
					attributesObj.put("Id",cb.getAttribId());
					attributesObj.put("isactive",cb.getIsActive());
					attributesObj.put("attrib_shortForm",cb.getAttributeName_shortForm());
					attributesObj.put("ErrorMsg",GenUtil.getHMvalue(profilePageLabels,"event.reg.requiredprofile.empty.msg","Required"));
					attributesObj.put("StarColor","red");
					String attrib_setid=cb.getAttribSetId();
					if("text".equals(cb.getAttributeType()))
						attributesObj.put("textboxsize",cb.getTextboxSize());
					else if("textarea".equals(cb.getAttributeType())){
						attributesObj.put("rows",cb.getRows());
						attributesObj.put("cols",cb.getCols());
					}
					else{
						ArrayList  customattribOptions=cb.getOptions();
						if(customattribOptions!=null&&customattribOptions.size()>0){
							JSONArray optionsArrayObj=new JSONArray();
							for(int p=0;p<customattribOptions.size();p++){
								AttribOption option=(AttribOption)customattribOptions.get(p);
								JSONObject optionObj=new JSONObject();
								optionObj.put("Display",option.getOptionValue());
								optionObj.put("Value",option.getOptionid());
								optionsArrayObj.put(optionObj);
							}
							if("select".equals(cb.getAttributeType()))
								attributesObj.put("Validate","N");
							attributesObj.put("Options",optionsArrayObj);
						}
					}
					if(buyerAttribs!=null&&buyerAttribs.contains(cb.getAttribId())){
						profilesetObject.put("buyer_"+cb.getAttribId(),attributesObj);
						buyerarray.put(cb.getAttribId());
					}
				}
			}
			profilesetObject.put("buyerquest",buyerarray);
		}
		catch(Exception e)
		{
			System.out.println("Exception occured in getting profileJson Is"+e.getMessage());
		}
		return profilesetObject.toString();
	}

	public JSONObject getAttendeeObject(String question,String id,String isRequired){
		JSONObject obj=new JSONObject();
		try{
			obj.put("Id",id);
			obj.put("textboxsize","30");
			obj.put("lblText",question);
			obj.put("txtValue","");
			obj.put("type","text");
			obj.put("Required",("Y".equals(isRequired)?"Y":"N"));
			obj.put("ErrorMsg",GenUtil.getHMvalue(profilePageLabels,"event.reg.requiredprofile.empty.msg","Required"));
			obj.put("StarColor","red");
		}
		catch(Exception e){}
		return obj;
	}
	public JSONObject getRSVPAttendeeObject(String question,String id,String isRequired){
		JSONObject obj=new JSONObject();
		try{
			obj.put("Id",id);
			obj.put("textboxsize","30");
			obj.put("lblText",question);
			obj.put("txtValue","");
			obj.put("type","text");
			obj.put("Required",("Y".equals(isRequired)?"Y":"N"));
			obj.put("ErrorMsg",GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.error.message","Required"));
			obj.put("StarColor","red");
		}
		catch(Exception e){}
		return obj;
	}
	public HashMap getAttribsForTickets(String ticketid,String eid){
		HashMap hm=new HashMap();
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
	
	public Map getBaseProfileMap(String eid){
		
		if(!CacheManager.getInstanceMap().containsKey("baseprofiles")){
			CacheLoader cacheLoader=new BaseProfileLoader();
			cacheLoader.setRefreshInterval(3*60*1000);
			cacheLoader.setMaxIdleTime(3*60*1000);
			CacheManager.getInstanceMap().put("baseprofiles",cacheLoader);		
		}
		Map baseProfilesMap=CacheManager.getData(eid, "baseprofiles");
		int t=0;
		while(baseProfilesMap==null && t<20){
			try {
			    Thread.sleep(200);
			    baseProfilesMap=CacheManager.getData(eid, "baseprofiles");
			    t++;
			} catch(InterruptedException ex) {
				System.out.println("InterruptedException in ProfilePageDisplay getBaseProfileMap: eventid: "+eid+" iteration: "+t+" Exception: "+ex.getMessage());
			    Thread.currentThread().interrupt();
			}
		}
		
		return baseProfilesMap;
	}
}