const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  const shortId = event.pathParameters.shortId;

  try {
    const result = await dynamoDb.get({
      TableName: process.env.TABLE_NAME,
      Key: { shortId },
    }).promise();

    if (!result.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "URL not found" }),
      };
    }

    return {
      statusCode: 301,
      headers: {
        Location: result.Item.longUrl,
      },
      body: null,
    };
  } catch (err) {
    console.error("Redirect Error:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal Server Error" }),
    };
  }
};
