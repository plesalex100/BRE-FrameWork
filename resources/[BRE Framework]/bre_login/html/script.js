
function setBoxShowing(bool) {
  if(bool) {
    $("#login").show();
  } else {
    $("#login").css("background", "#4CAF50");
    setTimeout(function() {
      $("#login").hide();
      $("#login").css("background", "#20A4F3");
    }, 500);
  }
}

function getError(msg) {
  $("#login").css("background", "red").effect("shake", 400);
  setTimeout(function() {
    $("#login").css("background", "#20A4F3");

    $("#error").show().empty().html(msg);
    setTimeout(function() {
      $("#error").hide();
    }, 3000);
  }, 500);
}

function tryEnter(register) {
  var nume = $("#name").val();
  var parola = $("#pass").val();

  var action = "login";
  if(register) {
    action = "register";
  }
  $.post("http://bre_login/tryEnter", JSON.stringify({
    doWhat: action,
    nume: nume,
    parola: parola
  }));
}

function setTitle(title) {
  $("#title").empty().html(title);
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
    case "open": setBoxShowing(true);
      break;
    case "close": setBoxShowing(false);
      break;
    case "changeTitle": setTitle(event.data.theTitle);
      break;
    case "error": getError(event.data.theError);
      break;
  }
});

$(document).ready(function() {
  $("#error").hide();
  $("#login").hide();
});
