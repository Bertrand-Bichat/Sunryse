require("channels")

// External imports
import 'bootstrap';

// Internal imports
import { topArrow, scrollFunction, topFunction } from '../components/top_arrow';
import toggleSpinner from '../components/spinner_form';
import { setTimer, displayTimer } from '../components/ninja_timer';
import '../components/stripe';
import activeBasketButton from '../components/basket';
import { twilioVideoApplication } from '../components/twilio_video_application'
import { initChatroomCable } from '../channels/chatroom_channel'
import { setCameraTimer, displayCameraTimer } from '../components/camera_timer';
import { initMapboxPosition } from '../components/init_mapbox_position.js';
import { geolocateUser, getUserPosition } from "../components/geolocation.js.erb"
import { initAutocomplete } from '../components/init_autocomplete';
// import { initChessGame, updateStatus, onSnapEnd, onDrop, onDragStart } from '../components/chess_game';
// import { initGameCable, initChessBoard } from '../channels/game_channel'

document.addEventListener('turbolinks:load', () => {

  /// flèche pour scroll jusqu'en haut (toutes les pages)
  topArrow();


  if (window.location.pathname !== '/') {
    // icone de téléchargement pour les photos, stories & avatar
    toggleSpinner();

    // timer pour le mode invisible (= ninja mode)
    setTimer();

    // tchat text
    initChatroomCable();

    // timer pour le mode invisible (= ninja mode)
    if (window.localStorage.getItem('ninjaTimer')) {
      displayTimer();
    }

    // toggle hidden class when user accet CGV
    if (window.location.pathname.includes('ma-commande-en-cours')) {
      activeBasketButton();
    }

    // launch Twilio JS visio-tchat
    if (window.location.pathname.includes('chatrooms/')) {
      twilioVideoApplication();
      setCameraTimer();

      if (window.localStorage.getItem('cameraTimer')) {
        displayCameraTimer();
      }
    }

    const keywords = ['/users', '/contact', '/conditions-generales-de-vente', '/404', '/422', '/500'];
    // set current_position for current_user every x milliseconds
    if (!keywords.some(el => window.location.pathname.includes(el))) {
      geolocateUser();
    }

    // Mapbox for current position
    if (window.location.pathname.includes('profils-a-cote-de-ma-position-actuelle')) {
      initMapboxPosition();
    }

    if (window.location.pathname.includes('/users')) {
      initAutocomplete();
    }
  }

  // chess game
  // if (window.location.pathname.includes('mini-jeux')) {
  //   initChessGame();
  // }

  // chess game bis
  // if (window.location.pathname.includes('/jeux')) {
  //  initChessBoard();
  //  initGameCable();
  // }

});


