package com.customattributes;

import java.util.*;
import com.eventbee.general.*;
import com.eventbee.survey.*;

public class CustomAttributesDB{

	 static Map ATTRIBUTE_TYPE_MAPPING=new HashMap();
	 static Map ATTRIBUTE_OPTION_MANADATORY=new HashMap();
	 static Map ATRRIBUTE_ERROR_MAPPING=new HashMap();

	static{
		ATTRIBUTE_TYPE_MAPPING.put("text","textbox");
		ATTRIBUTE_TYPE_MAPPING.put("textarea","multi");
		ATTRIBUTE_TYPE_MAPPING.put("radio","opt");
		ATTRIBUTE_TYPE_MAPPING.put("dropdown","dropdown");
		ATTRIBUTE_TYPE_MAPPING.put("select","select");

		ATTRIBUTE_TYPE_MAPPING.put("checkbox","checkbox");
	}

	static{
		ATTRIBUTE_OPTION_MANADATORY.put("Required","yes");
		ATTRIBUTE_OPTION_MANADATORY.put("Optional","no");
	}

	static{
		ATRRIBUTE_ERROR_MAPPING.put("textbox.error",EbeeConstantsF.get("customattrib.textbox.error","Enter value for ##name##"));
		ATRRIBUTE_ERROR_MAPPING.put("multi.error",EbeeConstantsF.get("customattrib.multi.error","Enter value for ##name##"));
		ATRRIBUTE_ERROR_MAPPING.put("opt.error",EbeeConstantsF.get("customattrib.opt.error","Enter value for ##name##"));
		ATRRIBUTE_ERROR_MAPPING.put("dropdown.error",EbeeConstantsF.get("customattrib.dropdown.error","Enter value for ##name##"));
		ATRRIBUTE_ERROR_MAPPING.put("checkbox.error",EbeeConstantsF.get("customattrib.checkbox.error","Enter value for ##name##"));
	}

	private final static String RESPONSE_QUERY_FOR_ATTRIBUTE="select distinct attrib_name from custom_attrib_response a,custom_attrib_response_master b"
				+" where a.responseid =b.responseid  and b.attrib_setid=?";

	private final static String RESPONSE_QUERY="select attrib_name,response,userid,a.responseid,b.attrib_setid,c.transactionid   from  custom_attrib_response"
				+" a,custom_attrib_response_master b,eventattendee c"
				+" where a.responseid=b.responseid and c.attendeekey=b.userid and b.attrib_setid=? and c.priattendee='Y'  order by a.responseid";


	private static final String INSERT_CUSTOM_ATTRIB_MASTER="insert into custom_attrib_master"
				+" (attrib_setid,groupid ,purpose ,created) values(?,?,?,now()) ";


	private static final String INSERT_ATTRIBUTES="insert into custom_attribs"
				+" (attrib_setid,attrib_id,attribname,attribtype,isrequired,textboxsize,rows,cols)"
				+" values(?,?,?,?,?,?,?,?)";


	private static final String INSERT_OPTIONS="insert into custom_attrib_options"
				+" (attrib_setid ,attrib_id ,option ,option_val)"
				+" values(?,?,?,?)";


	private static final String DELETE_ATTRIBUTES="delete from custom_attribs where attrib_setid=?";


	private static final String DELETE_OPTIONS="delete from custom_attrib_options where attrib_setid=?";


	private static final String GET_ATTRIBUTES="select attribname,attribtype,isrequired,textboxsize,rows,cols,"
				+" b.attrib_id,b.attrib_setid "
				+" from custom_attrib_master a,custom_attribs b "
				+" where a.attrib_setid=b.attrib_setid and "
				+" a.attrib_setid=(select attrib_setid from custom_attrib_master "
				+" where groupid=CAST(? AS INTEGER) and purpose=?) order by attrib_id";


	private static final String GET_ATTRIBUTE_OPTIONS="select attrib_id,a.attrib_setid,option_val  "
				+" from custom_attrib_options a, custom_attrib_master b "
				+" WHERE a.attrib_setid=b.attrib_setid and "
				+" a.attrib_setid=(select attrib_setid from custom_attrib_master where groupid=CAST(? AS INTEGER)  and purpose=?)"
				+" order by attrib_id,option";





 private static final String CLUB_RESPONSE_QUERY="select attrib_name,response,userid,a.responseid,b.attrib_setid   from  custom_attrib_response"
   				+" a,custom_attrib_response_master b"
   				+" where a.responseid=b.responseid  and b.attrib_setid=?   order by a.responseid";



	private static final String INSERT_RESPONSE_MASTER="insert into custom_attrib_response_master(userid,attrib_setid,responseid,response_dt) values (?,CAST(? AS INTEGER),CAST(? AS INTEGER),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
	private static final String INSERT_RESPONSE="insert into custom_attrib_response(responseid,attrib_name,response) values (CAST(? AS INTEGER),?,?)";

	private static final String DELETE_RESPONSE=" delete from custom_attrib_response where responseid=CAST(? AS INTEGER)";
	private static final String DELETE_RESPONSE_MASTER=" delete from custom_attrib_response_master where responseid=CAST(? AS INTEGER)";

	public static StatusObj insertIntoCustomAttribMaster(String[] params){

		StatusObj stobj=new StatusObj(false,"",null,0);
		try{
			stobj=DbUtil.executeUpdateQuery(INSERT_CUSTOM_ATTRIB_MASTER,params,null);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","insertIntoCustomAttribMaster()","stobj.getData()-->"+stobj.getData(),null);
		}catch(Exception e){
			EventbeeLogger.logException("Exception",EventbeeLogger.DEBUG,"CustomAttributesDB.java","insertIntoCustomAttribMaster","Exception in insertIntoCustomAttribMaster method",e);
		}
	return stobj;
	}



	public static void deleteAttribs(String setid)
    {
        StatusObj statusobj = null;
        statusobj = DbUtil.executeUpdateQuery(DELETE_OPTIONS, new String[] {setid}, null);
        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","deleteAttribs()","DELETE_OPTIONS status is--->"+statusobj.getStatus(),null);
        statusobj = DbUtil.executeUpdateQuery(DELETE_ATTRIBUTES, new String[] {setid}, null);
        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","deleteAttribs()","DELETE_ATTRIBUTES status is--->"+statusobj.getStatus(),null);
    }



	public static StatusObj setCustomAttributes(CustomAttributes [] customattribs,String groupid,String purpose,String setid){
		StatusObj statobj=new StatusObj(false,"",null,0);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","setCustomAttributes()","",null);

		try{
			if(customattribs==null) return statobj;
			String id=DbUtil.getVal("select attrib_setid from custom_attrib_master where purpose=? and groupid=CAST(? AS INTEGER) ",new String[]{purpose,groupid});

			if(id == null || "".equals(id)){
			    id=setid;
			    statobj = insertIntoCustomAttribMaster(new String[] {id, groupid, purpose});
			    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","setCustomAttributes()","New insertion to custom_attrib_master status is--->"+statobj.getStatus(),null);
		    }
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","setCustomAttributes()","*********setid**********  is--->"+id,null);
			deleteAttribs(id);

			List dbquery=new ArrayList();
			List optdbquery=new ArrayList();
			List queryParams=new ArrayList();

			for(int i=0;i<customattribs.length;i++){
				queryParams=new ArrayList();
				queryParams.add(id);
				queryParams.add((i+1)+"");
				queryParams.add((String)customattribs[i].getAttributeName());
				queryParams.add((String)customattribs[i].getAttributeType());
				queryParams.add((String)customattribs[i].getIsRequired());
				queryParams.add((String)customattribs[i].getTextBoxSize());
				queryParams.add((String)customattribs[i].getRows());
				queryParams.add((String)customattribs[i].getCols());
				dbquery.add(new DBQueryObj(INSERT_ATTRIBUTES,(String[])queryParams.toArray(new String[0])));
				String options []=(String [])customattribs[i].getOptions();
				if(options!=null && options.length>0){
					for(int j=0;j<options.length;j++){
							optdbquery.add(new DBQueryObj(INSERT_OPTIONS,new String [] {id,(i+1)+"",(j+1)+"",options[j]}));
						}
				}


			}
			if(dbquery!=null&&dbquery.size()>0)
				statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));

			if(optdbquery!=null&&optdbquery.size()>0&&statobj.getStatus())
				statobj=DbUtil.executeUpdateQueries((DBQueryObj [])optdbquery.toArray(new DBQueryObj [optdbquery.size()]));

			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"CustomAttributesDB.java","setCustomAttributes()","Status of setCustomAttributes is:"+statobj.getStatus(),null);

		}
		catch(Exception e){
				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "CustomAttributesDB.java", "setCustomAttributes()", e.getMessage(), e ) ;
		}
		return statobj;

	}





	public static CustomAttributes [] getCustomAttributes(String groupid,String purpose){
		DBManager dbmanager=new DBManager();
		List customattributes=new ArrayList();
		CustomAttributes  customattribs=null;
		StatusObj statobj=null;
		HashMap hm=new HashMap();
		statobj=dbmanager.executeSelectQuery(GET_ATTRIBUTE_OPTIONS,new String []{groupid,purpose});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){
			for(int k=0;k<count;k++){
				String attribid=dbmanager.getValue(k,"attrib_id","");
				String opt_val=dbmanager.getValue(k,"option_val","");
				ArrayList options=(ArrayList)hm.get(attribid);
				if (options==null)
					options=new ArrayList();
				options.add(dbmanager.getValue(k,"option_val","0"));
				hm.put(attribid,options);


			}
		}

		statobj=dbmanager.executeSelectQuery(GET_ATTRIBUTES,new String []{groupid,purpose});
		int recordcount=statobj.getCount();
		if(statobj.getStatus()&&recordcount>0){
			EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG, "Customattributes.Java", "setAttibutes()", "custom_attribs "+statobj.getData(),null);

			for(int k=0;k<recordcount;k++){

				customattribs=new CustomAttributes();
				String attrib_id=dbmanager.getValue(k,"attrib_id","");
				customattribs.setAttribSetId(dbmanager.getValue(k,"attrib_setid",""));
				customattribs.setAttributeName(dbmanager.getValue(k,"attribname",""));
				customattribs.setAttributeType(dbmanager.getValue(k,"attribtype",""));
				customattribs.setIsRequired(dbmanager.getValue(k,"isrequired",""));
				customattribs.setTextBoxSize(dbmanager.getValue(k,"textboxsize",""));
				customattribs.setRows(dbmanager.getValue(k,"rows",""));
				customattribs.setCols(dbmanager.getValue(k,"cols",""));
                customattribs.setAttribId(attrib_id);

				if(hm.get(attrib_id)!=null)
					customattribs.setOptions((String[]) ((ArrayList)hm.get(attrib_id)).toArray(new String[0]));
				customattributes.add(customattribs);
			}
		}
	return (CustomAttributes [])customattributes.toArray(new CustomAttributes[0]);

	}


	public static Vector  getSurveyQuestions(CustomAttributes [] custom_attribs){
		Vector questions=new Vector();
		SurveyQuestion surveyques=null;
		CustomAttributes custom_attribute=null;
		try{
		if(custom_attribs!=null){
			for(int i=0;i<custom_attribs.length;i++){
				surveyques=new SurveyQuestion();
				custom_attribute=custom_attribs[i];
				//System.out.println("custom_attribute============="+custom_attribute);
				surveyques.setQuestionType(GenUtil.getHMvalue(ATTRIBUTE_TYPE_MAPPING,custom_attribute.getAttributeType(),"textbox"));
				surveyques.setMandatoryType(GenUtil.getHMvalue(ATTRIBUTE_OPTION_MANADATORY,custom_attribute.getIsRequired(),"no"));

				//surveyques.setQuestionId(custom_attribute.getAttributeType());
				surveyques.setQuestionId(i+"");
				surveyques.setQuestion(custom_attribute.getAttributeName());
				surveyques.setTextBoxSize(custom_attribute.getTextBoxSize());
				surveyques.setRows(custom_attribute.getRows());
				surveyques.setCols(custom_attribute.getCols());
				surveyques.setOptions(custom_attribute.getOptions());
				surveyques.setSelected("");
				surveyques.setDisplayerrorMsg(setErrorMesage(surveyques.getQuestion(),surveyques.getQuestionType()));

				questions.add(surveyques);

			}
		}
		}catch(Exception e){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "CustomAttributesDB.java", "getSurveyQuestions()", e.getMessage(), e ) ;
		}
		return questions;
	}

	public static String getAttribSetID(String groupid,String purpose){
		String setId=DbUtil.getVal("select attrib_setid from custom_attrib_master where groupid=CAST(? AS INTEGER) and purpose=?",new String[] {groupid,purpose});
		return setId;
    }

	public static String getResponseId(){
		String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
		return responseId;
    }

	public static void addResponses(Vector questionVector,SurveyAttendee surveyAttendee,String attendeeid,String locationid){

		String responseid=getResponseId();

		String surveyid=surveyAttendee.getSurveyId();
		String groupid=surveyAttendee.getGroupId();
		String[][] surveyresponse=surveyAttendee.getSurveyResponse();
		setResponseToDB(questionVector,surveyresponse,attendeeid,surveyid,responseid);
	}

	public static void setResponseToDB(Vector questionVector,String[][] surveyresponse,String userid,String attrib_setid,String responseid){
		try{


		List queries=new ArrayList();
		String responseetring=null;
		if(questionVector!=null&&questionVector.size()>0){

			queries.add(new DBQueryObj(INSERT_RESPONSE_MASTER,new String [] {userid,attrib_setid,responseid,DateUtil.getCurrDBFormatDate()}));


			for(int i=0;i<questionVector.size();i++){
				SurveyQuestion squestion=(SurveyQuestion)questionVector.elementAt(i);
				String ques=squestion.getQuestion();

				String response[]=(String[])surveyresponse[i];

				responseetring=GenUtil.stringArrayToStr(response,"##");
				queries.add(new DBQueryObj(INSERT_RESPONSE,new String [] {responseid,ques,responseetring}));


			}
			StatusObj statobj=DbUtil.executeUpdateQueries((DBQueryObj [])queries.toArray(new DBQueryObj [0]));

		}
		}catch(Exception e){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "CustomAttributesDB.java", "setResponseToDB()", e.getMessage(), e ) ;
		}
	}

	public static void deleteResponseFromDB(String responseid){
		DBQueryObj [] queries=new DBQueryObj [2];
		queries[0]=new DBQueryObj(DELETE_RESPONSE,new String [] {responseid});
		queries[1]=new DBQueryObj(DELETE_RESPONSE_MASTER,new String [] {responseid});
		StatusObj statobj=DbUtil.executeUpdateQueries(queries);
	}

	public static String setErrorMesage(String question,String attributeType){
		String errormsg=GenUtil.getHMvalue(ATRRIBUTE_ERROR_MAPPING,attributeType+".error","error");
		question=java.net.URLEncoder.encode(question);
		errormsg=errormsg.replaceAll("##name##",question);
		errormsg=java.net.URLDecoder.decode(errormsg);
		return errormsg;
	}


public static HashMap getCommunityResponses(String setid){
		DBManager dbmanager=new DBManager();
		Vector responses=new Vector();
		StatusObj statobj=null;
		HashMap hm=null;
		statobj=dbmanager.executeSelectQuery(CLUB_RESPONSE_QUERY,new String []{setid});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){

				hm=new HashMap();
				for(int k=0;k<count;k++){
					String userid=dbmanager.getValue(k,"userid","");
					HashMap options=(HashMap)hm.get(userid);
					if (options==null)
						options=new HashMap();
					options.put(dbmanager.getValue(k,"attrib_name","0"),dbmanager.getValue(k,"response","0"));

					hm.put(userid,options);

				}

		}

	return hm;
}




	public static List getAttributes(String setid){

		DBManager dbmanager=new DBManager();
		List attribs_list=new ArrayList();
		StatusObj statobj=null;
		statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String []{setid});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){
			for(int k=0;k<count;k++){
				attribs_list.add(dbmanager.getValue(k,"attrib_name",""));
			}
		}

		return attribs_list;
	}



	public static HashMap getResponses(String setid){
		DBManager dbmanager=new DBManager();
		Vector responses=new Vector();
		StatusObj statobj=null;
		HashMap hm=null;
		statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY,new String []{setid});
		int count=statobj.getCount();
		if(statobj.getStatus()&&count>0){

				hm=new HashMap();
				for(int k=0;k<count;k++){
					String userid=dbmanager.getValue(k,"transactionid","");
					HashMap options=(HashMap)hm.get(userid);
					if (options==null)
						options=new HashMap();
					options.put(dbmanager.getValue(k,"attrib_name","0"),dbmanager.getValue(k,"response","0"));

					hm.put(userid,options);

				}

		}

	return hm;
}

}