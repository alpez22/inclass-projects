
// You MUST have a file called "token.secret" in the same directory as this file!
// This should be the secret token found in https://dashboard.ngrok.com/
// Make sure it is on a single line with no spaces!
// It will NOT be committed.

// TO START
//   1. Open a terminal and run 'npm start'
//   2. Open another terminal and run 'npm run tunnel'
//   3. Copy/paste the ngrok HTTPS url into the DialogFlow fulfillment.
//
// Your changes to this file will be hot-reloaded!

import fetch from 'node-fetch';
import fs from 'fs';
import ngrok from 'ngrok';
import morgan from 'morgan';
import express from 'express';
import CS571 from '@cs571/mobile-client';

// Read and register with secret ngrok token.
ngrok.authtoken(fs.readFileSync("token.secret").toString().trim());

// Start express on port 53705
const app = express();
const port = 53705;

// Accept JSON bodies and begin logging.
app.use(express.json());
app.use(morgan(':date ":method :url" :status - :response-time ms'));

// "Hello World" endpoint.
// You should be able to visit this in your browser
// at localhost:53705 or via the ngrok URL.
app.get('/', (req, res) => {
  res.status(200).send(JSON.stringify({
    msg: 'Express Server Works!'
  }))
})

// Dialogflow will POST a JSON body to /.
// We use an intent map to map the incoming intent to
// its appropriate async functions below.
// You can examine the request body via `req.body`
// See https://cloud.google.com/dialogflow/es/docs/fulfillment-webhook#webhook_request
app.post('/', (req, res) => {
  const intent = req.body.queryResult.intent.displayName;

  // A map of intent names to callback functions.
  // The "HelloWorld" is an example only -- you may delete it.
  const intentMap = {
    "HelloWorld": doHelloWorld,
    "GetWhenPosted": doRecentPost,
    "GetChatroomMessages": doPostIntent
  }

  if (intent in intentMap) {
    // Call the appropriate callback function
    intentMap[intent](req, res);
  } else {
    // Uh oh! We don't know what to do with this intent.
    // There is likely something wrong with your code.
    // Double-check your names.
    console.error(`Could not find ${intent} in intent map!`)
    res.status(404).send(JSON.stringify({ msg: "Not found!" }));
    res.status(304).send(JSON.stringify({msg:"what is going on"}))
  }
})

// Open for business!
app.listen(port, () => {
  console.log(`DialogFlow Handler listening on port ${port}. Use 'npm run tunnel' to expose this.`)
})

// Your turn!
// Each of the async functions below maps to an intent from DialogFlow
// Complete the intent by fetching data from the API and
// returning an appropriate response to DialogFlow.
// See https://cloud.google.com/dialogflow/es/docs/fulfillment-webhook#webhook_response
// Use `res` to send your response; don't return!

async function doHelloWorld(req, res) {
  res.status(200).send({
    fulfillmentMessages: [
      {
        text: {
          text: [
            'You will see this if you trigger an intent named HelloWorld'
          ]
        }
      }
    ]
  })
}

async function doRecentPost(req, res) {
  const chatroomName = req.body.queryResult.parameters;
  const response = await fetch(`https://cs571.org/api/f23/hw11//messages?chatroom=${chatroomName.chatroom}`, {
    headers: {
      "X-CS571-ID": "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49"
    }
  });
  const data = await response.json();
  const infoDate = data.messages[0].created;
  const date = new Date(infoDate);
  res.status(200).send({
    fulfillmentMessages: [
      {
        text: {
          text: [
            `The last message in ${chatroomName.chatroom} was posted on ${date.toLocaleDateString()} at ${date.toLocaleTimeString()}!`
          ]
        }
      }
    ]
  })
}

async function doPostIntent(req, res) {
  //to do for multiple
  const params = req.body.queryResult.parameters;
  const chatroomName = params.chatroom;
  const numMessages = params.numMessages;

  const response = await fetch(`https://cs571.org/api/f23/hw11//messages?chatroom=${chatroomName}`, {
    headers: {
      "X-CS571-ID": "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49"
    }
  });
  const data = await response.json();

  const url = `https://www.cs571.org/f23/badgerchat/chatrooms/${chatroomName}`;
  const fulfillmentArr = [];
  let num = 0;
  if(!numMessages || numMessages < 0){
    num = 1;
    fulfillmentArr.push({
      text: {
        text: [
          `Here is the last message from ${params.chatroom}!`
        ]
      }
    })
  } else if(numMessages > 5){
    num = 5;
    fulfillmentArr.push({
      text: {
        text: [
          `Sorry, you can only get up to 5 messages. Here are the last 5 messages from ${params.chatroom}!`
        ]
      }
    })
  }else{
    num = numMessages;
    fulfillmentArr.push({
      text: {
        text: [
          `Here are the last ${num} messages from ${params.chatroom}!`
        ]
      }
    })
  }
  for(let i = 0; i < num; i++){
    const title = data.messages[i].title;
    const content = data.messages[i].content;
    fulfillmentArr.push(
      {
        card: {
          title: title,
          subtitle: content,
          buttons: [
            {
              text: "READ MORE",
              postback: url
            }
          ]
        }
      }
    )
  }
  
  res.status(200).send({
    fulfillmentMessages: fulfillmentArr
  })
}