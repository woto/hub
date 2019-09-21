const jsdom = require('jsdom');

const { JSDOM } = jsdom;

const doc = `
  <!DOCTYPE html>
  <html>
    <head>
      <meta name="csrf-token" content="vflmXQIrdvEFNilf2cr7kJZZrKtSb073PLq/KH3RAntRy3UCEKCcV3vIL20t90D9vop5NvxAUUP3WlTiMOEGGA==" />
    </head>
    <body>
    </body>
  </html>
  `;

// TODO: get to know why it doesn't work
// const dom = new JSDOM(doc);
// global.document = dom.window.document;
// global.window = dom.window;
document.body.outerHTML = doc;
