function addCourseVideo(newObject) {
    let arrayString = localStorage.getItem('CURSO');
    let array = arrayString ? JSON.parse(arrayString) : [];
    array.push(newObject);
    localStorage.setItem('CURSO', JSON.stringify(array));
}

let title = document.getElementsByClassName('course-player__content-header__title')[0].innerText;
let url = document.querySelector('[id^="iframe-ember"]').src
addCourseVideo({title, url});