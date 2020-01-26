
// Replace the strings below with your own project & model info
const projectId = '224358754876';
const location = 'us-central1';
const modelId = 'ICN8028594323601752064';
const functions = require('firebase-functions');
exports.addMessage = functions.https.onCall((data, context) => {
const imageBytes = data.text;

const {PredictionServiceClient} = require(`@google-cloud/automl`).v1;
const fs = require(`fs`);

// Instantiates a client
const client = new PredictionServiceClient();

async function predict() {
  // Construct request
  // params is additional domain-specific parameters.
  // score_threshold is used to filter the result
  const request = {
    name: client.modelPath(projectId, location, modelId),
    payload: {
      image: {
        imageBytes: imageBytes,
      },
    },
  };

  const [response] = await client.predict(request);

  for (const annotationPayload of response.payload) {
    console.log(`Predicted class name: ${annotationPayload.displayName}`);
    return{
      name: annotationPayload.displayName
    };
  }
  return 0;
}

return predict()

});
