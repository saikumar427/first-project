package com.event.i18n.dbmanager;

import java.util.HashMap;

import com.eventbee.general.DBManager;
import com.eventbee.general.StatusObj;
import com.eventbee.interfaces.I18NWrapper;

public class ConfirmationEmailDAO implements I18NWrapper{
	
	static final String GET_DEFAULT_EMAIL_TEMPLATE="SELECT fromemail,replytoemail,textformat,htmlformat,subjectformat from default_email_templates where purpose=? and lang=?";
	static final String GET_CUSTOM_EMAIL_TEMPLATE="SELECT fromemail,replytoemail,textformat,htmlformat,subjectformat from custom_email_templates where groupid=? and purpose=?";
	
	@Override
	public HashMap<String, Object> getData(HashMap<String, String> hm,String lang, String eid) {
		DBManager dbmanager=new DBManager();
		StatusObj statobj=null;
		HashMap<String, String> emailTemplate=new HashMap<String, String>();
		if("N".equals(hm.get("isCustomFeature"))){
			statobj=dbmanager.executeSelectQuery(GET_DEFAULT_EMAIL_TEMPLATE,new String[]{hm.get("purpose"),lang});
			if(statobj != null && statobj.getStatus() && statobj.getCount()>0){}
			else{
				statobj=dbmanager.executeSelectQuery(GET_DEFAULT_EMAIL_TEMPLATE,new String[]{hm.get("purpose"),"en_US"});
			}
		}else{
			statobj=dbmanager.executeSelectQuery(GET_CUSTOM_EMAIL_TEMPLATE,new String[]{eid,hm.get("purpose")});
			if(statobj != null && statobj.getStatus() && statobj.getCount()>0){}
			else{
				statobj=dbmanager.executeSelectQuery(GET_DEFAULT_EMAIL_TEMPLATE,new String[]{hm.get("purpose"),lang});
				if(statobj != null && statobj.getStatus() && statobj.getCount()>0){}
				else{
					statobj=dbmanager.executeSelectQuery(GET_DEFAULT_EMAIL_TEMPLATE,new String[]{hm.get("purpose"),"en_US"});
				}
			}
		}
		
		emailTemplate.put("fromMail", dbmanager.getValue(0,"fromemail",""));
		emailTemplate.put("replyToMail", dbmanager.getValue(0,"replytoemail",""));
		emailTemplate.put("textFormat", dbmanager.getValue(0,"textformat",""));
		emailTemplate.put("htmlFormat", dbmanager.getValue(0,"htmlformat",""));
		emailTemplate.put("subjectFormat", dbmanager.getValue(0,"subjectformat",""));
		
		HashMap<String, Object> data=new HashMap<String, Object>();
		data.put("emailTemplate", emailTemplate);
		return data;
	}

}
