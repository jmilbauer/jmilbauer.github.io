var overlayboxes = document.getElementsByClassName('overlay');
console.log(overlayboxes);
for (var i = 0; i < overlayboxes.length; i++) {
    overlayboxes[i].style.display = 'none';
}

var overlaybox = null;
var currentFocus = null;

function show_overlay(pos) {
    overlaybox.style.top = `${pos.top + window.scrollY - 10}px`;
    overlaybox.style.display = 'block';
}

function hide_overlay() {
    if (overlaybox === null) {
        console.log("no box");
    } else {
        overlaybox.style.display = 'none';
    }
}

document.addEventListener('click', function(event) {
    if (currentFocus === null || !currentFocus.contains(event.target)) {
        hide_overlay();
    }
});

var highlight_spans = document.getElementsByClassName('highlight');
for (var i = 0; i < highlight_spans.length; i++) {
    const element = highlight_spans[i];
    element.onclick = function(me) {
        console.log('click');
        const pos = this.getBoundingClientRect();
        currentFocus = this;
        
        hide_overlay();
        const my_id = this.id.split('-')[1];
        overlaybox = document.getElementById('overlaybox-' + my_id);
        show_overlay(pos);
    }    
}