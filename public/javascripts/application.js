/************************************************************************************************************
 By organizing these methods into the Photo object, they can more easily be called from RJS.
 Photo.show          requests the display of a particular photo;
 Photo.hide          hides the image shown in the photo-wrapper id
 Photo.currentIndex  get the current index of the photo being displayed
 Photo.prev          Displays the previous photo
 Photo.next          Displays the next photo
 ************************************************************************************************************/
var Photo = {
    show: function(url){
        setReviewID(url);
        setStyleById("comment_container", "display", "block");
        $('photo').src = url;
        $('mask').show();
        $('photo-wrapper').visualEffect('appear', {
            duration: 0.5
        });
        $('structLegend').show();
    },
    
    hide: function(){
        $('comment_container').hide();
        $('mask').hide();
        $('photo-wrapper').visualEffect('fade', {
            duration: 0.5
        });
		$('structLegend').hide();
    },
    
    currentIndex: function(){
        return this.urls().indexOf($('photo').src);
    },
    
    prev: function(){
        if (this.urls()[this.currentIndex() - 1]) {
            /* Added by Divya to set the session review_id 
             session.setAttribute("review_id", this.currentIndex()-1);*/
            var url = this.urls()[this.currentIndex() - 1];
            setReviewID(url);
            this.show(url);
        }
    },
    
    next: function(){
        if (this.urls()[this.currentIndex() + 1]) {
            /* Added by Divya to set the session review_id 
             session.setAttribute("review_id", this.currentIndex()+1);*/
            var url = this.urls()[this.currentIndex() + 1];
            setReviewID(url);
            this.show(url);
        }
    },
    
    urls: function(){
        if (!this.cached_urls) {
            this.cached_urls = $$('a.show').collect(function(el){
                return el.onclick.toString().match(/".*"/g)[0].replace(/"/g, '');
            });
        }
        return this.cached_urls;
    }
}

function setStyleById(id, p, v){
    var n = document.getElementById(id);
    n.style[p] = v;
}

function setCookie(name, value, expires){
    document.cookie = name + "=" + escape(value) + "; path=/" + ((expires == null) ? "" : "; expires=" + expires.toGMTString());
}

function RGBtoHex(R, G, B){
    str = toHex(R) + toHex(G) + toHex(B)
    return ('#' + str.toString())
}

function toHex(N){
    if (N == null) 
        return "00";
    N = parseInt(N);
    if (N == 0 || isNaN(N)) 
        return "00";
    N = Math.max(0, N);
    N = Math.min(N, 255);
    N = Math.round(N);
    return "0123456789ABCDEF".charAt((N - N % 16) / 16) +
    "0123456789ABCDEF".charAt(N % 16);
}

function cancel_comment(){
    setStyleById("add_comment", "display", "none");
    setStyleById("new_link", "display", "block");
}

function cancel_newParam(){
    setStyleById("newParamShow", "display", "none");
    setStyleById("newParamlink", "display", "block");
    setStyleById("selectMetrics", "display", "none");
}

function cancel_report_type(){
    setStyleById("reprot_type_add", "display", "none");
    setStyleById("new_report_link", "display", "block");
}

function cancel_new_report(){
    setStyleById("new_report_link", "display", "none");
    setStyleById("reprot_type_add", "display", "block");
}

function cancel_new_report_param_link(){
    setStyleById("add_report_params", "display", "none");
    setStyleById("new_report_param_link", "display", "block");
}

function setReviewID(url, dvhNum){

    if (url.length < 1) {
    }
    else {
        var first = url.indexOf("photos/");
        
        first = first + 7;
        
        var second = url.indexOf(".full");
        
        new Ajax.Updater('structLegend', '/reviews/structLegend', {
            asynchronous: true,
            evalScripts: true,
            parameters: 'review_id=' + escape(url.slice(first, [second]))
        });
        
        if (dvhNum == 1) {
            new Ajax.Updater('DVH_Stat1', '/reviews/dvhstat', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('dvh_comment_list1', '/comments/list', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('new_link', '/comments/newCommentDropDown', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
        };
        
        if (dvhNum == 2) {
            new Ajax.Updater('DVH_Stat2', '/reviews/dvhstat', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('dvh_comment_list2', '/comments/list', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('new_link', '/comments/newCommentDropDown', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
        };
        
        if (dvhNum == 3) {
            new Ajax.Updater('DVH_Stat3', '/reviews/dvhstat', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('dvh_comment_list3', '/comments/list', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('new_link', '/comments/newCommentDropDown', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
        };
        
        if (dvhNum == 4) {
            new Ajax.Updater('DVH_Stat4', '/reviews/dvhstat', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('dvh_comment_list4', '/comments/list', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
            new Ajax.Updater('new_link', '/comments/newCommentDropDown', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
        };
        
        if (dvhNum != 1 || dvhNum != 2 || dvhNum != 3 || dvhNum != 4) {
            new Ajax.Updater('comment_list', '/comments/list', {
                asynchronous: true,
                evalScripts: true,
                parameters: 'review_id=' + escape(url.slice(first, [second]))
            });
        }
    }
}

function checkAll(el, tick){
    var els = el.form.elements;
    var x, i = els.length;
    while (i--) {
        x = els[i];
        if ('input' == x.nodeName.toLowerCase() &&
        'checkbox' == x.type) {
            x.checked = tick;
        }
    }
}

function checkThis(el){
    checkAll(el, el.checked);
}

function runApp(filePath){
    var sText = '"R:\CERR3\CERR_for_OQA_test\load_test_plan_in_CERR.bat"' + filePath;
    var wshShell = new ActiveXObject("WScript.Shell");
    wshShell.run(sText, 1, "True");
}

function installDepend(){
    var wshShell = new ActiveXObject("WScript.Shell");
    wshShell.run('"R:/CERR3/CERR3pt0beta5_Compiled/MCRInstaller.exe"', 1, "True");
}


/* Tag selection function */
function tabselect(tab){
    var tablist = $('nav').getElementsByTagName('li');
    var nodes = $A(tablist);
    var lClassType = tab.className.substring(0, tab.className.indexOf('-'));
    
    nodes.each(function(node){
        if (node.id == tab.id) {
            tab.className = lClassType + '-selected';
        }
        else {
            node.className = lClassType + '-unselected';
        };
            });
    $('comment_container').hide();
    $('DVH_Stat').hide();
}

function setDvhStat1(url){
    setReviewID(url, 1);
    setStyleById("dvh_comment_container", "display", "block");
    $('DVH_Stat1').show();
}

function setDvhStat2(url){
    setReviewID(url, 2);
    setStyleById("dvh_comment_container", "display", "block");
    $('DVH_Stat2').show();
}

function setDvhStat3(url){
    setReviewID(url, 3);
    setStyleById("dvh_comment_container", "display", "block");
    $('DVH_Stat3').show();
}

function setDvhStat4(url){
    setReviewID(url, 4);
    setStyleById("dvh_comment_container", "display", "block");
    $('DVH_Stat4').show();
}

function processPlanDataCheck(form){
    // var doseSelect =  document.testform.doseSelect.options[document.testform.doseSelect.selectedIndex].value
    // var userSelect =  document.testform.userSelect.options[document.testform.userSelect.selectedIndex].value
    
    var doseSelect = form.doseSelect.options[form.doseSelect.selectedIndex].value
    var userSelect = form.userSelect.options[form.userSelect.selectedIndex].value
    var presetSelect = form.presetSelect.options[form.presetSelect.selectedIndex].value
    
    var returnval;
    
    if ((doseSelect != 'None') && (userSelect != 'None') && (presetSelect != 'None')) 
        returnval = true;
    else {
        if (doseSelect == 'None') {
            alert("Must select a dose before proceeding");
            returnval = false;
        }
        
        if (userSelect == 'None') {
            alert("Must select a Ref MD before proceeding");
            returnval = false;
        }
        
        if (presetSelect == 'None') {
            alert("Must select Windowing Preference before proceeding");
            returnval = false;
        }
        
    }
    return returnval;
}
