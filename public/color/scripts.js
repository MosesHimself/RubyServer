function readHex()  {
	var hex = getParameterByName("hex");
	var l = hex.length;
	if(l < 3 || l > 6)  {
		random();
		return;
	}
	setColors(hexToR(hex), hexToG(hex), hexToB(hex));
	formColorString();
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function formColorString()  {
	var x = document.getElementById("num0").value;
	var y = document.getElementById("num1").value;
	var z = document.getElementById("num2").value;
	
	var string = "rgb(" + x + "," + y + "," + z + ")";
	document.getElementById('rgb').value = string;
	
	var hex = rgbToHex(x, y, z);
	document.getElementById('hex').value = "#" + hex;
	document.getElementById('hid').value = hex;
	document.body.style.backgroundColor = string;
	
	document.getElementById("title").style.textShadow = "2px 2px "+ string;
	
	var c = document.getElementsByClassName("change");
	var i;
	for (i = 0; i < c.length; i++) {
		c[i].style.backgroundColor = string;
	}
	
	document.getElementById("description").style.color = string;
}

function send()  {
	formColorString();
	document.getElementById("myForm").submit();
}

function update(n)  {
	
	if(document.getElementById("num" + n).value == undefined || document.getElementById("num" + n).value < 0)  {
		document.getElementById("num" + n).value = 0;
		//alert("shit was empty");
	}
	else if(document.getElementById("num" + n).value > 255)  {
		document.getElementById("num" + n).value = 255;
	}
	
	document.getElementById("slider" + n).value = document.getElementById("num" + n).value;
	send();
}

function increment(n)  {
	document.getElementById("num" + n).value++;
	update(n);
}

function decrement(n)  {
	document.getElementById("num" + n).value--;
	update(n);
}

function slide(n)  {
	document.getElementById("num" + n).value = document.getElementById("slider" + n).value;
	formColorString();
}


function setColors(x, y, z)  {
	document.getElementById("num0").value = x;
	document.getElementById("num1").value = y;
	document.getElementById("num2").value = z;
	
	document.getElementById("slider0").value = document.getElementById("num0").value;
	document.getElementById("slider1").value = document.getElementById("num1").value;
	document.getElementById("slider2").value = document.getElementById("num2").value;
	
}

function rainbowSlider()  {

	var i = (document.getElementById("sliderR").value / 159.1);

	var x = Math.round(127 * Math.cos(i  + (3.14159 * 2))) + 128;
    var y = Math.round(127 * Math.sin(i + (3.14159 * 2))) + 128;
    var z = Math.round(127 * Math.cos(i + 3.14159)) + 128;
    
    setColors(x, y, z);
	formColorString();
}

function random()  {
	var x = Math.floor(Math.random() * 255);
	var y = Math.floor(Math.random() * 255);
	var z = Math.floor(Math.random() * 255);
	
	setColors(x, y, z);
	send();
}

function rgbUpdate()  {

}

function hexUpdate()  {
	var hex = document.getElementById('hex').value;
	if(hex[0] == "#" && hex.length == 7)  {
		window.location.href='/color_picker/picker.php?hex=' + hex.substring(1,7);
	}
}

function componentToHex(c) {

	//keeps the value at 2 digits
	if(c < 16)  return "0" + toH(c);
	
	var string = "";
	var remainder = 0;
	while (c > 0)  {
		remainder = c % 16;
		remainder = toH(remainder);
		
		string = remainder + string;
		c = c / 16;
		c = Math.floor(c);
	}
	
	return string;
}

function toH(c)  {

	if(c == 10) return 'a';
	else if(c == 11) return "b";
	else if(c == 12) return "c";
	else if(c == 13) return "d";
	else if(c == 14) return "e";
	else if(c == 15) return "f";

	return c.toString();

}

function rgbToHex(r, g, b) {
	return componentToHex(r) + componentToHex(g) + componentToHex(b);
}

function hexToR(h) {
	var digits = cutHex(h);
	var r = parseInt(digits.substring(0, 2), 16);
	return r;
}
function hexToG(h) {
	var digits = cutHex(h);
	var g = parseInt(digits.substring(2,4), 16);
	return g;
}
function hexToB(h) {
	var digits = cutHex(h);
	var b = parseInt(digits.substring(4,6), 16);
	return b;
}

function cutHex(h) {return (h.charAt(0)=="#") ? h.substring(1,7):h}
