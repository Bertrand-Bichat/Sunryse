// permet de récupérer la différence en secondes entre 2 dates
function diff_secondes(dt2, dt1) {
  let diff =(dt2.getTime() - dt1.getTime()) / 1000;
  return Math.round(diff);
}

// permet d'afficher le timer dans le front
function countDown(time) {
  const timerDiplay = document.querySelector('#ninja-timer');
  const timerValue = timerDiplay.querySelector('#timer-value');

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

// permet de sauvegarder dans le localStorage JS le endTime du mode invisible
const setTimer = () => {
  const button = document.querySelector('#ninja-button');
  const input = document.querySelector('#ninja-time-input');

  if (button && input) {
    button.addEventListener('click', () => {
      let inputValue = input.value;
      let date = new Date();
      let time = new Date(date.getTime() + inputValue*60000); // transform minutes to milliseconds
      window.localStorage.setItem('ninjaTimer', time);
    });
  }
}

// permet d'afficher le temps restant du mode invisible
const displayTimer = () => {
  let timer = window.localStorage.getItem('ninjaTimer');
  if (timer) {
    let endDate = new Date(timer);
    let startDate = new Date();
    let diff = diff_secondes(endDate, startDate);

    if (diff > 0) {
      countDown(diff);
    } else {
      window.localStorage.removeItem('ninjaTimer');
    }
  }
}


export { setTimer, displayTimer };
