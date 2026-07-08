import {
  BedrockRuntimeClient,
  ConverseCommand,
  type Message,
} from "@aws-sdk/client-bedrock-runtime";
import {defineSecret} from "firebase-functions/params";

const awsAccessKeyId = defineSecret("AWS_ACCESS_KEY_ID");
const awsSecretAccessKey = defineSecret("AWS_SECRET_ACCESS_KEY");
const awsRegion = defineSecret("AWS_REGION");

const MODEL_ID = "amazon.nova-micro-v1:0";
const VISION_MODEL_ID = "amazon.nova-lite-v1:0";

export interface BedrockOptions {
  temperature?: number;
  maxTokens?: number;
}

/**
 * Calls AWS Bedrock Converse API with the given system prompt and user message.
 * Returns the raw text response from the model.
 */
export async function callBedrock(
  systemPrompt: string,
  userMessage: string,
  options: BedrockOptions = {}
): Promise<string> {
  const {temperature = 0.3, maxTokens = 4096} = options;

  const client = new BedrockRuntimeClient({
    region: awsRegion.value() || "us-east-1",
    credentials: {
      accessKeyId: awsAccessKeyId.value(),
      secretAccessKey: awsSecretAccessKey.value(),
    },
  });

  const messages: Message[] = [
    {
      role: "user",
      content: [{text: userMessage}],
    },
  ];

  const command = new ConverseCommand({
    modelId: MODEL_ID,
    system: [{text: systemPrompt}],
    messages,
    inferenceConfig: {
      temperature,
      maxTokens,
    },
  });

  const response = await client.send(command);

  const outputContent = response.output?.message?.content;
  if (!outputContent || outputContent.length === 0) {
    throw new Error("Empty response from Bedrock");
  }

  const text = outputContent[0].text;
  if (!text) {
    throw new Error("No text content in Bedrock response");
  }

  return text;
}

/**
 * Calls AWS Bedrock Converse API with an image + text message using Nova Lite.
 * Used for vision-capable requests (photo-to-recipe).
 */
export async function callBedrockVision(
  systemPrompt: string,
  userMessage: string,
  imageBase64: string,
  imageMediaType: "image/jpeg" | "image/png" | "image/webp",
  options: BedrockOptions = {}
): Promise<string> {
  const {temperature = 0.3, maxTokens = 4096} = options;

  const client = new BedrockRuntimeClient({
    region: awsRegion.value() || "us-east-1",
    credentials: {
      accessKeyId: awsAccessKeyId.value(),
      secretAccessKey: awsSecretAccessKey.value(),
    },
  });

  const format = imageMediaType.replace("image/", "") as "jpeg" | "png" | "webp";

  const messages: Message[] = [
    {
      role: "user",
      content: [
        {
          image: {
            format,
            source: {bytes: Buffer.from(imageBase64, "base64")},
          },
        },
        {text: userMessage},
      ],
    },
  ];

  const command = new ConverseCommand({
    modelId: VISION_MODEL_ID,
    system: [{text: systemPrompt}],
    messages,
    inferenceConfig: {
      temperature,
      maxTokens,
    },
  });

  const response = await client.send(command);

  const outputContent = response.output?.message?.content;
  if (!outputContent || outputContent.length === 0) {
    throw new Error("Empty response from Bedrock");
  }

  const text = outputContent[0].text;
  if (!text) {
    throw new Error("No text content in Bedrock response");
  }

  return text;
}

/** Export secrets so functions can declare them in runWith config */
export const bedrockSecrets = [awsAccessKeyId, awsSecretAccessKey, awsRegion];
