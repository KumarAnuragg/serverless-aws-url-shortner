const AWS = require('aws-sdk');
const crypto = require('crypto');

const dynamo = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const longUrl = body.longUrl;

    if (!longUrl) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Missing longUrl" }),
      };
    }

    // Generate random 6-char short ID
    const shortId = crypto.randomBytes(3).toString('hex');

    // Save to DynamoDB
    await dynamo.put({
      TableName: TABLE_NAME,
      Item: {
        shortId: shortId,
        longUrl: longUrl,
      },
    }).promise();

    const domain = event.requestContext?.domainName || "ngswko493b.execute-api.ap-south-1.amazonaws.com";
const path = event.requestContext?.stage || "prod";
const shortUrl = `https://${domain}/${path}/${shortId}`;

return {
  statusCode: 200,
  body: JSON.stringify({
    shortId,
    shortUrl
  }),
};

  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
