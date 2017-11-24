var maxBoxes = 35;

var score = 0;
var boxCount = 0;
var gameOver = false;

var screenNum;

var timer = 0;
var beginTime;
var lastTime = 0;

// Number of boxes shown over the entire task: maxBoxes * number of screens
// e.g. 35 * 23 = 805

//var timings = [10, 9, 10, 8, 11, 9, 10, 12, 10, 11, 9, 9, 10, 10, 12, 8, 12, 10, 9, 9, 12, 8, 12, 10]; 
//var timings = [12, 12, 10, 11, 14, 13, 12, 12, 11, 13, 14, 10, 12, 10, 13, 11, 12, 14, 13, 11, 10, 12, 11, 13, 14]; // I clicked on 73% of the boxes with the 8 sec avg.
var timings = [7, 7, 5, 6, 9, 8, 7, 7, 6, 8, 9, 5, 7, 5, 8, 6, 7, 9, 8, 6, 7, 8, 7, 5, 6]; // I clicked on 47% of the boxes with the 8 sec avg.
var practiceTimings = [8, 10, 12, 9];

var maxScreens = timings.length
var treatment;
var practice = false;

var boxClickOrder = new Array();
var browseOrder = new Array();

var counterTimer;

var replay = false;
var record;

var myWindow;

function sign(x) { return x > 0 ? 1 : x < 0 ? -1 : 0; }

function game() {
    var stylesheet = document.styleSheets[0],
    selector = "div[id^=\"box\"]", rule = "{ width:30px; height:30px; background:black; border-radius:3px; box-shadow: 1px 1px 1px grey; margin: 2px 2px 2px 2px; display:inline-block; }";

    if (stylesheet.insertRule) {
        stylesheet.insertRule(selector + rule, stylesheet.cssRules.length);
    } else if (stylesheet.addRule) {
        stylesheet.addRule(selector, rule, -1);
    }

    var objTo = document.getElementById('PanelJavascript')

    var game = document.createElement('div');
    game.className = 'center';
    game.setAttribute('id', "game");
    $("#game").css('width', '850px');
    $("#game").css('text-align', 'center');
    $("#game").css('line-height', '0px');
    objTo.appendChild(game)

    for (var l = 0; l < 14; l++) {
        for (var i = 0; i < 24; i++) {
            var div = document.createElement('div');
            div.className = 'box';
            div.setAttribute('id', "box" + boxCount);
            $('#box' + boxCount).css('visibility', 'hidden');
            $('#box' + boxCount).css('opacity', '0');
            game.appendChild(div);
            boxCount++;
        }
        var mybr = document.createElement('br');
        game.appendChild(mybr);
    }

    $(document).ready(function () {
        for (var k = 0; k < boxCount; k++) {
            $('#box' + k).click(boxClicked(k));
        }
    });

    treatment = parseInt(document.getElementById('qHiddenField2').value);

//---------------------------------
    var screenChoice = parseInt(document.getElementById('qHiddenField3').value);

    finalTimings = [];

    if (screenChoice != 9999) {
        for (n = 0; n < screenChoice; n++) {
            finalTimings.push(timings[n]);
        }
        timings = finalTimings
    }

//---------------------------------
    document.getElementById('qHiddenField2').value = "";

    if (treatment == -1000) {
        timings = practiceTimings;
        treatment = 1;
        practice = true;
    }

    if (treatment < 0) {
        screenNum = timings.length - 1;
    }
    else {
        screenNum = 0;
    }

    if (treatment == Math.abs(2000)) {
        treatment = sign(treatment);

        var compressed = document.getElementById('qHiddenField1').value;

        replay = true;

        if (compressed.charAt(0) == "$") {
            record = [];
        }
        else {
            record = JSON.parse(lzw_decode(compressed));
            console.log(JSON.stringify(record));
        }        
    }

    clearBoxes();

    setTimeout(
        function () {
            resetBoxes();
            beginTime = new Date().getTime();
            counterTimer = setInterval(counter, 1000);

            if (replay == true) {
                setInterval(clicker, 10);
            }

            //if (replay == false) {
                //$("#game").append("<br/><br/><input type='button' value='Browse Internet' id='jsBrowseButton' />");

                //$("#jsBrowseButton").click(function () {
                //    var time = new Date().getTime() - beginTime;
                //    browseOrder[browseOrder.length] = time;
                //    myWindow = window.open("http://www.google.com", "myWindow", "width=1024, height=768");
                //});
            //}

        }, 3000);

    //$("#ButtonNext").css('visibility', 'hidden');
    console.log("test");

    if (practice == true) {
        //console.log("test2");
        //$("#game").append("<br/><br/><input type='button' value='Back' id='jsBackButton' /> ");
        //$("#game").append("<input type='button' value='Next' id='jsSubmitButton' />");

        //$("#jsBackButton").click(function () {
        //    serverBack();
        //});
        $("#jsSubmitButton").click(function () {
            serverSubmit();
        });
    }
}

function boxClicked(k) {
    return function () {
        if (replay == true)
        {
            return;
        }

        if ($(this).clickable == 0) {
            return;
        }

        score++;
        $(this).clickable = 0;

        //$(this).fadeTo("fast", 0, function () {
            $(this).css('visibility', 'hidden');
        //});
        var time = new Date().getTime() - beginTime;
        //alert(time);
        boxClickOrder[boxClickOrder.length] = new Array(time, k);
    }
}

function counter() {
    if (gameOver == true) {
        //$("#ButtonNext").css('visibility', 'visible');
        //document.getElementById("ButtonNext").disabled = false;

        clearTimeout(counterTimer);

        $("#game").append("<br/><br/><input type='button' value='Next' id='jsSubmitButton' />");

        $("#game").append('<br/><br/>The task is over. Click \'Next\' to continue with the experiment.');

        if (replay == false) {
            //$("#jsBrowseButton").css('visibility', 'hidden');

            if (myWindow) {
                myWindow.close();
            }
        }

        $("#jsSubmitButton").click(function () {
            serverSubmit();
        });

        clearBoxes();
        return;
    }
    timer++;

    if (timer - lastTime >= timings[screenNum]) {
        //alert(screenNum);
        screenNum = screenNum + parseFloat(treatment);
        resetBoxes();
        lastTime = timer;
    }

    if ((screenNum == timings.length || screenNum < 0) && gameOver == false) {
        gameOver = true;

        var serializedArr = JSON.stringify(boxClickOrder);
        //alert(serializedArr);
        if (practice != true && replay != true) {
            document.getElementById('qHiddenField1').value = lzw_encode(serializedArr);
            //document.getElementById('qHiddenField2').value = score;

            document.getElementById('qHiddenField2').value = (score * 100 / (maxScreens * maxBoxes)).toFixed(2);
        }
        else {
            document.getElementById('qHiddenField1').value = "done";
            document.getElementById('qHiddenField2').value = "done";
        }
        document.getElementById('qHiddenField3').value = JSON.stringify(browseOrder);
        counter();

        return;
    }
}
function clearBoxes()
{
    for (var l = 0; l < boxCount; l++) {
        $('#box' + l).css('visibility', 'hidden');
        $('#box' + l).css('opacity', '0');
    }
}

var totalBoxesAdded = 0;

function resetBoxes() {
    //alert(timings[screenNum]);
    
    var boxesAdded = 0;
    var boxesArray = [];
    var rand;

    if (practice != true) {
        rand = new Rc4Random(screenNum.toFixed(0));
        //seed(screenNum);
    }
    else
    {
        rand = new Rc4Random((1000+screenNum).toFixed(0));
        //seed(1000 + screenNum);
    }

    clearBoxes();
    setTimeout(
    function () {
        if (gameOver == true) {
            return;
        }
        //$(document).ready(function () {
            while (boxesAdded < maxBoxes) {
                for (var l = 0; l < boxCount; l++) {
                    if (rand.getRandomNumber() > 0.9 && boxesAdded < maxBoxes) {
                        if (boxesArray[l] != true) {
                            boxesArray[l] = true;
                            boxesAdded++;
                            totalBoxesAdded++;
                        }
                        $('#box' + l).css('visibility', 'visible');
                        $('#box' + l).css('opacity', '1');
                        $('#box' + l).clickable = 1;
                    }
                }
            }
        //});
    }, 1);
}


var clickindex = 0;
function clicker() {
    if (clickindex < record.length) {

        //console.log(String(clickindex));
        //console.log(record.length);
        //console.log(String(record[clickindex][1]));

        var time = record[clickindex][0];
        var box = record[clickindex][1];
        var currentTime = new Date().getTime() - beginTime;

        if (currentTime > time) {
            //$("#box" + box).fadeTo("fast", 0, function () {
                $("#box" + box).css('visibility', 'hidden');
            //});
            clickindex++;
            score++;
        }
    }
}

function Rc4Random(seed)
{
    var keySchedule = [];
    var keySchedule_i = 0;
    var keySchedule_j = 0;
    
    function init(seed) {
        for (var i = 0; i < 256; i++)
            keySchedule[i] = i;
        
        var j = 0;
        for (var i = 0; i < 256; i++)
        {
            j = (j + keySchedule[i] + seed.charCodeAt(i % seed.length)) % 256;
            
            var t = keySchedule[i];
            keySchedule[i] = keySchedule[j];
            keySchedule[j] = t;
        }
    }
    init(seed);
    
    function getRandomByte() {
        keySchedule_i = (keySchedule_i + 1) % 256;
        keySchedule_j = (keySchedule_j + keySchedule[keySchedule_i]) % 256;
        
        var t = keySchedule[keySchedule_i];
        keySchedule[keySchedule_i] = keySchedule[keySchedule_j];
        keySchedule[keySchedule_j] = t;
        
        return keySchedule[(keySchedule[keySchedule_i] + keySchedule[keySchedule_j]) % 256];
    }
    
    this.getRandomNumber = function() {
        var number = 0;
        var multiplier = 1;
        for (var i = 0; i < 8; i++) {
            number += getRandomByte() * multiplier;
            multiplier *= 256;
        }
        return number / 18446744073709551616;
    }
}

function lzw_encode(s) {
    var dict = {};
    var data = (s + "").split("");
    var out = [];
    var currChar;
    var phrase = data[0];
    var code = 256;
    for (var i = 1; i < data.length; i++) {
        currChar = data[i];
        if (dict[phrase + currChar] != null) {
            phrase += currChar;
        }
        else {
            out.push(phrase.length > 1 ? dict[phrase] : phrase.charCodeAt(0));
            dict[phrase + currChar] = code;
            code++;
            phrase = currChar;
        }
    }
    out.push(phrase.length > 1 ? dict[phrase] : phrase.charCodeAt(0));
    for (var j = 0; j < out.length; j++) {
        out[j] = String.fromCharCode(out[j]);
    }
    return out.join("");
}

function lzw_decode(s) {
    var dict = {};
    var data = (s + "").split("");
    var currChar = data[0];
    var oldPhrase = currChar;
    var out = [currChar];
    var code = 256;
    var phrase;
    for (var i = 1; i < data.length; i++) {
        var currCode = data[i].charCodeAt(0);
        if (currCode < 256) {
            phrase = data[i];
        }
        else {
            phrase = dict[currCode] ? dict[currCode] : (oldPhrase + currChar);
        }
        out.push(phrase);
        currChar = phrase.charAt(0);
        dict[code] = oldPhrase + currChar;
        code++;
        oldPhrase = phrase;
    }
    return out.join("");
}

window.onload = game;
