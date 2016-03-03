<%@ page import="java.util.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page import="com.event.dbhelpers.*,com.eventbee.general.*"%>
<%
String eventid=request.getParameter("eid");
String tid=request.getParameter("tid");
String BUYER_PROFILE_LABEL="Buyer Profile";
String FIRSTNAME_LABEL="First Name";
String LASTNAME_LABEL="Last Name";
String EMAIL_LABEL="Email";
String PHONE_LABEL="Phone";
String attrib_setid="";
JSONObject profiledata = new JSONObject();
JSONArray buyerbasefields= new JSONArray();
JSONObject buyersettings = new JSONObject("{\"label\": \""+BUYER_PROFILE_LABEL+"\"}");

buyerbasefields.put(new JSONObject("{\"c\":\"fname\", \"req\":\"y\"}"));
buyerbasefields.put(new JSONObject("{\"c\":\"lname\", \"req\":\"y\"}"));
buyerbasefields.put(new JSONObject("{\"c\":\"email\", \"req\":\"y\"}"));

DBManager db=new DBManager();
StatusObj sb=null;
HashMap baseprofilefortickets=new HashMap();
String baseprofilesettingsquery="SELECT attribid, contextid, isrequired from base_profile_questions where groupid=?";
sb=db.executeSelectQuery(baseprofilesettingsquery,new String[]{eventid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		String attrib=db.getValue(i,"attribid","");
		String contextid=db.getValue(i,"contextid","");
		String isrequired=db.getValue(i,"isrequired","N");
		if("phone".equals(attrib) && "0".equals(contextid)){
			String p_req="Y".equals(isrequired)?"y":"n";
			buyerbasefields.put(new JSONObject("{\"c\":\"phone\", \"req\":\""+p_req+"\"}"));
		}else{
			baseprofilefortickets.put(attrib+"_"+contextid, isrequired);
		}
	}
}
buyersettings.put("basefields",buyerbasefields);

HashMap buyer_custom_questions_map=new HashMap();
String buyer_custom_questions_query ="SELECT attribid from buyer_custom_questions where eventid=?";
sb=db.executeSelectQuery(buyer_custom_questions_query,new String[]{eventid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		buyer_custom_questions_map.put(db.getValue(i,"attribid",""),"Y");
	}
}

HashMap ticket_custom_questions_map=new HashMap();
String ticket_custom_questions_query ="SELECT attribid, subgroupid  from subgroupattribs where groupid=?";
sb=db.executeSelectQuery(ticket_custom_questions_query,new String[]{eventid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		String subgroupid=db.getValue(i,"subgroupid","");
		ArrayList attribs=(ArrayList)ticket_custom_questions_map.get(subgroupid);
		if(attribs==null) attribs=new ArrayList();
		attribs.add(db.getValue(i,"attribid",""));
		ticket_custom_questions_map.put(subgroupid,attribs);
	}
}

HashMap custom_question_options_map=new HashMap();
HashMap custom_question_optionvals_map=new HashMap();
String custom_question_options_query ="SELECT attrib_setid, attrib_id,option_val ,  option  from custom_attrib_options"; 
	custom_question_options_query +=" where attrib_setid in (SELECT attrib_setid from custom_attrib_master where groupid=?)";
	custom_question_options_query +=" order by attrib_id, position";

sb=db.executeSelectQuery(custom_question_options_query,new String[]{eventid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		attrib_setid=db.getValue(i,"attrib_setid","");
		String attrib_id=db.getValue(i,"attrib_id","");
		JSONArray attriboptions=(JSONArray)custom_question_options_map.get(attrib_id);
		if(attriboptions==null) attriboptions=new JSONArray();
		attriboptions.put(db.getValue(i,"option",""));
		custom_question_options_map.put(attrib_id,attriboptions);
		
		JSONArray attriboptionvals=(JSONArray)custom_question_optionvals_map.get(attrib_id);
		if(attriboptionvals==null) attriboptionvals=new JSONArray();
		attriboptionvals.put(db.getValue(i,"option_val",""));
		custom_question_optionvals_map.put(attrib_id,attriboptionvals);
	}
}

HashMap responses_map=new HashMap();
String responses_query ="SELECT attribid, profilekey, shortresponse from custom_questions_response a, custom_questions_response_master b where a.ref_id=b.ref_id and transactionid=?";
sb=db.executeSelectQuery(responses_query,new String[]{tid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		String profilekey=db.getValue(i,"profilekey","");
		HashMap responses=(HashMap)responses_map.get(profilekey);
		if(responses==null) responses=new HashMap();
		responses.put(db.getValue(i,"attribid",""), db.getValue(i,"shortresponse",""));
		responses_map.put(profilekey,responses);
	}
}

String buyerbaseinfoquery="SELECT profilekey,fname, lname,phone,email, profileid from buyer_base_info where transactionid=?";
sb=db.executeSelectQuery(buyerbaseinfoquery,new String[]{tid});

String fname="";
String lname="";
String email="";
String phone="";
String profilekey="";
String profileid="";
JSONObject transaction = new JSONObject();
transaction.put("tid",tid);
transaction.put("attrib_setid",attrib_setid);
if(sb.getStatus() && sb.getCount()>0){
	fname=db.getValue(0,"fname","");
	lname=db.getValue(0,"lname","");
	email=db.getValue(0,"email","");
	phone=db.getValue(0,"phone","");
	profilekey=db.getValue(0,"profilekey","");
	profileid=db.getValue(0,"profileid","");
}
JSONObject tbuyer = new JSONObject();
tbuyer.put("fname", fname);
tbuyer.put("lname", lname);
tbuyer.put("email", email);
tbuyer.put("phone", phone);
tbuyer.put("k", profilekey);
tbuyer.put("profileid", profileid);

HashMap buyerresponses=(HashMap)responses_map.get(profilekey);
if(buyerresponses!=null){
	for (Object key : buyerresponses.keySet()) {
    	tbuyer.put("q"+(String)key, buyerresponses.get((String)key));
	}
}
transaction.put("buyer",tbuyer);

String profilebaseinfoquery="SELECT a.ticketid,fname, lname,phone,email, profileid, profilekey , ticketname ";
	profilebaseinfoquery += "from profile_base_info a, transaction_tickets b where a.transactionid=b.tid and a.ticketid=b.ticketid and a.transactionid=?";
sb=db.executeSelectQuery(profilebaseinfoquery,new String[]{tid});
JSONArray tickets= new JSONArray();
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		JSONObject profile = new JSONObject();
		String ticketid=db.getValue(i,"ticketid","");
		if((baseprofilefortickets.get("fname_"+ticketid)!=null)||("101".equals(ticketid))||("102".equals(ticketid)))
			profile.put("fname", db.getValue(i,"fname",""));
		if((baseprofilefortickets.get("lname_"+ticketid)!=null)||("101".equals(ticketid))||("102".equals(ticketid)))
			profile.put("lname", db.getValue(i,"lname",""));
		if((baseprofilefortickets.get("email_"+ticketid)!=null)||("101".equals(ticketid))||("102".equals(ticketid)))
			profile.put("email", db.getValue(i,"email",""));
		if(baseprofilefortickets.get("phone_"+ticketid)!=null)
			profile.put("phone", db.getValue(i,"phone",""));
		profile.put("k", db.getValue(i,"profilekey",""));
		profile.put("profileid", db.getValue(i,"profileid",""));
		HashMap ticketresponses=(HashMap)responses_map.get(db.getValue(i,"profilekey",""));
		if(ticketresponses!=null){
			for (Object key : ticketresponses.keySet()) {
    			profile.put("q"+(String)key, ticketresponses.get((String)key));
			}
		}
		JSONObject t = null;
		int found=0;
	    for(int j=0;j<tickets.length();j++){
	    	found=0;
	    	t=(JSONObject)tickets.get(j);
	    	if(ticketid.equals((String)t.get("id"))){
	    		found=1;
	    		((JSONArray)((JSONObject)tickets.get(j)).get("profiles")).put(profile);
	    		((JSONObject)tickets.get(j)).put("q", ((JSONArray)((JSONObject)tickets.get(j)).get("profiles")).length());
	    		break;
	    	}
	    }
	    if(found==0){
	    	JSONArray profiles= new JSONArray();
	    	profiles.put(profile);
	    	t = new JSONObject("{\"id\":\""+ticketid+"\", \"q\":1}");
	    	t.put("profiles", profiles);
	    	t.put("label", "Profile #index# - " + db.getValue(i,"ticketname",""));
	    	tickets.put(t);
	    }
	}
}
transaction.put("tickets",tickets);
profiledata.put("transaction", transaction);



JSONArray basequestions= new JSONArray();
basequestions.put(new JSONObject("{\"c\":\"fname\", \"t\":\"text\",\"l\":\""+FIRSTNAME_LABEL+"\"}"));
basequestions.put(new JSONObject("{\"c\":\"lname\", \"t\":\"text\",\"l\":\""+LASTNAME_LABEL+"\"}"));
basequestions.put(new JSONObject("{\"c\":\"email\", \"t\":\"text\",\"l\":\""+EMAIL_LABEL+"\"}"));
basequestions.put(new JSONObject("{\"c\":\"phone\", \"t\":\"text\",\"l\":\""+PHONE_LABEL+"\"}"));
profiledata.put("basequestions", basequestions);

JSONArray profiletickets= new JSONArray();
for(int i=0;i<tickets.length();i++){
	JSONObject tkt=(JSONObject)tickets.get(i);
	JSONObject ntkt=new JSONObject();
	ntkt.put("id", tkt.get("id"));
	ntkt.put("label", tkt.get("label"));
	ntkt.put("fields", new JSONArray());
	JSONArray profileticketsbasefields= new JSONArray();
	String bfields[] = {"fname", "lname", "email", "phone"};
	for(int j=0;j<bfields.length;j++){
		String f= bfields[j];
		String req=(String)baseprofilefortickets.get(f+"_"+(String)tkt.get("id"));
		if("101".equals((String)tkt.get("id"))||"102".equals((String)tkt.get("id"))) 
		{
			if(j<3) req="Y";
		}
		if(req!=null){
			if("Y".equals(req)) req="y";
			profileticketsbasefields.put(new JSONObject("{\"c\":\""+f+"\", \"req\":\""+req+"\"}"));
		}
	}
	ntkt.put("basefields", profileticketsbasefields);
	profiletickets.put(ntkt);
}

JSONArray reqquestions= new JSONArray();
JSONArray buyercustomfields= new JSONArray();
String custom_questions_query ="SELECT attrib_id ,cols ,attribtype, isrequired , attribname, rows";
	custom_questions_query += " from custom_attribs ";
	custom_questions_query += " where attrib_setid in (SELECT attrib_setid from custom_attrib_master where groupid=? )";
	custom_questions_query += "  order by position";
sb=db.executeSelectQuery(custom_questions_query,new String[]{eventid});
if(sb.getStatus() && sb.getCount()>0){
	for(int i=0;i<sb.getCount();i++){
		int qreq=0;
		String qid=db.getValue(i,"attrib_id","");
		if(buyer_custom_questions_map.get(qid)!=null){
			buyercustomfields.put("q"+qid);
			qreq=1;
		}
		for(int j=0;j<profiletickets.length();j++){
			String tktid=(String)((JSONObject)profiletickets.get(j)).get("id");
			ArrayList attribs=(ArrayList)ticket_custom_questions_map.get(tktid);
			if(attribs!=null){
				if(attribs.contains(qid)){
					qreq=1;
					((JSONArray)((JSONObject)profiletickets.get(j)).get("fields")).put("q"+qid);
				}
			}
		}
		if(qreq==1){
			String attribtype=db.getValue(i,"attribtype","");
			String attribname=db.getValue(i,"attribname","");
			String isreq=db.getValue(i,"isrequired","Optional");
			isreq="Optional".equals(isreq)?"n":"y";
			JSONObject qt=new JSONObject("{\"c\":\"q"+qid+"\", \"t\":\""+attribtype+"\", \"req\":\""+isreq+"\"}");
			qt.put("l",attribname);
			if("text".equals(attribtype)){
				reqquestions.put(qt);
			}
			else if("textarea".equals(attribtype)){
				qt.put("rows",db.getValue(i,"rows","2"));
				qt.put("cols",db.getValue(i,"cols","40"));
				reqquestions.put(qt);
			}else {
				JSONArray ovA=(JSONArray)custom_question_options_map.get(qid);
				if(ovA==null) ovA=new JSONArray();
				qt.put("optionVals",ovA);
				JSONArray olA=(JSONArray)custom_question_optionvals_map.get(qid);
				if(olA==null) olA=new JSONArray();
				qt.put("optionLabels",olA);
				reqquestions.put(qt);
			}
		}
	}
}
buyersettings.put("fields",buyercustomfields);
profiledata.put("buyer", buyersettings);
profiledata.put("tickets", profiletickets);
profiledata.put("questions", reqquestions);

out.println(profiledata.toString());
%>
