

package com.eventbee.survey;

/**
 *
 * @author  narayan
 */
import java.util.*;
import com.eventbee.general.*;
import java.sql.*;
public class SurveyDB {
 
static final String CLASS_NAME="com.eventbee.survey.SurveyDB";
static final String SURVEYS_OF_MANAGER="select surveyid,surveyname,surveyDesc  from survey_master  where managerid=? and role='Member'";
static final String SURVEYS_OF_UNIT="select surveyId,surveyName,surveyDesc from survey_master where unit_id=? and role='Manager' order by surveyName";




static final String SURVEY_AT_LOCATION_QUERY = " select surveyid,surveyname "
				+" from survey_master "
				+" where cast(surveyid as varchar)= "
				+" (select surveyid from survey_location "
				+" 	where locationid=? "
				+" 	and groupid=?)";
static final String SURVEY_OF_GROUP_QUERY = " select surveyid, surveyname from survey_master "
				+" where groupid=? "
				+" and grouptype='unit' "
				+" Union "
				+" select surveyid, surveyname from survey_master "
				+" where groupid=? "
				+" and grouptype='event'";
//surveydesc	varchar	false
static final String SURVEY_OF_GROUP_QUERY1 = " select surveyid, surveyname,surveydesc from survey_master "
				+" where groupid=? "
				+" and grouptype='unit' and role='Manager'"
				+" Union "
				+" select surveyid, surveyname,surveydesc from survey_master "
				+" where groupid=? "
				+" and grouptype=?";
static final String SURVEY_OF_GROUP_QUERY2 = " select surveyid, surveyname,surveydesc from survey_master "
				+" where cast(managerid as varchar)=? "
				+" and grouptype='unit' "
				+" Union "
				+" select surveyid, surveyname,surveydesc from survey_master "
				+" where groupid=? "
				+" and grouptype=?";

static final String SURVEYINFO_BY_ID_QUERY = " select surveyId,managerId,groupId, "
					+" groupType,surveyName, surveyDesc, getSurveyStatus(''||?) as status,"
					+" sbuttontext,cmessage,tmessage,surveyNoOfQues,surveyPromotion "
					+" from survey_master where cast(surveyId as varchar)=? ";
static final String QUESTIONS_BY_ID_QUERY = " select questionNo,questionType, "
					     +" questionId,question,textboxsize, "
					     +" rows,cols,mandatory,errormsg from survey_question_type "
					      +" where surveyId=? ";
static final String OPTIONS_BY_QID_QUERY = " select optionId,optionPosition, "
						+" optionCode,optionDisplay,optionDefault "
						+" from survey_question_options "
						+" where questionId=? ";
static final String SURVEY_LOCATION_DELETE = " DELETE from survey_location "
				+" where locationid=? "
				+" and groupid=?";
static final String SURVEYID_SEQ_QUERY = " select nextval('seq_surveyid') as tempid";
static final String QUESTIONID_SEQ_QUERY = " select nextval('seq_questionid') as tempid";

static final String SURVEY_MASTER_INSERT = " insert into survey_master "
			+" (surveyId,managerId,groupId,groupType, "
			+" surveyName,surveyDesc,sbuttontext,cmessage,tmessage,surveyNoOfQues,surveyPromotion, "
			+" created_by,created_at,updated_by,updated_at,unit_id,role) "
		        +" values(?,?,?,?,?,?,?,?,?,0,?,'survey',now(),'survey',now(),?,?) ";
static final String SURVEY_QUESTION_INSERT = " insert into survey_question_type "
			+" (surveyId,questionNo,questionType,questionId, "
			+" question,textboxsize,rows,cols,mandatory,errormsg, "
			+" created_by,created_at,updated_by,updated_at) "
			+" values(?,?,?,?,?,?,?,?,?,?,'survey',now(),'survey',now())";
static final String QUESTION_OPTION_INSERT = " insert into survey_question_options "
					+" (questionId,optionId,optionPosition, "
					+" optionCode,optionDisplay,optionDefault, "
					+" created_by,created_at,updated_by,updated_at) "
					+" values(?,nextval('seq_optionid'),?,?,?,?, "
					+" 'survey',now(),'survey',now()) ";
static final String SURVEY_LOCATION_INSERT = " insert into survey_location "
					     +" (surveyid,locationid,groupid,grouptype) "
					    +" values(?,?,?,?) ";






    public static String[] getSurveyAtEventLoc(String location, String eventid){
	String [] sinfo=null;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("survey");
		pstmt=con.prepareStatement(SURVEY_AT_LOCATION_QUERY);
		pstmt.setString(1,location);
		pstmt.setString(2,eventid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			do{
				sinfo=new String[2];
				sinfo[0]=rs.getString("surveyid");
				sinfo[1]=rs.getString("surveyname");
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getSurveyAtEventLoc(String location, String eventid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return sinfo;
    }




    public static int RemoveSurveyAtEventLoc(String location, String eventid){
	int rcount=0;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getWriteConnection("survey");
		pstmt=con.prepareStatement(SURVEY_LOCATION_DELETE);
		pstmt.setString(1,location);
		pstmt.setString(2,eventid);
		rcount=pstmt.executeUpdate();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "RemoveSurveyAtEventLoc(String location, String eventid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
    }

    public static int SetSurveyAtLoc(String location, String groupid, String grouptype,String surveyid){
	int rcount=0;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getWriteConnection("survey");
		RemoveSurveyAtEventLoc(location, groupid);
		pstmt=con.prepareStatement(SURVEY_LOCATION_INSERT);
		pstmt.setString(1,surveyid);
		pstmt.setString(2,location);
		pstmt.setString(3,groupid);
		pstmt.setString(4,grouptype);
		int ucw1=pstmt.executeUpdate();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "SetSurveyAtLoc(String location, String groupid, String grouptype,String surveyid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
    }

    public static String AddSurvey(String groupid, String grouptype,String manid, SurveyInfo sinfo, Vector questionvector,String unitId,String role){
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	java.sql.PreparedStatement pstmt1=null;
	java.sql.PreparedStatement pstmt2=null;
	String surveyid=null;
	try{
		con=EventbeeConnection.getWriteConnection("survey");
		pstmt=con.prepareStatement(SURVEYID_SEQ_QUERY);
		ResultSet rs=pstmt.executeQuery();
		rs.next();
		surveyid=rs.getString("tempid");
		rs.close();
		pstmt.close();
		pstmt=con.prepareStatement(SURVEY_MASTER_INSERT);
		pstmt.setString(1,surveyid);
		pstmt.setString(2,manid);
		pstmt.setString(3,groupid);
		pstmt.setString(4,grouptype);
		pstmt.setString(5,sinfo.getSurveyName());
		pstmt.setString(6,sinfo.getSurveyDesc());
		pstmt.setString(7,sinfo.getSurveySubmittext());
		pstmt.setString(8,sinfo.getSurveySclosemsg());
		pstmt.setString(9,sinfo.getSurveyThankmsg());
		pstmt.setString(10,sinfo.getSurveyPromotion());
		pstmt.setString(11,unitId);
		pstmt.setString(12,role);
		int updcount=pstmt.executeUpdate();
		pstmt.close();
           /*******************survey question type *****************/

		pstmt=con.prepareStatement(SURVEY_QUESTION_INSERT);
		pstmt1=con.prepareStatement(QUESTIONID_SEQ_QUERY);
		pstmt2=con.prepareStatement(QUESTION_OPTION_INSERT);
		for(int i=0;i<questionvector.size();i++){
			rs=pstmt1.executeQuery();
			rs.next();
			String quesid=rs.getString(1);
			rs.close();
			SurveyQuestion sinfotemp1=(SurveyQuestion)questionvector.elementAt(i);
			String[] options= sinfotemp1.getOptions();
			int j=i+1;
			pstmt.setString(1,surveyid);
			pstmt.setString(2,j+"");
			pstmt.setString(3,sinfotemp1.getQuestionType());
			pstmt.setString(4,quesid);
			pstmt.setString(5,sinfotemp1.getQuestion());
			pstmt.setString(6,sinfotemp1.getTextBoxSize());
			pstmt.setString(7,sinfotemp1.getRows());
			pstmt.setString(8,sinfotemp1.getCols());
			pstmt.setString(9,sinfotemp1.getMandatoryType());
			pstmt.setString(10,sinfotemp1.getDisplayerrorMsg());

			int uc=pstmt.executeUpdate();
			for(int k=0;k<options.length;k++){
				pstmt2.setString(1,quesid);
				pstmt2.setString(2,k+"");
				pstmt2.setString(3,k+"");
				pstmt2.setString(4,options[k]);
				pstmt2.setString(5,sinfotemp1.getSelected());
				int uc1=pstmt2.executeUpdate();
			}//end for options
		}//end for question vector
		pstmt.close();
		pstmt=null;
		pstmt1.close();
		pstmt1=null;
		pstmt2.close();
		pstmt2=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "AddSurvey(String groupid, String grouptype,String manid, SurveyInfo sinfo, Vector questionvector,String unitId)", e.getMessage(), e ) ;
System.out.println("error occured at surveyDB.java/AddSurvey()"+e);
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if (pstmt1!=null) pstmt1.close();
			if (pstmt2!=null) pstmt2.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return surveyid;
    }

    public static SurveyInfo getSurveyInfo(String surveyid){
	Connection con=null;
	SurveyInfo sinfo=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("survey");
		pstmt=con.prepareStatement(SURVEYINFO_BY_ID_QUERY);
		pstmt.setString(1,surveyid);
		pstmt.setString(2,surveyid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			do{
				sinfo=new SurveyInfo();
				sinfo.setSurveyId(rs.getString("surveyId"));
				sinfo.setSurveyName(rs.getString("surveyName"));
				sinfo.setSurveyDesc(rs.getString("surveyDesc"));
				sinfo.setSurveyThankmsg(rs.getString("tmessage"));
				sinfo.setSurveySclosemsg(rs.getString("cmessage"));
				sinfo.setSurveySubmittext(rs.getString("sbuttontext"));
				sinfo.setSurveyStatus(rs.getString("status"));
				sinfo.setSurveyPromotion(rs.getString("surveyPromotion"));
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getSurveyInfo(String surveyid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return sinfo;
    }


    public static Vector getSurveyQuestions(String surveyid){
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	java.sql.PreparedStatement pstmt1=null;
	SurveyQuestion surveyques=null;
	Vector questionvector=new Vector();
	try{
		con=EventbeeConnection.getReadConnection("survey");
		pstmt=con.prepareStatement(QUESTIONS_BY_ID_QUERY);
		pstmt1=con.prepareStatement(OPTIONS_BY_QID_QUERY);
		pstmt.setString(1,surveyid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			do{
				String quesid="";
				surveyques=new SurveyQuestion();
				surveyques.setQuestionType(rs.getString("questionType"));
				surveyques.setMandatoryType(rs.getString("mandatory"));
				surveyques.setDisplayerrorMsg(rs.getString("errormsg"));
				quesid=rs.getString("questionId");
				surveyques.setQuestionId(quesid);
				surveyques.setQuestion(rs.getString("question"));
				surveyques.setTextBoxSize(rs.getString("textboxsize"));
				surveyques.setRows(rs.getString("rows"));
				surveyques.setCols(rs.getString("cols"));
				pstmt1.setString(1,quesid);
				ResultSet rs1=pstmt1.executeQuery();
				Vector optvect=new Vector();
				String selected="";
				if(rs1.next()){
					do{
						String r="";
						r=rs1.getString("optionDisplay");
						optvect.add(r);
						selected=rs1.getString("optionDefault");
					}while(rs1.next());
				}
				rs1.close();
				String[] options=new String[optvect.size()];
				optvect.copyInto(options);
				surveyques.setSelected(selected);
				surveyques.setOptions(options);
				questionvector.add(surveyques);
			}while(rs.next());
		}
		rs.close();
		pstmt1.close();
		pstmt1=null;
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getSurveyQuestions(String surveyid)", e.getMessage(), e ) ;
System.out.println("Exception occured at SurveyDB/getSurveyQuestions() "+e);
	}
	finally{
		try{
			if (pstmt1!=null) pstmt.close();
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return questionvector;
    }
    
    
    public static Vector getAvailableSurveys(String unitid, String eventid){
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
        Vector v=new Vector();
	try{
		con=EventbeeConnection.getReadConnection("survey");		
		pstmt=con.prepareStatement(SURVEY_OF_GROUP_QUERY);
		pstmt.setString(1,unitid);
		pstmt.setString(2,eventid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			do{
				String[] sinfo1=new String[2];
				sinfo1[0]=rs.getString("surveyid");
				sinfo1[1]=rs.getString("surveyname");
				v.add(sinfo1);
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getAvailableSurveys(String unitid, String eventid)", e.getMessage(), e ) ;		
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }
public static Vector getMgrAvailableSurveys(String unitid, String groupid,String grouptype){
return getAvailableSurveys(unitid,groupid,grouptype,SURVEY_OF_GROUP_QUERY1);
}

public static Vector getMemAvailableSurveys(String userid, String groupid,String grouptype){
return getAvailableSurveys(userid,groupid,grouptype,SURVEY_OF_GROUP_QUERY2);
}

   public static Vector getAvailableSurveys(String id, String groupid,String grouptype,String query){
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
        Vector v=new Vector();
	try{
		con=EventbeeConnection.getReadConnection("survey");		
		pstmt=con.prepareStatement(query);
		pstmt.setString(1,id);
		pstmt.setString(2,groupid);
		pstmt.setString(3,grouptype);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			do{
				String[] sinfo1=new String[3];
				sinfo1[0]=rs.getString("surveyid");
				sinfo1[1]=rs.getString("surveyname");
				String temp= ( (temp=rs.getString("surveydesc") )==null)?"":temp;
				sinfo1[2]=temp;
				v.add(sinfo1);
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getAvailableSurveys(String unitid, String groupid,String grouptype)", e.getMessage(), e ) ;		
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }


//deelte survey:
//SurveyDB.deleteSurvey(String surveyid);

public static void deleteSurvey(String surveyid){


java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;
java.sql.PreparedStatement pstmt1=null;
	

	try{
			con=EventbeeConnection.getWriteConnection("survey");
			String query1="delete from survey_question_options where questionId in("
				+" select questionId from survey_question_type where surveyId=?)";			
			pstmt=con.prepareStatement(query1);
			pstmt.setString(1,surveyid);
			int upd=pstmt.executeUpdate();
			pstmt.close();
			String query10="delete  from survey_question_type where surveyId=?";
			pstmt=con.prepareStatement(query10);
			pstmt.setString(1,surveyid);
			upd=pstmt.executeUpdate();

			pstmt.close();
			String query="delete from survey_master where surveyId=? ";
			pstmt=con.prepareStatement(query);
			pstmt.setString(1,surveyid);
			//pstmt.setString(2,manid);
			upd=pstmt.executeUpdate();

			pstmt.close();

			String resdel="delete from survey_response where responseid in(select responseid from survey_answer_master where surveyid=?)";
			pstmt=con.prepareStatement(resdel);
			pstmt.setString(1,surveyid);			
			upd=pstmt.executeUpdate();			
			pstmt.close();



			String ansmasdel="delete from survey_answer_master where surveyid=?";
			pstmt=con.prepareStatement(ansmasdel);
			pstmt.setString(1,surveyid);			
			upd=pstmt.executeUpdate();			
			pstmt.close();



			String surlocdel="delete from survey_location where surveyid=?";
			pstmt=con.prepareStatement(surlocdel);
			pstmt.setString(1,surveyid);			
			upd=pstmt.executeUpdate();			
			pstmt.close();

			pstmt=null;
			con.close();
			con=null;
			
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "deleteSurvey(String surveyid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}



}

public static Vector getSurveysOfManager(String manid){
 Vector v=null;
	String [] sinfo=null;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("survey");
		pstmt=con.prepareStatement(SURVEYS_OF_MANAGER);
		pstmt.setString(1,manid);


		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			v=new Vector();
			do{
				sinfo=new String[2];
				sinfo[0]=rs.getString("surveyid");
				sinfo[1]=rs.getString("surveyname");
				//sinfo[2]=rs.getString("surveyDesc");
				v.add(sinfo);
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getSurveysOfManager(String manid)", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }

public static List getMgrSurveysOfUnit(String unitid){
	return getSurveysMainBeelet(unitid, SURVEYS_OF_UNIT);
}
public static List getMemberSurveys(String userid){
	return getSurveysMainBeelet(userid, SURVEYS_OF_MANAGER);
}
//SurveyDB.getSurveysMainBeelet(String unitid)
public static List getSurveysMainBeelet(String id, String queryName){
java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;

	List  surveylist=null;
	String[] sarr=null;
	try{
		con=EventbeeConnection.getReadConnection("survey");
		
		pstmt=con.prepareStatement(queryName);
		pstmt.setString(1,id);
		
		ResultSet rs=pstmt.executeQuery();
		
		if(rs.next()){
			surveylist= new ArrayList();
			do{
				String sid=rs.getString("surveyId");
				String sname=rs.getString("surveyName");
				String sdesc= ((sdesc=rs.getString("surveyDesc"))==null)?"":sdesc;
				Map confloc=SurveyResDB.getConfigLoc(sid);
				String configured="Available";
				if(confloc.size()>0)configured="Configured";
				sarr=new String[]{sid,sname,sdesc,configured};
				surveylist.add(sarr);
			}while(rs.next());
			
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "getSurveysMainBeelet(String unitid)", e.getMessage(), e ) ;
	}
	finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
	}
	return surveylist;

}




    
}
