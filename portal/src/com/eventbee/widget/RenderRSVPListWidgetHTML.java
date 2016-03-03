package com.eventbee.widget;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONArray;
import org.json.JSONObject;

import com.eventbee.layout.EventGlobalTemplates;

public class RenderRSVPListWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject rsvplist = new JSONObject(config_options.getString("RSVPList"));
		JSONArray chkarray = rsvplist.getJSONArray("chkflds");
		ArrayList<String> chkvals = new ArrayList<String>();
		String showgender="Y";
		for(int i=0;i<chkarray.length();i++)
			chkvals.add(chkarray.getString(i));
		if(!chkvals.contains("fbmfcount"))
			showgender="N";
		
		System.out.println("RenderRSVPListWidgetHTML");
		String eid=refHash.get("eventid");
		String serveraddress=refHash.get("serveraddress");
		String template=configHash.get("global_template_rsvplist");
		if(template==null || "".equals(template.trim()))
		   template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_rsvplist");
		VelocityContext vc = new VelocityContext();
		vc.put("eid", eid);
		vc.put("serveraddress", serveraddress);
		
		String result=getVelocityOutPut(vc,template);
		return result;
	}

	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			 {
		try{
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		if(!config_options.has("RSVPList"))
			return false;
		
		JSONObject rsvplist = new JSONObject(config_options.getString("RSVPList"));
		if(!rsvplist.has("fbeventid") || !rsvplist.has("chkflds"))
			return false;
		String fbeventid=rsvplist.get("fbeventid").toString();
		JSONArray chkarray = rsvplist.getJSONArray("chkflds");
		ArrayList<String> chkvals = new ArrayList<String>();
		for(int i=0;i<chkarray.length();i++)
			chkvals.add(chkarray.getString(i));
		
		if(fbeventid== null || "".equals(fbeventid) || !chkvals.contains("fbatt")){
			return false;
		}
		// TODO Auto-generated method stub
		return true;
		}catch(Exception e){
			return false;
		}
	}
	
	private static String getVelocityOutPut(VelocityContext vc,String template){
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"fbrsvplist",template);
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("fbrsvplist exception: "+e.getMessage());
		}
			return str.toString();
	}

}
