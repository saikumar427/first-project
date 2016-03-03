package com.eventbee.general;

import java.util.HashMap;

import com.eventbee.util.CoreConnector;

public class OTPMailThread implements Runnable{
	HashMap<String, String> paramMap=new HashMap<String, String>();
	public OTPMailThread(HashMap<String, String> hm){
		paramMap=hm;
	}

	@Override
	public void run() {
		
		try{
			String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
			CoreConnector cc1=new CoreConnector("http://"+serveraddress+"/attendee/utiltools/sendOtpMail.jsp");
			cc1.setArguments(paramMap);
			cc1.setTimeout(50000);
			String data=cc1.MGet();
		}catch(Exception e){
			System.out.println("Exception Occured while Sending buyer OtpMail:"+e.getMessage());
		}
	}

}
