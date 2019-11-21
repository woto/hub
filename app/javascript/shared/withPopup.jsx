import axios from 'axios';

function withPopup(Component) {
  Component.prototype.popupWindow = async function(url, title, w, h) {

    // TODO: Stupid hack #2 it could be replaced by puppeter interception
    // https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#event-targetcreated
    // https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#pagesetrequestinterceptionvalue
    // but i didn't figure out how to combine these both.
    if (url === 'oauth-test') {
      await axios.get('/api/v1/staff/seeder/redis/get_ready_for_proxy')
        .then(({ data }) => {
          url = `/proxy/${data}`;
        })
    } else {
      url = `https://${process.env.DOMAIN_NAME}/users/auth/${url}`;
    }

    const popup = window.open(url, title,
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
