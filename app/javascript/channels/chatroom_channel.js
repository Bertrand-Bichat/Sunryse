import consumer from "./consumer";

const initChatroomCable = () => {
  const messagesContainer = document.getElementById('posts');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId;

    App.cable.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        messagesContainer.insertAdjacentHTML('beforeend', data);
        messagesContainer.lastElementChild.scrollIntoView();
      },
    });
  }
}

export { initChatroomCable };
