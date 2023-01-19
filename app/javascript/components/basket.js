// pour toggle la classe 'disabled' du bouton 'Acheter' si le client valide les CGV
const activeBasketButton = () => {

  const fake = document.getElementById('order-fake-button');
  const button = document.getElementById('order-button');
  const cgv = document.getElementById('cgv');

  cgv.addEventListener ('click', () => {
    if (cgv.checked === true) {
      button.classList.remove("hidden");
      fake.classList.add("hidden");
    } else if (cgv.checked === false) {
      button.classList.add("hidden");
      fake.classList.remove("hidden");
    }
  });
}

export default activeBasketButton;
