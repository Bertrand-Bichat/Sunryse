import 'twilio-video';
'use strict';

const activeRoom = [];

/**
 * Mute/unmute your media in a Room.
 * @param {Room} room - The Room you have joined
 * @param {'audio'|'video'} kind - The type of media you want to mute/unmute
 * @param {'mute'|'unmute'} action - Whether you want to mute/unmute
 */
function muteOrUnmuteYourMedia(room, kind, action) {

  if (kind === 'video') {
    const publications = room.localParticipant.videoTracks;

    publications.forEach(function(publication) {
      if (action === 'mute') {
        publication.track.disable();

        // publication.track.stop();
        // publication.unpublish();

        // document.querySelector('#local-media > video').style.display = "none";

        // document.querySelectorAll('#local-media > video').forEach(video => {
        //   video.style.display = "none";
        // });
      } else {
        publication.track.enable();

        // document.querySelectorAll('#local-media > video').forEach(video => {
        //   video.style.display = "flex";
        // });

        // const { createLocalVideoTrack } = require('twilio-video');
        // createLocalVideoTrack({ video: true }).then(track => {
        //   //return room.localParticipant.publishTrack(localVideoTrack);
        //   const localMediaContainer = document.getElementById('local-media');
        //   localMediaContainer?.appendChild(track.attach());
        // });

        // document.querySelector('#local-media > video').style.display = "block";
      }
    });
  } else if (kind === 'audio') {
    const publications = room.localParticipant.audioTracks;

    publications.forEach(function(publication) {
      if (action === 'mute') {
        publication.track.disable();
      } else {
        publication.track.enable();
      }
    });
  }

  // const publications = kind === 'audio'
  //   ? room.localParticipant.audioTracks
  //   : room.localParticipant.videoTracks;

  // publications.forEach(function(publication) {
  //   if (action === 'mute') {
  //     publication.track.disable();
  //     console.log("local mute");
  //     if (kind === 'video') {
  //       document.querySelector('#local-media > video').style.display = "none";
  //     }
  //   } else {
  //     publication.track.enable();
  //     console.log("local unmute");
  //     if (kind === 'video') {
  //       document.querySelector('#local-media > video').style.display = "block";
  //     }
  //   }
  // });
}

/**
 * Mute your audio in a Room.
 * @param {Room} room - The Room you have joined
 * @returns {void}
 */
function muteYourAudio(room) {
  muteOrUnmuteYourMedia(room, 'audio', 'mute');
}

/**
 * Mute your video in a Room.
 * @param {Room} room - The Room you have joined
 * @returns {void}
 */
function muteYourVideo(room) {
  muteOrUnmuteYourMedia(room, 'video', 'mute');
}

/**
 * Unmute your audio in a Room.
 * @param {Room} room - The Room you have joined
 * @returns {void}
 */
function unmuteYourAudio(room) {
  muteOrUnmuteYourMedia(room, 'audio', 'unmute');
}

/**
 * Unmute your video in a Room.
 * @param {Room} room - The Room you have joined
 * @returns {void}
 */
function unmuteYourVideo(room) {
  muteOrUnmuteYourMedia(room, 'video', 'unmute');
}

/**
 * A RemoteParticipant muted or unmuted its media.
 * @param {Room} room - The Room you have joined
 * @param {function} onMutedMedia - Called when a RemoteParticipant muted its media
 * @param {function} onUnmutedMedia - Called when a RemoteParticipant unmuted its media
 * @returns {void}
 */
function participantMutedOrUnmutedMedia(room, onMutedMedia, onUnmutedMedia) {
  console.log("Smthg was mute or umute");
  room.on('trackSubscribed', function(track, publication, participant) {
    console.log(track);
    track.on('disabled', function() {
      console.log(`Remote user has mute his ${track.kind} himself`);
      return onMutedMedia(track, participant);
    });
    track.on('enabled', function() {
      console.log(`Remote user has unmute his ${track.kind} himself`);
      return onUnmutedMedia(track, participant);
    });
  });
}

const videoConnect = (token, roomName) => {
  const { connect, createLocalTracks } = require('twilio-video');

  // createLocalTracks({
  //   video: true,
  //   audio: true
  // }).then(localTracks => {
  //   const localMediaContainer = document.getElementById('local-media');
  //   localTracks.forEach(localTrack => {
  //     localMediaContainer?.appendChild(localTrack.attach());
  //   });
  // });

  const connectOptions = {
    name: roomName,
    video: true,
    audio: true
  };

  connect(token, connectOptions).then(room => {
    console.log(room);
    const localMediaContainer = document.getElementById('local-media');
    room.localParticipant.videoTracks.forEach(publication => {
      localMediaContainer?.appendChild(publication.track.attach());
    });

    console.log(`Successfully joined a Room: ${room}`);
    room.on('participantConnected', participant => {
      console.log(`A remote Participant connected: ${participant}`);
    });
    const localParticipant = room.localParticipant;
    console.log(`Connected to the Room as LocalParticipant "${localParticipant.identity}"`);

    // Log any Participants already connected to the Room
    room.participants.forEach(participant => {
      console.log(`Participant "${participant.identity}" is connected to the Room`);
      console.log(participant);
      document.querySelector("#message").style.display = "none";
      document.getElementById('remote-media').innerHTML = "";
      participant.tracks.forEach(publication => {
        if (publication.isSubscribed) {
          const track = publication.track;
          document.getElementById('remote-media').appendChild(track.attach());
          console.log("1");
        }
      });
      participant.on('trackSubscribed', track => {
        document.getElementById('remote-media').appendChild(track.attach());
        console.log("2");
      });
    });

    // Log new Participants as they connect to the Room
    room.once('participantConnected', participant => {
      console.log(`Participant "${participant.identity}" has connected to the Room`);
      document.getElementById('remote-media').innerHTML = "";
      participant.tracks.forEach(publication => {
        if (publication.isSubscribed) {
          const track = publication.track;
          document.getElementById('remote-media').appendChild(track.attach());
          console.log("3");
        }
      });
    });

    // Log Participants as they disconnect from the Room
    room.once('participantDisconnected', participant => {
      console.log(`Participant "${participant.identity}" has disconnected from the Room`);
      document.getElementById('remote-media').innerHTML = "";
    });

    room.on('participantConnected', participant => {
      console.log(`Participant "${participant.identity}" connected`);
      document.querySelector("#message").style.display = "none";

      document.getElementById('remote-media').innerHTML = "";
      participant.tracks.forEach(publication => {
        if (publication.isSubscribed) {
          const track = publication.track;
          document.getElementById('remote-media').appendChild(track.attach());
          console.log("4");
        }
      });

      participant.on('trackSubscribed', track => {
        document.getElementById('remote-media').appendChild(track.attach());
        console.log("5");
      });
    });

    room.on('participantDisconnected', participant => {
      console.log(`Remote participant disconnected: ${participant.identity}`);
      // document.querySelector("#message").style.display = "flex";
      document.getElementById('remote-media').innerHTML = "";
    });

    // get mute / unmute from remote
    room.on('trackSubscribed', (track => {
      console.log(track);
      if (track.isEnabled) {
        if (track.kind === 'audio') {
          document.getElementById('remote-media').appendChild(track.attach());
        } else {
          document.getElementById('remote-media').appendChild(track.attach());
        }
      }

      participantMutedOrUnmutedMedia(room, track => {
        console.log(`Mute ${track.kind}`);
        track.detach().forEach(element => {
          element.remove();
        });
      }, track => {
          console.log(`Unmute ${track.kind}`);
          if (track.kind === 'audio') {
            document.getElementById('remote-media').appendChild(track.attach());
          }
          if (track.kind === 'video') {
            document.getElementById('remote-media').appendChild(track.attach());
          }
        });
    }));

    activeRoom.push(room);
  }, error => {
    console.error(`Unable to connect to Room: ${error.message}`);
  });
  // console.log(activeRoom);
  return activeRoom;
};


const videoDisconnect = (room) => {

  room.on('disconnected', room => {
    // Detach the local media elements
    room.localParticipant.tracks.forEach(publication => {
      const attachedElements = publication.track.detach();
      attachedElements.forEach(element => element.remove());
    });
  });

  // To disconnect from a Room
  // room.disconnect();
}

const webcamPreview = () => {
  const { createLocalTracks } = require('twilio-video');

  createLocalTracks({
    video: true,
    audio: true
  }).then(localTracks => {
    const localMediaContainer = document.getElementById('local-media');
    localTracks.forEach(localTrack => {
      localMediaContainer?.appendChild(localTrack.attach());
    });
    // const previewWidth = localMediaContainer.offsetWidth;
    // localMediaContainer.querySelector("video").style.width = "100%";

  });
};

const setUpLocalMedia = (token, roomName) => {
  const { connect } = require('twilio-video');

  connect(token, {
    audio: true,
    name: roomName,
    video: { width: 150 }
  }).then(room => {
    console.log(`Connected to Room: ${room.name}`);
  });
};

const RemoteParticipant = (room) => {
  // Log your Client's LocalParticipant in the Room
};

const detectBrowser = () => {

  let isOpera = (navigator.userAgent.indexOf("Opera") != -1) ||
                (navigator.userAgent.indexOf("OPR") != -1);

  let isSafari = (navigator.userAgent.indexOf("Safari") != -1) &&
                 (navigator.userAgent.indexOf("CriOS") === -1) &&
                 (navigator.userAgent.indexOf("Chrome") === -1) &&
                 (navigator.userAgent.indexOf("Chromium") === -1);

  let isIE = (navigator.userAgent.indexOf("MSIE") != -1 ) ||
             (navigator.userAgent.indexOf("Trident") != -1 ) ||
             (navigator.userAgent.indexOf("Microsoft Internet Explorer") != -1 );

  let isEdge = (navigator.userAgent.indexOf("Edg") != -1 );

  let isChromium = (navigator.userAgent.indexOf("Chromium") != -1 );

  let isFirefox = (navigator.userAgent.indexOf("Firefox") != -1) &&
                  (navigator.userAgent.indexOf("Seamonkey") === -1);

  let isChrome = (((navigator.userAgent.indexOf("Chrome") != -1) &&
                 (navigator.userAgent.indexOf("Chromium") === -1)) ||
                 (navigator.userAgent.indexOf("CriOS") != -1)) &&
                  !isOpera && !isEdge;

  let output;
  if (isOpera) {
    output = "opera";
  } else if (isFirefox) {
    output = "firefox";
  } else if (isEdge) {
    output = "edge";
  } else if (isIE) {
    output = "IE";
  } else if (isChromium) {
    output = "chromium";
  } else if (isSafari) {
    output = "safari";
  } else if (isChrome) {
    output = "chrome";
  } else {
    output = null;
  }

  // let output = 'Detecting browsers by ducktyping:<hr>';
  // output += 'isFirefox: ' + isFirefox + '<br>';
  // output += 'isChrome: ' + isChrome + '<br>';
  // output += 'isSafari: ' + isSafari + '<br>';
  // output += 'isOpera: ' + isOpera + '<br>';
  // output += 'isIE: ' + isIE + '<br>';
  // output += 'isEdge: ' + isEdge + '<br>';
  // output += 'isChromium: ' + isChromium + '<br>';

  return output;
};

const detectOS = () => {

  let isIOS = (navigator.userAgent.indexOf("iPhone") != -1) ||
              (navigator.userAgent.indexOf("iPad") != -1) ||
              (navigator.userAgent.indexOf("Macintosh") != -1);

  let output;

  if (isIOS) {
    output = "IOS";
  } else {
    output = null;
  }

  return output;
};

// detecte mobile IOS (iphone surtout)
const detectIos = () => {
    const toMatch = [
        /iPhone/i,
        /iPod/i
    ];
    return toMatch.some((toMatchItem) => {
        return navigator.userAgent.match(toMatchItem);
    });
};

// detecte tablette IOS (ipad) : ne marche pas, car macintosh dans navigator.userAgent au lieu de iPad
const detectIpad = () => {
    const toMatch = [
        /iPad/i
    ];
    return toMatch.some((toMatchItem) => {
        return navigator.userAgent.match(toMatchItem);
    });
};

// sleep time expects milliseconds
const sleep = (time) => {
  return new Promise((resolve) => setTimeout(resolve, time));
}

const updateVideoContainerRatio = (idClassOrTag, width, height) => {
  const element = document.querySelector(idClassOrTag);
  const widthElement = element.offsetWidth;
  // console.log(width);
  element.style.height = (widthElement / width * height) + 'px';
};

const swithcVideoContainerRatio = (idClassOrTag, width, height) => {
  const element = document.querySelector(idClassOrTag);
  element.style.height = (width) + 'px';
  element.style.width = (height) + 'px';
};


const toggleHideShowElement = (idClassOrTag, visibleDisplayType = "block") => {
  const element = document.querySelector(idClassOrTag);
  if (element.style.display === "none") {
    element.style.display = visibleDisplayType;
  } else {
    element.style.display = "none";
  }
}

// fonction pour détecter les mobiles (tablettes & desktop exclus)
const isMobileDevise = () => {
  let check = false;
  // alert(navigator.userAgent);
  // alert(detectBrowser());
  (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
  return check;
};

export { webcamPreview, videoConnect, videoDisconnect, setUpLocalMedia, RemoteParticipant, updateVideoContainerRatio, sleep, toggleHideShowElement, muteOrUnmuteYourMedia, muteYourAudio, unmuteYourAudio, muteYourVideo, unmuteYourVideo, participantMutedOrUnmutedMedia, isMobileDevise, detectIos, detectIpad, detectOS, detectBrowser, swithcVideoContainerRatio };
