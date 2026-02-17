import { isEnvBrowser } from "./misc";

export async function fetchNui<T = unknown>(
  eventName: string,
  data?: unknown
): Promise<T> {
  if (isEnvBrowser()) {
    return Promise.resolve({} as T);
  }

  const resourceName = (window as any).GetParentResourceName
    ? (window as any).GetParentResourceName()
    : "sleepless_lootbox";

  const resp = await fetch(`https://${resourceName}/${eventName}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  });

  return resp.json();
}
