package com.eventbee.widget;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

public class RenderTextWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException {
		
		String refid = refHash.get("refid");
		//System.out.println("ref id text wiget::"+refid);
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		//System.out.println("config optionsn text widget::"+config_options.toString());
		//added for WYSIWYG Editor
		JSONObject jsonText = new JSONObject(config_options.getString("text_"+refid));
		String tempate = jsonText.getString("templatedata");
		return tempate;
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) throws Exception{
		// TODO Auto-generated method stub
		String refid = refHash.get("refid");
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		String textdata=config_options.getString("text_"+refid);
		if(textdata==null || "".equals(textdata.trim()))
			return false;
		
		return true;
	}

}
