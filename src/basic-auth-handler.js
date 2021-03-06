// This code is based on
// https://github.com/builtinnya/aws-lambda-edge-basic-auth-terraform/blob/master/src/basic-auth.js

'use strict'

exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request
  const headers = request.headers

  const encodedCredentials = new Buffer(`${username}:${password}`).toString('base64')
  const authString = 'Basic ' + encodedCredentials

  if (
    typeof headers.authorization == 'undefined' ||
    headers.authorization[0].value != authString
  ) {
    const response = {
      status: '401',
      statusDescription: 'Unauthorized',
      body: 'Unauthorized',
      headers: {
        'www-authenticate': [
          {
            key: 'WWW-Authenticate',
            value: 'Basic',
          }
        ]
      },
    }

    callback(null, response)
    return
  }

  // Continue request processing if authentication passed
  callback(null, request)
}

