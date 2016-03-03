<%@ page import="java.io.*,com.eventbee.clubs.*,com.eventbee.clubmember.*, java.util.*,com.eventbee.general.*,com.eventbee.authentication.*" %>



<%!




 String MEM_PREFERENCE_INSERT =" insert into member_preference(user_id, pref_name, pref_value) values (?,?,?) ";


	  String encodePassword(String password, String algorithm){
		byte[] unencodedPassword = password.getBytes();
		java.security.MessageDigest md = null;
		try{
			// first create an instance, given the provider
			md = java.security.MessageDigest.getInstance(algorithm);
		}catch (Exception e){
			return password;
		}
		md.reset();
		// call the update method one or more times
		// (useful when you don't know the size of your data, eg. stream)
		md.update(unencodedPassword);

		// now calculate the hash
		byte[] encodedPassword = md.digest();
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < encodedPassword.length; i++){
			if ((encodedPassword[i] & 0xff) < 0x10){
				buf.append("0");
			}
			buf.append(Long.toString(encodedPassword[i] & 0xff, 16));
		}
		return buf.toString();
	}










%>








<%


			String manid=null;
			String unitid=null;
			manid=request.getParameter("userid");
			AuthDB adb=new AuthDB();
			Authenticate authData=adb.authenicateUserByID(manid);
			unitid="13579";
			String modclubid=request.getParameter("clubid");
			String membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {modclubid});

			ClubInfo cinfo= ClubDB.getClubInformation("13579",modclubid);
			String clubname="";
			clubname=cinfo.getClubName();
			String cluburl="";
			String servername=EbeeConstantsF.get("serveraddress","http://www.desihub.com");
			if(!servername.startsWith("http://")) servername="http://"+servername;
			cluburl=servername+"/"+cinfo.getClubLogo()+"/login";
			Config conf=com.eventbee.general.ConfigLoader.getConfig("13579", ConfigLoader.UNITBASE);
			String accountstatusval="1";
			String queryforuserpass="";
			if( ("yes". equalsIgnoreCase(conf.getKeyValue("unit.memberadd.needresetusername","yes")) )  ){
				queryforuserpass+="U";
				accountstatusval="6";
			}
			if( ("yes". equalsIgnoreCase(conf.getKeyValue("unit.memberadd.needresetpassword","yes")) ) ){
				queryforuserpass+="P";
				accountstatusval="6";
			}
			List members=new ArrayList();
			String message=null;
			try{
				
				ClubMemberProfile cmp= new ClubMemberProfile();
					String  loginid=  request.getParameter("loginid").trim();
					String  password=request.getParameter("password").trim();
					String  firstname=request.getParameter("firstname").trim();
					String lastname=request.getParameter("lastname").trim();
					String email=request.getParameter("email").trim();
					String street=request.getParameter("street");
					String city=request.getParameter("city");
					String state=request.getParameter("state");
					String zip=request.getParameter("zip");
					String phone=request.getParameter("phone");
					String internalid=request.getParameter("internalid");
					String gender=request.getParameter("gender");
					String mobile=request.getParameter("mobile");
					String startdate=request.getParameter("startdate");
					String duedate=request.getParameter("duedate");
					cmp.setStatus(accountstatusval);
					String clubid=request.getParameter("clubid");
					String mid=request.getParameter("mid");
					cmp.setClubId(clubid);
					cmp.setManagerId(manid);
					cmp.setMemberShipId(mid);
					cmp.setFirstName(firstname);
					cmp.setLastName(lastname);
					cmp.setEmail(email);
					cmp.setStreet(street);
					cmp.setCity(city);
					cmp.setState(state);
					cmp.setZip(zip);
					cmp.setPhoneNo(phone);
					cmp.setInternalId(internalid);
					cmp.setMobile(mobile);
					cmp.setGender(gender);
					cmp.setRefSource("Manual,manager id="+manid);
					cmp.setStartDate(startdate);
					cmp.setDueDate(duedate);
					cmp.setLoginName(loginid);
					cmp.setPassword(password);
					cmp.requserpassstr=queryforuserpass;
					members.add(cmp);
					ClubMemberProfile test=null;
					int rowsadded=0;
					EmailObj emailobj=null;
					if(!members.isEmpty()){
						ClubDB clubdb=new ClubDB();
						Vector memshipvec=clubdb.getClubMemShipInfo(modclubid,unitid);
						Iterator iter=members.iterator();
						while(iter.hasNext()){
							test= ( ClubMemberProfile)iter.next();
							try{
							StatusObj stobj=clubdb.createMember( test, authData,memshipvec);
							if(stobj.getStatus()){
								rowsadded=rowsadded+1;
								String themecode=EbeeConstantsF.get("accounts.basic.deftheme","movablemanila");
								StatusObj statobjn= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{test.getUserId(),"Snapshot",themecode    } );
								statobjn= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{test.getUserId(),"Photos",themecode    } );
								statobjn= DbUtil.executeUpdateQuery(MEM_PREFERENCE_INSERT, new String[]{test.getUserId(),"pref:myurl",test.getLoginName()} );
							
							if("EXCLUSIVE".equals(membertype)){

								StatusObj sobj1=DbUtil.executeUpdateQuery("update authentication set acct_status='3',updated_by='CLUB_UNITMEMBER' where user_id=?", new String []{test.getUserId()});

						  }
				
							}else{
								throw new Exception(stobj.getErrorMsg());
							}
							}catch(Exception exp){
								System.out.println(" Exception ===11111111="+exp.getMessage());
							}
						}//end of while
					}//end of if
					System.out.println("successfully added");
				
			}catch(Exception e){
				System.out.println(" Exception =22222==="+e.getMessage());
			}
		



%>