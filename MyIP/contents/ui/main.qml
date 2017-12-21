/*!
  * KDE Plasma script to display the current IP address and ISP
  *
  * Lee Thompson <sr.mysql.dba@gmail.com>
  * 05.March.2017
*/
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


Item {
    id:myip

    width: 250
    height: 250
    property string ip: ""
    property string isp: ""
    property string country: ""
    property string region: ""
    property string city: ""
    property string lat: ""
    property string lon: ""
    property string fontColor:"#FFFFFF"
    property int fontSize:24
    property int rate:60
    property bool backgroundHints:true
    property string lastCheck:""
    
    function callback(x){
        if (x.responseText) {
	    myip.lastCheck = getFormattedDate()
            var d = JSON.parse(x.responseText);
            myip.ip = d.query;
            myip.isp = d.isp;
            myip.country = d.country
            myip.region = d.regionName
            myip.city = d.city
            myip.lat = d.lat
            myip.lon = d.lon

        }
    }

    function request(url, callback) {
       var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = (function f() {callback(xhr)});
       xhr.open('GET', url, true);
       xhr.send();
   }
   function getFormattedDate() {
        var date = new Date();
        var str = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate() + " "
                        +  date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
        return str;
    }

    Timer {
        running: true
        triggeredOnStart: true
        interval: 60000
        onTriggered: request('http://ip-api.com/json',callback)
    }

    PlasmaComponents.Button {
    	id: refresh_button
    	anchors { top: parent.top; right: parent.right }
    	iconSource: "view-refresh"
    	tooltip: i18n("Refresh")
    	onClicked:  {   
/*			console.log(refresh_button.text + " clicked") */
			request('http://ip-api.com/json',callback)
        	    }
    }

    Column{
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize; text: "IP Address: "+myip.ip }
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize; text: "ISP: "+myip.isp }
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize; text: " City: "+myip.city }
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize; text: " Region: "+myip.region }
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize; text: " Country: "+myip.country }
        Text {  color: myip.fontColor; font.pointSize: myip.fontSize-2; text: {"(Last check: "+ myip.lastCheck+")" }}
    }
}
