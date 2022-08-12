import * as React from "react"

export default function EntitiesEditLink(props: { entityId: number }) {

  // NOTE: test
  const messageContentScript = () => {
    console.log('b');
    window.postMessage({
      direction: "from-page-script",
      message: "Message from the page"
    }, "*");
  }


  const openWindow = (entityId: number) => {
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
  }

  return (
    <>
      <a
        className="tw-cursor-pointer"
        onClick={() => openWindow(props.entityId)}
      >Редактировать</a>

      <a
        className="tw-cursor-pointer"
        onClick={() => messageContentScript()}
      >Редактировать 2</a>
    </>
  )
}