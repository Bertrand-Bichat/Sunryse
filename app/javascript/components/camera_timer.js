// permet de récupérer la différence en secondes entre 2 dates
function diff_secondes(dt2, dt1) {
  let diff =(dt2.getTime() - dt1.getTime()) / 1000;
  return Math.round(diff);
}

// permet d'afficher le timer dans le front
function countDownCamera(time) {
  const timerDiplay = document.querySelector('#camera-timer');
  const timerValue = timerDiplay.querySelector('#camera-timer-value');

  let minutes = Math.floor(time/60);
  let secondes = time % 60;

  if (timerDiplay && timerValue) {
    setInterval(function() {
      timerValue.innerHTML = `${minutes}m${secondes}s`;
      if ((secondes > 0) && (minutes >= 0)) {
        secondes--;
      } else if (minutes > 0)  {
        secondes = 59;
        minutes--;
      } else {
        minutes = 0;
        secondes = 0;
      }
    }, 1000);
  }
}

// permet d'afficher le temps restant du visio-tchat en cours
const displayCameraTimer = () => {
  let timer = window.localStorage.getItem('cameraTimer');
  if (timer) {
    let endDate = new Date(timer);
    let startDate = new Date();
    let diff = diff_secondes(endDate, startDate);

    if (diff > 0) {
      countDownCamera(diff);
    } else {
      window.localStorage.removeItem('cameraTimer');
    }
  }
}

// permet de sauvegarder dans le localStorage JS le endTime du visio-tchat en cours
const setCameraTimer = () => {
  const button = document.querySelector("#btn-start-twilio-video");
  let timer = window.localStorage.getItem('cameraTimer');

  button?.addEventListener('click', () => {
    if (timer) {

    } else {
      let inputValue = 30; // 30 minutes par crédit
      let date = new Date();
      let time = new Date(date.getTime() + inputValue*60000); // transform minutes to milliseconds
      window.localStorage.setItem('cameraTimer', time);
    }
    displayCameraTimer();
  });
}


export { setCameraTimer, displayCameraTimer };
