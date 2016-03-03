package com.eventbee.authentication;

import com.eventbee.general.EventbeeConnection;
import com.eventbee.general.StringEncrypter;
import java.util.Vector;
import java.util.HashMap;
import java.sql.*;
import com.eventbee.general.EventbeeLogger;

public class AuthDB {

  // Uday Developed Query's
  /*
 final String IsvalidMgrid="select a.login_name,a.password,b.email from authentication a,user_profile b "
	+" where a.user_id=b.user_id and a.login_name=? and b.email=? ";

final String IsvalidMgrPassword="select a.login_name,a.password,b.email from "
+" authentication a,user_profile b where a.user_id=b.user_id and a.password=? and b.email=?";


final String IsvalidMemberid="select a.login_name,a.password,b.email from authentication a,"
+" user_profile b where a.user_id=b.user_id and a.login_name=? and b.email=? and a.unit_id=? ";

final String IsvalidMemberPassword="select a.login_name,a.password,b.email from "
+" authentication a,user_profile b where a.user_id=b.user_id and a.password=? and b.email=? "
+" and a.unit_id=?";
*/

final String IsvalidMgrid="select a.login_name,a.password,b.email from authentication a,user_profile b "
	+" where a.user_id=b.user_id and b.email=? and role_id not in('-100') ";

final String IsvalidMgrPassword="select a.login_name,a.password,b.email from "
+" authentication a,user_profile b where a.user_id=b.user_id and b.email=? and role_id not in('-100')";


final String IsvalidMemberid="select a.login_name,a.password,b.email from authentication a,"
+" user_profile b where a.user_id=b.user_id  and b.email=? and a.unit_id=? ";

final String IsvalidMemberPassword="select a.login_name,a.password,b.email from "
+" authentication a,user_profile b where a.user_id=b.user_id and b.email=? "
+" and a.unit_id=?";



  final String UNITINFO_MGR_QUERY=" select up.user_id,up.first_name,up.last_name,up.email,c.clubid,"
 +"c.clubname,c.clubid,o.unit_code,o.unit_name from user_profile up,authentication a,user_role u,"
 +"org_unit o left outer join clubinfo c on o.unit_id=c.unitid and c.unitid=? where a.unit_id=?"
 +" and a.unit_id=u.unit_id and u.unit_id=o.unit_id and a.user_id=up.user_id and u.role_code='MGR'"
 +" and u.role_type=1 and u.role_id=a.role_id ";
  //   ***************
  final String NAME_EXISTS_QUERY = " select * from AUTHENTICATION Where lower(Login_Name)=?";

  final String NAME_EXISTS_QUERY_BY_UNITID = " select * from AUTHENTICATION Where lower(Login_Name)=? and unit_id =? ";

  final String USER_INFO=" select auth_id,org_id,unit_id,role_id,login_name,acct_status,mgrcomments from authentication where user_id=?";
  final String USER_PREF_INFO="select * from member_preference where pref_name='pref:myurl' and lower(pref_value)=lower(?)";
  final String USER_PREF_INFO1="select * from member_preference where user_id=? and pref_name=?";

  final String NAME_EXISTS_QUERY1 = " select count(*) as count from AUTHENTICATION Where Login_Name like ?";

  final String AUTHENTICATION_QUERY = " select distinct a.Auth_ID, a.Org_ID, a.Unit_Id, "
       + " a.Role_ID,a.User_ID, a.Login_Name, a.password,a.Acct_Status  as Acct_Status_id,"
       + " u.first_name,u.last_name, u.email, u.phone,"
+ " b.orgpkg_type,c.unitpkg_type,b.acct_status as org_acct_status ,c.acct_status as unit_acct_status,"

+"b.org_sts_desc as org_sts_description,c.unit_sts_desc as unit_sts_description,a.description as account_description,"
      + " b.Org_Name, f.Type_Code  as Org_Type_Code,c.Unit_Name, c.Unit_Code, g.Type_Code as "
  + " Unit_Type_Code,d.Role_Code, d.Role_Name, d.Role_Type, h.Type_Code  as Role_Type_Code, i.Type_Code as "
 + " Acct_Status_Code,a.accounttype from AUTHENTICATION a, ORGANIZATION b, ORG_UNIT c, USER_ROLE d, "
 +" ORG_TYPE f, UNIT_TYPE g, ROLE_TYPE h, ACCOUNT_TYPE i, USER_PROFILE u Where a.Login_Name=? AND a.Password=? "
 +" AND b.Org_iD=a.Org_ID AND f.Type_Id=b.Org_Type And c.Unit_iD=a.Unit_ID "
 +" AND g.Type_Id=c.Unit_Type And d.Role_iD=a.Role_ID AND h.Type_id=d.Role_Type "
 +" AND i.Type_id=a.Acct_Status"
  +" AND u.user_id=a.user_id";

  final String AUTHENTICATION_BY_USERID_QUERY = " select distinct a.Auth_ID, a.Org_ID, a.Unit_Id, "
         + " a.Role_ID,a.User_ID, a.Login_Name, a.password,a.Acct_Status  as Acct_Status_id,"
         + " u.first_name,u.last_name, u.email, u.phone,"
  + " b.orgpkg_type,c.unitpkg_type,b.acct_status as org_acct_status ,c.acct_status as unit_acct_status,"

  +"b.org_sts_desc as org_sts_description,c.unit_sts_desc as unit_sts_description,a.description as account_description,"
        + " b.Org_Name, f.Type_Code  as Org_Type_Code,c.Unit_Name, c.Unit_Code, g.Type_Code as "
    + " Unit_Type_Code,d.Role_Code, d.Role_Name, d.Role_Type, h.Type_Code  as Role_Type_Code, i.Type_Code as "
   + " Acct_Status_Code,a.accounttype from AUTHENTICATION a, ORGANIZATION b, ORG_UNIT c, USER_ROLE d, "
   +" ORG_TYPE f, UNIT_TYPE g, ROLE_TYPE h, ACCOUNT_TYPE i, USER_PROFILE u Where a.user_id=? "
   +" AND b.Org_iD=a.Org_ID AND f.Type_Id=b.Org_Type And c.Unit_iD=a.Unit_ID "
   +" AND g.Type_Id=c.Unit_Type And d.Role_iD=a.Role_ID AND h.Type_id=d.Role_Type "
   +" AND i.Type_id=a.Acct_Status"
  +" AND u.user_id=a.user_id";

  final String PORTALMEM_AUTHENTICATION_QUERY = " select distinct a.Auth_ID, a.Org_ID, a.Unit_Id, "
       + " a.Role_ID,a.User_ID, a.Login_Name, a.password,a.Acct_Status  as Acct_Status_id,"
       + " u.first_name,u.last_name, u.email, u.phone,"
+ " b.orgpkg_type,c.unitpkg_type,b.acct_status as org_acct_status ,c.acct_status as unit_acct_status,"

+"b.org_sts_desc as org_sts_description,c.unit_sts_desc as unit_sts_description,a.description as account_description,"
      + " b.Org_Name, f.Type_Code  as Org_Type_Code,c.Unit_Name, c.Unit_Code, g.Type_Code as "
  + " Unit_Type_Code,d.Role_Code, d.Role_Name, d.Role_Type, h.Type_Code  as Role_Type_Code, i.Type_Code as "
 + " Acct_Status_Code ,a.accounttype from AUTHENTICATION a, ORGANIZATION b, ORG_UNIT c, USER_ROLE d, "
 +" ORG_TYPE f, UNIT_TYPE g, ROLE_TYPE h, ACCOUNT_TYPE i, USER_PROFILE u Where a.Login_Name=? AND a.Password=? "
 +" AND b.Org_iD=a.Org_ID AND f.Type_Id=b.Org_Type And c.Unit_iD=a.Unit_ID "
 +" AND g.Type_Id=c.Unit_Type And d.Role_iD=a.Role_ID AND h.Type_id=d.Role_Type "
 +" AND i.Type_id=a.Acct_Status  and a.unit_id=CAST(? AS INTEGER)"
  +" AND u.user_id=a.user_id and d.Role_Code='MEM' ";



  final String MEMBER_AUTHENTICATION_QUERY = " select distinct a.Auth_ID, a.Org_ID, a.Unit_Id, "
       + " a.Role_ID,a.User_ID, a.Login_Name, a.password,a.Acct_Status  as Acct_Status_id,"
       + " u.first_name,u.last_name, u.email, u.phone,"
+ " b.orgpkg_type,c.unitpkg_type,b.acct_status as org_acct_status ,c.acct_status as unit_acct_status,"

+"b.org_sts_desc as org_sts_description,c.unit_sts_desc as unit_sts_description,a.description as account_description,"
      + " b.Org_Name, f.Type_Code  as Org_Type_Code,c.Unit_Name, c.Unit_Code, g.Type_Code as "
  + " Unit_Type_Code,d.Role_Code, d.Role_Name, d.Role_Type, h.Type_Code  as Role_Type_Code, i.Type_Code as "
 + " Acct_Status_Code,a.accounttype from AUTHENTICATION a, ORGANIZATION b, ORG_UNIT c, USER_ROLE d, "
 +" ORG_TYPE f, UNIT_TYPE g, ROLE_TYPE h, ACCOUNT_TYPE i, USER_PROFILE u Where a.Login_Name=? AND a.Password=? "
 +" AND b.Org_iD=a.Org_ID AND f.Type_Id=b.Org_Type And c.Unit_iD=a.Unit_ID "
 +" AND g.Type_Id=c.Unit_Type And d.Role_iD=a.Role_ID AND h.Type_id=d.Role_Type "
 +" AND i.Type_id=a.Acct_Status"
  +" AND u.user_id=a.user_id AND a.Acct_Status='1' and a.unit_id=? and d.Role_Code='MEM'";


public boolean isLoginNameAlreadyExists(String loginname){
	return isLoginNameAlreadyExists(loginname,"");
}
   public boolean isLoginNameAlreadyExists(String loginname,String UNITID){
	Connection con=null;
	boolean exists=false;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		if(UNITID==null || "".equals(UNITID.trim())){
			pstmt=con.prepareStatement(NAME_EXISTS_QUERY);
			pstmt.setString(1,loginname);
		}else{
			pstmt=con.prepareStatement(NAME_EXISTS_QUERY_BY_UNITID);
			pstmt.setString(1,loginname);
			pstmt.setString(2,UNITID);
		}

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
		System.out.println("Error in isLoginNameAlreadyExists()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return exists;
   }

   //    ****  Uday Created this function on 17/02/2004.

	public Vector isValidMember(String byNamePwd,String email,String unit_id,String forgottype){
	Connection con=null;
	HashMap hm=null;
	Vector v=new Vector();
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		//if("password".equals(forgottype))
		//	pstmt=con.prepareStatement(IsvalidMemberPassword);
		//else
			pstmt=con.prepareStatement(IsvalidMemberid);

		pstmt.setString(1,email);
		pstmt.setString(2,unit_id);
		ResultSet rs=pstmt.executeQuery();
		while(rs.next()){
			hm=new HashMap();
			hm.put("login_name",rs.getString("login_name"));
			//hm.put("password",rs.getString("password"));

			hm.put("password",

			(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(rs.getString("password") )

			);

			hm.put("email",rs.getString("email"));
			v.add(hm);
			hm=null;
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in isValidMember()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
   }

   //    ****  Uday Created this function on 17/02/2004.

	public Vector isValidManager(String byNamePwd,String email,String forgottype){
	Connection con=null;
	HashMap hm=null;
	Vector v=new Vector();
	String Query=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		//if("password".equals(forgottype))
			//Query=IsvalidMgrPassword;
		//else
			Query=IsvalidMgrid;

			pstmt=con.prepareStatement(Query);

		//pstmt.setString(1,byNamePwd);
		pstmt.setString(1,email);
		ResultSet rs=pstmt.executeQuery();
		while(rs.next()){
			hm=new HashMap();
			hm.put("login_name",rs.getString("login_name"));
			//hm.put("password",rs.getString("password"));
			hm.put("password",
			(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(rs.getString("password") )
			);


			hm.put("email",rs.getString("email"));
			v.add(hm);

			hm=null;

		}

		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in isValidManager()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
   }

   //    ****   Uday created this function on 02/02/2004.
    public HashMap getUserPreferenceInfo(String pref_value){
	Connection con=null;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(USER_PREF_INFO);
		pstmt.setString(1,pref_value);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			hm=new HashMap();
			hm.put("user_id",rs.getString("user_id"));
			hm.put("pref_name",rs.getString("pref_name"));
			hm.put("pref_value",rs.getString("pref_value"));
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in getUserPreferenceInfo()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return hm;
   }
   public HashMap getUserPreferenceInfo(String userid,String pref_value){
	Connection con=null;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(USER_PREF_INFO1);
		pstmt.setString(1,userid);
		pstmt.setString(2,pref_value);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			hm=new HashMap();
			hm.put("user_id",rs.getString("user_id"));
			hm.put("pref_name",rs.getString("pref_name"));
			hm.put("pref_value",rs.getString("pref_value"));
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in getUserPreferenceInfo()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return hm;
   }
   public HashMap getUserInfoByUserID(String userid){
	Connection con=null;
	HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(USER_INFO);
		pstmt.setString(1,userid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			hm=new HashMap();
			hm.put("auth_id",rs.getString("auth_id"));
			hm.put("org_id",rs.getString("org_id"));
			hm.put("unit_id",rs.getString("unit_id"));
			hm.put("role_id",rs.getString("role_id"));
			hm.put("login_name",rs.getString("login_name"));
			hm.put("acct_status",rs.getString("acct_status"));
			hm.put("mgrcomments",rs.getString("mgrcomments"));
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in getUserInfoByUserID()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return hm;
   }


   public int getLoginNameCount(String loginname){
	Connection con=null;
	int count=0;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(NAME_EXISTS_QUERY1);
		pstmt.setString(1,loginname+"%");
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			count=rs.getInt(1);
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in getLoginNameCount()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return count;
   }

//    method to get the profile for manager depending upon the unit_id
public Authenticate fillUnitInfo(Authenticate au)
{
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	String unitid=au.getUnitID();
	try
	{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(UNITINFO_MGR_QUERY);
		pstmt.setString(1,unitid);
		pstmt.setString(2,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next())
		{
			au.UnitInfo.put("mgrFName",rs.getString("first_name"));
			au.UnitInfo.put("mgrLName",rs.getString("last_name"));
			au.UnitInfo.put("mgrUserId",rs.getString("user_id"));
			au.UnitInfo.put("mgrUnitCode",rs.getString("unit_code"));
			au.UnitInfo.put("mgrClubName",rs.getString("clubname"));
			au.UnitInfo.put("mgrClubId",rs.getString("clubid"));
			au.UnitInfo.put("mgrUnitName",rs.getString("unit_name"));
			au.UnitInfo.put("mgrEmail",rs.getString("email"));

		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in fillUnitInfo()"+e.getMessage());

	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return au;
}

public Authenticate authenicateUserByID(String userid){
	return authenticateUser("","","",userid);
}


public Authenticate authenticateUser(String loginname, String password, String unitid, String userid){
	Connection con=null;
		Authenticate au=null;
	        java.sql.PreparedStatement pstmt=null;
		try{
			con=EventbeeConnection.getReadConnection("authenticate");
			if(userid.length()>0){
				pstmt=con.prepareStatement(AUTHENTICATION_BY_USERID_QUERY);
				pstmt.setString(1,userid);
			}
			else{
				pstmt=con.prepareStatement(AUTHENTICATION_QUERY);
				pstmt.setString(1,loginname);
			//pstmt.setString(2,password);

				pstmt.setString(2,
				(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).encrypt(password)

				);
			}

			ResultSet rs=pstmt.executeQuery();
			if(rs.next()){
				au=new Authenticate();
	                	UserAccount Uacc=new UserAccount();
	                	Organization Org=new Organization();
	                	OrgUnit orgUnit=new OrgUnit();
	                	UserRole Urole=new UserRole();
	                	au.islogged=true;

						AccessStore accstore=new AccessStore();
						accstore.setAccessStore(rs.getString("Role_ID"));
						au.setRolePermission(accstore);

	                	Uacc.setAuthID(rs.getString("Auth_ID"));
	                	Uacc.setUserID(rs.getString("User_ID"));
	                	Uacc.setLoginName(rs.getString("Login_Name"));
	                	Uacc.setAcctStatusID(rs.getString("Acct_Status_id"));
	                	Uacc.setAcctStatusCode(rs.getString("Acct_Status_Code"));
	                	Uacc.setAcctDescription(rs.getString("account_description"));
				Uacc.setAccountType(rs.getString("accounttype"));
				System.out.println("account typefdfdd: "+rs.getString("accounttype"));
	                	au.setUserAccount(Uacc);

	                	Org.setOrgID(rs.getString("Org_ID"));
	                	Org.setOrgName(rs.getString("Org_Name"));
	                	Org.setOrgTypeCode(rs.getString("Org_Type_Code"));
						Org.setOrgPkgType(rs.getString("orgpkg_type"));
						Org.setOrgAcctStatus(rs.getString("org_acct_status"));
						Org.setOrgAcctDescription(rs.getString("org_sts_description"));
						au.setOrganization(Org);

	                	orgUnit.setUnitID(rs.getString("Unit_ID"));
	                	orgUnit.setUnitName(rs.getString("Unit_Name"));
	                	orgUnit.setUnitCode(rs.getString("Unit_Code"));
	                	orgUnit.setUnitTypeCode(rs.getString("Unit_Type_Code"));
						orgUnit.setUnitPkgType(rs.getString("unitpkg_type"));
						orgUnit.setUnitAcctStatus(rs.getString("unit_acct_status"));
						orgUnit.setUnitAcctDescription(rs.getString("unit_sts_description"));
	                	au.setOrgUnit(orgUnit);

	                	Urole.setRoleID(rs.getString("Role_ID"));
	                	Urole.setRoleCode(rs.getString("Role_Code"));
	                	Urole.setRoleName(rs.getString("Role_Name"));
	                	Urole.setRoleTypeCode(rs.getString("Role_Type_Code"));
	                	au.setUserRole(Urole);
				Uacc.setFirstName(rs.getString("first_name"));
				Uacc.setLastName(rs.getString("last_name"));
				au.UserInfo.put("FirstName", rs.getString("first_name"));
				au.UserInfo.put("LastName", rs.getString("last_name"));
				au.UserInfo.put("Email", rs.getString("email"));
				au.UserInfo.put("Phone", rs.getString("phone"));
				au.UserInfo.put("LoginName", rs.getString("Login_Name"));

				//au.UserInfo.put("Password", rs.getString("password"));

				au.UserInfo.put("Password",
					(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(rs.getString("password") )

				);


			}
			rs.close();
			pstmt.close();
			pstmt=null;
			con.close();
			con=null;
		}catch(Exception e){
			System.out.println("Error in authenticateUser()"+e.getMessage());
			au=null;
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}

		if(au!=null)
			au=fillUnitInfo(au);

	return au;
}
  	public Authenticate authenticateUser(String loginname, String password){
		return authenticateUser(loginname,password,"","");

    }



    public Authenticate authenticatePortalUser(String loginname, String password,String unitid){
	Connection con=null;
	Authenticate au=null;
        java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(PORTALMEM_AUTHENTICATION_QUERY);
		pstmt.setString(1,loginname);
		//pstmt.setString(2,password);
		pstmt.setString(2,
		(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).encrypt(password)
		);


		pstmt.setString(3,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			au=new Authenticate();
                	UserAccount Uacc=new UserAccount();
                	Organization Org=new Organization();
                	OrgUnit orgUnit=new OrgUnit();
                	UserRole Urole=new UserRole();
                	au.islogged=true;

					AccessStore accstore=new AccessStore();
					accstore.setAccessStore(rs.getString("Role_ID"));
					au.setRolePermission(accstore);

                	Uacc.setAuthID(rs.getString("Auth_ID"));
                	Uacc.setUserID(rs.getString("User_ID"));
                	Uacc.setLoginName(rs.getString("Login_Name"));
                	Uacc.setAcctStatusID(rs.getString("Acct_Status_id"));
                	Uacc.setAcctStatusCode(rs.getString("Acct_Status_Code"));
                	Uacc.setAcctDescription(rs.getString("account_description"));
                	Uacc.setAccountType(rs.getString("accounttype"));
                	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"AuthDB.java","in authenticatePortalUser()","accounttype is :"+rs.getString("accounttype"),null);
                	au.setUserAccount(Uacc);

                	Org.setOrgID(rs.getString("Org_ID"));
                	Org.setOrgName(rs.getString("Org_Name"));
                	Org.setOrgTypeCode(rs.getString("Org_Type_Code"));
					Org.setOrgPkgType(rs.getString("orgpkg_type"));
					Org.setOrgAcctStatus(rs.getString("org_acct_status"));
					Org.setOrgAcctDescription(rs.getString("org_sts_description"));
					au.setOrganization(Org);

                	orgUnit.setUnitID(rs.getString("Unit_ID"));
                	orgUnit.setUnitName(rs.getString("Unit_Name"));
                	orgUnit.setUnitCode(rs.getString("Unit_Code"));
                	orgUnit.setUnitTypeCode(rs.getString("Unit_Type_Code"));
					orgUnit.setUnitPkgType(rs.getString("unitpkg_type"));
					orgUnit.setUnitAcctStatus(rs.getString("unit_acct_status"));
					orgUnit.setUnitAcctDescription(rs.getString("unit_sts_description"));
                	au.setOrgUnit(orgUnit);

                	Urole.setRoleID(rs.getString("Role_ID"));
                	Urole.setRoleCode(rs.getString("Role_Code"));
                	Urole.setRoleName(rs.getString("Role_Name"));
                	Urole.setRoleTypeCode(rs.getString("Role_Type_Code"));
                	au.setUserRole(Urole);
			Uacc.setFirstName(rs.getString("first_name"));
			Uacc.setLastName(rs.getString("last_name"));
			Uacc.setEmail(rs.getString("email"));
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"AuthDB.java","in authenticatePortalUser()","email is :"+rs.getString("email"),null);
			au.UserInfo.put("FirstName", rs.getString("first_name"));
			au.UserInfo.put("LastName", rs.getString("last_name"));
			au.UserInfo.put("Email", rs.getString("email"));
			au.UserInfo.put("Phone", rs.getString("phone"));
			au.UserInfo.put("LoginName", rs.getString("Login_Name"));
			//au.UserInfo.put("Password", rs.getString("password"));
			au.UserInfo.put("Password",
			(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(rs.getString("password") )
			);

		au.UserInfo.put("MyAccount" ,com.eventbee.myaccount.AccountFactory.getUserAccount(au ) );
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in authenticateUser()"+e.getMessage());
		au=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}

	if(au!=null)
		au=fillUnitInfo(au);

	return au;
    }



   	public Authenticate authenticateMember(String loginname, String password,String unitid){
	Connection con=null;
	Authenticate au=null;
        java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("authenticate");
		pstmt=con.prepareStatement(MEMBER_AUTHENTICATION_QUERY);
		pstmt.setString(1,loginname);
		//pstmt.setString(2,password);
		pstmt.setString(2,
		(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).encrypt(password)
		);

		pstmt.setString(3,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			au=new Authenticate();
                	UserAccount Uacc=new UserAccount();
                	Organization Org=new Organization();
                	OrgUnit orgUnit=new OrgUnit();
                	UserRole Urole=new UserRole();

					AccessStore accstore=new AccessStore();
					accstore.setAccessStore(rs.getString("Role_ID"));
					au.setRolePermission(accstore);
					au.islogged=false;

                	Uacc.setAuthID(rs.getString("Auth_ID"));
                	Uacc.setUserID(rs.getString("User_ID"));
                	Uacc.setLoginName(rs.getString("Login_Name"));
                	Uacc.setAcctStatusID(rs.getString("Acct_Status_id"));
                	Uacc.setAcctStatusCode(rs.getString("Acct_Status_Code"));
                	Uacc.setAcctDescription(rs.getString("account_description"));
			Uacc.setAccountType(rs.getString("accounttype"));
                	au.setUserAccount(Uacc);

                	Org.setOrgID(rs.getString("Org_ID"));
                	Org.setOrgName(rs.getString("Org_Name"));
                	Org.setOrgTypeCode(rs.getString("Org_Type_Code"));
					Org.setOrgPkgType(rs.getString("orgpkg_type"));
					Org.setOrgAcctStatus(rs.getString("org_acct_status"));
					Org.setOrgAcctDescription(rs.getString("org_sts_description"));
					au.setOrganization(Org);

                	orgUnit.setUnitID(rs.getString("Unit_ID"));
                	orgUnit.setUnitName(rs.getString("Unit_Name"));
                	orgUnit.setUnitCode(rs.getString("Unit_Code"));
                	orgUnit.setUnitTypeCode(rs.getString("Unit_Type_Code"));
					orgUnit.setUnitPkgType(rs.getString("unitpkg_type"));
					orgUnit.setUnitAcctStatus(rs.getString("unit_acct_status"));
					orgUnit.setUnitAcctDescription(rs.getString("unit_sts_description"));
                	au.setOrgUnit(orgUnit);

                	Urole.setRoleID(rs.getString("Role_ID"));
                	Urole.setRoleCode(rs.getString("Role_Code"));
                	Urole.setRoleName(rs.getString("Role_Name"));
                	Urole.setRoleTypeCode(rs.getString("Role_Type_Code"));
                	au.setUserRole(Urole);
			Uacc.setFirstName(rs.getString("first_name"));
			Uacc.setLastName(rs.getString("last_name"));
			Uacc.setEmail(rs.getString("email"));
			au.UserInfo.put("FirstName", rs.getString("first_name"));
			au.UserInfo.put("LastName", rs.getString("last_name"));
			au.UserInfo.put("Email", rs.getString("email"));
			au.UserInfo.put("Phone", rs.getString("phone"));
			au.UserInfo.put("LoginName", rs.getString("Login_Name"));
			//au.UserInfo.put("Password", rs.getString("password"));
			au.UserInfo.put("Password",
			(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(rs.getString("password") )
			);


			au.UserInfo.put("MyAccount" ,com.eventbee.myaccount.AccountFactory.getUserAccount(au ) );

		}
		rs.close();






		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in authenticateMember(username,password,unitid)"+e.getMessage());
		au=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return au;
    }




  }
