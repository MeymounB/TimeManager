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
  const { accessToken } = storeToRefs(useSessionStore());

  const response = await fetch(url, {
    headers: {
      "Content-type": "application/json",
      Authorization: `Bearer ${publicRoute ? accessToken.value : ""}`,
    },
    method,
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    return { ok: false, status: response.status };
  }

  const { data } =
    method !== "DELETE" ? await response.json() : { data: undefined };
  return { ok: true, data };
}
