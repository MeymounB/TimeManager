import { storeToRefs } from "pinia";
import { useSessionStore } from "~/stores/sessionStore";

type Ok<T> = { ok: true; data: T };
type Err = { ok: false; status: number };

export async function useFetchAPI<T>(
  method: "GET" | "POST" | "PUT" | "DELETE",
  url: string,
  body?: any,
  publicRoute: boolean = false,
): Promise<Ok<T> | Err> {
  const session = useSessionStore();
  const { accessToken } = storeToRefs(session);

  const response = await fetch(url, {
    headers: {
      "Content-type": "application/json",
      Authorization: `Bearer ${!publicRoute ? accessToken.value : ""}`,
    },
    method,
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    if (response.status === 401) {
      const success = await session.refreshSession();

      if (!success) {
        return { ok: false, status: response.status };
      }

      return useFetchAPI(method, url, body, publicRoute);
    }
    return { ok: false, status: response.status };
  }

  const json =
    method !== "DELETE" ? await response.json() : { data: undefined };

  const data = json?.data ?? { ...json };
  return { ok: true, data };
}
