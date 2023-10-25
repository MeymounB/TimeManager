type Ok<T> = { ok: true, data: T }
type Err = { ok: false, status: number }

export async function useFetch<T>(method: 'GET' | 'POST' | 'PUT' | 'DELETE', url: string, body?: any): Promise<Ok<T> | Err> {
	const response = await fetch(url, {headers: { 'Content-type': 'application/json'}, method, body})

	if (!response.ok) {
		return { ok: false, status: response.status }
	}

	const { data } = await response.json()
	return { ok: true, data }
}
