package com.eventbee.widget;

import java.util.HashMap;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONException;
import org.json.JSONObject;
import com.eventbee.layout.EventGlobalTemplates;
public class RenderMyticketsWidgetHTML implements RenderWidgetHTML{
	@Override
	public String getHTML(HashMap<String, String> refHash,
		HashMap<String, String> dataHash, HashMap<String, String> configHash) throws JSONException  {
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		JSONObject options = new JSONObject(config_options.getString("mytickets"));
		String tid=refHash.get("tid");
		String eventid=refHash.get("eventid");
		String token=refHash.get("token");
		String description = options.getString("des");
		String btnLbl = options.getString("btnLbl");
		VelocityContext vc = new VelocityContext();
		vc.put("descrip",description);
		vc.put("btnLbl",btnLbl);
		vc.put("tid", tid);
		vc.put("eid", eventid);
		vc.put("token", token);
		
		String template=configHash.get("global_template_mytickets");
		if(template==null || "".equals(template.trim()))
			   template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_mytickets");
		return getVelocityOutPut(vc,template);
	}
	
	@Override
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash) {
		// TODO Auto-generated method stub
		return true;
	}
	
	private static String getVelocityOutPut(VelocityContext vc,String template){
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"mytickets",template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("Exception in getVelocityOutPut for RenderMyticketsWidgetHTML ERROR: "+e.getMessage());
		}
		return str.toString();
	}
}
