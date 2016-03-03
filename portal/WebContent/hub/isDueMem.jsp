<%!


public static String DUE_HUBMEMBER="select membership_name,c.membership_id,to_char(pay_next_due_date,'mm/dd/yyyy') "
+" as duedate,to_date(to_char(pay_next_due_date,'yyyy/mm/dd'),'yyyy/mm/dd')-"
+"to_date(to_char(now(),'yyyy/mm/dd'),'yyyy/mm/dd')  as diff, "
+" pay_next_due_date,term_fee,mship_term from club_membership_master c,club_member c1 "
+" where c.membership_id=c1.membership_id and c.clubid=c1.clubid and c1.clubid=? and userid=?";





public static HashMap isDueHubMember(String userid,String clubid){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"HubMaster.java","in isDueHubMember()","userid is :"+userid,null);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"HubMaster.java","in isDueHubMember()","clubid is :"+clubid,null);
		boolean showlink=false;
		HashMap hm=new HashMap();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(DUE_HUBMEMBER,new String []{clubid,userid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"HubMaster.java","in isDueHubMember()","Status is :"+statobj.getStatus(),null);

		if(statobj.getStatus()){
			int duedays =Integer.parseInt(dbmanager.getValue(0,"diff","0"));
			String tremfee=dbmanager.getValue(0,"term_fee","0");
			String m_term=dbmanager.getValue(0,"mship_term","");
			String ddate=dbmanager.getValue(0,"duedate","");

			int t=1;
			int showdays=Integer.parseInt(EbeeConstantsF.get("hubmember.renew.period","3"));
			if(ddate==null||"".equals(ddate.trim())){
				showlink=false;
			}else{
				if(Double.parseDouble(tremfee)>0)
				{
					if(duedays>0){
						if("Monthly".equalsIgnoreCase(m_term))
							t=1;
						else if("Annual".equalsIgnoreCase(m_term))
							t=12;
						else if("Quarterly".equalsIgnoreCase(m_term))
							t=3;
						else if("half yearly".equalsIgnoreCase(m_term))
							t=6;
						if(duedays/t<showdays)
						showlink=true;

					}else{
					showlink=true;
					}
				}
			}

			hm.put("membership_name",dbmanager.getValue(0,"membership_name",""));
			hm.put("duedate",ddate);
			hm.put("tremfee",tremfee);
			hm.put("membershipid",dbmanager.getValue(0,"membership_id",""));
			
			hm.put("mship_term",m_term);
			hm.put("duedays",dbmanager.getValue(0,"diff","0"));
			if(showlink)
				hm.put("duemember","yes");
			else
				hm.put("duemember","no");
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"HubMaster.java","in isDueHubMember()","showlink is :"+showlink,null);
		return hm;
	}



%>