import {
  BedrockRuntimeClient,
  ConverseCommand,
  type ContentBlock,
  type Message,
} from "@aws-sdk/client-bedrock-runtime";
import {defineSecret} from "firebase-functions/params";

const awsAccessKeyId = defineSecret("AWS_ACCESS_KEY_ID");
const awsSecretAccessKey = defineSecret("AWS_SECRET_ACCESS_KEY");
const awsRegion = defineSecret("AWS_REGION");

const MODEL_ID = "amazon.nova-micro-v1:0";
const VISION_MODEL_ID = "amazon.nova-lite-v1:0";
const HAIKU_MODEL_ID = "us.anthropic.claude-haiku-4-5-20251001-v1:0";

export interface BedrockOptions {
  temperature?: number;
  maxTokens?: number;
  modelId?: string;
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
  const {temperature = 0.3, maxTokens = 4096, modelId} = options;

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
    modelId: modelId || MODEL_ID,
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
  return callBedrockVisionImages(
    systemPrompt,
    userMessage,
    [{base64: imageBase64, mediaType: imageMediaType}],
    options
  );
}

/** Like callBedrockVision, with several images in order (e.g. book pages). */
export async function callBedrockVisionImages(
  systemPrompt: string,
  userMessage: string,
  images: {base64: string; mediaType: "image/jpeg" | "image/png" | "image/webp"}[],
  options: BedrockOptions = {}
): Promise<string> {
  const {temperature = 0.3, maxTokens = 4096, modelId} = options;

  const client = new BedrockRuntimeClient({
    region: awsRegion.value() || "us-east-1",
    credentials: {
      accessKeyId: awsAccessKeyId.value(),
      secretAccessKey: awsSecretAccessKey.value(),
    },
  });

  const content: ContentBlock[] = [];
  images.forEach((image, i) => {
    if (images.length > 1) content.push({text: `Photo ${i + 1} of ${images.length}:`});
    content.push({
      image: {
        format: image.mediaType.replace("image/", "") as "jpeg" | "png" | "webp",
        source: {bytes: Buffer.from(image.base64, "base64")},
      },
    });
  });
  content.push({text: userMessage});

  const command = new ConverseCommand({
    modelId: modelId || VISION_MODEL_ID,
    system: [{text: systemPrompt}],
    messages: [{role: "user", content}],
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

/** Export model IDs for function-specific overrides */
export {HAIKU_MODEL_ID};

/** Export secrets so functions can declare them in runWith config */
export const bedrockSecrets = [awsAccessKeyId, awsSecretAccessKey, awsRegion];

/** Region and credentials for other AWS clients (Polly) on the same account. */
export function awsClientConfig() {
  return {
    region: awsRegion.value() || "us-east-1",
    credentials: {
      accessKeyId: awsAccessKeyId.value(),
      secretAccessKey: awsSecretAccessKey.value(),
    },
  };
}
