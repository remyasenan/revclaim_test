// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Toggles all the passed checkboxes
function checkAll(checkboxes, exby) 
{
	for (i = 0; i < checkboxes.length; i++)
	{
		checkboxes[i].checked = exby.checked? true:false
	}
}

function imagedisply(singlepagetiff, multipagetiff,pageno,appletcontrol){
    var k = 1;
    var sub_uri = '';
    var path1 = '<APPLET CODEBASE = "'
    var path2 = '../v1/v1files" ARCHIVE = "ji.jar" CODE = "ji.applet.jiApplet.class" id= "viewONE" NAME = "ViewONE" WIDTH = "100%" HEIGHT = "100%" HSPACE = "0" VSPACE = "0" ALIGN = "middle" accesskey="Z" MAYSCRIPT="true" >'
    var fullPath = path1+sub_uri+path2
    document.write(fullPath)
    document.write('<param name="type" value="application/x-java-applet;version=1.4">');
    document.write('VALUE="/v1files/ji.cab, daeja1.cab, daeja2.cab, daeja3.cab">');
    if (appletcontrol != 1) {
        document.write('<PARAM NAME="printKeys" value="false">');
        document.write('<PARAM NAME="printMenus" value="false">');
        document.write('<PARAM NAME="cabbase" VALUE=“ViewONE.cab”>');
        document.write('<PARAM NAME="scale" value="ftow">');
        document.write('<PARAM NAME="fileButtonSave" value="false">');
        document.write('<PARAM NAME="fileButtonOpen" value="false">');
        document.write('<PARAM NAME="fileButtonClose" value="false">');
        document.write('<PARAM NAME="printButtons" value="false">');
    }
    document.write('<PARAM NAME="prefetchPages" value="5">');
    document.write('<PARAM NAME="obfuscate" value="false">');
    document.write('<param name="version3Features" value="true">');
    document.write('<param name="eventInterest" value="0, 9, 22, 30, 34, 35, 37, 38, 39, 41, 43">');
    document.write('<param name="ProcessKeys" value = "true">');
    document.write('<param name="annotationEncoding" value="UTF8">');
    document.write('<param name="annotate" value="true">');
    document.write('<param name="annotateEdit" value="true">');
    document.write('<PARAM NAME="initialFocus" value="false">');
    document.write('<PARAM NAME="focusBorder" value="false">');
    document.write('<PARAM NAME="annotationJavascriptExtensions" value="true">');
    document.write('<PARAM NAME="hideAnnotationToolbar" value="true">');
    if (singlepagetiff != "") 
	document.write('<param name="filename" value="../..' + sub_uri + singlepagetiff + '">');
    document.write('</APPLET>');
}

function setXYScroll(y){
var zoom_factor = $('viewONE').getZoom();
var y_scr_px = (y / zoom_factor);
$('viewONE').setXYScroll(0, y_scr_px);
}

//The following functions expand the text boxes as the user types in
// and collapse them after the user tabs out
function enlargeTextbox(id){
    $(id).size = ($(id).size) + 4
}

function resetTextboxSize(id){
    $(id).size = 2
}

function resetTextfieldSize(id,actualwidth){
       $(id).size = actualwidth
}

function enlargeTextfieldSize(id,actualsize){
   var text_length = $(id).value.length
   if (text_length >= actualsize){
      $(id).size = ($(id).value.length) + 4
   }
}
