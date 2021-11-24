import SwaggerUI from 'swagger-ui'
// or use require if you prefer
// const SwaggerUI = require('swagger-ui')

document.addEventListener('DOMContentLoaded', function() {
    if(document.querySelector('#swagger-ui')) {
        SwaggerUI({
            dom_id: '#swagger-ui',
            url: '/swagger_doc',
            // layout: "StandaloneLayout"
        })
    }
})
