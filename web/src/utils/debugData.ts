import { isEnvBrowser } from "./misc";

interface DebugEvent<T = unknown> {
  action: string;
  data: T;
}

export const debugData = <T>(events: DebugEvent<T>[], timer = 1000): void => {
  if (!isEnvBrowser()) return;

  for (const event of events) {
    setTimeout(() => {
      window.dispatchEvent(
        new MessageEvent("message", {
          data: {
            action: event.action,
            data: event.data,
          },
        })
      );
    }, timer);
  }
};

export default debugData;
