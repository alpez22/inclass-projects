let originalStudentHtml = "";

/**
 * Given an array of students, generates HTML for all students
 * using {@link buildStudentHtml}.
 * 
 * @param {*} studs array of students
 * @returns html containing all students
 */
function buildStudentsHtml(studs) {
	return studs.map(stud => buildStudentHtml(stud)).join("\n");
}

/**
 * Given a student object, generates HTML. Use innerHtml to insert this
 * into the DOM, we will talk about security considerations soon!
 * 
 * @param {*} stud 
 * @returns 
 */
function buildStudentHtml(stud) {
	let html = `<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-2">`;
	html += `<h2>${stud.name.first} ${stud.name.last}</h2>`;
	html += `<p><em><b>${stud.major}</b></em></p>`;
	html += `<p>${stud.name.first} is taking ${stud.numCredits} credits and ${stud.fromWisconsin ? "is" : "is not"} from Wisconsin.</p>`;
	html += `<p>They have ${stud.interests.length} interests including... </p>`;
	let bulletPoints = "";
	stud.interests.filter(element => bulletPoints += `<li>${element}</li>`);
	html += `<ul>${bulletPoints}</ul>`;
	html += `</div>`
	return html;
}

function handleSearch(e) {
	e.preventDefault();

	const name = document.getElementById("search-name").value;
	const major = document.getElementById("search-major").value;
	const interest = document.getElementById("search-interest").value;
	
	// Filter listener
	document.getElementById("students").innerHTML = originalStudentHtml;
	const studentObj = document.getElementById("students");
	const studentDiv = Array.from(studentObj.children);
	let filteredStudentHtml = "";
	let resultNum = 0;
	let nameFilter = studentDiv.filter(div => div.children[0].innerText.toLowerCase().includes(name.toLowerCase().trim())
	 											&& div.children[1].innerText.toLowerCase().includes(major.toLowerCase().trim())
	 											&& div.children[4].innerText.toLowerCase().includes(interest.toLowerCase().trim())
												? (filteredStudentHtml += `<div class="col-xs-12 col-sm-6 col-md-4 col-lg-3 col-xl-2">` + div.innerHTML + `</div>`, resultNum++) 
												: ('', resultNum));

	//return the number and student results
	if(filteredStudentHtml.length != 0){
		document.getElementById("students").innerHTML = filteredStudentHtml;
		document.getElementById("num-results").innerHTML = resultNum;
	}else{
		document.getElementById("students").innerHTML = "";
		document.getElementById("num-results").innerHTML = resultNum;
	}
}

fetch("https://cs571.org/api/f23/hw2/students", {
    headers: {
        "X-CS571-ID": CS571.getBadgerId()
    }
})
.then(res => res.json())
.then(data =>{
	console.log(data);
	document.getElementById("num-results").innerText = data.length;
	let allStudentHtml = "";
	data.filter(element => allStudentHtml += buildStudentHtml(element));
	originalStudentHtml = allStudentHtml;
	document.getElementById("students").innerHTML = allStudentHtml;
	console.log(originalStudentHtml);
});
document.getElementById("students").className = "row";

// Add a document search-btn listener to update search results
document.getElementById("search-btn").addEventListener("click", handleSearch);