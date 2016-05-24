package com.customquestions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.customquestions.beans.CAttribOption;
import com.customquestions.beans.CCustomAttribResponse;
import com.customquestions.beans.CCustomAttribSet;
import com.customquestions.beans.CCustomAttribute;

import com.eventbee.general.DBManager;
import com.eventbee.general.DBQueryObj;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.StatusObj;

public class CCustomAttribsDB {

    private static final String INSERT_CUSTOM_ATTRIB_MASTER = "insert into custom_attrib_master" + 
    " (attribsetid,groupid ,purpose ,created) values(CAST(? AS INTEGER),CAST(? AS INTEGER),?,now()) ";

    private static final String INSERT_ATTRIBUTES = "insert into custom_attribs" + 
    " (attrib_setid,attrib_id ,attribname,attribtype,isrequired,textboxsize,rows,cols," + 
    		"  position,lastupdated)" + " values(?,?,?,?,?,?,?,?,?,now())";

    private static final String GET_EVENT_ATTRIB_SET = "select b.attrib_setid,a.* from custom_attribs a," + 
    "custom_attrib_master b" + " where a.attrib_setid=b.attrib_setid and b.groupid=CAST(? AS INTEGER) and b.purpose=? order by position ";
    
    private static final String attribIdSelectQuery = "select b.attrib_setid,a.* from custom_attribs a," + 
    "custom_attrib_master b,subgroupattribs c" + " where a.attrib_setid=b.attrib_setid and b.groupid=? and b.purpose=? and " + " a.attribsetid=c.attribsetid and b.groupid=c.groupid and c.subgroupid=? order by position";

    private static final String GET_ATTRIB_DETAILS = "select * from custom_attribs where attrib_id=?";

    private static final String GET_ATTRIB_OPTIONS = "select * from custom_attrib_options" + 
    " where attrib_setid=CAST(? AS INTEGER) and attrib_id=CAST(? AS INTEGER) order by position";

    private static final String GET_ALL_ATTRIB_OPTIONS = "select * from custom_attrib_options" + 
    " where attrib_setid=CAST(? AS INTEGER) order by attrib_id,position";


    private static final String GET_ATTRIB_RESPONSE = "select a.* from custom_questions_response a," + 
    "custom_questions_response_master b where b.groupid=? and b.subgroupid=? and b.transactionid=?" + 
    		" and b.profileid=? and b.purpose=? and a.ref_id=b.ref_id";

    private static final String INSERT_RESPONSE_MASTER = "insert into custom_questions_response" + 
    "(groupid,subgroupid,transactionid,profileid,attribsetid,ref_id,status) values " + "(?,?,?,?,?,?,1)";
    
    private static final String DELETE_RESPONSE = "delete from custom_questions_response where ref_id=?";

    private static final String DELETE_RESPONSE_MASTER = "delete from custom_questions_response_master where ref_id=?";

    private static final String INSERT_RESPONSE = "insert into custom_questions_response" + 
    " (ref_id,attribid,option_id,shortresponse,bigresponse,question_shortform,question_original," + 
    		" optionval,optiondisplay) values (?,?,?,?,?,?,?,?,?)";

    private final static String GETATTR_FOR_SETID = "select question_original from custom_questions_response a,custom_questions_response_master b" + 
    " where a.ref_id =b.ref_id  and b.attribsetid=? ";

    private final static String RESPONSE_QUERY = "select a.* from custom_questions_response a," + 
    " custom_questions_response_master b where b.attribsetid=? and a.ref_id=b.ref_id order by ref_id";

    private static final String DELETE_ATTRIBUTES = "delete from custom_attribs where attrib_setid=?";


    private static final String DELETE_OPTIONS = "delete from custom_attrib_options where attrib_setid=?";

    private static final String INSERT_OPTIONS = "insert into custom_attrib_options" + 
    " (attrib_setid ,attrib_id ,option_id,position," + "option_val,created,lastupdated)" + " values(?,?,?,?,?,now(),now())";

    public HashMap < String, ArrayList < CAttribOption >> getAllCustomAttribSetOptions(String attribsetid) {
        HashMap < String, ArrayList < CAttribOption >> attribOptionsMap = new HashMap < String, ArrayList < CAttribOption >> ();
        DBManager dbmanager = new DBManager();
        StatusObj statobj = null;
        try {
            statobj = dbmanager.executeSelectQuery(GET_ALL_ATTRIB_OPTIONS, new String[] {
                attribsetid
            });
            int count = statobj.getCount();
            if (statobj.getStatus() && count > 0) {
                for (int k = 0; k < count; k++) {
                    String attribid = dbmanager.getValue(k, "attrib_id", "");
                    ArrayList < CAttribOption > options = null;
                    CAttribOption cop = null;
                    if (attribOptionsMap.containsKey(attribid)) {
                        options = (ArrayList < CAttribOption > ) attribOptionsMap.get(attribid);
                        cop = new CAttribOption();
                        cop.setPosition(dbmanager.getValue(k, "position", ""));
                        cop.setOptionid(dbmanager.getValue(k, "option", ""));
                        cop.setOptionValue(dbmanager.getValue(k, "option_val", ""));
                        String subQuesionString = dbmanager.getValue(k, "subquestions", "") == null || "".equals(dbmanager.getValue(k, "subquestions", "")) ? "" : dbmanager.getValue(k, "subquestions", "");
                        cop.setSubQuestions(subQuesionString.split(","));
                        options.add(cop);
                    } else {
                        options = new ArrayList < CAttribOption > ();
                        cop = new CAttribOption();
                        cop.setPosition(dbmanager.getValue(k, "position", ""));
                        cop.setOptionid(dbmanager.getValue(k, "option", ""));
                        cop.setOptionValue(dbmanager.getValue(k, "option_val", ""));
                        String subQuesionString = dbmanager.getValue(k, "subquestions", "") == null || "".equals(dbmanager.getValue(k, "subquestions", "")) ? "" : dbmanager.getValue(k, "subquestions", "");
                        cop.setSubQuestions(subQuesionString.split(","));
                        options.add(cop);
                        attribOptionsMap.put(attribid, options);
                    }
                }
            }
        } //End of try
        catch (Exception e) {
            EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "getCustomAttribSetOptions()", e.getMessage(), e);
        } //End of catch
        return attribOptionsMap;
    }


    public CCustomAttribSet getCustomAttribSet(String groupid, String purpose) {
        return getCustomAttribSet(groupid, null, purpose);
    }

    public CCustomAttribSet getCustomAttribSet(String groupid, String subgroupid, String purpose) {
            ArrayList < String > params = new ArrayList < String > ();
            CCustomAttribSet customAttSet = new CCustomAttribSet();
            DBManager dbmanager = new DBManager();

            StatusObj statobj = null;
            String query = null;
            params.add(groupid);
            params.add(purpose);
            //EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO,"CustomAttribsDB.java","getCustomAttribSet()","Entered the method getCustomAttribSet()",null);
            try {
                if (subgroupid == null) {
                    query = GET_EVENT_ATTRIB_SET;
                } else {
                    params.add(subgroupid);
                    query = attribIdSelectQuery;
                }
                statobj = dbmanager.executeSelectQuery(query, (String[]) params.toArray(new String[params.size()]));
                int count = statobj.getCount();
                if (statobj.getStatus() && count > 0) {
                    HashMap < String, CCustomAttribute > attribs = new HashMap < String, CCustomAttribute > ();
                    String attribSetId = dbmanager.getValue(0, "attrib_setid", "");
                    HashMap < String, ArrayList < CAttribOption >> optionsOfAttribs = getAllCustomAttribSetOptions(attribSetId);
                    customAttSet.setAttribSetid(attribSetId);
                    for (int k = 0; k < count; k++) {
                        CCustomAttribute attrib = new CCustomAttribute();
                        String attribid = dbmanager.getValue(k, "attrib_id", "");
                        String rows = dbmanager.getValue(k, "rows", "");
                        String cols = dbmanager.getValue(k, "cols", "");
                        String textboxsize = dbmanager.getValue(k, "textboxsize", "");
                        String attribname = dbmanager.getValue(k, "attribname", "");
                        String attribtype = dbmanager.getValue(k, "attribtype", "");
                        String isreq = dbmanager.getValue(k, "isrequired", "");
                        String position = dbmanager.getValue(k, "position", "");
                        String lastupdated = dbmanager.getValue(k, "lastupdated", "");
                        attrib.setAttribId(attribid);
                        attrib.setisRequired(isreq);
                        attrib.setTextboxSize(textboxsize);
                        attrib.setRows(rows);
                        attrib.setCols(cols);
                        attrib.setPosition(position);
                        attrib.setAttributeName(attribname);
                        attrib.setAttributeType(attribtype);
                        attrib.setlastUpdated(lastupdated);
                        //HashMap optionsOfAttribs=getCustomAttribSetOptions(attribsetid,attribid);

                        if (optionsOfAttribs.containsKey(attribid)) {
                            attrib.setOptions((ArrayList < CAttribOption > ) optionsOfAttribs.get(attribid));
                        } // End if()
                        attribs.put(attribid, attrib);
                    } //End for()
                    customAttSet.setAttributes(attribs);
                } //End if()
                else {
                    //There is an error in query execution
                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.DEBUG, "(Box office) CustomAttribsDB.java", "getCustomAttribSet()", "statobj.getStatus() Error in selection of records" + statobj.getStatus(), null);
                } //End else
            } //End of try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, " (Box office) TicketCustomAttribsDB.java", "getCustomAttribSet()", e.getMessage(), e);
            } //End of catch
            //EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO,"CustomAttribsDB.java","getCustomAttribSet()","Exited from method getCustomAttribSet()",null);
            return customAttSet;
        } //End of getCustomAttribSet()


    public HashMap < String, ArrayList < String >> getTicketLevelAttributes(String groupid) {
        DBManager db = new DBManager();
        HashMap < String, ArrayList < String >> ticketsAttribs = new HashMap < String, ArrayList < String >> ();
        StatusObj sb = db.executeSelectQuery("select subgroupid,a.attribid,a.position as x,b.position as y from subgroupattribs a,custom_attribs b where a.attribsetid=b.attrib_setid and groupid=CAST(? AS INTEGER) and a.attribid=b.attrib_id order by subgroupid,a.position,b.position", new String[] {
            groupid
        });
        if (sb.getStatus()) {
            ArrayList < String > attribList = null;
            for (int i = 0; i < sb.getCount(); i++) {
                if (ticketsAttribs.containsKey(db.getValue(i, "subgroupid", "")))
                    attribList.add(db.getValue(i, "attribid", ""));
                else {
                    attribList = new ArrayList < String > ();
                    attribList.add(db.getValue(i, "attribid", ""));
                }
                ticketsAttribs.put(db.getValue(i, "subgroupid", ""), attribList);
            }
        }
        return ticketsAttribs;
    }

    public HashMap getCustomAttribSetOptions(String attribsetid, String attribid) {
            HashMap attribOptionsMap = new HashMap();
            DBManager dbmanager = new DBManager();
            StatusObj statobj = null;
            ArrayList options = new ArrayList();
            try {
                statobj = dbmanager.executeSelectQuery(GET_ATTRIB_OPTIONS, new String[] {
                    attribsetid, attribid
                });
                //EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO,"CustomAttribsDB.java","getCustomAttribSetOptions()","statobj.getStatus()-->"+statobj.getStatus(),null);
                int count = statobj.getCount();
                if (statobj.getStatus() && count > 0) {
                    for (int k = 0; k < count; k++) {
                        //String attribid=dbmanager.getValue(k,"attrib_id","");
                        String position = dbmanager.getValue(k, "position", "");
                        String optionid = dbmanager.getValue(k, "option", "");
                        String optvalue = dbmanager.getValue(k, "option_val", "");
                        CAttribOption cop = new CAttribOption();
                        cop.setPosition(position);
                        cop.setOptionid(optionid);
                        cop.setOptionValue(optvalue);
                        options.add(cop);
                        attribOptionsMap.put(attribid, options);
                    } //End for()
                } //End if()
                else {
                    //There is an error in query execution
                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.DEBUG, "CustomAttribsDB.java", "getCustomAttribSetOptions()", "statobj.getStatus() Error in selection of records" + statobj.getStatus(), null);
                }
            } //End of try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "getCustomAttribSetOptions()", e.getMessage(), e);
            } //End of catch
            return attribOptionsMap;
        } //End of getCustomAttribSetOptions()

    public HashMap getAttribResponseSet(String trnid, String groupid, String subgroupid, String profileid, String purpose) {
            HashMap custatresponsemap = new HashMap();
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "getAttribResponseSet()", "Entered the method getAttribResponseSet()", null);
            try {
                DBManager dbmanager = new DBManager();
                HashMap hm = new HashMap();
                StatusObj statobj = null;
                statobj = dbmanager.executeSelectQuery(GET_ATTRIB_RESPONSE, new String[] {
                    groupid, subgroupid, trnid, profileid, purpose
                });
                int count = statobj.getCount();
                //ArrayList
                CCustomAttribResponse custattresp = new CCustomAttribResponse();
                if (statobj.getStatus() && count > 0) {
                    for (int k = 0; k < count; k++) {
                        String attribid = dbmanager.getValue(k, "attribid", "");
                        String optionid = dbmanager.getValue(k, "optionid", "");
                        String shortresp = dbmanager.getValue(k, "shortresponse", "");
                        String bigresp = dbmanager.getValue(k, "bigresponse", "");
                        String quest_shortform = dbmanager.getValue(k, "question_shortform", "");
                        String question_original = dbmanager.getValue(k, "question_original", "");
                        String optvalue = dbmanager.getValue(k, "optionval", "");
                        String optiondisp = dbmanager.getValue(k, "option_display", "");
                        custattresp.setattribId(attribid);
                        custattresp.setShortResponse(shortresp);
                        custattresp.setResponse(bigresp);
                        custattresp.setQuestionShortform(quest_shortform);
                        custattresp.setQuestionOriginal(question_original);
                        custattresp.setOptionVal(optvalue);
                        custattresp.setOptionDisplay(optiondisp);
                        custattresp.setOptionid(optionid);
                        custatresponsemap.put(attribid, custattresp);
                    } //End of for() loop
                } //End of if()
                else {
                    //There is an error in query execution
                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.DEBUG, "CustomAttribsDB.java", "getAttribResponseSet()", "statobj.getStatus() Error in selection of records" + statobj.getStatus(), null);
                } //End else
            } //End of try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "TicketCustomAttribsDB.java", "getAttribResponseSet()", e.getMessage(), e);
            } //End of catch
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "getAttribResponseSet()", "Exited from method getAttribResponseSet()", null);
            return custatresponsemap;
        } //End of getAttribResponseSet()
    
    public StatusObj setAttributeResponsekey(CCustomAttribResponse[] custattrbresp, String trnid, String groupid, String profileid, String subgroupid, String attribsetid) {
            DBManager dbmanager = new DBManager();
            HashMap hm = new HashMap();
            StatusObj statobj = null;
            List queries = new ArrayList();
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "setAttributeResponsekey()", "Entered the method getAttribResponseSet()", null);
            try {
                String refseq = DbUtil.getVal("select nextval('refidseq')", new String[] {});
                String ref_id = EncodeNum.encodeNum(refseq);
                queries.add(new DBQueryObj(INSERT_RESPONSE_MASTER, new String[] {
                    groupid, subgroupid, trnid, profileid, attribsetid, ref_id
                }));
                for (int i = 0; i < custattrbresp.length; i++) {
                    CCustomAttribResponse custresp = custattrbresp[i];
                    String attribid = custresp.getattribId();
                    String optionid = custresp.getOptionid();
                    String shortresp = custresp.getShortResponse();
                    String bigresp = custresp.getResponse();
                    String ques_shortform = custresp.getQuestionShortform();
                    String ques_orig = custresp.getQuestionOriginal();
                    String optval = custresp.getOptionVal();
                    String optdisp = custresp.getOptionDisplay();
                    queries.add(new DBQueryObj(INSERT_RESPONSE, new String[] {
                        ref_id, attribid, optionid, shortresp, bigresp, ques_shortform, ques_orig, optval, optdisp
                    }));
                } //End for
                StatusObj statobj1 = DbUtil.executeUpdateQueries((DBQueryObj[]) queries.toArray(new DBQueryObj[0]));
            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "setAttributeResponsekey()", e.getMessage(), e);

            } //End catch
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "setAttributeResponsekey()", "Exited from the method getAttribResponseSet()", null);
            return statobj;
        } //End setAttributeResponsekey()
    
    public List getAttributes(String setid) {

            DBManager dbmanager = new DBManager();
            List attribs_list = new ArrayList();
            StatusObj statobj = null;
            try {
                statobj = dbmanager.executeSelectQuery(GETATTR_FOR_SETID, new String[] {
                    setid
                });
                int count = statobj.getCount();
                if (statobj.getStatus() && count > 0) {
                    for (int k = 0; k < count; k++) {
                        attribs_list.add(dbmanager.getValue(k, "question_original", ""));
                    } //End for()
                } // End if()
                else {
                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.DEBUG, "CustomAttribsDB.java", "getAttributes()", "statobj.getStatus() Error in selection of records" + statobj.getStatus(), null);
                }
            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "getAttributes()", e.getMessage(), e);
            } //End catch
            return attribs_list;
        } //End getAttributes()
    public HashMap getResponses(String setid) {
            DBManager dbmanager = new DBManager();
            StatusObj statobj = null;
            HashMap hm = null;
            HashMap custatresponsemap = new HashMap();
            CCustomAttribResponse custattresp = new CCustomAttribResponse();
            try {
                statobj = dbmanager.executeSelectQuery(RESPONSE_QUERY, new String[] {
                    setid
                });
                int count = statobj.getCount();
                if (statobj.getStatus() && count > 0) {
                    for (int k = 0; k < count; k++) {
                        String attribid = dbmanager.getValue(k, "attribid", "");
                        String optionid = dbmanager.getValue(k, "optionid", "");
                        String shortresp = dbmanager.getValue(k, "shortresponse", "");
                        String bigresp = dbmanager.getValue(k, "bigresponse", "");
                        String quest_shortform = dbmanager.getValue(k, "question_shortform", "");
                        String question_original = dbmanager.getValue(k, "question_original", "");
                        String optvalue = dbmanager.getValue(k, "optionval", "");
                        String optiondisp = dbmanager.getValue(k, "option_display", "");
                        custattresp.setattribId(attribid);
                        custattresp.setShortResponse(shortresp);
                        custattresp.setResponse(bigresp);
                        custattresp.setQuestionShortform(quest_shortform);
                        custattresp.setQuestionOriginal(question_original);
                        custattresp.setOptionVal(optvalue);
                        custattresp.setOptionDisplay(optiondisp);
                        custattresp.setOptionid(optionid);
                        custatresponsemap.put(attribid, custattresp);
                    } //End for
                } //End if
                else {
                    //There is a problem in query execution. Log Entry
                }
            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "getResponses()", e.getMessage(), e);
            } //End catch
            return custatresponsemap;
        } //End getResponses()
    
    public StatusObj insertIntoCustomAttribMaster(String[] params) {

            StatusObj stobj = new StatusObj(false, "", null, 0);
            try {
                stobj = DbUtil.executeUpdateQuery(INSERT_CUSTOM_ATTRIB_MASTER, params, null);
                //Log entry
            } // End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "insertIntoCustomAttribMaster()", e.getMessage(), e);
            } //End catch
            return stobj;
        } //End insertIntoCustomAttribMaster()
    
    public void deleteAttribs(String setid) {
            StatusObj statusobj = null;
            try {
                statusobj = DbUtil.executeUpdateQuery(DELETE_OPTIONS, new String[] {
                    setid
                }, null);
                //Log
                statusobj = DbUtil.executeUpdateQuery(DELETE_ATTRIBUTES, new String[] {
                    setid
                }, null);
                //Log
            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "deleteAttribs()", e.getMessage(), e);
            } //End catch
        } //End deleteAttribs()

    public StatusObj insertCustomAttributes(CCustomAttribute[] customattribs, String groupid, String purpose, String setid) {
            StatusObj statobj = new StatusObj(false, "", null, 0);
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "insertCustomAttributes()", "Entered the method insertCustomAttributes()", null);
            try {
                if (customattribs == null) return statobj;
                String id = DbUtil.getVal("select attribsetid from custom_attrib_master where purpose=? and groupid=? ", new String[] {
                    purpose, groupid
                });

                if (id == null || "".equals(id)) {
                    id = setid;
                    statobj = insertIntoCustomAttribMaster(new String[] {
                        id, groupid, purpose
                    });
                    //Log entry
                }
                //Log entry
                deleteAttribs(id);
                List dbquery = new ArrayList();
                List optdbquery = new ArrayList();
                List queryParams = new ArrayList();

                for (int i = 0; i < customattribs.length; i++) {
                    queryParams = new ArrayList();
                    queryParams.add(id);
                    queryParams.add((i + 1) + "");
                    queryParams.add((String) customattribs[i].getAttributeName());
                    queryParams.add((String) customattribs[i].getAttributeType());
                    queryParams.add((String) customattribs[i].getisRequired());
                    queryParams.add((String) customattribs[i].getTextboxSize());
                    queryParams.add((String) customattribs[i].getRows());
                    queryParams.add((String) customattribs[i].getCols());
                    queryParams.add((String) customattribs[i].getPosition());

                    dbquery.add(new DBQueryObj(INSERT_ATTRIBUTES, (String[]) queryParams.toArray(new String[0])));
                    List options = (ArrayList) customattribs[i].getOptions();
                    if (options != null && options.size() > 0) {
                        for (int j = 0; j < options.size(); j++) {
                            List opt = new ArrayList();
                            CAttribOption attopt = (CAttribOption) options.get(j);
                            opt.add(id);
                            opt.add((j + 1) + "");
                            opt.add((String) attopt.getOptionid());
                            opt.add((String) attopt.getPosition());
                            opt.add((String) attopt.getOptionValue());
                            optdbquery.add(new DBQueryObj(INSERT_OPTIONS, (String[]) opt.toArray(new String[0])));
                        } //End for
                    } //End if


                } //End of outer for()
                if (dbquery != null && dbquery.size() > 0)
                    statobj = DbUtil.executeUpdateQueries((DBQueryObj[]) dbquery.toArray(new DBQueryObj[dbquery.size()]));

                if (optdbquery != null && optdbquery.size() > 0 && statobj.getStatus())
                    statobj = DbUtil.executeUpdateQueries((DBQueryObj[]) optdbquery.toArray(new DBQueryObj[optdbquery.size()]));

            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "insertCustomAttributes()", e.getMessage(), e);
            } //End catch
            EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN, EventbeeLogger.INFO, "CustomAttribsDB.java", "insertCustomAttributes()", "Exited from method insertCustomAttributes()", null);
            return statobj;

        } //End insertCustomAttributes()
    
    public void deleteResponseFromDB(String refid) {
            DBQueryObj[] queries = new DBQueryObj[2];
            queries[0] = new DBQueryObj(DELETE_RESPONSE, new String[] {
                refid
            });
            queries[1] = new DBQueryObj(DELETE_RESPONSE_MASTER, new String[] {
                refid
            });
            try {
                StatusObj statobj = DbUtil.executeUpdateQueries(queries);
            } //End try
            catch (Exception e) {
                EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION, EventbeeLogger.ERROR, "CustomAttribsDB.java", "deleteResponseFromDB()", e.getMessage(), e);
            } //End catch
        } //End deleteResponseFromDB()

    public String extendsTestMethod(String arg1, String arg2) {
        return "args" + arg1 + arg2;
    }
}