package com.event.i18n.dbmanager;

import java.util.HashMap;

import com.eventbee.general.DbUtil;
import com.eventbee.interfaces.I18NWrapper;

public class ConfirmationPageDAO implements I18NWrapper{

	@Override
	public HashMap<String, Object> getData(HashMap<String, String> hm, String lang, String eid) {
		String content="";
		content=DbUtil.getVal("select content from custom_reg_flow_templates where eventid=CAST(? AS BIGINT) and purpose=?", new String[]{eid,hm.get("purpose")});
		if("null".equals(content) || "".equals(content) || content==null){
			content=DbUtil.getVal("select content from default_reg_flow_templates where purpose=? and lang=?", new String[]{hm.get("purpose"),lang});
		}
		if(content==null || "".equals(content.trim())){
			content=DbUtil.getVal("select content from default_reg_flow_templates where purpose=? and lang=?", new String[]{hm.get("purpose"),"en_US"});
		}
		HashMap<String, Object> contentMap=new HashMap<String, Object>();
		contentMap.put("content", content);
		return contentMap;
	}

}
