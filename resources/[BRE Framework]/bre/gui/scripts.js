
/*
  ⊂ヽ
  　 ＼＼  Λ＿Λ
  　　 ＼( 'ㅅ' )
  　　　 >　⌒ヽ
  　　　/    へ＼
  　　 /　　/　＼＼
  　　 ﾚ　ノ　　 ヽつ
  　　/　/     BRE FRAME
  　 /　/|
  　(　(ヽ
  　|　|、＼
  　| 丿 ＼ ⌒)
  　| |　　) /
  ⊂ヽ'
░░░░░░░░░░░░░░░░░░░░░
░░░░░█▀█░█▀█░█▀▀░░░░░
░░░░░█▀▄░█▀▄░█▀░░░░░░
░░░░░▀▀▀░▀░▀░▀▀▀░░░░░
░░░░░░░░░░░░░░░░░░░░░
*/

var action_do = null;

var selected = 0;

var locked = true;

function getChoicesCount() {
  return $("#list").find(".list-item").length;
};

function Add(name){
  choice = document.createElement("li");
  choice.classList.add("list-item");
  choices = document.getElementById("list");
  choices.appendChild(choice);
  this.choice.innerHTML = "<h1 class='text'> " + name + "</h1>";
  action_do = name;
}

function Dialog(type, dText, exraData) { // dText = ['title', 'maintext', 'button1', 'button2 (optional)']

  this.remove = function() {
    document.body.removeChild(this.box);
  }
 
  // Main Box
  this.box = document.createElement("div");
  this.box.classList.add("dialog_box");
  
  // Title
  var head = document.createElement("div");
  head.classList.add("dialog_head");
  head.innerHTML = dText[0];
  this.box.appendChild(head);
  
  
  //Main Content
  var content = document.createElement("div");
  content.classList.add("dialog_" + type + "_content");
  if(type == "msg") {
	  var cPar = document.createElement("p");
	  cPar.innerHTML = dText[1];
	  content.appendChild(cPar);
  } else if(type == "list") {
	  // O sa folosesc niste extraData si vedem noi
  }
  this.box.appendChild(content);
  
  //Button Box
  var buttons = document.createElement("div");
  buttons.classList.add("dialog_buttons");

  //Btn 1
  var bt1 = document.createElement("span");
  bt1.classList.add("dialog_button1");
  bt1.innerHTML = dText[2];
  
  bt1.onclick = function(){
	  $.post("http://bre/dialogPressed", JSON.stringfy({
		  pressed: 1
	  }));
  };
  
  buttons.appendChild(bt1);
  
  //Btn 2
  if(dText[3]) {
	var bt2 = document.createElement("span");
	bt2.classList.add("dialog_button2");
	bt2.innerHTML = dText[3];
	buttons.appendChild(bt2);
	
	bt2.onclick = function(){
	  $.post("http://bre/dialogPressed", JSON.stringfy({
		  pressed: 2
	  }));
    };
  }
  
  this.box.appendChild(buttons);

  //build js sandbox
  var params = {"self":{},"window":{}}
  for(var k in window) //overload all window (global) keys
    params[k] = {};

  //whitelist
  params.box = this.box;

  //build proto/params
  this.proto_params = [];
  for(var k in params)
    this.proto_params.push(params[k]);
  this.proto = Object.keys(params).join(",");
  
  document.body.appendChild(this.box);
}

var divs = {}

function Div(data) {
  this.setCss = function(css) {
    this.style_css.nodeValue = css;
  }

  this.setContent = function(content) {
    this.div.innerHTML = content;
  }

  this.executeJS = function(js) {
    (new Function(this.proto,js)).apply(null,this.proto_params);
  }

  this.addDom = function() {
    document.body.appendChild(this.div);
    document.head.appendChild(this.style);
  }

  this.removeDom = function() {
    document.body.removeChild(this.div);
    document.head.removeChild(this.style);
  }

  this.div = document.createElement("div");
  this.div.classList.add("div_"+data.name);

  this.style = document.createElement("style");
  this.style_css = document.createTextNode("");
  this.style.appendChild(this.style_css);

  this.setCss(data.css);
  this.setContent(data.content);

  //build js sandbox
  var params = {"self":{},"window":{}}
  for(var k in window) //overload all window (global) keys
    params[k] = {};

  //whitelist
  params.div = this.div;

  //build proto/params
  this.proto_params = [];
  for(var k in params)
    this.proto_params.push(params[k]);
  this.proto = Object.keys(params).join(",");
}

function addGaps(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + '<span style="margin-left: 3px; margin-right: 3px;"/>' + '$2');
  }
  return x1 + x2;
}
function addCommas(nStr) {
  nStr += '';
  var x = nStr.split('.');
  var x1 = x[0];
  var x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',<span style="margin-left: 0px; margin-right: 1px;"/>' + '$2');
  }
  return x1 + x2;
}

$(document).ready(function(){

  function removeClass(){
    $(".selected").removeClass("selected");
  }

  function moveUp() {
    removeClass();
    $(".list-item").prev().addClass("selected");
  }

  function moveDown() {
    removeClass();
    $(".list-item").next().addClass("selected");
  }
  // Partial Functions
	function closeMain() {
    $(".block-screen").css("display", "none");
    $(".home-screen").css("display", "none");
    $(".phone").css("display", "none");
    opened = false;
    locked = true;
    removeClass();
	}
	function openMain() {
    $(".phone").css("display", "block");
    $(".block-screen").css("display", "block");
    $(".home-screen").css("display", "none");
    $(".phone").css("animation", "opacity 0.5s");
    opened = true;
    locked = true;
	}
	function left(){
    $(".block-screen").css("display", "none");
    $(".home-screen").css("display", "block");
    removeClass();
    $(".list-item").first().addClass("selected");
    locked = false;
	}
	function right(){
    $(".home-screen").css("display", "none");
    $(".block-screen").css("display", "block");
    locked = true;
    removeClass();
  }
	function DoAction(){
    selected = document.getElementsByClassName(".selected");
    text = selected.text();
    $.post('http://bre/triggerchoice', JSON.stringify({text}));
	}
  
  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var data = event.data;
    
    if (data.act == "add_choice"){
      Add(data.choice);
    }
    if(data.select == "select") {
			if (!locked) {
				DoAction();
			}
    }
    if(data.select == "up") {
			if (!locked)
        moveUp();
      else
        openMain();
    }
    if(data.select == "down") {
			if (!locked)
			  moveDown();
      else
        closeMain();
    }
    if(data.select == "right") {
			if (opened) {
				right();
			}
    }
    if(data.select == "left") {
			if (opened == locked == true) {
				left();
			}
    }
    if (data.act == "set_div") {
      var div = divs[data.name];
      if (div)
        div.removeDom();
  
      divs[data.name] = new Div(data)
      divs[data.name].addDom();
    }
    if (data.act == "set_div_css") {
      var div = divs[data.name];
      if (div)
        div.setCss(data.css);
    }
    if (data.act == "set_div_content") {
      var div = divs[data.name];
      if (div)
        div.setContent(data.content);
    }
    if (data.act == "div_execjs") {
      var div = divs[data.name];
      if (div)
        div.executeJS(data.js);
    }
    if (data.act == "remove_div") {
      var div = divs[data.name];
      if (div)
        div.removeDom();
  
      delete divs[data.name];
    }
  });

  document.onkeyup = function (data) {
    if (data.which == 8) {
      $.post('http://bre/close', JSON.stringify({}));
    }
  };
});
