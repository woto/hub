export const useShowToast = (controller) => {
  Object.assign(controller, {
    showToast(object) {
      const ev = new CustomEvent('showToast', { detail: { title: object.title, body: object.body } });
      window.dispatchEvent(ev);
    },
  });
};
