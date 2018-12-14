console.log("SUCCESS");

function load_out_small(url) {
  document.getElementById('canvas').style.transition = "0.4s";
  document.getElementById('canvas').style.width = "300px";
  document.getElementById('canvas').style.height = "300px";
  setTimeout( function() {
    window.location = url;
  }, 400);
}

function load_out_big(url) {
  document.getElementById('canvas').style.transition = "0.4s";
  document.getElementById('canvas').style.width = "700px";
  document.getElementById('canvas').style.height = "700px";
  setTimeout( function() {
    window.location = url;
  }, 400);
}

function loginTransition() {
  document.getElementById('canvas').style.transition = "0.4s";
  document.getElementById('canvas').style.width = "700px";
  document.getElementById('canvas').style.height = "700px";
}
