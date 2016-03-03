function Pager(tableName, itemsPerPage) {
    this.tableName = tableName;
    this.itemsPerPage = itemsPerPage;
    this.currentPage = 1;
    this.pages = 0;
    this.inited = false;
    this.pagname="";
	this.positionid="";
	
    this.showRecords = function(from, to) {        
        var rows = document.getElementById(tableName).rows;
        // i starts from 1 to skip table header row
        for (var i = 1; i < rows.length; i++) {
            if (i < from || i > to)  
                rows[i].style.display = 'none';
            else
                rows[i].style.display = '';
        }
    }
    
    this.showPage = function(pageNumber) {
    	if (! this.inited) {
    		alert("not inited");
    		return;
    	}
		this.showPageNav(this.pagname,this.positionid);
        var oldPageAnchor = document.getElementById('pg'+this.currentPage);
        oldPageAnchor.className = 'pg-normal';
        
        this.currentPage = pageNumber;
        var newPageAnchor = document.getElementById('pg'+this.currentPage);
        newPageAnchor.className = 'pg-selected';
        
        var from = (pageNumber - 1) * itemsPerPage + 1;
        var to = from + itemsPerPage - 1;
        this.showRecords(from, to);
    }   
    
    this.prev = function() {
	this.showPageNav(this.pagname,this.positionid);
        if (this.currentPage > 1)
            this.showPage(this.currentPage - 1);
    }
    
    this.next = function() {
	this.showPageNav(this.pagname,this.positionid);
        if (this.currentPage < this.pages) {
            this.showPage(this.currentPage + 1);
        }
    }                        
    
    this.init = function() {
        var rows = document.getElementById(tableName).rows;
        var records = (rows.length - 1); 
        this.pages = Math.ceil(records / itemsPerPage);
        this.inited = true;
    }

    this.showPageNav = function(pagerName, positionId) {
    	if (! this.inited) {
    		alert("not inited");
    		return;
    	}
		this.pagname=pagerName;
	    this.positionid=positionId;
    	
    	var element = document.getElementById(positionId);
    	var stindex=""; var enindex="";
		if(this.pages <=3){stindex=1; enindex=this.pages;}
		else{
		var currpos =this.currentPage;
		stindex=currpos-1;  enindex=currpos+1;
		if((currpos-1)<=0){stindex=1;  enindex=3;}
		if(this.pages<=(currpos+1)){stindex=this.pages-2;  enindex=this.pages;}
		}
    	var pagerHtml = '<span onclick="' + pagerName + '.prev();" class="pg-normal">  Prev </span>  ';
        for (var page = stindex; page <= enindex; page++) 
            pagerHtml += '<span id="pg' + page + '" class="pg-normal" onclick="' + pagerName + '.showPage(' + page + ');">' + page + '</span>  ';
        pagerHtml += '<span onclick="'+pagerName+'.next();" class="pg-normal"> Next </span>';            
        
        element.innerHTML = pagerHtml;
    }
}

