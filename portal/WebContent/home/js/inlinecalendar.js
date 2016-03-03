<!--
ReturnFunc = '';
function Calendar(iYear, iMonth, iDay, ContainerId, ClassName)
{
	todayDate = new Date();
	tDay=todayDate.getDate();
	tMonth=todayDate.getMonth();
	tYear=todayDate.getYear();
	if(tYear<1000){
	tYear+=1900;
	}

    MonthNames = new Array('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    //If no parameter is passed use the current date.
    oDate = new Date();
    Year = (iYear == null) ? oDate.getFullYear() : iYear;
    Month = (iMonth == null) ? oDate.getMonth() : iMonth - 1;
    while(Month < 0){Month += 12;Year--}
    while(Month >= 12){Month -= 12;Year++}
    Day = (iDay == null) ? 0 : iDay;
    oDate = new Date(Year, Month, 1);
    NextMonth = new Date(Year, Month + 1, 1);
    LastMonth = new Date(Year, Month - 1, 1);
    WeekStart = oDate.getDay();
    // Get the number of months in current month
    MonthDays = Math.round((NextMonth.getTime() - oDate.getTime()) / 86400000) + 1;
    // Check whether the Container Id is null
    if(ContainerId != null)
    {
        ContainerId = ContainerId;
        Container = document.getElementById(ContainerId);
        // If an element doesnot exists with the given ContainerId then create it
        if(!Container)
            document.write('<div id="' + ContainerId + '"> </div>');
    }
    else
    {
        // Loop until a unique id is obtained for the container
        do
        {
            ContainerId = 'tblCalendar' + Math.round(Math.random() * 1000);
        }
        while(document.getElementById(ContainerId));
        // create an element with the new id
        document.write('<div id="' + ContainerId + '"> </div>');
    }
      
  
    Container = document.getElementById(ContainerId);
    ClassName = (ClassName == null) ? 'tblCalendar' : ClassName;
    HTML = '<table class="' + ClassName + '" cellspacing="0">';
    // Title bar
    HTML += '<tr><td colspan="7"><table style="width:100%;height:100%;" class="CalendarRed" cellspacing="0"><tr class="TitleBar"><td class="Title"><a ID=caldatelink href="javascript:void(0)" onMouseDown="Calendar(' + Year + ', ' + Month + ', ' + Day+', \''+ContainerId+'\', \''+ClassName+'\');">'+MonthNames[LastMonth.getMonth()]+'</a></td> <td class="Title">' + MonthNames[Month] + ' ' + Year + '</td><td class="Title"><a ID=caldatelink href="javascript:void(0)" onMouseDown="Calendar(' + Year + ', ' + (Month + 2) + ', ' + Day+', \''+ContainerId+'\', \''+ClassName+'\');">'+MonthNames[NextMonth.getMonth()]+'</a></td></tr></table></td></tr>';  
    // Week Names
    HTML += '<tr class="WeekName"><td>S</td><td>M</td><td>T</td><td>W</td><td>T</td><td>F</td><td>S</td></tr>';
    HTML += '<tr class="Days">';
    // Fill the previous month days with space
    for(DayCounter = 0; DayCounter < WeekStart; DayCounter++)
    {
        HTML += '<td> </td>';
    }
    // Populate current month
    for(DayCounter = 1; DayCounter < MonthDays; DayCounter++)
    {
        if((DayCounter + WeekStart) % 7 == 1) HTML += '<tr class="Days">';
        if(DayCounter == tDay)
		{
            HTML += '<td class="SelectedDay"><a id="caldatelink" href="javascript:ReturnDate(' + DayCounter + ')">' + DayCounter + '</a></td>';
		}
		else if((DayCounter == Day))
		{
			
            HTML += '<td class="SelectedDay"><a id="caldatelink" href="javascript:ReturnDate(' + DayCounter + ')">' + DayCounter + '</a></td>';
		}
        else 
		{
			HTML += '<td><a id="caldatelink" href="javascript:ReturnDate(' + DayCounter + ')">' + DayCounter + '</a></td>';
		}
        if((DayCounter + WeekStart) % 7 == 0) HTML += '</tr>';
    }
    // Fill the next month days with space
    for(j = (42 - (MonthDays + WeekStart)), DayCounter = 0; DayCounter <= j; DayCounter++)
    {
        HTML += '<td> </td>';
        if((j - DayCounter) % 7 == 0) HTML += '</tr>';
    }
    HTML +='<tr><td colspan="7" height="10"></td></tr>'

	HTML +='<tr><td colspan="7">Today: <a id="caldatelink" href="javascript:void(0)" onMouseDown="ReturnFunc(tDay,eval(tMonth+1),tYear);">'+tDay+" "+MonthNames[tMonth]+" "+tYear+'</a></td></tr>'
   
    HTML += '</table>';
    Container.innerHTML = HTML;
    // Returns Id of the element containing the calendar
    return ContainerId;
}
function ReturnDate(Day)
{
	Calendar(Year, Month+1, Day, 'cal', 'CalendarRed');
    ReturnFunc(Day, Month+1, Year);
}
function MakeDate(fn, iYear, iMonth, iDay )
{
    D = new Date();
    Year = (typeof(iYear) != 'undefined') ? iYear : D.getFullYear();
    Month = (typeof(iMonth) != 'undefined') ? iMonth : D.getMonth()+1;
    Day = (typeof(iDay) != 'undefined') ? iDay : D.getDate();
    ReturnFunc = fn;
    id = Calendar(Year, Month, Day, 'cal', 'CalendarRed');
}
//-->
