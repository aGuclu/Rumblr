console.log("SUCCESS");

function load_out_small(url) {
  document.getElementById('canvas').style.transition = "0.4s";
  document.getElementById('canvas').style.width = "400px";
  document.getElementById('canvas').style.height = "400px";
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

function transition() {
  document.getElementById('canvas').style.transition = "0.4s";
  document.getElementById('canvas').style.width = "700px";
  document.getElementById('canvas').style.height = "700px";
}
