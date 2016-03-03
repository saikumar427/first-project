<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<%
//"My Photos"

String club_title=EbeeConstantsF.get("club.label","Bee Hive");
	String code=("Communities".equalsIgnoreCase(club_title))?"My Communities":"My Hubs";
	//if("My Hubs".equals(code) ){
	
		String subtabtype=(String)request.getAttribute("subtabtype");
					
		System.out.println("From DesiTabSetter:"+subtabtype );
		if(subtabtype !=null){
			boolean displaysubmenub=false;
			
			
			
			if("My Photos".equals(subtabtype) )
			{
			displaysubmenub=true;
			request.setAttribute("subtabtype","mylifestyle");

			request.setAttribute("linktohighlight","myphoto");

			}

			
			/*if("My Page".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","mylifestyle");
				request.setAttribute("linktohighlight","mypage");
				
			}
			*/
			
			if("settings".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","mylifestyle");
				request.setAttribute("linktohighlight","settings");
				
			}
			
			
                     

			displaysubmenub=false;
	
			
			
			
			
			
			
			if("My Social Network".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","mylifestyle");
				request.setAttribute("linktohighlight","myguestbook");
				request.setAttribute("type","Guestbook");
				request.setAttribute("dispalysubmenu","Snapshot");
			}
			displaysubmenub=false;
			
			
			
			
			if("My Profile".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Settings");
				request.setAttribute("linktohighlight","My Settings");
				request.setAttribute("dispalysubmenu","My Settings");
				
			}
			displaysubmenub=false;
			
			
			if("MyThemes".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Themes");
				request.setAttribute("linktohighlight","My Themes");
				//request.setAttribute("dispalysubmenu","My Settings");
				
			}
			
			displaysubmenub=false;
			
			/*if("F2FPages".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Events");
				request.setAttribute("linktohighlight","F2FPages");
				request.setAttribute("truesubtabtype","F2F Pages");
				request.setAttribute("dispalysubmenu","Events");
				
			}
			*/
			
			if("My EmailCampaigns".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Campaigns");
				//request.setAttribute("linktohighlight","List Info");
				request.setAttribute("dispalysubmenu","My EmailCampaigns");
				request.setAttribute("truesubtabtype","List Info");
			}
			
			displaysubmenub=false;
			
			
			
			if("My Campaign".equals(subtabtype) ){
			
				
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Campaigns");
				//request.setAttribute("linktohighlight","Members");
				request.setAttribute("submenu","members");
				request.setAttribute("dispalysubmenu","My EmailCampaigns");
				request.setAttribute("truesubtabtype","Members");
				request.setAttribute("type","Members");
			}
			
			displaysubmenub=false;
			
			
			if("Members".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Campaigns");
				//request.setAttribute("linktohighlight","All");
				request.setAttribute("submenu","addmembers");	
				request.setAttribute("dispalysubmenu","My EmailCampaigns");
				request.setAttribute("truesubtabtype","Add Members");
				request.setAttribute("type","Add Members");
			}
			
			displaysubmenub=false;
			
			if("My Settings".equals(subtabtype) ){
			
			
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Settings");
				request.setAttribute("linktohighlight","My Settings");
				request.setAttribute("dispalysubmenu","My Settings");
				//request.setAttribute("type","Alerts");
				
				
			}
			displaysubmenub=false;
			
			
			
			
			if("My Alerts".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Settings");
				request.setAttribute("type","Alerts");
				request.setAttribute("linktohighlight","Alerts");
				request.setAttribute("dispalysubmenu","My Settings");
			}
			displaysubmenub=false;
			
			if("My Preferences".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","mylifestyle");
				//request.setAttribute("type","Alerts");
				request.setAttribute("type","Profile");
				request.setAttribute("linktohighlight","myprefs");
				
			}
			
			displaysubmenub=false;
			
			
			if("My Guestbook".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("truesubtabtype","Network");
				request.setAttribute("type","Guestbook");
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","mylifestyle");
			}
			displaysubmenub=false;
			
			
		
			
			if("F2FPages".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Events");
				request.setAttribute("linktohighlight","F2FPages");
				request.setAttribute("truesubtabtype","F2F Pages");
				request.setAttribute("dispalysubmenu","Events");
				
			}
			
			
			
			displaysubmenub=false;
			
			if("LFPhotos".equals(subtabtype) )
			{
				displaysubmenub=true;
			        request.setAttribute("subtabtype","My Pages");
				request.setAttribute("truesubtabtype","Photos");
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","photos");	
			}displaysubmenub=false;
			
			if(displaysubmenub)request.setAttribute("dispalysubmenu","Snapshot");
			
			
			if("mylifestyle".equals(subtabtype) ){
				displaysubmenub=true;
				
				String linktohighloght=request.getParameter("stype");
				
				//if(linktohighloght !=null)
				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("linktohighlight",linktohighloght);
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","mylifestyle");
				
			}
			displaysubmenub=false;
			
			
			
			if("mynetwork".equals(subtabtype) ){

				displaysubmenub=true;
				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("submenu","mynetwork");
				request.setAttribute("truesubtabtype","Network");
				request.setAttribute("dispalysubmenu","Events");
				
			}
			displaysubmenub=false;
			
			
			
		if("mymessages".equals(subtabtype) ){
				displaysubmenub=true;
				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("type","Messages");
				request.setAttribute("truesubtabtype","Network");
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","mylifestyle");
		}
		displaysubmenub=false;
			
			//start of event related tabs

			if("My Page".equals(subtabtype) ){
			displaysubmenub=true;

				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("truesubtabtype","Events");
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","My Events");
				//request.setAttribute("submenu","manageevents");
		}
			displaysubmenub=false;
			
			if("My Pages".equals(subtabtype) ){
			displaysubmenub=true;

				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("truesubtabtype","Events");
				request.setAttribute("dispalysubmenu","Events");
				//request.setAttribute("submenu","manageevents");
		}
			displaysubmenub=false;
			
			if("Communities".equals(subtabtype) ){
			displaysubmenub=true;

				request.setAttribute("subtabtype","My Pages");
				request.setAttribute("truesubtabtype","Community");
				request.setAttribute("dispalysubmenu","Events");
				//request.setAttribute("submenu","manageevents");
		}
			displaysubmenub=false;
			
			
			
			if("Manage Events".equals(subtabtype) ){
			displaysubmenub=true;

				request.setAttribute("subtabtype","My Events");
				request.setAttribute("truesubtabtype","Manage Events");
				request.setAttribute("dispalysubmenu","Events");
				request.setAttribute("submenu","manageevents");
		}
			displaysubmenub=false;
			
			
			
			
		if("My Invitations".equals(subtabtype)){
			displaysubmenub=true;

				request.setAttribute("subtabtype","My Events");
				request.setAttribute("truesubtabtype","My Invitations");

				request.setAttribute("dispalysubmenu","Events");
		}
		displaysubmenub=false;
		

			
			
			
			if(displaysubmenub)request.setAttribute("dispalysubmenu","Events");
		if("My Surveys".equals(subtabtype) ){
		displaysubmenub=true;
				//request.setAttribute("subtabtype","My Surveys");
				request.setAttribute("truesubtabtype","My Surveys");
				//request.setAttribute("dispalysubmenu","Events");
		}
			
		}//subtype !=null



	//}// end if for hubs ie desihub
%>
<%--
if("event".equals(subtabtype)){
				displaysubmenub=true;
				request.setAttribute("subtabtype","home");
				request.setAttribute("dispalysubmenu","event");
				request.setAttribute("truesubtabtype","Events");
			}
			displaysubmenub=false;
			
			
			if("class".equals(subtabtype)){
				displaysubmenub=true;
				request.setAttribute("subtabtype","home");
				request.setAttribute("dispalysubmenu","class");
				request.setAttribute("truesubtabtype","Classes");
			}
			displaysubmenub=false;
			--%>
