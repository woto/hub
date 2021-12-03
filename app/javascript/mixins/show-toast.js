export const useShowToast = controller => {
    Object.assign(controller, {
        showToast(object) {
            let ev = new CustomEvent("showToast", {detail: {title: object.title, body: object.body }});
            window.dispatchEvent(ev);
        }
    });
};