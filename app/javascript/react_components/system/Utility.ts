const openEditEntity = (entityId: number) => {
  chrome.runtime.sendMessage(
    process.env.CHROME_EXTENSION_ID,
    {
      message: 'edit-entity',
      entityId,
    },
    (response) => {
      if (!response || !response.success) {
        throw new Error('An error occurred while sending a message to the extension.');
      }
    },
  );

  return null;
};

export default openEditEntity;

// // NOTE: test (seems Firefox supports only this way)
// const messageContentScript = () => {
//   console.log('b');
//   window.postMessage({
//     direction: "from-page-script",
//     message: "Message from the page"
//   }, "*");
// }
