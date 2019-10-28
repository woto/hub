function withPopup(Component) {
  Component.prototype.popupWindow = function (url, title, w, h) {
    const popup = window.open(`https://nv6.ru/users/auth/${url}`, title,
      `width=${w}, height=${h}, modal=no, resizable=no, toolbar=no, menubar=no,` +
      `scrollbars=no, alwaysRaise=yes`);

    const authHandler = (event) => {
      if (event.data === 'Oauth authenticated') {
        popup.close();
        const { context } = this;
        const accessToken = context.readAccessToken();
        context.setAxiosAuthorizationHeader(accessToken);
        window.removeEventListener('message', authHandler);
        this.redirectToDashboard();
      }
    };

    window.addEventListener('message', authHandler);
  };

  return Component;
}

export default withPopup;
