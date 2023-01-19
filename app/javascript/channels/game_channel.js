// import Chess from 'chess.js';
// import Chessboard from 'chess.js';
// import $ from 'jquery';
// import consumer from "./consumer";

// const initChessBoard = () => {

//   function onDragStart (source, piece, position, orientation) {
//     return !(App.chess.game_over() ||
//              (App.chess.turn() == "w" && piece.search(/^b/) != -1) ||
//              (App.chess.turn() == "b" && piece.search(/^w/) != -1) ||
//              (orientation == "white" && piece.search(/^b/) != -1) ||
//              (orientation == "black" && piece.search(/^w/) != -1))
//   }

//   function onDrop (source, target) {
//     move = App.chess.move
//       from: source
//       to: target
//       promotion: "q"

//     if (move == null)
//       return "snapback"
//     else
//       App.game.perform("make_move", move)
//       App.board.position(App.chess.fen(), false)
//   }

//   App.chess = new Chess()

//   let config = {
//     draggable: true,
//     pieceTheme: "assets/chesspieces/alpha/{piece}.png",
//     showNotation: false,
//     onDragStart: onDragStart,
//     onDrop: onDrop
//   }

//   App.board = Chessboard("#chessboard", config)
// }

// const initGameCable = () => {
//   const gamesContainer = document.getElementById('games');

//   if (gamesContainer) {
//     const messagesContainer = document.getElementById('messages');
//     const id = gamesContainer.dataset.gameId;

//     App.cable.subscriptions.create({ channel: "GameChannel", id: id }, {
//       connected() {
//         printMessage("En attente de l'adversaire...")
//       },

//       received(data) {
//         switch (data.action) {
//           case "game_start":
//             App.board.position("start")
//             App.board.orientation(data.msg)
//             printMessage(`Le jeu a commencé ! Vous jouez les pions ${data.msg}.`)
//           case "make_move":
//             [source, target] = data.msg.split("-")
//             App.chess.move
//               from: source
//               to: target
//               promotion: "q"
//             App.board.position(App.chess.fen())
//           case "opponent_forfeits":
//             printMessage("L'adversaire a perdu. Vous avez gagnez !")
//         }
//       },

//       printMessage(message) {
//         messagesContainer.innerHTML = ''
//         messagesContainer.append(`<p>${message}</p>`)
//       },

//     });
//   }
// }

// export { initGameCable, initChessBoard };
