package com.eventbee.clubmember;

import com.eventbee.general.*;
import java.util.*;
import java.text.*;
import com.eventbee.authentication.Authenticate;
import com.eventbee.authentication.AuthDB;
import com.eventbee.useraccount.AccountDB;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.creditcard.*;
import java.sql.*;
import com.eventbee.clubs.*;
import com.eventbee.activateaccount.*;

public class ClubDB {

  final static String FILE_NAME="ClubMemberSignUp";

 public  static final String INSERT_CLUB_PAYMENTS ="insert into club_payments(payment_trans_id,clubid,member_id,payment_date,pay_amount,pay_purpose,pay_mode,created_by,created_at) values(?,?,?,now(),?,'MEMBER_SUBSCRIPTION','CARD','CLUBDB',now())";

  final String CLUB_MEMBERSHIPEXISTS_QUERY = " select membership_id from club_membership_master "
											+" where  clubid IN (select clubid from clubinfo where cast(unitid as varchar)=?)";
  final String CLUB_EXIST="select clubid from clubinfo where unitid=?";
  final String CLUB_MEMBER_QUERY = " select * from club_member_profile "
				+" where userid=? "
				+" and clubid=?";
  final String CLUB_MEMBERSHIP_QUERY = " select * from club_membership_master where  clubid=?";

  final String CLUB_UNIT_MEMSHIP_QUERY=" select b.clubname,a.membership_id,a.membership_name,a.description,a.createtype,a.status,"
				+"a.currency_type,a.price,a.term_fee,a.mship_term from club_membership_master as a,"
				+"clubinfo as b where a.clubid=b.clubid and  a.clubid=? and b.unitid=? and a.status='ACTIVE'";

  final String MEMBER_SEQIDS_QUERY = " select org_id as orgid,unit_id as unitid, "
				+" nextval('seq_roleid') as roleid, 1 as authid, "
				+" nextval('seq_userid') as userid "
				+" from org_unit where unit_id=?";

final String GET_EBEE_FEE_UNIT ="select * from ebeefees where purpose=? and unitid=? and range_min<=? and range_max>=? ";

  final String GET_EBEE_FEE ="select * from ebeefees where purpose=?";
  final String GET_CLUBID_QUERY = " select clubid,clubname as clubid from clubinfo where unitid=?";
  final String TRANSACTION_INSERT = " insert into transaction(transactionid, "
			+" refid,unitid,purpose,trandate,ebeefee,cardfee,mgrfee,attendeefee, "
			+" totalamount,grandtotal,discount,discountcode) values (?,?,'13579',?,now(),?,?,?,?,?,?,?,?) ";

  static final String CLUB_INFO_INSERT="insert into clubinfo(clubid,unitid,mgr_id,category,clubname,description,"
+"clublogo,config_id,city,state,created_by,created_at,updated_by,updated_at)"
 +" values(nextval('seq_groupid'),?,?,?,?,?,?,?,?,?,'clubadd',now(),'clubadd',now()) ";

  static final String CLUB_INFO_UPDATE = " update clubinfo set clubname=?,description=?,clublogo=? where clubid=?";
  static final String CLUB_INFO_GET = " select * from clubinfo where unitid=?";

static final String INSERT_MEMBER="insert into member_profile(manager_id,member_id,m_email,userid,created_at)	values (?,?,?,?,now())";
static final String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at) values(?,?,'available',now())";


   public void getGrandPrice(HashMap hm,String purpose,String unitid,String amount){
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(GET_EBEE_FEE_UNIT,new String[]{purpose,unitid,amount,amount});

		if(!(statobj != null && statobj.getStatus() && statobj.getCount()>0   )){
				statobj=dbmanager.executeSelectQuery(GET_EBEE_FEE_UNIT,new String[]{purpose,"0",amount,amount});
			}
		if(statobj != null && statobj.getStatus() && statobj.getCount()>0   ){
			hm.put("ebee_fee_base",dbmanager.getValue(0,"ebee_base","0"));
			hm.put("ebee_fee_percent",dbmanager.getValue(0,"ebee_factor","0"));
			hm.put("card_fee_base",dbmanager.getValue(0,"card_base","0"));
			hm.put("card_fee_percent",dbmanager.getValue(0,"card_factor","0"));
		}
}

  public boolean isAlreadyMember(String clubid, String userid){
	Connection con=null;
	boolean exists=false;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("clubmember");
		pstmt=con.prepareStatement(CLUB_MEMBER_QUERY);
		pstmt.setString(1,userid);
		pstmt.setString(2,clubid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			exists=true;
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in isAlreadyMember()", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return exists;
    }

 public StatusObj InsertClubMember(ClubMemberSignUp jBean){
        int rcount=0;
        Connection con=null;
        boolean autocommit=false;
	HashMap hm=null;
	StatusObj stob=new StatusObj(false,"",null);
	try{
		 con=EventbeeConnection.getWriteConnection("clubmember");
	         con.setAutoCommit(false);
		 AccountDB accDB=new AccountDB();
 		 stob=accDB.insertMemberData(jBean.getAuthInfo().getDataHash(),jBean.getUserInfo().getDataHash(),null,con);  // authenticate,user_profile insert
	         if(stob.getStatus()){
			rcount=accDB.InsertClubMemberDueEntry(jBean.getUserInfo().getDataHash(), con); // club_member_profile insert
			if(rcount>0){
				rcount=0;
				String member_id=getMemberID((String)((jBean.getAuthInfo().getDataHash()).get("userid")),con);
				jBean.getAuthInfo().getDataHash().put("memberid",member_id);
				rcount=InsertClubPayments(jBean,con);
				if(rcount>0){
					rcount=0;
					rcount=InsertTransactionInfo(jBean,"CLUB_MEMBERSHIP",con);
					HashMap DataHash=jBean.getAuthInfo().getDataHash();
					DataHash.put("termamount",jBean.getDueAmount()+"");
					DataHash.put("nextpaydate",(String)(jBean.getUserInfo().getDataHash()).get("nextpaydate"));
					DataHash.put("purpose","MEMBER_SUBSCRIPTION");
				if(rcount>0){
					if(jBean.getGrandTotal()>0){
						CreditCardModel ccm=jBean.getCard();
						if(ccm!=null){
							SimpleDateFormat SDF = new SimpleDateFormat("MM-dd-yyyy");
							java.util.Date nextpaydate=SDF.parse((String)(jBean.getUserInfo().getDataHash().get("nextpaydate")));
							java.util.Date expirationdate=SDF.parse(ccm.getExpmonth()+"-28-"+ccm.getExpyear());
							if((nextpaydate.equals(expirationdate))||(nextpaydate.before(expirationdate))){
								boolean flag=ccm.recurringPayment((String)((jBean.getDataHash()).get("userid")),Integer.parseInt((String)(jBean.getDataHash().get("termmonths"))),(String)((jBean.getUserInfo().getDataHash()).get("nextpaydate")),jBean.getDueAmount()+"","MEMBER_SUBSCRIPTION");
								if(!flag){
									rcount=0;
									rcount=accDB.InsertSubscriptionDue(DataHash,con); // subscriptiondue insert
								}
							}else{
								rcount=0;
								rcount=accDB.InsertSubscriptionDue(DataHash,con); // subscriptiondue insert
							}
						}
					  }
				    }
				}
			}
		 }
		 if(rcount==0){
			  con.rollback();
			  stob=new StatusObj(false, "rollback",null);
		 }else{
			    con.commit();
			    stob=new StatusObj(true, "success","");
		  }
        	  con.close();
		  con=null;
        }catch(Exception e){
	      rcount=0;
	      stob=new StatusObj(false, e.getMessage(), null, rcount);

	      EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in InsertClubMember()", e.getMessage(), e ) ;

       }
     finally{
		try{
			if(con!=null){
			      if(rcount==0){
				  con.rollback();
			      }
			      con.close();
			}
		}catch(Exception e){}
	}
      return stob;
  }



//////InsertClubMemberNew

   public StatusObj InsertClubMemberNew(ClubMemberSignUp jBean){
          EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","clubmember insert",null);
          int rcount=0;
          Connection con=null;
          boolean autocommit=false;
  	HashMap hm=null;
  	StatusObj stob=new StatusObj(false,"",null);
  	try{
  		 con=EventbeeConnection.getWriteConnection("clubmember");
  	         con.setAutoCommit(false);
  		 AccountDB accDB=new AccountDB();
   		// stob=accDB.insertMemberData(jBean.getAuthInfo().getDataHash(),jBean.getUserInfo().getDataHash(),null,con);  // authenticate,user_profile insert
  	         //if(stob.getStatus()){
  			rcount=accDB.InsertClubMemberDueEntryNew(jBean.getUserInfo().getDataHash(), con); // club_member insert
  			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","after accDB.InsertClubMemberDueEntry, rcount: "+rcount,null);
  			if(rcount>0){
  				rcount=0;
  				String query="select member_id from club_member where userid=? and membership_id="+jBean.getMemberShipId();
				String member_id=getMemberID((String)((jBean.getAuthInfo().getDataHash()).get("userid")),con,query);

  				jBean.getAuthInfo().getDataHash().put("memberid",member_id);
  				rcount=InsertClubPayments(jBean,con);
  				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","after InsertClubPayments, rcountttt: "+rcount,null);

  				if(rcount>0){
  					rcount=0;
  					rcount=InsertTransactionInfo(jBean,"CLUB_MEMBERSHIP",con);
  					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","after InsertTransactionInfo, rcount: "+rcount,null);
  					HashMap DataHash=jBean.getAuthInfo().getDataHash();
  					DataHash.put("termamount",jBean.getDueAmount()+"");
  					DataHash.put("nextpaydate",(String)(jBean.getUserInfo().getDataHash()).get("nextpaydate"));
  					DataHash.put("purpose","MEMBER_SUBSCRIPTION");

  				if(rcount>0){
  					if(jBean.getGrandTotal()>0){
  						CreditCardModel ccm=jBean.getCard();
  						if(ccm!=null){
							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","ccm!=null: ",null);
  							SimpleDateFormat SDF = new SimpleDateFormat("MM-dd-yyyy");
  							java.util.Date nextpaydate=SDF.parse((String)(jBean.getUserInfo().getDataHash().get("nextpaydate")));
  							java.util.Date expirationdate=SDF.parse(ccm.getExpmonth()+"-28-"+ccm.getExpyear());
  							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","ccm!=null:and nextpaydate is  "+nextpaydate.toString(),null);
  							EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","ccm!=null:and expirationdate is  "+expirationdate.toString(),null);
  							if((nextpaydate.equals(expirationdate))||(nextpaydate.before(expirationdate))){
  								boolean flag=ccm.recurringPayment((String)((jBean.getDataHash()).get("userid")),Integer.parseInt((String)(jBean.getDataHash().get("termmonths"))),(String)((jBean.getUserInfo().getDataHash()).get("nextpaydate")),jBean.getDueAmount()+"","MEMBER_SUBSCRIPTION");
  								if(!flag){

  									rcount=0;
  									rcount=accDB.InsertSubscriptionDue(DataHash,con); // subscriptiondue insert
  									EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","in !ccm.recurringPayment,accDB.InsertSubscriptionDue, rcount: "+rcount,null);
  								}
  							}else{
  								rcount=0;
  								rcount=accDB.InsertSubscriptionDue(DataHash,con); // subscriptiondue insert
  								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","in else of !ccm.recurringPayment,accDB.InsertSubscriptionDue, rcount: "+rcount,null);
  							}
  						}
  					  }
  				    }
  				}
  			}
  		 //}
  		 if(rcount==0){
  			  con.rollback();
  			  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","con.rollback(), rcount: "+rcount,null);
  			  stob=new StatusObj(false, "rollback",null);
  		 }else{
  			  con.commit();
  			  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertClubMemberNew(ClubMemberSignUp jBean)","con.commit(), rcount: "+rcount,null);


  			  stob=new StatusObj(true, "success","");
  		  }
          	  con.close();
  		  con=null;
          }catch(Exception e){
  	      rcount=0;
  	      stob=new StatusObj(false, e.getMessage(), null, rcount);
  	     EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "InsertClubMemberNew(ClubMemberSignUp jBean)", e.getMessage(), e ) ;


         }
       finally{
  		try{
  			if(con!=null){
  			      if(rcount==0){
  				  con.rollback();
  			      }
  			      con.close();
  			}
  		}catch(Exception e){}
  	}
        return stob;
  }





public String getMemberID(String userid,Connection con){
	String query="select member_id from club_member_profile where userid=?";
	return getMemberID(userid,con,query);
}




   public String getMemberID(String userid,Connection con,String query){
	int rcount=0;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	java.sql.ResultSet rs=null;
	String member_id="";
	try{
		pstmt=con.prepareStatement(query);
		pstmt.setString(1,userid);
                rs=pstmt.executeQuery();
		if(rs.next()){
			member_id=rs.getString("member_id");
		}
		rs.close();
		rs=null;
		pstmt.close();
 		pstmt=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getMemberId()", e.getMessage(), e ) ;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(rs!=null) rs.close();
		}catch(Exception e){}
	}
	return member_id;
    }

  public int InsertClubPayments(ClubMemberSignUp jBean,Connection con){
	int rcount=0;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		hm=jBean.getDataHash();
		//pstmt=con.prepareStatement("insert into club_payments(payment_trans_id,clubid,member_id,payment_date,pay_amount,pay_purpose,pay_mode,created_by,created_at) values(?,?,?,now(),?,'MEMBER_SUBSCRIPTION','CARD','CLUBDB',now())");
		pstmt=con.prepareStatement(INSERT_CLUB_PAYMENTS);
		pstmt.setString(1,jBean.getTransactionId());
		pstmt.setString(2,(String)(jBean.getUserInfo().getDataHash().get("clubid")));
		pstmt.setString(3,(String)(jBean.getAuthInfo().getDataHash().get("memberid")));
		pstmt.setString(4,jBean.getGrandTotal()+"");

                rcount=pstmt.executeUpdate();
		pstmt.close();
 		pstmt=null;

	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in InsertClubPayments()", e.getMessage(), e ) ;

	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return rcount;
    }

 public Vector getMemberShipInfo(String clubid){
	Connection con=null;
        HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
        Vector v=new Vector();
	try{
		con=EventbeeConnection.getReadConnection("clubmember");
		pstmt=con.prepareStatement(CLUB_MEMBERSHIP_QUERY);
		pstmt.setString(1,clubid);
		ResultSet rs=pstmt.executeQuery();
		while(rs.next()){
			ClubMemberShip memship=new ClubMemberShip();
			memship.setMemberShipId(rs.getString("membership_id"));
 			memship.setMemberShipName(rs.getString("membership_name"));
 			memship.setDescription(rs.getString("description"));
 			memship.setCurrencyType(rs.getString("currency_type"));
 			memship.setPrice(rs.getString("price"));
 			memship.setTermPrice(rs.getString("term_fee"));
			memship.setMshipTerm(rs.getString("mship_term"));
			v.addElement(memship);
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getMemberShipInfo()", e.getMessage(), e ) ;
		v=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }

  public Vector getClubMemShipInfo(String clubid,String unitid){
  	Connection con=null;
        HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
        Vector v=new Vector();
	try{
		con=EventbeeConnection.getReadConnection("clubmember");
		pstmt=con.prepareStatement(CLUB_UNIT_MEMSHIP_QUERY);
		pstmt.setString(1,clubid);
		pstmt.setString(2,unitid);
		ResultSet rs=pstmt.executeQuery();
		while(rs.next()){
			ClubMemberShip memship=new ClubMemberShip();
			memship.setMemberShipId(rs.getString("membership_id"));
 			memship.setMemberShipName(rs.getString("membership_name"));
 			memship.setDescription(rs.getString("description"));
			memship.setCreateType(rs.getString("createtype"));
			memship.setStatus(rs.getString("status"));
 			memship.setCurrencyType(rs.getString("currency_type"));
 			memship.setPrice(rs.getString("price"));
 			memship.setTermPrice(rs.getString("term_fee"));
			memship.setMshipTerm(rs.getString("mship_term"));
			memship.setClubName(rs.getString("clubname"));
			v.addElement(memship);
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getClubMemShipInfo()", e.getMessage(), e ) ;
		v=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }

  public void getGrandPrice(HashMap hm,String param){
	Connection con=null;
	ResultSet rs=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection();
		pstmt=con.prepareStatement(GET_EBEE_FEE);
                pstmt.setString(1,param);
                rs=pstmt.executeQuery();
                if(rs.next()){

			      hm.put("ebee_fee_base",rs.getString("ebee_base"));
			      hm.put("ebee_fee_percent",rs.getString("ebee_factor"));
                              hm.put("card_fee_base",rs.getString("card_base"));
                              hm.put("card_fee_percent",rs.getString("card_factor"));

        	}
		rs.close();
		pstmt.close();
               	pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getGrandPrice()", e.getMessage(), e ) ;

	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
    }

  public int InsertTransactionInfo(ClubMemberSignUp jBean,String purpose,Connection con){
	int rcount=0;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{



		hm=jBean.getDataHash();
		String transid=jBean.getTransactionId();
		pstmt=con.prepareStatement(TRANSACTION_INSERT);
		pstmt.setString(1,transid);

		pstmt.setString(2,(String)hm.get("userid"));
		pstmt.setString(3,purpose);
		pstmt.setString(4,(String)jBean.getObject("ebeefee"));
                pstmt.setString(5,(String)jBean.getObject("cardfee"));
                pstmt.setString(6,(String)jBean.getObject("mgrfee"));
                pstmt.setString(7,"0");
                pstmt.setString(8,(String)jBean.getObject("totalamt"));
                pstmt.setString(9,(String)jBean.getObject("grandtotal"));
                 pstmt.setString(10,jBean.getDiscount());
                  pstmt.setString(11,jBean.getDiscountCode());

                rcount=pstmt.executeUpdate();
		pstmt.close();
 		pstmt=null;

	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in InsertEventInfo()", e.getMessage(), e ) ;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return rcount;
    }

  public boolean isValidClubExists(String unitid){
	  if("13579".equals(unitid))
	  return false;
	Connection con=null;
	boolean exists=false;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection();
		pstmt=con.prepareStatement(CLUB_MEMBERSHIPEXISTS_QUERY);
		pstmt.setString(1,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			exists=true;
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in isValidClubExists()", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return exists;
    }

    public Vector getMemberShipData(String clubid){
	Connection con=null;
        HashMap hm=null;
	Vector v=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection();
		pstmt=con.prepareStatement(CLUB_MEMBERSHIP_QUERY);
		pstmt.setString(1,clubid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			v=new Vector();
			do{
				hm=new HashMap();
				hm.put("membership_id", rs.getString("membership_id"));
				hm.put("membership_name", rs.getString("membership_name"));
				hm.put("description", rs.getString("description"));
				hm.put("price", rs.getString("price"));
				v.addElement(hm);
			}while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getMemberShipData()", e.getMessage(), e ) ;
		v=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }



   public StatusObj createMember(ClubSignUp jBean, Authenticate au){
     String userid=null;
	 StatusObj statusObj=null;
	  int rcount=1;
     Connection con=null;
    boolean autocommit=false;
    try{
	  HashMap DataHash=new HashMap();
          AccountDB actdb=new AccountDB();
	  con=EventbeeConnection.getWriteConnection("clubmember");
          con.setAutoCommit(false);
          if (au==null){
		  rcount=0;
		  DataHash=actdb.getSequenceID(jBean.getUnitId());
     		  DataHash.put("rolecode", "MEM");
		  DataHash.put("rolename", "Member");
		  DataHash.put("roletype", "1");
                  rcount=actdb.InsertUserRoleEntry(DataHash, con);
                  if(rcount>0){
			DataHash.put("firstname", jBean.getFirstName());
			DataHash.put("lastname", jBean.getLastName());
			DataHash.put("email", jBean.getEmail());
			DataHash.put("phone", jBean.getPhone());
			DataHash.put("mobile", jBean.getMobilephone());
			DataHash.put("gender", jBean.getGenderData());
		       	rcount=actdb.InsertUserProfileEntry(DataHash, con);
		  }
		  if(rcount>0){
			DataHash.put("loginname", jBean.getUserName());
			DataHash.put("password", jBean.getPassword());
			DataHash.put("acctstatus", "1");
                  	rcount=actdb.InsertAuthenticationEntry(DataHash, con);
		  }
                  if(rcount>0)
	          	rcount=actdb.InsertMemPortalConfigEntry(DataHash, con);
                  if(rcount>0){
			Set e = jBean.getAllPreferences();
                	List B =Arrays.asList(jBean.getPref());
   	            	for (Iterator i = e.iterator(); i.hasNext();){
                          Map.Entry entry =(Map.Entry)i.next();
		          String keyName= (String)entry.getKey();
                          DataHash.put("prefname",keyName);
                          DataHash.put("prefvalue",B.contains(keyName)?"yes":"no");
                          actdb.InsertMemberPreferences(DataHash, con);
			}
                   }
          }else{
		DataHash.put("userid", au.getUserID());
	  }

          if(rcount>0){
		DataHash.put("membershipid", jBean.getMembershipId());
		DataHash.put("clubid", jBean.getClubId());
		DataHash.put("firstname", jBean.getFirstName());
		DataHash.put("lastname", jBean.getLastName());
		DataHash.put("email", jBean.getEmail());
		DataHash.put("phone", jBean.getPhone());
          	rcount=actdb.InsertClubMemberEntry(DataHash, con);
          }
	 	  if(rcount==0){
			  con.rollback();
			  statusObj=new StatusObj(false, "rollback", null, rcount);
		  }else{
			    con.commit();
			   statusObj=new StatusObj(true, "success", jBean, rcount);
		  }
          con.close();
	  con=null;
     }catch(Exception e){
		rcount=0;
		statusObj=new StatusObj(false, e.getMessage(), null, rcount);

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createMember()", e.getMessage(), e ) ;

     }
     finally{
		try{
			if(con!=null) con.close();
		}catch(Exception e){}
	}
      return statusObj;
  }



  public HashMap getSeqIds(String unitid){
	Connection con=null;
        HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection();
		pstmt=con.prepareStatement(MEMBER_SEQIDS_QUERY);
		pstmt.setString(1,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
				hm=new HashMap();
				hm.put("orgid", rs.getString("orgid"));
				hm.put("unitid", rs.getString("unitid"));
				hm.put("roleid", rs.getString("roleid"));
				hm.put("userid", rs.getString("userid"));
				//hm.put("transid", rs.getString("transid"));
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getSeqIds()", e.getMessage(), e ) ;
		hm=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return hm;
    }

/* narayan clubmmber *******************/

public StatusObj createMember(ClubMemberProfile jBean, Authenticate au){
     String userid=null;
	 StatusObj statusObj=null;
     int rcount=1;
     Connection con=null;
    boolean autocommit=false;
    AuthDB authDb=new AuthDB();
    try{
	  HashMap DataHash=new HashMap();
          AccountDB actdb=new AccountDB();
	  con=EventbeeConnection.getWriteConnection("clubmember");
          con.setAutoCommit(false);

		  rcount=0;
		  DataHash=actdb.getSequenceID(au.getUnitID());
	 	  DataHash.put("firstname", jBean.getFirstName());
  		  DataHash.put("lastname", jBean.getLastName());
		  DataHash.put("email", jBean.getEmail());
		  DataHash.put("phone", jBean.getPhoneNo());
		  DataHash.put("mobile", jBean.getMobile());
		  DataHash.put("gender", jBean.getGender());
		  DataHash.put("street", jBean.getStreet());
		  DataHash.put("city", jBean.getCity());
		  DataHash.put("state", jBean.getState());
		  DataHash.put("zip", jBean.getZip());
		  DataHash.put("refsource", jBean.getRefSource());
		  DataHash.put("refby", jBean.getRefBy());

		  rcount=actdb.InsertUserProfileEntry(DataHash, con);
		  if(rcount>0){
			  String temploginname=jBean.getFirstName().substring(0,1)+jBean.getLastName().substring(0,1);
			  int usercount =authDb.getLoginNameCount(temploginname);
			  usercount=usercount+1;
			  jBean.setLoginName(temploginname+usercount);

			DataHash.put("loginname", jBean.getLoginName() );
			DataHash.put("password", EncodeNum.encodeNum(jBean.getClubId()).toUpperCase());

			DataHash.put("acctstatus", jBean.getStatus());
                  	rcount=actdb.InsertAuthenticationEntry(DataHash, con);
		  }

          if(rcount>0){
		DataHash.put("membershipid", jBean.getMemberShipId());
		DataHash.put("clubid", jBean.getClubId());
		DataHash.put("internalid", jBean.getInternalId());
		DataHash.put("memberstartdate", jBean.getStartDate());
		DataHash.put("memberduedate", jBean.getDueDate());

          	rcount=actdb.InsertClubMemberEntry(DataHash, con);
          }

	  	  if(rcount==0){
			  con.rollback();
			  statusObj=new StatusObj(false, "rollback", null, rcount);
		  }else{
			    con.commit();
			    jBean.setUserId((String)DataHash.get("userid"));
			     jBean.setLoginName((String)DataHash.get("loginname"));
			      jBean.setPassword((String)DataHash.get("password"));
				statusObj=new StatusObj(true, "success", jBean, rcount);
		  }
          con.close();
	  con=null;
     }catch(Exception e){
		rcount=0;
		statusObj=new StatusObj(false, e.getMessage(), null, rcount);

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createMember()", e.getMessage(), e ) ;
     }
     finally{
		try{
			if(con!=null) con.close();
		}catch(Exception e){}
	}
      return statusObj;
  }


public StatusObj createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector){
	 String unitid=au.getUnitID();
	 String userid=null;
	 StatusObj statusObj=null;
     int rcount=1;
     Connection con=null;
    boolean autocommit=false;
    AuthDB authDb=new AuthDB();
    try{
	  HashMap DataHash=new HashMap();
          AccountDB actdb=new AccountDB();
	  con=EventbeeConnection.getWriteConnection("clubmember");
          con.setAutoCommit(false);

		  rcount=0;
		  DataHash=actdb.getSequenceID(au.getUnitID());
	 	  DataHash.put("firstname", jBean.getFirstName());
  		  DataHash.put("lastname", jBean.getLastName());
		  DataHash.put("email", jBean.getEmail());
		  DataHash.put("phone", jBean.getPhoneNo());
		  DataHash.put("mobile", jBean.getMobile());
		  DataHash.put("gender", jBean.getGender());
		  DataHash.put("street", jBean.getStreet());
		  DataHash.put("city", jBean.getCity());
		  DataHash.put("state", jBean.getState());
		  DataHash.put("zip", jBean.getZip());
		  DataHash.put("refsource", jBean.getRefSource());
		  DataHash.put("refby", jBean.getRefBy());

		  rcount=actdb.InsertUserProfileEntry(DataHash, con);
		  if(rcount>0){
			  if(jBean.getLoginName()==null || "".equals( jBean.getLoginName()  ) ){
			  String temploginname=jBean.getFirstName().substring(0,1)+jBean.getLastName();
			  int usercount =authDb.getLoginNameCount(temploginname);
			  if(usercount==0){}
			  else if(usercount>9){
				  temploginname=temploginname+usercount;
				  }
			  else {

				  temploginname=temploginname+"0"+usercount;
				  }

			  jBean.setLoginName(temploginname);
			  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember()","temploginname created automatically is  : "+temploginname,null);
			  }

			DataHash.put("loginname", jBean.getLoginName() );

			DataHash.put("password", (jBean.getPassword()==null || "".equals( jBean.getPassword()  ) )?EncodeNum.encodeNum(jBean.getClubId()).toUpperCase():jBean.getPassword() );


			DataHash.put("acctstatus", jBean.getStatus());
			DataHash.put("requestup", jBean.requserpassstr);
                  	rcount=actdb.InsertAuthenticationEntryWithReqUP(DataHash, con);
		  }

          //-----------------------------------------------------------------//
	   ClubMemberShip clubmship=new ClubMemberShip();
		  clubmship.setMemberShipId(jBean.getMemberShipId());
		  Object obj=GenUtil.getObj(clubmship, mshipvector);
		  if(obj != null){
			  clubmship=(ClubMemberShip)obj;
		 }
		 String termPrice=clubmship.getTermPrice();
		  String termperiod=clubmship.getMshipTerm();
		  String tempduedate=jBean.getDueDate();
		  java.util.Date duepaydate=null;
		  if(tempduedate==null||"".equals(tempduedate)){
			  String tempstdate=jBean.getStartDate();
			  StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempstdate,"Start Date");

			  Calendar cal=Calendar.getInstance();
			  if(statobjstdt.getStatus()){
				  cal.setTime((java.util.Date)statobjstdt.getData());

				if("annual".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,12);
				}else
				if("Monthly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,1);
				}else
				if("Quarterly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,3);
				}else
				if("Half yearly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,6);
				}else{
					cal.add(Calendar.MONTH,12);
				}

			  }
			duepaydate=cal.getTime();
		 }else{
		 	StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempduedate,"End Date");
			if(statobjstdt.getStatus()){
					duepaydate=(java.util.Date)statobjstdt.getData();
				}

		 }

         //-----------------------------------------------------------------//
          if(rcount>0){
		DataHash.put("membershipid", jBean.getMemberShipId());
		DataHash.put("clubid", jBean.getClubId());
		DataHash.put("internalid", jBean.getInternalId());
		DataHash.put("memberstartdate", jBean.getStartDate());
		//DataHash.put("memberduedate", jBean.getDueDate());
		DataHash.put("memberduedate", duepaydate+"");

        String mgrid=DbUtil.getVal("select mgr_id from clubinfo where clubid=?",new String[]{jBean.getClubId()} );
		String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
		String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
		String listid=DbUtil.getVal("select list_id from mail_list where list_name like 'Active Members%' and unit_id=? and manager_id=?",new String[]{jBean.getClubId(),mgrid} );
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","listid is ----->:"+listid,null);
		StatusObj statob=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {mgrid,memberid,jBean.getEmail(),(String)DataHash.get("userid")});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","statob is----> :"+statob.getStatus(),null);
		statob=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","statob issss :"+statob.getStatus(),null);

          	//rcount=actdb.InsertClubMemberEntry(DataHash, con);
		if("13579".equals(unitid)){
			rcount=actdb.InsertClubMemberEntryNew(DataHash, con);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid=13579 is :"+rcount,null);
		}
		else{
			rcount=actdb.InsertClubMemberEntry(DataHash, con);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid!=13579 is :"+rcount,null);
		}
		}


	 if(rcount>0){
		  SubscriptionDue subdue=new SubscriptionDue();
		  subdue.setUserId((String)DataHash.get("userid"));
		  subdue.setPurpose("MEMBER_SUBSCRIPTION");
		  subdue.setStatus("");
		  subdue.setEntryDate(new java.util.Date());
		  /*ClubMemberShip clubmship=new ClubMemberShip();
		  clubmship.setMemberShipId(jBean.getMemberShipId());
		  Object obj=GenUtil.getObj(clubmship, mshipvector);
		  if(obj != null){
			  clubmship=(ClubMemberShip)obj;
		 }

		  String termPrice=clubmship.getTermPrice();
		  String termperiod=clubmship.getMshipTerm();
		  String tempduedate=jBean.getDueDate();
		  if(tempduedate==null||"".equals(tempduedate)){
			  String tempstdate=jBean.getStartDate();
			  StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempstdate,"Start Date");

			  Calendar cal=Calendar.getInstance();
			  if(statobjstdt.getStatus()){
				  cal.setTime((java.util.Date)statobjstdt.getData());

				if("annual".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,12);
				}else
				if("Monthly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,1);
				}else
				if("Quarterly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,3);
				}else
				if("Half yearly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,6);
				}else{
					cal.add(Calendar.MONTH,12);
				}

			  }

			  subdue.setDueDate(cal.getTime());

		  }else{
			  StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempduedate,"End Date");
			  	if(statobjstdt.getStatus()){
					subdue.setDueDate((java.util.Date)statobjstdt.getData());
				}
		  }*/
		  subdue.setDueDate(duepaydate);
		  subdue.setAmountDue(termPrice);

		  rcount=ActivateAccountMemDB.insertSubscriptionDue( subdue, au, con);
	  }

		  if(rcount==0){
			  con.rollback();
			  statusObj=new StatusObj(false, "rollback", null, rcount);
		  }else{
			    con.commit();
			    jBean.setUserId((String)DataHash.get("userid"));
			     jBean.setLoginName((String)DataHash.get("loginname"));
			      jBean.setPassword((String)DataHash.get("password"));
				statusObj=new StatusObj(true, "success", jBean, rcount);
		  }
          con.close();
	  con=null;
     }catch(Exception e){
		rcount=0;
		statusObj=new StatusObj(false, e.getMessage(), null, rcount);

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createMember()", e.getMessage(), e ) ;
     }
     finally{
		try{
			if(con!=null) con.close();
		}catch(Exception e){}
	}
      return statusObj;
  }





/*public StatusObj createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector){
	String unitid=au.getUnitID();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","unitid is :"+unitid,null);

     String userid=null;
	 StatusObj statusObj=null;
     int rcount=1;
     Connection con=null;
    boolean autocommit=false;
    AuthDB authDb=new AuthDB();
    try{
	  HashMap DataHash=new HashMap();
          AccountDB actdb=new AccountDB();
	  con=EventbeeConnection.getWriteConnection("clubmember");
          con.setAutoCommit(false);

		  rcount=0;
		  DataHash=actdb.getSequenceID(au.getUnitID());
	 	  DataHash.put("firstname", jBean.getFirstName());
  		  DataHash.put("lastname", jBean.getLastName());
		  DataHash.put("email", jBean.getEmail());
		  DataHash.put("phone", jBean.getPhoneNo());
		  DataHash.put("mobile", jBean.getMobile());
		  DataHash.put("gender", jBean.getGender());
		  DataHash.put("street", jBean.getStreet());
		  DataHash.put("city", jBean.getCity());
		  DataHash.put("state", jBean.getState());
		  DataHash.put("zip", jBean.getZip());
		  DataHash.put("refsource", jBean.getRefSource());
		  DataHash.put("refby", jBean.getRefBy());

		  rcount=actdb.InsertUserProfileEntry(DataHash, con);
		  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertUserProfileEntry(DataHash, con) rcount is :"+rcount,null);
		  if(rcount>0){
			  if(jBean.getLoginName()==null || "".equals( jBean.getLoginName()  ) ){
			  String temploginname=jBean.getFirstName().substring(0,1)+jBean.getLastName().substring(0,1);
			  int usercount =authDb.getLoginNameCount(temploginname);
			  usercount=usercount+1;
			  jBean.setLoginName(temploginname+"0"+usercount);
			  }

			DataHash.put("loginname", jBean.getLoginName() );

			DataHash.put("password", (jBean.getPassword()==null || "".equals( jBean.getPassword()  ) )?EncodeNum.encodeNum(jBean.getClubId()).toUpperCase():jBean.getPassword() );


			DataHash.put("acctstatus", jBean.getStatus());
			DataHash.put("requestup", jBean.requserpassstr);
                  	rcount=actdb.InsertAuthenticationEntryWithReqUP(DataHash, con);
                  	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertAuthenticationEntryWithReqUP(DataHash, con) rcount is :"+rcount,null);

		  }


          if(rcount>0){
		DataHash.put("membershipid", jBean.getMemberShipId());
		DataHash.put("clubid", jBean.getClubId());
		DataHash.put("internalid", jBean.getInternalId());
		DataHash.put("memberstartdate", jBean.getStartDate());
		DataHash.put("memberduedate", jBean.getDueDate());

		if("13579".equals(unitid)){
			rcount=actdb.InsertClubMemberEntryNew(DataHash, con);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid=13579 is :"+rcount,null);


		}
		else{
          	rcount=actdb.InsertClubMemberEntry(DataHash, con);
          	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid!=13579 is :"+rcount,null);


		}
          }


	  if(rcount>0){
		  SubscriptionDue subdue=new SubscriptionDue();
		  subdue.setUserId((String)DataHash.get("userid"));
		  subdue.setPurpose("MEMBER_SUBSCRIPTION");
		  subdue.setStatus("");
		  subdue.setEntryDate(new java.util.Date());
		  ClubMemberShip clubmship=new ClubMemberShip();
		  clubmship.setMemberShipId(jBean.getMemberShipId());
		  Object obj=GenUtil.getObj(clubmship, mshipvector);
		  if(obj != null){
			  clubmship=(ClubMemberShip)obj;
		  }

		  String termPrice=clubmship.getTermPrice();

		  String termperiod=clubmship.getMshipPeriod();

		  String tempduedate=jBean.getDueDate();
		  if(tempduedate==null||"".equals(tempduedate)){
			  String tempstdate=jBean.getStartDate();
			  StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempstdate,"Start Date");
			  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) statobjstdt :"+statobjstdt.getStatus(),null);

			  Calendar cal=Calendar.getInstance();
			  if(statobjstdt.getStatus()){
				  cal.setTime((java.util.Date)statobjstdt.getData());

				if("annual".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,12);
				}else
				if("Monthly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,1);
				}else
				if("Quarterly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,3);
				}else
				if("Half yearly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,6);
				}else{
					cal.add(Calendar.MONTH,12);
				}

			  }

			  subdue.setDueDate(cal.getTime());

		  }else{
			  StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempduedate,"End Date");
			  	if(statobjstdt.getStatus()){
					subdue.setDueDate((java.util.Date)statobjstdt.getData());
				}
		  }

		  subdue.setAmountDue(termPrice);
		  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","termPrice is:"+termPrice,null);
		  rcount=ActivateAccountMemDB.insertSubscriptionDue( subdue, au, con);
		  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at ActivateAccountMemDB.insertSubscriptionDue rcount is:"+rcount,null);
	  }

		  if(rcount==0){
			  con.rollback();
			  statusObj=new StatusObj(false, "rollback", null, rcount);
		  }else{
			    con.commit();
			    jBean.setUserId((String)DataHash.get("userid"));
			     jBean.setLoginName((String)DataHash.get("loginname"));
			      jBean.setPassword((String)DataHash.get("password"));
				statusObj=new StatusObj(true, "success", jBean, rcount);
		  }
          con.close();
	  con=null;
     }catch(Exception e){
		rcount=0;
		statusObj=new StatusObj(false, e.getMessage(), null, rcount);

     }
     finally{
		try{
			if(con!=null) con.close();
		}catch(Exception e){}
	}
      return statusObj;
  }



*/



/* narayan clubmmber end*******************/



//by sudha to retrive clubid based on unitid
  public String getClubID(String unitid){
	Connection con=null;
	String clubid=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("clubmember");
		pstmt=con.prepareStatement(GET_CLUBID_QUERY);
		pstmt.setString(1,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			clubid=rs.getString("clubid");
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in getClubID()", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return clubid;
    }

    public boolean isClubExists(String unitid){
	Connection con=null;
	boolean exists=false;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("clubmember");
		pstmt=con.prepareStatement(CLUB_EXIST);
		pstmt.setString(1,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			exists=true;
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in isClubExists()", e.getMessage(), e ) ;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return exists;
    }


   public static int createClub(ClubInfo clubInfo){
	Connection con = null;
        PreparedStatement pstmt = null;
	 int rcount=0;
        try{
	     String[] configSeq=DbUtil.getSeqVals("seq_configid",1);
	     String configId=configSeq[0];
	     con=EventbeeConnection.getWriteConnection();
	     con.setAutoCommit(false);
	     pstmt=con.prepareStatement(CLUB_INFO_INSERT);
 	     pstmt.setString(1,clubInfo.getUnitId());
	     pstmt.setString(2,clubInfo.getManagerId());
	     pstmt.setString(3,clubInfo.getCategory());
	     pstmt.setString(4,clubInfo.getClubName());
   	     pstmt.setString(5,clubInfo.getDescription());
  	     pstmt.setString(6,clubInfo.getClubLogo());
	     pstmt.setString(7,configId);
       	     pstmt.setString(8,clubInfo.getClubCity());
       	     pstmt.setString(9,clubInfo.getClubState());
	     rcount=pstmt.executeUpdate();
	     pstmt.close();
	     HashMap hm=new HashMap();
	     hm.put(ClubInfo.URL,clubInfo.getClubURL());
	     hm.put(ClubInfo.LISTATEB,clubInfo.getListAtEventbee());
	     if(rcount>0){
		  rcount=0;
		  rcount=ConfigLoader.insertConfigInfo(configId,hm,con);
	     }
	     if(rcount>0){
			con.commit();
	     }else{
		 con.rollback();
	     }
	     con.close();
	     con=null;
	}catch(SQLException sqle){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createClub()", sqle.getMessage(), sqle ) ;
	}catch(Exception e){

		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createClub()", e.getMessage(), e ) ;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
    }


	public static ClubInfo getClubInformation(String unitid,String clubid){
		String query="select * from clubinfo where clubid=?";
		return getClubInfo(clubid,query);
	}

	public static ClubInfo getClubInfo(String unitid){
		return getClubInfo(unitid,CLUB_INFO_GET);
	}

   public static ClubInfo getClubInfo(String unitid,String query){
        EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getClubInfo()", "Entered into club info method"+unitid,null);
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	ResultSet rs=null;
	ClubInfo cb=null;
	try{
		con=EventbeeConnection.getReadConnection();
		pstmt=con.prepareStatement(query);
		pstmt.setString(1,unitid);
		rs=pstmt.executeQuery();
		if(rs.next()){
			cb=new ClubInfo();
			cb.setUnitId(rs.getString("unitid"));
 			cb.setManagerId(rs.getString("mgr_id"));
 			cb.setClubId(rs.getString("clubid"));
 			cb.setCategory(rs.getString("category"));
 			cb.setClubName(rs.getString("clubname"));
 			cb.setDescription(rs.getString("description"));
			cb.setClubLogo(rs.getString("clublogo"));
			cb.setTermsCond(rs.getString("termscond"));
                        EventbeeLogger.log("com.eventbee.main",EventbeeLogger.DEBUG,FILE_NAME, "getClubInfo()", "Terms and Conditions value"+cb.getTermsCond(),null);
			cb.setConfigId(rs.getString("config_id"));
			HashMap hm=ConfigLoader.getConfig(rs.getString("config_id"));
			if(hm!=null){
				String cluburl=(String)hm.get(ClubInfo.URL);
				if("".equals(cluburl) || cluburl==null)
					cluburl=getDefaultClubURL(cb.getClubId(),cb.getManagerId());
				cb.setClubURL(cluburl);
				cb.setListAtEventbee((String)hm.get(ClubInfo.LISTATEB));
			}
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
                EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getClubInfo()","Error occured in ClubInfo object is:",e);
		cb=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return cb;
    }
   public static String getDefaultClubURL(String clubid,String mgr_id){
	   String cluburl = "";
		String servername = EbeeConstantsF.get("serveraddress","http://www.eventbee.com");
		if (!servername.startsWith("http://"))
			servername = "http://" + servername;
		String clublogo = DbUtil.getVal("select clublogo from clubinfo where clubid=to_number(?,'999999999')",
						new String[] { clubid });
		String username = DbUtil.getVal(
				"select login_name from authentication where " + " user_id=?",
				new String[] { mgr_id });
		cluburl = ShortUrlPattern.get(username) + "/community/" + clublogo
				+ "/login";
		return cluburl;

   }
     public static int updateClubInfo(ClubInfo clubInfo){
	int rcount=0;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getWriteConnection("clubmember");
		pstmt=con.prepareStatement(CLUB_INFO_UPDATE);
 	        pstmt.setString(1,clubInfo.getClubName());
   	        pstmt.setString(2,clubInfo.getDescription());
  	        pstmt.setString(3,clubInfo.getClubLogo());
		pstmt.setString(4,clubInfo.getClubId());
		rcount=pstmt.executeUpdate();
		pstmt.close();
		if(rcount==1){
			HashMap hm=new HashMap();
			 hm.put(ClubInfo.URL,clubInfo.getClubURL());
		         hm.put(ClubInfo.LISTATEB,clubInfo.getListAtEventbee());
			rcount=ConfigLoader.setConfig(clubInfo.getConfigId(),hm,true,con);
		}
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){

		EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getClubInfo()","Error occured in updateMgrProfileEntry() is:",e);

	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return rcount;
    }
public static void InsertHubMailListMember(String groupid,String userid){
		String listid=null;
		String mgrid=DbUtil.getVal("select mgr_id from clubinfo where clubid=?",new String[]{groupid} );
		String memberstatus=DbUtil.getVal("select membership_status from authentication where user_id=?",new String[]{userid} );
		String email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{userid} );
		String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
		String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
		if("INDIRECT".equals(memberstatus))
			listid=DbUtil.getVal("select list_id from mail_list where list_name like 'Passive Members%' and unit_id=? and manager_id=?",new String[]{groupid,mgrid} );
		else
			listid=DbUtil.getVal("select list_id from mail_list where list_name like 'Active Members%' and unit_id=? and manager_id=?",new String[]{groupid,mgrid} );
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertHubMailListMember(String groupid,String userid)","listid issssss------>"+listid,null);
		StatusObj stob=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {mgrid,memberid,email,userid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertHubMailListMember(String groupid,String userid)","stob issssss------>"+stob.getStatus(),null);
		stob=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","InsertHubMailListMember(String groupid,String userid)","stob is------------->"+stob.getStatus(),null);
	}


	public static StatusObj createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector){
		String unitid=au.getUnitID();
		String userid=null;
		StatusObj statusObj=null;
		int rcount=1;
		Connection con=null;
		boolean autocommit=false;
		AuthDB authDb=new AuthDB();
		try{
			HashMap DataHash=new HashMap();
			AccountDB actdb=new AccountDB();
			con=EventbeeConnection.getWriteConnection("clubmember");
			con.setAutoCommit(false);
			rcount=0;
			DataHash=actdb.getSequenceID(au.getUnitID());
			DataHash.put("firstname", jBean.getFirstName());
			DataHash.put("lastname", jBean.getLastName());
			DataHash.put("email", jBean.getEmail());
			DataHash.put("phone", jBean.getPhoneNo());
			DataHash.put("mobile", jBean.getMobile());
			DataHash.put("gender", jBean.getGender());
			DataHash.put("street", jBean.getStreet());
			DataHash.put("city", jBean.getCity());
			DataHash.put("state", jBean.getState());
			DataHash.put("zip", jBean.getZip());
			DataHash.put("refsource", jBean.getRefSource());
			DataHash.put("refby", jBean.getRefBy());
			DataHash.put("membershipstatus", jBean.getMembershipStatus());
			DataHash.put("acctstatus", "1");

			String loginname=jBean.getClubId()+"_"+(String)DataHash.get("userid");

			DataHash.put("loginname", loginname);
			DataHash.put("password",loginname);
			statusObj=actdb.insertAttendeeData(DataHash);

	          //-----------------------------------------------------------------//
			ClubMemberShip clubmship=new ClubMemberShip();
			clubmship.setMemberShipId(jBean.getMemberShipId());
			Object obj=GenUtil.getObj(clubmship, mshipvector);
			if(obj != null){
				clubmship=(ClubMemberShip)obj;
			}
			String termPrice=clubmship.getTermPrice();
			String termperiod=clubmship.getMshipTerm();
			String tempduedate=jBean.getDueDate();
			java.util.Date duepaydate=null;
			if(tempduedate==null||"".equals(tempduedate)){
				String tempstdate=jBean.getStartDate();
				StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempstdate,"Start Date");

				Calendar cal=Calendar.getInstance();
				if(statobjstdt.getStatus()){
				  cal.setTime((java.util.Date)statobjstdt.getData());

				if("annual".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,12);
				}else
				if("Monthly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,1);
				}else
				if("Quarterly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,3);
				}else
				if("Half yearly".equalsIgnoreCase(termperiod)){
					cal.add(Calendar.MONTH,6);
				}else{
					cal.add(Calendar.MONTH,12);
				}

				}
				duepaydate=cal.getTime();
			}else{
				StatusObj statobjstdt=EventBeeValidations.isValidDate1(tempduedate,"End Date");
				if(statobjstdt.getStatus()){
					duepaydate=(java.util.Date)statobjstdt.getData();
				}
			}

    //-----------------------------------------------------------------//
			if(statusObj.getStatus()){
					DataHash.put("membershipid", jBean.getMemberShipId());
					DataHash.put("clubid", jBean.getClubId());
					DataHash.put("internalid", jBean.getInternalId());
					DataHash.put("memberstartdate", jBean.getStartDate());
					DataHash.put("memberduedate", duepaydate+"");

					String mgrid=DbUtil.getVal("select mgr_id from clubinfo where clubid=?",new String[]{jBean.getClubId()} );
					String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
					String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
					String listid=DbUtil.getVal("select list_id from mail_list where list_name like 'Passive Members%' and unit_id=? and manager_id=?",new String[]{jBean.getClubId(),mgrid} );
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","listid is :"+listid,null);
					StatusObj statob=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {mgrid,memberid,jBean.getEmail(),(String)DataHash.get("userid")});
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","statob is----> :"+statob.getStatus(),null);
					statob=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","statob issss :"+statob.getStatus(),null);
					if("13579".equals(unitid)){
						rcount=actdb.InsertClubMemberEntryNew(DataHash, con);
						EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid=13579 is :"+rcount,null);
					}
					else{
						rcount=actdb.InsertClubMemberEntry(DataHash, con);
						EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubDB.java","createPassiveMember(ClubMemberProfile jBean, Authenticate au,Vector mshipvector)","at actdb.InsertClubMemberEntryNew(DataHash, con) rcount for unitid!=13579 is :"+rcount,null);
					}

			}
		 if(rcount>0){
			  SubscriptionDue subdue=new SubscriptionDue();
			  subdue.setUserId((String)DataHash.get("userid"));
			  subdue.setPurpose("MEMBER_SUBSCRIPTION");
			  subdue.setStatus("");
			  subdue.setEntryDate(new java.util.Date());
			  subdue.setDueDate(duepaydate);
			  subdue.setAmountDue(termPrice);

			  rcount=ActivateAccountMemDB.insertSubscriptionDue( subdue, au, con);
		  }
			  if(rcount==0){
				  con.rollback();
				  statusObj=new StatusObj(false, "rollback", null, rcount);
			  }else{
				    con.commit();
			  }

	          con.close();
		  con=null;
	     }catch(Exception e){
			rcount=0;
			statusObj=new StatusObj(false, e.getMessage(), null, rcount);
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "ClubDB.java", "Error in createPassiveMember()", e.getMessage(), e ) ;
	     }
	     finally{
			try{
				if(con!=null) con.close();
			}catch(Exception e){}
		}
	      return statusObj;
  }


  }
