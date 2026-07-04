import {HttpsError} from "firebase-functions/v2/https";
import {defineString} from "firebase-functions/params";

const aiEnabled = defineString("AI_ENABLED", {default: "true"});

/**
 * Checks if AI features are enabled. Throws `unavailable` if disabled.
 * Use AI_ENABLED env param to disable AI without redeploying.
 */
export function checkKillSwitch(): void {
  if (aiEnabled.value() !== "true") {
    throw new HttpsError(
      "unavailable",
      "AI features are temporarily disabled for maintenance."
    );
  }
}
