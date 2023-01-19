import { webcamPreview, videoConnect, videoDisconnect, setUpLocalMedia, RemoteParticipant, updateVideoContainerRatio, toggleHideShowElement, sleep, muteOrUnmuteYourMedia, muteYourAudio, unmuteYourAudio, muteYourVideo, unmuteYourVideo, participantMutedOrUnmutedMedia, isMobileDevise, detectIos, detectIpad, detectOS, detectBrowser, swithcVideoContainerRatio } from "./twilio_video_helpers";

let screenHeight = window.screen.height;
let screenWidth = window.screen.width;
let lastAngle = 1;
let started = false

const toggleFullscreen = (idClassOrTag) => {
  const elem = document.querySelector(idClassOrTag);
  const sidebar = document.querySelector('#sidebar-block');
  const navbar = document.querySelector('.sticky-navbar');
  const video = document.querySelector('#visio-bloc');
  if (detectIos()) {
    // alert("Ios");
    sidebar.classList.add('d-none');
    navbar.classList.add('d-none');
    // video.classList.add('video-full-screen');
  } else {
    if (!document.fullscreenElement) {
      elem.requestFullscreen().catch(err => {
        alert(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`);
      });
    } else {
      document.exitFullscreen();
    }
  }
};

// const toggleFullscreen = (idClassOrTag) => {
//     const elem = document.querySelector(idClassOrTag);
//       if (!document.fullscreenElement) {
//         elem.requestFullscreen().catch(err => {
//           alert(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`);
//         });
//       } else {
//         document.exitFullscreen();
//       }
// };

const actionsOnToggleFullScreen = () => {
  sleep(1200).then(() => {
    console.log(screenWidth, screenHeight);
    updateVideoContainerRatio("#local-media", screenWidth, screenHeight);
    updateVideoContainerRatio("#remote-media", screenWidth, screenHeight);
    updateVideoContainerRatio("#visio-bloc", screenWidth, screenHeight);
    // UI changes (toggle btn)
    document.querySelectorAll("#btn-video-fullscreen > i").forEach( (icon) => {
      icon.classList.toggle("current");
      icon.classList.toggle("action");
    });
  });
}

const exitHandler = () => {
  if (
      document.webkitIsFullScreen === false
      || document.mozFullScreen === false
      || document.msFullscreenElement === false
  ) {
      // alert("exit fullscreen");
      actionsOnToggleFullScreen();
      if (isMobileDevise()) {
        document.querySelector("#visio-bloc").style.display = "none";
      }
  }
}

const initializeTwilioVideoApplication = () => {
  // if (screen.orientation.angle % 180 === 90) [screenWidth, screenHeight] = [screenHeight, screenWidth];
  let room;
  started = true

  // Display local video => Ask video autorization from browser
  document.querySelector("#btn-video-preview")?.addEventListener("click", event => {
    // webcamPreview();
    document.querySelector("#btn-video-preview").style.display = "none";
    document.querySelector("#btn-video-mute").style.display = "flex";
    document.querySelector("#btn-video-stop").style.display = "flex";
    document.querySelector("#btn-video-mute").classList.add("btn-bg-green");
    document.querySelector("#btn-video-stop").classList.add("btn-bg-green");

    // Those two values come from back side of the app
    const token = document.querySelector(".data-visio").dataset.token;
    const roomName = document.querySelector(".data-visio").dataset.roomName;
    // Connect to the room
    // I set 'room' variable so I can use it later
    room = videoConnect(token, roomName);
    document.querySelector("#remote-media").style.display = "none";

    sleep(2500).then(() => {
      document.querySelector("#btn-video-connect").style.display = "flex";
    });
  });

  // Join to the conversation
  document.querySelector("#btn-video-connect")?.addEventListener("click", event => {

    // UI changes
    document.querySelector("#btn-video-disconnect").style.display = "flex";
    document.querySelector("#btn-video-connect").style.display = "none";
    document.querySelector("#remote-media").style.display = "flex";

    // pour les devises non-mobile
    if (!isMobileDevise()) {
      document.querySelector("#btn-video-fullscreen").style.display = "flex";
      document.querySelector("#btn-video-mobile-devise").style.display = "none";
    }

    // manage the text 'waiting for connection of the other person'
    if (room[room.length - 1].participants.size === 0) {
      document.querySelector("#message").style.display = "flex";
    } else if (room[room.length - 1].participants.size === 1) {
      document.querySelector("#message").style.display = "none";
    }

    // Unmute audio if it is mute
    let audioMute = !document.querySelector("#btn-video-mute")?.classList.contains('muted');
    if(!audioMute) {
      unmuteYourAudio(room[room.length - 1]);
      document.querySelector("#btn-video-mute")?.classList.remove('muted');
      // UI changes => Update btn icons
      document.querySelectorAll("#btn-video-mute > i")?.forEach( (icon) => {
        icon.classList.toggle("current");
        icon.classList.toggle("action");
      });
      document.querySelector("#btn-video-mute").classList.toggle("btn-bg-green");
      document.querySelector("#btn-video-mute").classList.toggle("btn-bg-red");
    }

    // Unmute video if it is mute
    let videoMute = !document.querySelector("#btn-video-stop")?.classList.contains('muted');
    if(!videoMute) {
      unmuteYourVideo(room[room.length - 1]);
      document.querySelector("#btn-video-stop")?.classList.remove('muted');
      // UI changes => Update btn icons
      document.querySelectorAll("#btn-video-stop > i")?.forEach( (icon) => {
        icon.classList.toggle("current");
        icon.classList.toggle("action");
      });
      document.querySelector("#btn-video-stop").classList.toggle("btn-bg-green");
      document.querySelector("#btn-video-stop").classList.toggle("btn-bg-red");
    }

    // // Those two values come from back side of the app
    // const token = document.querySelector(".data-visio").dataset.token;
    // const roomName = document.querySelector(".data-visio").dataset.roomName;
    // // I set 'room' variable so I can use it later
    // room = videoConnect(token, roomName);


    // setUpLocalMedia(token, roomName);
  });

  // Disconnect from the room
  document.querySelector("#btn-video-disconnect")?.addEventListener("click", event => {
    videoDisconnect(room[room.length - 1]);

    // pour les devises non-mobile
    if (!isMobileDevise()) {
      // cache le bouton fullscreen
      document.querySelector("#btn-video-fullscreen").style.display = "none";
      document.querySelector("#btn-video-mobile-devise").style.display = "flex";

      // si on est en fullscreen, on enlève le fullscreen
      if (document.fullscreenElement) {
        toggleFullscreen('#visio-bloc');
        actionsOnToggleFullScreen();
      }
    }

    // UI changes & mute audio and video
    sleep(1500).then(() => {
      // UI
      document.querySelector("#btn-video-connect").style.display = "flex";
      document.querySelector("#btn-video-disconnect").style.display = "none";
      document.querySelector("#message").style.display = "none";
      document.querySelector("#remote-media").style.display = "none";

      // mute audio if it is unmute
      let audioMute = !document.querySelector("#btn-video-mute")?.classList.contains('muted');
      if(audioMute) {
        muteYourAudio(room[room.length - 1]);
        document.querySelector("#btn-video-mute")?.classList.add('muted');
        document.querySelectorAll("#btn-video-mute > i")?.forEach( (icon) => {
          icon.classList.toggle("current");
          icon.classList.toggle("action");
        });
        document.querySelector("#btn-video-mute").classList.toggle("btn-bg-green");
        document.querySelector("#btn-video-mute").classList.toggle("btn-bg-red");
      }

      // mute video if it is unmute
      let videoMute = !document.querySelector("#btn-video-stop")?.classList.contains('muted');
      if(videoMute) {
        muteYourVideo(room[room.length - 1]);
        document.querySelector("#btn-video-stop")?.classList.add('muted');
        document.querySelectorAll("#btn-video-stop > i")?.forEach( (icon) => {
          icon.classList.toggle("current");
          icon.classList.toggle("action");
        });
        document.querySelector("#btn-video-stop").classList.toggle("btn-bg-green");
        document.querySelector("#btn-video-stop").classList.toggle("btn-bg-red");
      }
    });
    // toggleHideShowElement("#btn-video-disconnect");
    // toggleHideShowElement("#btn-video-connect", "flex");
    // toggleHideShowElement("#message");
    // toggleHideShowElement("#btn-video-mute");
    // toggleHideShowElement("#btn-video-stop");
  });

  // Toggle Fullscreen on #visio-bloc and update containers ratio (16/9 for computer and 9/16 for mobile
  document.querySelector("#btn-video-fullscreen")?.addEventListener("click", event => {
    toggleFullscreen('#visio-bloc');
    actionsOnToggleFullScreen();
  });

  // Gestion de la sortie du fullscreen via ts autres moyens que le bouton #btn-video-fullscreen
  const visioBloc = document.querySelector("#visio-bloc");
  visioBloc.addEventListener('fullscreenchange', exitHandler);
  visioBloc.addEventListener('webkitfullscreenchange', exitHandler);
  visioBloc.addEventListener('mozfullscreenchange', exitHandler);
  visioBloc.addEventListener('MSFullscreenChange', exitHandler);

  // UI changes on orientationchange for mobile
  // window.addEventListener("orientationchange", () => {
  //   if (lastAngle != screen.orientation.angle % 180) {
  //     lastAngle = screen.orientation.angle % 180;
  //     [screenWidth, screenHeight] = [screenHeight, screenWidth];
  //     console.log("the orientation of the device is now " + screen.orientation.angle);
  //     sleep(1200).then(() => {
  //       updateVideoContainerRatio("#local-media",screenWidth, screenHeight);
  //       updateVideoContainerRatio("#remote-media",screenWidth, screenHeight);
  //       updateVideoContainerRatio("#visio-bloc", screenWidth, screenHeight);
  //     });

  //     // if (isMobileDevise()) {
  //     //   if (screen.orientation.angle % 180 === 90) {
  //     //     document.querySelector("#mobile-orientation-alert").style.display = "none";
  //     //   } else {
  //     //     document.querySelector("#mobile-orientation-alert").style.display = "flex";
  //     //   }
  //     // }
  //   }
  // });

  // Mute / unmute audio
  document.querySelector("#btn-video-mute")?.addEventListener("click", event => {
    let audioMute = !document.querySelector("#btn-video-mute")?.classList.contains('muted');

    // Mute / unmute audio localy
    if(audioMute) {
      muteYourAudio(room[room.length - 1]);
      document.querySelector("#btn-video-mute")?.classList.add('muted');
    } else {
      unmuteYourAudio(room[room.length - 1]);
      document.querySelector("#btn-video-mute")?.classList.remove('muted');
    }
    // UI changes => Update btn icons
    document.querySelectorAll("#btn-video-mute > i")?.forEach( (icon) => {
      icon.classList.toggle("current");
      icon.classList.toggle("action");
    });

    document.querySelector("#btn-video-mute").classList.toggle("btn-bg-green");
    document.querySelector("#btn-video-mute").classList.toggle("btn-bg-red");
  });

  // Mute / unmute video
  document.querySelector("#btn-video-stop")?.addEventListener("click", event => {
    let videoMute = !document.querySelector("#btn-video-stop")?.classList.contains('muted');

    // Stop / unmute video localy
    if(videoMute) {
      muteYourVideo(room[room.length - 1]);
      document.querySelector("#btn-video-stop")?.classList.add('muted');
    } else {
      unmuteYourVideo(room[room.length - 1]);
      document.querySelector("#btn-video-stop")?.classList.remove('muted');
    }
    // UI changes => Update btn icons
    document.querySelectorAll("#btn-video-stop > i")?.forEach( (icon) => {
      icon.classList.toggle("current");
      icon.classList.toggle("action");
    });

    document.querySelector("#btn-video-stop").classList.toggle("btn-bg-green");
    document.querySelector("#btn-video-stop").classList.toggle("btn-bg-red");
  });

  // UI initializing
  // if (screen.orientation.angle % 180 === 90) [screenWidth, screenHeight] = [screenHeight, screenWidth];
  updateVideoContainerRatio("#local-media",screenWidth, screenHeight);
  updateVideoContainerRatio("#remote-media",screenWidth, screenHeight);
  updateVideoContainerRatio("#visio-bloc", screenWidth, screenHeight);
  document.querySelector("#btn-video-disconnect").style.display = "none";

}

const twilioVideoApplication = () => {
  let browser = detectBrowser();

  // pour les desktop & tablettes
  if (!isMobileDevise()) {
    if ((browser === "firefox") || (browser === "chrome")) {
      document.querySelector("#browser-incorrect").style.display = "none";
    } else {
      document.querySelector("#browser-correct").style.display = "none";
    }
  // pour les mobiles
  } else if (isMobileDevise()) {
    if ((browser === "firefox") || (browser === "chrome") || (browser === "safari")) {
      document.querySelector("#browser-incorrect").style.display = "none";
    } else {
      document.querySelector("#browser-correct").style.display = "none";
    }
  }

  // btn UI adapted for mobil device
  if (isMobileDevise()) {
    document.querySelector("#btn-video-preview").classList.add('mobil-style-btn');
    document.querySelector("#btn-video-connect").classList.add('mobil-style-btn');
  } else {
    document.querySelector(".portrait-message").style.display = "none";
  }

  // on cache tout
  // document.querySelector("#mobile-orientation-alert").style.display = "none";
  document.querySelector("#message").style.display = "none";
  document.querySelector("#btn-video-preview").style.display = "none";
  document.querySelector("#btn-video-connect").style.display = "none";
  document.querySelector("#btn-video-disconnect").style.display = "none";
  document.querySelector("#btn-video-mute").style.display = "none";
  document.querySelector("#btn-video-stop").style.display = "none";
  document.querySelector("#btn-video-mobile-devise").style.display = "none";
  document.querySelector("#btn-video-fullscreen").style.display = "none";

  // clique sur 'accéder à la visio'
  document.querySelector("#btn-start-twilio-video")?.addEventListener("click", event => {
    document.querySelector("#credits-form").style.display = "none";
    document.querySelector("#credits-balance").style.display = "none";
    document.querySelector("#visio-bloc").style.display = "flex";
    document.querySelector("#btn-start-twilio-video").style.display = "none";
    document.querySelector("#btn-video-mobile-devise").style.display = "flex";

    // si le user est sur un smartphone
    if (isMobileDevise()) {
      // on force le full screen
      toggleFullscreen('#visio-bloc');
      actionsOnToggleFullScreen();
      sleep(1700).then(() => {
        document.querySelector("#btn-video-preview").style.display = "flex";
      });
    } else {
      sleep(100).then(() => {
        document.querySelector("#btn-video-preview").style.display = "flex";
      });
    }

    // on force le scroll de la page jusqu'à avoir la vidéo au centre de l'écran
    document.querySelector("#visio-bloc").scrollIntoView();


    if (!started) {
      initializeTwilioVideoApplication();
    }
  });

  // if (isMobileDevise()) {
  //   document.querySelector("#btn-start-twilio-video")?.addEventListener("click", event => {
  //     console.log("start twilio");
  //     document.querySelector("#visio-bloc").style.display = "flex";
  //     if (!started) initializeTwilioVideoApplication();
  //     toggleFullscreen('#visio-bloc');
  //     actionsOnToggleFullScreen();
  //     if (screen.orientation.angle % 180 === 90) {
  //       document.querySelector("#mobile-orientation-alert").style.display = "none";
  //     }
  //   });

  // } else {
  //   // on larger devise : tablet / computer
  //   document.querySelector("#btn-start-twilio-video").style.display = "none";
  //   document.querySelector("#mobile-orientation-alert").style.display = "none";
  //   document.querySelector("#visio-bloc").style.display = "flex";
  //   initializeTwilioVideoApplication();
  // }

}

export { twilioVideoApplication };
