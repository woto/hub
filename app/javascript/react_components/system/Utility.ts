export const openEditEntity = (entityId: number) => {
  // The ID of the extension we want to talk to.
  var editorExtensionId = "aofgjcicjlegjpjjalajdbmhdcjjlkgd";

  // Make a simple request:
  chrome.runtime.sendMessage(
    editorExtensionId,
    {
      message: 'edit-entity',
      entityId: entityId
    },
    function (response) {
      if (!response.success) alert('error oops');
    }
  );

  return null;
}

// // NOTE: test (seems Firefox supports only this way)
// const messageContentScript = () => {
//   console.log('b');
//   window.postMessage({
//     direction: "from-page-script",
//     message: "Message from the page"
//   }, "*");
// }
