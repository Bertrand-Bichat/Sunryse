function setEventListener(button, spinner) {
  button.addEventListener('click', (event) => {
    event.currentTarget.classList.add('hidden');
    spinner.classList.remove('hidden');
  });
};


const toggleSpinner = () => {

  // stories form (navbar)
  const storiesButton = document.getElementById('stories-btn');
  const storiesSpinner = document.getElementById('stories-spinner');
  if (storiesButton && storiesSpinner) {
    setEventListener(storiesButton, storiesSpinner);
  }

  // profil page
  if (window.location.pathname.includes('profil')) {
    // photos form
    const photosButton = document.getElementById('photos-btn');
    const photosSpinner = document.getElementById('photos-spinner');
    if (photosButton && photosSpinner) {
      setEventListener(photosButton, photosSpinner);
    }

    // avatar form
    const avatarButton = document.getElementById('avatar-btn');
    const avatarSpinner = document.getElementById('avatar-spinner');
    if (avatarButton && avatarSpinner) {
      setEventListener(avatarButton, avatarSpinner);
    }
  }
};

export default toggleSpinner;
