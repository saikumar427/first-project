<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.json.JSONObject"%>
<%!
public HashMap getSeatingCodeDetails(String eid,String tid,String eventdate,String ticketids){
	String []arrayticketids=ticketids.split(",");
	HashMap seatingdetails=new HashMap();
	if(" ".equals(eventdate))eventdate="";
	String query="select seatcode,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT))";
	if(!"".equals(eventdate)){
		query="select seatcode,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT) and eventdate=?)";		
	}
	DBManager db=new DBManager();
	StatusObj Sel_tic_sb;	
	for(int k=0;k<arrayticketids.length;k++){
		ArrayList seatcodes=new ArrayList();
		ArrayList seatindex=new ArrayList();
		String ticketid=arrayticketids[k];
		if(!"".equals(eventdate))
			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid,eventdate});
		else
			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid});
		if(Sel_tic_sb.getStatus()&&Sel_tic_sb.getCount()>0){
			for(int i=0;i<Sel_tic_sb.getCount();i++){
				String seatcode=db.getValue(i, "seatcode", "");
				seatcodes.add(seatcode);
				seatindex.add(db.getValue(i, "seatindex", ""));
			}
			
		}
		seatingdetails.put(ticketid, seatcodes);
		seatingdetails.put(ticketid+"_index", seatindex);
	}
	
	return seatingdetails;
}

%>
<%
String tid=request.getParameter("tid");
Map reqmapnet=request.getParameterMap();
		String totalqstr="";
		Iterator iterator = reqmapnet.keySet().iterator();
		while (iterator.hasNext()) {
				String key = (String) iterator.next();
				totalqstr=totalqstr+key+":{";
				String[] stringArray = (String[])reqmapnet.get(key);
				 
				 for(int i=0;i<stringArray.length;i++)
				  {
				  if(i==stringArray.length-1)
				   totalqstr=totalqstr+stringArray[i];
				   else
				  totalqstr=totalqstr+stringArray[i]+",";
				  }totalqstr=totalqstr+"} ";
	}
	 try{
			StatusObj sb=DbUtil.executeUpdateQuery("insert into querystring_temp (tid,useragent,created_at,querystring,jsp) values (?,?,now(),?,?)",new String[]{tid, request.getHeader("User-Agent"),totalqstr,"profileformaction.jsp"});
		}catch(Exception eq){System.out.println("error in profileformaction.jsp(tid: "+tid+") inserting  query string"+eq.getMessage());}


RegistrationDBHelper regprodb=new RegistrationDBHelper();
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
JSONObject obj =new JSONObject();
ProfileActionDB profiledbaction=new ProfileActionDB();

String eid=request.getParameter("eid");
String enablepromotion=request.getParameter("enablepromotion");
String seatingenabled=request.getParameter("seatingenabled");
String ticketids=request.getParameter("ticketids");
String eventdate=request.getParameter("eventdate");



EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "Entered profile action page with  the transaction---------"+tid, "", null);
if(request.getParameter("q_buyer_email_1")==null||"".equals(request.getParameter("q_buyer_email_1"))||request.getParameter("q_buyer_fname_1")==null||"".equals(request.getParameter("q_buyer_fname_1"))||request.getParameter("eid")==null||"".equals(request.getParameter("eid"))||request.getParameter("tid")==null||"".equals(request.getParameter("tid"))){
	
	
		try{
		String missing="<br/>missing:<br/>\n\n buyername:"+request.getParameter("q_buyer_fname_1")+" email:"+request.getParameter("q_buyer_email_1")+" eid: "+request.getParameter("eid")+"  tid: "+request.getParameter("tid");
			StatusObj sb=DbUtil.executeUpdateQuery("insert into event_reg_empty_profile_info (tid,useragent,created_at) values (?,?,now())",new String[]{tid, request.getHeader("User-Agent")+missing});
		}catch(Exception e){}
		obj.put("status","Fail");
		out.print(obj.toString());

		return ;
		
	}

ArrayList buyerAttribs=regTktMgr.getBuyerSpecificAttribs(eid);
boolean status=true;



ArrayList ticketsList=regTktMgr.getSelectedTickets(tid);
HashMap seatingtickets=null;
if("YES".equals(seatingenabled)){
	//seatingtickets=regTktMgr.getSeatingCodeDetails(eid,tid,eventdate,ticketids);
	seatingtickets=getSeatingCodeDetails(eid,tid,eventdate,ticketids);
	
}

HashMap responseMasterMap=new HashMap();
HashMap ticketspecificAttributeIds=null;
ArrayList ticketlevelbaseProfiles=regTktMgr.getTicketIdsForBaseProfiles(eid);
String custom_setid=request.getParameter("attribsetid");
CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
ticketspecificAttributeIds=ticketcustomattribs.getTicketLevelAttributes(eid);
profiledbaction.clearDBEntries(tid);
try{
		String buyerfname=request.getParameter("q_buyer_fname_1");
		String buyerlname=request.getParameter("q_buyer_lname_1");
		String buyeremail=request.getParameter("q_buyer_email_1");
		String buyerphone=request.getParameter("q_buyer_phone_1");
		String buyer_profileid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
		for(int i=0;i<ticketsList.size();i++){
			HashMap hmap=(HashMap)ticketsList.get(i);
			String ticketid=(String)hmap.get("selectedTicket");
			String tickettype=(String)hmap.get("type");
			String count=(String)hmap.get("qty");
			String attendeeids[]=DbUtil.getSeqVals("seq_attendeeId",Integer.parseInt(count));
			ArrayList attriblist=(ArrayList)ticketspecificAttributeIds.get(ticketid);
			
			String seatcode="",seatindex="";
				
				
			
			for(int index=0;index<Integer.parseInt(count);index++){
				HashMap basicProfile=new HashMap();
				
				try{
					ArrayList seating=(ArrayList) seatingtickets.get(ticketid);
					seatcode=(String)seating.get(index);
					
				}catch(Exception e){
					seatcode="";
				}
				 basicProfile.put("seatcode",seatcode);
		
				String attendeeKey="AK"+EncodeNum.encodeNum(attendeeids[index]).toUpperCase();
				
				if(request.getParameter("q_"+ticketid+"_fname_"+(index+1))!=null)
					basicProfile.put("fname",request.getParameter("q_"+ticketid+"_fname_"+(index+1)));
				else
					basicProfile.put("fname",buyerfname);
				if(request.getParameter("q_"+ticketid+"_lname_"+(index+1))!=null)
					basicProfile.put("lname",request.getParameter("q_"+ticketid+"_lname_"+(index+1)));
				else
					basicProfile.put("lname",buyerlname);
				if(request.getParameter("q_"+ticketid+"_email_"+(index+1))!=null)
					basicProfile.put("email",request.getParameter("q_"+ticketid+"_email_"+(index+1)));
				else
					basicProfile.put("email",buyeremail);
				if(request.getParameter("q_"+ticketid+"_phone_"+(index+1))!=null)
					basicProfile.put("phone",request.getParameter("q_"+ticketid+"_phone_"+(index+1)));
				else
					basicProfile.put("phone",buyerphone);
				
				basicProfile.put("profileid",attendeeids[index]);
				basicProfile.put("profilekey",attendeeKey);
				basicProfile.put("eventid",eid);
				basicProfile.put("tid",tid);
				basicProfile.put("ticketid",ticketid);
				basicProfile.put("tickettype",tickettype);
				basicProfile.put("profile_setid",buyer_profileid);
				//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "before Updating  profile data---------"+tid+"--------"+basicProfile, "", null);
				profiledbaction.updateBaseProfile(basicProfile);
				
				if("YES".equals(seatingenabled)){
					try{
						ArrayList seating=(ArrayList) seatingtickets.get(ticketid+"_index");
						if(seating.get(index)!=null||!"null".equals(seating.get(index)))
						DbUtil.executeUpdateQuery("update profile_base_info set seatindex=? where eventid=CAST(? AS BIGINT) and profilekey=? and transactionid=?",new String[]{(String)seating.get(index),eid,attendeeKey,tid});
					}catch(Exception e){
					
					}
				}	
				
				if(attributeSet!=null&&attributeSet.length>0){
					if(attriblist!=null&&attriblist.size()>0){
						String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
						responseMasterMap.put("responseid",responseId);
						responseMasterMap.put("tid",tid);
						responseMasterMap.put("eventid",eid);
						responseMasterMap.put("profileid",attendeeids[index]);
						responseMasterMap.put("profilekey",attendeeKey);
						responseMasterMap.put("ticketid",ticketid);
						responseMasterMap.put("custom_setid",custom_setid);
						profiledbaction.InsertResponseMaster(responseMasterMap);
						String shortresponse=null;
						String bigresponse=null;
						for(int j=0;j<attributeSet.length;j++){
							shortresponse=null;
							bigresponse=null;
							CustomAttribute cb=(CustomAttribute)attributeSet[j];
							if(attriblist.contains(cb.getAttribId())){
								String questionid=cb.getAttribId();
								String question=cb.getAttributeName();
								String type=cb.getAttributeType();
								ArrayList options=cb.getOptions();
								if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
									String responses[]=request.getParameterValues("q_"+ticketid+"_"+questionid+"_"+(index+1));
									if(responses!=null){
									String responsesVal[]=profiledbaction.getOptionVal(options,responses);
									shortresponse=GenUtil.stringArrayToStr(responses,",");
									bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
									}
								}
								else{
									shortresponse=request.getParameter("q_"+ticketid+"_"+questionid+"_"+(index+1));
									bigresponse=request.getParameter("q_"+ticketid+"_"+questionid+"_"+(index+1));
								}
								HashMap respnseMap=new HashMap();
								respnseMap.put("question",question);
								respnseMap.put("questionid",questionid);
								respnseMap.put("shortresponse",shortresponse);
								respnseMap.put("bigresponse",bigresponse);
								respnseMap.put("responseid",responseId);
								if(bigresponse!=null && !"".equals(bigresponse.trim()))
									profiledbaction.insertResponse(respnseMap);
							}
						}
					}  
				}
			}
		}  

		
		String profilekey="AK"+EncodeNum.encodeNum(buyer_profileid).toUpperCase();
		HashMap buyerBasInfo=new HashMap();
		buyerBasInfo.put("fname",buyerfname);
		buyerBasInfo.put("lname",buyerlname);
		buyerBasInfo.put("email",buyeremail);
		buyerBasInfo.put("phone",buyerphone);
		buyerBasInfo.put("profileid",buyer_profileid);
		buyerBasInfo.put("profilekey",profilekey);
		buyerBasInfo.put("tid",tid);
		buyerBasInfo.put("eventid",eid);
		//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "before Updating  buyer data---------"+tid+"--------"+buyerBasInfo, "", null);
		profiledbaction.InserBuyerInfo(buyerBasInfo);
		if("yes".equals(enablepromotion)){
			profiledbaction.updatePromotionList(buyerBasInfo);
		}
		if(attributeSet!=null&&attributeSet.length>0&&buyerAttribs!=null&&buyerAttribs.size()>0){
			String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
			HashMap buyerResponsemaster=new HashMap();
			buyerResponsemaster.put("responseid",responseId);
			buyerResponsemaster.put("ticketid","0");
			buyerResponsemaster.put("profileid",buyer_profileid);
			buyerResponsemaster.put("eventid",eid);
			buyerResponsemaster.put("profilekey",profilekey);
			buyerResponsemaster.put("tid",tid);
			buyerResponsemaster.put("custom_setid",custom_setid);
			profiledbaction.InsertResponseMaster(buyerResponsemaster);
			String bigresponse=null;
			String shortresponse=null;
			for(int j=0;j<attributeSet.length;j++){
			shortresponse=null;
			bigresponse=null;
				CustomAttribute cb=(CustomAttribute)attributeSet[j];
				if(buyerAttribs.contains(cb.getAttribId())){
					String questionid=cb.getAttribId();
					String question=cb.getAttributeName();
					String type=cb.getAttributeType();
					ArrayList options=cb.getOptions();
					if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
						String responses[]=request.getParameterValues("q_buyer_"+questionid+"_1");
						if(responses!=null){
						String responsesVal[]=profiledbaction.getOptionVal(options,responses);
						shortresponse=GenUtil.stringArrayToStr(responses,",");
						bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
						}
					}
					else{
						shortresponse=request.getParameter("q_buyer_"+questionid+"_1");
						bigresponse=request.getParameter("q_buyer_"+questionid+"_1");
					}
					HashMap buyerResponse=new HashMap();
					buyerResponse.put("question",question);
					buyerResponse.put("questionid",questionid);
					buyerResponse.put("shortresponse",shortresponse);
					buyerResponse.put("bigresponse",bigresponse);
					buyerResponse.put("responseid",responseId);
					if(bigresponse!=null && !"".equals(bigresponse.trim()))
					profiledbaction.insertResponse(buyerResponse);
				}
			}
		}
}
catch(Exception e){
	status=false;
	System.out.println("Exception In  PROFILE SUBMISSION(tid"+tid+")"+e.getMessage());
	
}
if(status)
	obj.put("status","Success");
else
	obj.put("status","fail");
try{
String eventname="",eventwhere="",eventwhen="";
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select to_char(start_date+cast(cast(to_timestamp(COALESCE(starttime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM') ||' to '|| to_char(end_date+cast(cast(to_timestamp(COALESCE(endtime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM')  as when,eventname, CASE WHEN venue!='' THEN venue ||',' ELSE '' END ||  CASE WHEN address1!='' THEN address1 ||' ' ELSE '' END || CASE WHEN address2 !='' THEN address2 ||', ' ELSE '' END || CASE WHEN city!='' THEN city ||'.' ELSE '.' END as where  from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eid});
if(sb.getStatus()){
	eventname=db.getValue(0,"eventname","");
	eventwhere=db.getValue(0,"where","");
	eventwhen=db.getValue(0,"when","");
}
obj.put("eventname",eventname);
obj.put("eventwhere",eventwhere);
obj.put("eventwhen",eventwhen);
}
catch(Exception e){

}
	
out.print(obj.toString());

%>
